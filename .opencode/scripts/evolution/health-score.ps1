<#
.SYNOPSIS
System Health Score v1.0 — Chấm điểm sức khỏe toàn bộ hệ thống
.DESCRIPTION
Tính điểm dựa trên:
- Workflow integrity (100)
- Skills freshness (80)
- Knowledge completeness (60)
- Compatibility score (100)
- Agents health (95)
- Scripts quality (85)
- Tests coverage (75)
- Learning maturity (30)
#>

param(
    [string]$compatibilityReport = "",
    [string]$knowledgeReport = "",
    [string]$migrationReport = "",
    [string]$simulationReport = "",
    [string]$benchmarkReport = "",
    [string]$contractDir = ".opencode/system/contracts",
    [string]$agentsDir = ".opencode/agents",
    [string]$commandsDir = ".opencode/commands",
    [string]$skillsDir = ".opencode/skills",
    [string]$scriptsDir = ".opencode/scripts",
    [string]$outputDir = ".opencode/scripts/evolution/reports"
)

$ErrorActionPreference = "Continue"
$toolVersion = "1.0.0"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }

function Load-Report {
    param([string]$Path)
    if (-not $Path -or -not (Test-Path $Path)) { return $null }
    try {
        $content = Get-Content -LiteralPath $Path -Raw -Encoding utf8
        return $content | ConvertFrom-Json
    } catch { return $null }
}

# Load external reports if provided
$compData = Load-Report -Path $compatibilityReport
$knowData = Load-Report -Path $knowledgeReport
$migrData = Load-Report -Path $migrationReport
$simData = Load-Report -Path $simulationReport
$bmData = Load-Report -Path $benchmarkReport

$results = @{
    tool = "health-score.ps1"
    version = $toolVersion
    timestamp = $timestamp
    categories = @{}
    overall = 0
    summary = ""
    recommendations = @()
}

# 1. Workflow integrity
Write-Host "Scoring: Workflow integrity..." -ForegroundColor Cyan
$wfScore = 100
$wfContract = "$contractDir/workflow.yaml"
if (-not (Test-Path $wfContract)) { $wfScore -= 30 }
$wfContent = if (Test-Path $wfContract) { Get-Content -LiteralPath $wfContract -Raw -Encoding utf8 } else { "" }
if ($wfContent -notmatch 'steps:') { $wfScore -= 20 }
if ($wfContent -notmatch 'transitions:') { $wfScore -= 20 }
$wfScore = [Math]::Max(0, $wfScore)
$results.categories.Workflow = $wfScore

# 2. Skills freshness
Write-Host "Scoring: Skills freshness..." -ForegroundColor Cyan
$skScore = 100
$skillDirs = Get-ChildItem -Path "$skillsDir" -Directory -ErrorAction SilentlyContinue
$skillFiles = Get-ChildItem -Path "$skillsDir\*\SKILL.md" -ErrorAction SilentlyContinue

if ($skillDirs.Count -eq 0) { $skScore = 0 }
else {
    foreach ($sf in $skillFiles) {
        $content = Get-Content -LiteralPath $sf.FullName -Raw -Encoding utf8 -ErrorAction SilentlyContinue
        if ($content -match 'schema_version:\s*"(\d+\.\d+)"') {
            $ver = [version]$Matches[1]
            if ($ver -lt [version]"1.0") { $skScore -= 10 }
        }
        # Chi tru diem khi skill tu khang dinh deprecated, khong phai chi nham toi tu trong docs
        $cleanContent = [regex]::Replace($content, '(?s)```.*?```', '')
        $cleanContent = [regex]::Replace($cleanContent, '`[^`]*`', '')
        if ($content -match '(?i)deprecated\s*:\s*["'']?true' -or $cleanContent -match '(?i)(this\s+skill\s+is\s+(?:deprecated|outdated)|skill\s+no\s+longer\s+(?:maintained|used)|superseded\s+by\s+\S+)') { $skScore -= 15 }
    }
}
$skScore = [Math]::Max(0, $skScore)
$results.categories.Skills = $skScore

# 3. Knowledge completeness
Write-Host "Scoring: Knowledge completeness..." -ForegroundColor Cyan
$knScore = 100
if ($knowData) {
    $knScore = [int]$knowData.score
} else {
    $knFiles = Get-ChildItem -Path ".opencode/knowledge\*" -Recurse -File -ErrorAction SilentlyContinue
    $knScore = [Math]::Min(100, $knFiles.Count * 10)
    if ($knFiles.Count -eq 0) { $knScore = 20 }
}
$results.categories.Knowledge = $knScore

# 4. Compatibility
Write-Host "Scoring: Compatibility..." -ForegroundColor Cyan
$compScore = 100
if ($compData) {
    $compScore = [int]$compData.compatibility_score
} else {
    $contracts = Get-ChildItem -Path "$contractDir\*.yaml" -ErrorAction SilentlyContinue
    $compScore = [Math]::Min(100, $contracts.Count * 20)
}
$results.categories.Compatibility = $compScore

# 5. Agents health
Write-Host "Scoring: Agents health..." -ForegroundColor Cyan
$agScore = 100
$agentFiles = Get-ChildItem -Path "$agentsDir\*.md" -ErrorAction SilentlyContinue
if ($agentFiles.Count -eq 0) { $agScore = 0 }
else {
    foreach ($af in $agentFiles) {
        $content = Get-Content -LiteralPath $af.FullName -Raw -Encoding utf8 -ErrorAction SilentlyContinue
        # Check for basic structure
        if ($content -notmatch '^---') { $agScore -= 5 }
        if ($content -notmatch '(?i)(mode\s*:\s*(subagent|primary|agent)|description\s*:)') { $agScore -= 5 }
    }
    # Check contract coverage
    $contractCount = (Get-ChildItem -Path "$contractDir\*.yaml" -ErrorAction SilentlyContinue).Count
    $expectedContracts = ($agentFiles | Where-Object { $_.BaseName -notin @('codebase-explorer', 'backup-agent', 'cleaner', 'pusher', 'general') }).Count
    if ($expectedContracts -gt 0) {
        $contractRatio = [Math]::Min(1, $contractCount / $expectedContracts)
        $agScore = [Math]::Round($agScore * (0.5 + ($contractRatio * 0.5)))
    }
}
$results.categories.Agents = [Math]::Max(0, $agScore)

# 6. Scripts quality
Write-Host "Scoring: Scripts quality..." -ForegroundColor Cyan
$scrScore = 100
$scriptFiles = Get-ChildItem -Path "$scriptsDir\*.ps1" -ErrorAction SilentlyContinue
$evolutionScripts = Get-ChildItem -Path "$scriptsDir\evolution\*.ps1" -ErrorAction SilentlyContinue

if ($scriptFiles.Count -eq 0) { $scrScore = 0 }
else {
    $totalScripts = $scriptFiles.Count + $evolutionScripts.Count
    $hasHelp = 0
    foreach ($sf in @($scriptFiles) + @($evolutionScripts)) {
        $content = Get-Content -LiteralPath $sf.FullName -Raw -Encoding utf8 -ErrorAction SilentlyContinue
        if ($content -match '<#\s*\.SYNOPSIS') { $hasHelp++ }
        if ($content -match 'param\(') { $hasHelp++ }
    }
    if ($totalScripts -gt 0) {
        $scrScore = [Math]::Round(($hasHelp / ($totalScripts * 2)) * 100)
    }
}
$results.categories.Scripts = [Math]::Max(0, $scrScore)

# 7. Tests coverage
Write-Host "Scoring: Tests coverage..." -ForegroundColor Cyan
$testScore = 100
$testFiles = Get-ChildItem -Path "JapaneseLearner.Tests\*.cs" -Recurse -ErrorAction SilentlyContinue
$e2eFiles = Get-ChildItem -Path "JapaneseLearner.E2ETests\*.cs" -Recurse -ErrorAction SilentlyContinue
$totalTests = $testFiles.Count + $e2eFiles.Count
if ($totalTests -eq 0) { $testScore = 20 }
else {
    $testScore = [Math]::Min(100, 30 + ($totalTests * 5))
}
$results.categories.Tests = $testScore

# 8. Learning maturity
Write-Host "Scoring: Learning maturity..." -ForegroundColor Cyan
$learnScore = 100
$lessonsFile = ".opencode/knowledge/lessons.md"
$skillsLearned = ".opencode/knowledge/skills-learned.md"
if (-not (Test-Path $lessonsFile)) { $learnScore -= 40 }
if (-not (Test-Path $skillsLearned)) { $learnScore -= 30 }
if ($migrData) {
    if ($migrData.tasks.Count -gt 0) { $learnScore -= 10 }
}
# Check for learning patterns
$learnScore = [Math]::Max(0, $learnScore)
$results.categories.Learning = $learnScore

# 9. Runtime Health (tu Simulation Engine — sandbox mode)
Write-Host "Scoring: Runtime Health..." -ForegroundColor Cyan
$runScore = 50  # fallback khi khong co simulation report
if ($simData) {
    $runScore = [int]$simData.runtime_health
    if (-not $runScore -or $runScore -lt 0 -or $runScore -gt 100) { $runScore = 50 }
}
$results.categories.Runtime = $runScore

# 10. Capability Score (tu Capability Benchmark Engine)
Write-Host "Scoring: Capability..." -ForegroundColor Cyan
$capScore = 50  # fallback khi khong co benchmark report
if ($bmData) {
    $capScore = [int]$bmData.capability_score
    if (-not $capScore -or $capScore -lt 0 -or $capScore -gt 100) { $capScore = 50 }
}
$results.categories.Capability = $capScore

# Compute overall
$weights = @{
    Workflow = 0.13
    Skills = 0.13
    Knowledge = 0.09
    Compatibility = 0.13
    Agents = 0.13
    Scripts = 0.09
    Tests = 0.09
    Learning = 0.09
    Runtime = 0.06
    Capability = 0.06
}

$overall = 0
foreach ($cat in $results.categories.Keys) {
    $w = if ($weights.ContainsKey($cat)) { $weights[$cat] } else { 0.10 }
    $overall += $results.categories[$cat] * $w
}
$results.overall = [Math]::Round($overall)

# Generate recommendations
$knScore = $results.categories.Knowledge
$lnScore = $results.categories.Learning
$cpScore = $results.categories.Compatibility
$tsScore = $results.categories.Tests

if ($knScore -lt 60) {
    $results.recommendations += "Knowledge score low ($knScore/100) - consider adding missing KB entries"
}
if ($lnScore -lt 50) {
    $results.recommendations += "Learning score low ($lnScore/100) - consider adding lessons and patterns"
}
if ($cpScore -lt 80) {
    $results.recommendations += "Compatibility score low ($cpScore/100) - check contract mismatches"
}
if ($tsScore -lt 60) {
    $results.recommendations += "Tests score low ($tsScore/100) - more tests needed"
}
if ($runScore -lt 70) {
    $results.recommendations += "Runtime health low ($runScore/100) - run simulation-engine.ps1 and fix runtime errors"
}
if ($capScore -lt 70) {
    $results.recommendations += "Capability score low ($capScore/100) - consider adding skills/knowledge for weak domains"
}

$results.summary = "Health score: " + $results.overall + "/100"

# Write report
$reportPath = "$outputDir/health-score-$timestamp.json"
$results | ConvertTo-Json -Depth 5 | Out-File -LiteralPath $reportPath -Encoding utf8

# Display
Write-Host "=== System Health Score ===" -ForegroundColor Cyan
$sortedCats = $results.categories.Keys | Sort-Object
foreach ($cat in $sortedCats) {
    $score = $results.categories[$cat]
    $color = if ($score -ge 80) { "Green" } elseif ($score -ge 50) { "Yellow" } else { "Red" }
    $padded = $cat.PadRight(15)
    Write-Host "  $padded $score" -ForegroundColor $color
}
Write-Host "  " -NoNewline
Write-Host "-" * 25
$overallColor = if ($results.overall -ge 80) { "Green" } elseif ($results.overall -ge 50) { "Yellow" } else { "Red" }
Write-Host "  Overall         $($results.overall)/100" -ForegroundColor $overallColor
Write-Host "============================" -ForegroundColor Cyan

return $results
