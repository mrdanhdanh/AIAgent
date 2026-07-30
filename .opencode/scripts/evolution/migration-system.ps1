<#
.SYNOPSIS
Migration System v1.0 — Tự động sinh migration plan khi có breaking changes
.DESCRIPTION
Giống như EF Migration — phát hiện thay đổi schema/contract và sinh migration tasks
để cập nhật toàn bộ hệ thống agents, workflows, docs, knowledge.
#>

param(
    [string]$contractDir = ".opencode/system/contracts",
    [string]$changeReport = "",
    [string]$outputDir = ".opencode/scripts/evolution/reports",
    [switch]$apply
)

$ErrorActionPreference = "Continue"
$toolVersion = "1.0.0"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }

function Get-YamlBlock {
    param([string]$Path, [string]$Field)
    if (-not (Test-Path $Path)) { return $null }
    $content = Get-Content -LiteralPath $Path -Raw -Encoding utf8
    $pattern = "(?ms)^$Field\s*:\s*\n(.+?)(?:\n\n|\z|^\w)"
    if ($content -match $pattern) {
        return $Matches[1].Trim()
    }
    return $null
}

$results = @{
    tool = "migration-system.ps1"
    version = $toolVersion
    timestamp = $timestamp
    migration_plan = @()
    affected_agents = @()
    tasks = @()
    pending = @()
    all_pass = $true
    summary = ""
}

# Load change report if provided
$changes = @()
if ($changeReport -and (Test-Path $changeReport)) {
    $reportContent = Get-Content -LiteralPath $changeReport -Raw -Encoding utf8
    try {
        $reportData = $reportContent | ConvertFrom-Json
        if ($reportData.changes) { $changes = $reportData.changes }
    } catch {
        Write-Host "WARNING: Could not parse change report" -ForegroundColor Yellow
    }
}

# Scan all contracts for migration rules
$contractFiles = Get-ChildItem -Path "$contractDir\*.yaml" -ErrorAction SilentlyContinue

foreach ($cf in $contractFiles) {
    $agentName = $cf.BaseName
    $content = Get-Content -LiteralPath $cf.FullName -Raw -Encoding utf8
    
    # Parse migration rules
    $ruleSection = Get-YamlBlock -Path $cf.FullName -Field "migration_rules"
    if (-not $ruleSection) { continue }
    
    $ruleMatches = [regex]::Matches($ruleSection, '(?m)^\s*"([^"]+)"\s*:')
    
    foreach ($rule in $ruleMatches) {
        $versionKey = $rule.Groups[1].Value
        $breaking = if ($ruleSection -match [regex]::Escape($versionKey) -and $ruleSection -match "breaking:\s*(true|false)") { $Matches[1] } else { "false" }
        
        # Parse added fields
        $addedFields = @()
        $addedMatch = [regex]::Match($ruleSection, "(?ms)" + [regex]::Escape($versionKey) + ".*?added:\s*\n(.+?)(?:\n\s+\w+|\z)")
        if ($addedMatch.Success) {
            $lines = $addedMatch.Groups[1].Value -split '\n'
            foreach ($line in $lines) {
                if ($line -match '^\s*-\s*(.+)') {
                    $addedFields += $Matches[1].Trim()
                }
            }
        }
        
        # Parse removed fields
        $removedFields = @()
        $removedMatch = [regex]::Match($ruleSection, "(?ms)" + [regex]::Escape($versionKey) + ".*?removed:\s*\n(.+?)(?:\n\s+\w+|\z)")
        if ($removedMatch.Success) {
            $lines = $removedMatch.Groups[1].Value -split '\n'
            foreach ($line in $lines) {
                if ($line -match '^\s*-\s*(.+)') {
                    $removedFields += $Matches[1].Trim()
                }
            }
        }
        
        if ($addedFields.Count -gt 0 -or $removedFields.Count -gt 0) {
            # Determine affected downstream agents
            $downstream = @()
            $depBlock = Get-YamlBlock -Path $cf.FullName -Field "dependencies"
            if ($depBlock -match "(?ms)provides_to:\s*\n(.+?)(?:\n\s+\w+|\z)") {
                $lines = $Matches[1] -split '\n'
                foreach ($line in $lines) {
                    if ($line -match '^\s*-\s*["'']?(\w+)') {
                        $downstream += $Matches[1]
                    }
                }
            }
            
            $task = @{
                source = $agentName
                version = $versionKey
                breaking = ($breaking -eq 'true')
                added = $addedFields
                removed = $removedFields
                downstream_affected = $downstream
                requires_migration = $true
            }
            $results.migration_plan += $task
            
            # Generate migration tasks
            if ($addedFields.Count -gt 0) {
                $results.tasks += @{
                    type = "ADD_FIELD_SUPPORT"
                    agent = $agentName
                    fields = $addedFields
                    action = "Update agent prompt/contract to support new fields"
                    priority = "HIGH"
                }
            }
            
            if ($removedFields.Count -gt 0) {
                $results.tasks += @{
                    type = "REMOVE_FIELD_SUPPORT"
                    agent = $agentName
                    fields = $removedFields
                    action = "Remove deprecated fields from agent prompt/contract"
                    priority = "HIGH"
                }
                $results.all_pass = $false
            }
            
            # Add downstream migration tasks
            foreach ($down in $downstream) {
                $results.tasks += @{
                    type = "DOWNSTREAM_MIGRATION"
                    agent = $down
                    source = $agentName
                    action = "Update $down to handle changes from $agentName ($versionKey)"
                    priority = if ($breaking -eq 'true') { "CRITICAL" } else { "MEDIUM" }
                }
                $results.affected_agents += $down
            }
            
            $results.affected_agents += $agentName
        }
    }
}

# Unique affected agents
$results.affected_agents = $results.affected_agents | Sort-Object -Unique

# Generate pending items
if ($results.tasks.Count -gt 0) {
    $results.pending = $results.tasks | Where-Object { $_.priority -eq "HIGH" -or $_.priority -eq "CRITICAL" } | ForEach-Object {
        "Update $($_.agent): $($_.action)"
    }
}

$results.summary = "Migration: " + $results.migration_plan.Count + " schema changes, " + $results.tasks.Count + " tasks, " + $results.affected_agents.Count + " affected agents"
if ($results.tasks.Count -eq 0) {
    $results.summary = "Migration: No migration required - all contracts up to date"
}

# Write report
$reportPath = "$outputDir/migration-system-$timestamp.json"
$results | ConvertTo-Json -Depth 5 | Out-File -LiteralPath $reportPath -Encoding utf8

Write-Host "=== Migration System Report ===" -ForegroundColor Cyan
Write-Host "  Schema changes: $($results.migration_plan.Count)" -ForegroundColor White
Write-Host "  Tasks:          $($results.tasks.Count)" -ForegroundColor $(if ($results.tasks.Count -eq 0) { "Green" } else { "Yellow" })
Write-Host "  Affected:       $($results.affected_agents.Count) agents" -ForegroundColor $(if ($results.affected_agents.Count -eq 0) { "Green" } else { "Yellow" })
Write-Host "  Report:         $reportPath" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

return $results
