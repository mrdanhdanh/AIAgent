<#
.SYNOPSIS
Evolution Report v1.0 — Tạo báo cáo tiến hóa của hệ thống sau mỗi lần quét
.DESCRIPTION
Tổng hợp kết quả từ Semantic Diff, Compatibility Checker, Migration System,
Self Healing, Knowledge Migration, Health Score thành một báo cáo duy nhất.
#>

param(
    [string]$semanticDiffReport = "",
    [string]$compatibilityReport = "",
    [string]$migrationReport = "",
    [string]$selfHealingReport = "",
    [string]$knowledgeReport = "",
    [string]$healthReport = "",
    [string]$outputDir = ".opencode/scripts/evolution/reports",
    [string]$outputFile = ""
)

$ErrorActionPreference = "Continue"
$toolVersion = "1.0.0"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }

function Load-JsonReport {
    param([string]$Path)
    if (-not $Path -or -not (Test-Path $Path)) { return $null }
    try {
        $content = Get-Content -LiteralPath $Path -Raw -Encoding utf8
        return $content | ConvertFrom-Json
    } catch { return $null }
}

# Load all reports
$sd = Load-JsonReport -Path $semanticDiffReport
$cc = Load-JsonReport -Path $compatibilityReport
$ms = Load-JsonReport -Path $migrationReport
$sh = Load-JsonReport -Path $selfHealingReport
$km = Load-JsonReport -Path $knowledgeReport
$hs = Load-JsonReport -Path $healthReport

$results = @{
    report_type = "System Evolution Report"
    generated_at = $now
    tool_version = $toolVersion
    summary = @{}
    sections = @{}
    health_score = @{}
    recommendations = @()
}

# SECTION 1: Detected Changes
$detected = @{
    workflow_changes = 0
    schema_changes = 0
    compatibility_issues = 0
    migration_tasks = 0
    deprecated_knowledge = 0
    missing_knowledge = 0
    auto_fixes = 0
    pending_fixes = 0
}

if ($sd) {
    $detected.workflow_changes = @($sd.changes | Where-Object { $_.type -eq 'workflow_change' }).Count
    $detected.schema_changes = @($sd.changes | Where-Object { $_.type -eq 'schema_change' }).Count
}

if ($cc) {
    $detected.compatibility_issues = $cc.issues.Count
}

if ($ms) {
    $detected.migration_tasks = $ms.tasks.Count
}

if ($km) {
    $detected.deprecated_knowledge = $km.deprecated_knowledge.Count
    $detected.missing_knowledge = $km.missing_knowledge.Count
}

if ($sh) {
    $detected.auto_fixes = $sh.auto_fixed_count
    $detected.pending_fixes = $sh.pending_count
}

$results.sections.detected = $detected

# SECTION 2: Auto-fixed
$autoFixed = @()
if ($sh -and $sh.fixes) {
    foreach ($fix in $sh.fixes) {
        $autoFixed += "- " + $fix.type + ": " + $fix.file + " - '" + $fix.wrong + "' -> '" + $fix.fixed_to + "'"
    }
}
$results.sections.auto_fixed = $autoFixed

# SECTION 3: Pending
$pending = @()
if ($sh -and $sh.pending) {
    foreach ($p in $sh.pending) {
        $pending += "- " + $p.type + ": " + $p.file + " - '" + $p.wrong + "' -> '" + $p.suggestion + "' (confidence: " + $p.confidence + "%)"
    }
}
if ($km -and $km.pending_updates) {
    foreach ($pu in $km.pending_updates) {
        $pending += "- " + $pu
    }
}
$results.sections.pending = ($pending | Select-Object -Unique)

# SECTION 4: Learning
$learning = @()
if ($sd -and $sd.changes.Count -gt 0) {
    $learning += "- New pattern detected: " + $sd.changes.Count + " semantic changes in system"
}
if ($sh -and $sh.auto_fixed_count -gt 0) {
    $learning += "- New validation rules: " + $sh.auto_fixed_count + " auto-fixes applied"
}
if ($ms -and $ms.tasks.Count -gt 0) {
    $learning += "- New bug fix strategy: " + $ms.tasks.Count + " migration tasks generated"
}
$results.sections.learning = $learning

# SECTION 5: Suggestions
$suggestions = @()
if ($hs -and $hs.recommendations) {
    foreach ($rec in $hs.recommendations) {
        $suggestions += "- " + $rec
    }
}
if ($km -and $km.missing_knowledge.Count -gt 0) {
    $topTopics = $km.missing_knowledge | Select-Object -First 3
    foreach ($mt in $topTopics) {
        $suggestions += "- Add knowledge topic: " + $mt.topic + " (" + $mt.category + ")"
    }
}
$results.sections.suggestions = $suggestions

# SECTION 6: Health Score
if ($hs) {
    $results.health_score = @{
        categories = $hs.categories
        overall = $hs.overall
        summary = $hs.summary
    }
} else {
    $results.health_score = @{
        overall = "N/A"
        summary = "Health score not computed"
    }
}

# Summary
$results.summary = @{
    detected_changes = $detected
    auto_fixed_count = $autoFixed.Count
    pending_count = $pending.Count
    health = $results.health_score
    report = "System Evolution Report - $now"
}

# Display
Write-Host ""
Write-Host "============================================================" -ForegroundColor Magenta
Write-Host "            SYSTEM EVOLUTION REPORT" -ForegroundColor Magenta
Write-Host "============================================================" -ForegroundColor Magenta
Write-Host ""
Write-Host "Detected:" -ForegroundColor Cyan
Write-Host "  $($detected.workflow_changes) workflow changes"
Write-Host "  $($detected.schema_changes) schema changes"
Write-Host "  $($detected.compatibility_issues) compatibility issues"
Write-Host "  $($detected.migration_tasks) migration tasks"
Write-Host "  $($detected.deprecated_knowledge) deprecated knowledge"
Write-Host "  $($detected.missing_knowledge) missing knowledge topics"
Write-Host ""
Write-Host "--------------------------------" -ForegroundColor DarkGray
Write-Host ""
if ($autoFixed.Count -gt 0) {
    Write-Host "Auto-fixed:" -ForegroundColor Green
    foreach ($af in $autoFixed) { Write-Host "  $af" -ForegroundColor Green }
    Write-Host ""
}
if ($pending.Count -gt 0) {
    Write-Host "Pending:" -ForegroundColor Yellow
    foreach ($p in $pending) { Write-Host "  $p" -ForegroundColor Yellow }
    Write-Host ""
}
if ($learning.Count -gt 0) {
    Write-Host "Learning:" -ForegroundColor Cyan
    foreach ($l in $learning) { Write-Host "  $l" -ForegroundColor Cyan }
    Write-Host ""
}
if ($suggestions.Count -gt 0) {
    Write-Host "Suggestions:" -ForegroundColor Magenta
    foreach ($sg in $suggestions) { Write-Host "  $sg" -ForegroundColor Magenta }
    Write-Host ""
}
Write-Host "--------------------------------" -ForegroundColor DarkGray
Write-Host ""
Write-Host "Health Score: $($results.health_score.overall)/100" -ForegroundColor $(if ($results.health_score.overall -ge 80) { "Green" } elseif ($results.health_score.overall -ge 50) { "Yellow" } else { "Red" })
Write-Host ""
Write-Host "============================================================" -ForegroundColor Magenta

# Write report
if (-not $outputFile) {
    $outputFile = "$outputDir/evolution-report-$timestamp.md"
}

$reportLines = @()
$reportLines += "# System Evolution Report"
$reportLines += ""
$reportLines += "**Generated:** $now"
$reportLines += "**Tool:** evolution-report.ps1 v$toolVersion"
$reportLines += ""
$reportLines += "---"
$reportLines += ""
$reportLines += "## Detected"
$reportLines += ""
$reportLines += "| Type | Count |"
$reportLines += "|------|-------|"
$reportLines += "| Workflow changes | $($detected.workflow_changes) |"
$reportLines += "| Schema changes | $($detected.schema_changes) |"
$reportLines += "| Compatibility issues | $($detected.compatibility_issues) |"
$reportLines += "| Migration tasks | $($detected.migration_tasks) |"
$reportLines += "| Deprecated knowledge | $($detected.deprecated_knowledge) |"
$reportLines += "| Missing knowledge topics | $($detected.missing_knowledge) |"
$reportLines += "| Auto-fixes applied | $($detected.auto_fixes) |"
$reportLines += "| Pending fixes | $($detected.pending_fixes) |"
$reportLines += ""
$reportLines += "---"
$reportLines += ""

if ($autoFixed.Count -gt 0) {
    $reportLines += "## Auto-fixed"
    $reportLines += ""
    foreach ($af in $autoFixed) { $reportLines += "$af" }
    $reportLines += ""
    $reportLines += "---"
    $reportLines += ""
}

if ($pending.Count -gt 0) {
    $reportLines += "## Pending"
    $reportLines += ""
    foreach ($p in $pending) { $reportLines += "$p" }
    $reportLines += ""
    $reportLines += "---"
    $reportLines += ""
}

if ($learning.Count -gt 0) {
    $reportLines += "## Learning"
    $reportLines += ""
    foreach ($l in $learning) { $reportLines += "$l" }
    $reportLines += ""
    $reportLines += "---"
    $reportLines += ""
}

if ($suggestions.Count -gt 0) {
    $reportLines += "## Suggestions"
    $reportLines += ""
    foreach ($sg in $suggestions) { $reportLines += "$sg" }
    $reportLines += ""
    $reportLines += "---"
    $reportLines += ""
}

$reportLines += "## Health Score"
$reportLines += ""
if ($hs) {
    foreach ($cat in ($hs.categories.PSObject.Properties | Sort-Object Name)) {
        $padded = $cat.Name.PadRight(15)
        $reportLines += "| $padded | $($cat.Value)/100 |"
    }
    $reportLines += "|-----------------|--------|"
    $reportLines += "| **Overall**     | **$($hs.overall)/100** |"
} else {
    $reportLines += "Health score not computed."
}
$reportLines += ""
$reportLines += "---"
$reportLines += ""
$reportLines += "> Generated by System Evolution Engine"

$reportContent = $reportLines -join "`r`n"
$reportContent | Out-File -LiteralPath $outputFile -Encoding utf8

Write-Host "Report saved: $outputFile" -ForegroundColor Cyan

return $results
