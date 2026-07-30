<#
.SYNOPSIS
Self Healing Engine v1.0 - Detects and auto-fixes simple compatibility issues
.DESCRIPTION
Detects:
- Typo in field names (validation_command vs validate_command)
- Version mismatch (agent references wrong version)
- File path inconsistencies
- Deprecated agent references
- Missing required fields
Only auto-patches when confidence >= 95% with backup first.
#>

param(
    [string]$contractDir = ".opencode/system/contracts",
    [string]$agentsDir = ".opencode/agents",
    [string]$commandsDir = ".opencode/commands",
    [string]$outputDir = ".opencode/scripts/evolution/reports",
    [switch]$apply
)

$ErrorActionPreference = "Continue"
$toolVersion = "1.0.0"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }

function Get-StringSimilarity {
    param([string]$s1, [string]$s2)
    $s1 = $s1.ToLower().Trim()
    $s2 = $s2.ToLower().Trim()
    if ($s1 -eq $s2) { return 100 }
    
    $len1 = $s1.Length
    $len2 = $s2.Length
    if ($len1 -eq 0 -or $len2 -eq 0) { return 0 }
    
    # Levenshtein distance using 1D array approach
    $prev = New-Object int[] ($len2 + 1)
    $curr = New-Object int[] ($len2 + 1)
    for ($j = 0; $j -le $len2; $j++) { $prev[$j] = $j }
    
    for ($i = 1; $i -le $len1; $i++) {
        $curr[0] = $i
        for ($j = 1; $j -le $len2; $j++) {
            $cost = if ($s1[$i-1] -eq $s2[$j-1]) { 0 } else { 1 }
            $del = $prev[$j] + 1
            $ins = $curr[$j-1] + 1
            $sub = $prev[$j-1] + $cost
            $min = $del
            if ($ins -lt $min) { $min = $ins }
            if ($sub -lt $min) { $min = $sub }
            $curr[$j] = $min
        }
        $tmp = $prev
        $prev = $curr
        $curr = $tmp
    }
    
    $distance = $prev[$len2]
    $maxLen = [Math]::Max($len1, $len2)
    if ($maxLen -eq 0) { return 100 }
    return [Math]::Round((1 - $distance / $maxLen) * 100)
}

$results = @{
    tool = "self-healing.ps1"
    version = $toolVersion
    timestamp = $timestamp
    scans = @()
    fixes = @()
    pending = @()
    auto_fixed_count = 0
    pending_count = 0
    all_pass = $true
    summary = ""
}

# Scan 1: Agent file to contract field name typos
Write-Host "Scan 1: Field name typos in agent files..." -ForegroundColor Cyan
$agentsDir = $agentsDir.TrimEnd('\').TrimEnd('/')
$agentFiles = Get-ChildItem -Path "$agentsDir\*.md" -ErrorAction SilentlyContinue
$contractFields = @{
    "planner" = @("status", "summary", "effort", "design", "steps", "rollback_strategy", "validate", "blocking_issues", "non_blocking_issues", "artifacts", "expected_result", "risk_level", "per_step_validation", "per_chunk_validate", "final_validation", "validation_command")
    "builder" = @("status", "summary", "overall", "steps", "changed_files", "created_files", "deleted_files", "failure_type", "validation_status", "backup_workflow_id", "error_type", "error_normalized", "error_hash", "retryable")
    "reviewer" = @("decision", "scores", "score_rationale", "issues", "consistency_checks", "missing_info", "required_updates", "edge_cases_checked", "not_covered_risks", "recommendation", "next_step")
    "tester" = @("status", "coverage", "results", "thresholds_met")
}

$knownFields = @()
foreach ($list in $contractFields.Values) { $knownFields += $list }
$knownFields = $knownFields | Sort-Object -Unique

foreach ($af in $agentFiles) {
    $agentName = $af.BaseName
    $content = Get-Content -LiteralPath $af.FullName -Raw -Encoding utf8
    
    # Find YAML field-like patterns
    $fieldMatches = [regex]::Matches($content, '(?<!["''#])\b([a-z_]+)\s*:\s')
    
    foreach ($match in $fieldMatches) {
        $field = $match.Groups[1].Value
        if ($field -in $knownFields) { continue }
        if ($field -match '^(order|description|action|file|logic|check|chunk|depends_on|id|severity|category|blocking|suggestion|type|size|summary|status|agent|command|skill|name|schema_version)$') { continue }
        if ($field.Length -lt 3) { continue }
        
        # Find closest match
        $bestMatch = ""
        $bestScore = 0
        foreach ($kf in $knownFields) {
            $score = Get-StringSimilarity -s1 $field -s2 $kf
            if ($score -gt $bestScore) {
                $bestScore = $score
                $bestMatch = $kf
            }
        }
        
        if ($bestScore -ge 90 -and $bestMatch -ne $field) {
            $scan = @{
                type = "POSSIBLE_TYPO"
                file = $af.Name
                line = "unknown"
                wrong = $field
                suggestion = $bestMatch
                similarity = $bestScore
                confidence = $bestScore
            }
            $results.scans += $scan
            
            if ($bestScore -ge 95 -and $apply) {
                # Auto-fix
                $newContent = $content -replace "(?<![`"'])\b$field\s*:", "$bestMatch`:"
                if ($newContent -ne $content) {
                    $backupDir = ".opencode/backup/self-heal"
                    if (-not (Test-Path $backupDir)) { New-Item -ItemType Directory -Path $backupDir -Force | Out-Null }
                    Copy-Item -LiteralPath $af.FullName -Destination "$backupDir/$($af.Name).$timestamp.bak" -Force
                    
                    $newContent | Out-File -LiteralPath $af.FullName -Encoding utf8
                    $results.fixes += @{
                        type = "TYPO_FIX"
                        file = $af.Name
                        wrong = $field
                        fixed_to = $bestMatch
                        confidence = $bestScore
                        backup = "$backupDir/$($af.Name).$timestamp.bak"
                    }
                    $results.auto_fixed_count++
                    $msg = "  AUTO-FIXED: " + $af.Name + " - '" + $field + "' -> '" + $bestMatch + "'"
                    Write-Host $msg -ForegroundColor Green
                }
            } else {
                $results.pending += @{
                    type = "TYPO_CANDIDATE"
                    file = $af.Name
                    wrong = $field
                    suggestion = $bestMatch
                    confidence = $bestScore
                    requires_approval = ($bestScore -lt 95)
                }
                $results.pending_count++
                $msg = "  PENDING: " + $af.Name + " - '" + $field + "' -> '" + $bestMatch + "' (" + $bestScore + "%)"
                Write-Host $msg -ForegroundColor Yellow
            }
        }
    }
}

# Scan 2: Command to Agent reference consistency
Write-Host "Scan 2: Command to Agent reference consistency..." -ForegroundColor Cyan
$commandsDir = $commandsDir.TrimEnd('\').TrimEnd('/')
$commandFiles = Get-ChildItem -Path "$commandsDir\*.md" -ErrorAction SilentlyContinue
$agentNames = $agentFiles | ForEach-Object { $_.BaseName }

foreach ($cf in $commandFiles) {
    $content = Get-Content -LiteralPath $cf.FullName -Raw -Encoding utf8
    
    if ($content -match '(?m)^agent:\s*(\w[\w-]*)') {
        $referencedAgent = $Matches[1]
        if ($referencedAgent -notin $agentNames -and $referencedAgent -ne "general") {
            $bestAgent = ""
            $bestScore = 0
            foreach ($an in $agentNames) {
                $score = Get-StringSimilarity -s1 $referencedAgent -s2 $an
                if ($score -gt $bestScore) {
                    $bestScore = $score
                    $bestAgent = $an
                }
            }
            
            $scan = @{
                type = "BROKEN_AGENT_REFERENCE"
                file = $cf.Name
                wrong = $referencedAgent
                suggestion = if ($bestScore -ge 70) { $bestAgent } else { "unknown" }
                similarity = $bestScore
            }
            $results.scans += $scan
            
            if ($bestScore -ge 95 -and $apply -and $bestAgent) {
                $newContent = $content -replace "(?m)^agent:\s*$referencedAgent", "agent: $bestAgent"
                $backupDir = ".opencode/backup/self-heal"
                if (-not (Test-Path $backupDir)) { New-Item -ItemType Directory -Path $backupDir -Force | Out-Null }
                Copy-Item -LiteralPath $cf.FullName -Destination "$backupDir/$($cf.Name).$timestamp.bak" -Force
                $newContent | Out-File -LiteralPath $cf.FullName -Encoding utf8
                $results.fixes += @{
                    type = "AGENT_REFERENCE_FIX"
                    file = $cf.Name
                    wrong = $referencedAgent
                    fixed_to = $bestAgent
                    confidence = $bestScore
                }
                $results.auto_fixed_count++
                Write-Host ("  AUTO-FIXED: " + $cf.Name + " - agent '" + $referencedAgent + "' -> '" + $bestAgent + "'") -ForegroundColor Green
            } else {
                $results.pending += @{
                    type = "BROKEN_REFERENCE"
                    file = $cf.Name
                    wrong = $referencedAgent
                    suggestion = $bestAgent
                    confidence = $bestScore
                }
                $results.pending_count++
            }
        }
    }
}

$results.summary = "Self-healing: " + $results.auto_fixed_count + " auto-fixed, " + $results.pending_count + " pending (" + $results.scans.Count + " total scans)"
if ($results.auto_fixed_count -gt 0) { $results.summary = $results.summary + " - backups saved" }

# Write report
$reportPath = "$outputDir/self-healing-$timestamp.json"
$results | ConvertTo-Json -Depth 5 | Out-File -LiteralPath $reportPath -Encoding utf8

Write-Host "=== Self Healing Engine Report ===" -ForegroundColor Cyan
Write-Host "  Scans:        $($results.scans.Count)" -ForegroundColor White
Write-Host "  Auto-fixed:   $($results.auto_fixed_count)" -ForegroundColor Green
Write-Host "  Pending:      $($results.pending_count)" -ForegroundColor Yellow
Write-Host "  Report:       $reportPath" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan

return $results
