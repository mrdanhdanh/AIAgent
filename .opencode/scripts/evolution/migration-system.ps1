<#
.SYNOPSIS
Migration System v1.0 — Tự động sinh migration plan khi có breaking changes
.DESCRIPTION
Giống như EF Migration — phát hiện thay đổi schema/contract và sinh migration tasks
để cập nhật toàn bộ hệ thống agents, workflows, docs, knowledge.
#>

param(
    [string]$contractDir = ".opencode/system/contracts",
    [string]$agentsDir = ".opencode/agents",
    [string]$changeReport = "",
    [string]$outputDir = ".opencode/scripts/evolution/reports",
    [switch]$apply
)

$ErrorActionPreference = "Continue"
$toolVersion = "1.1.0"
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

# Xác định file target cho agent: .md nếu tồn tại, workflow thì dùng contract
function Get-AgentTargetFile {
    param([string]$AgentName, [string]$AgentsDir, [string]$ContractDir)
    $md = Join-Path $AgentsDir "$AgentName.md"
    if (Test-Path $md) { return $md }
    if ($AgentName -eq "workflow") {
        $wf = Join-Path $ContractDir "workflow.yaml"
        if (Test-Path $wf) { return $wf }
    }
    return $null
}

# Trích token "ý nghĩa" từ field string (bỏ chú thích trong ngoặc, từ < 4 ký tự)
function Get-FieldTokens {
    param([string]$Field)
    $clean = $Field -replace '\s*\(.*?\)', ''
    $tokens = $clean -split '[\.\s]+' | Where-Object { $_ -and $_.Length -ge 4 }
    if ($tokens.Count -eq 0) { $tokens = @($clean -replace '\s+', '') }
    return @($tokens | Select-Object -Unique)
}

# Kiểm tra agent đã hỗ trợ field chưa (bất kỳ token ý nghĩa nào xuất hiện trong file)
function Test-AgentSupportsField {
    param([string]$AgentName, [string]$Field, [string]$AgentsDir, [string]$ContractDir)
    $target = Get-AgentTargetFile -AgentName $AgentName -AgentsDir $AgentsDir -ContractDir $ContractDir
    if (-not $target) { return $false }
    $content = Get-Content -LiteralPath $target -Raw -Encoding utf8
    $tokens = Get-FieldTokens -Field $Field
    foreach ($token in $tokens) {
        if ($content -match [regex]::Escape($token)) { return $true }
    }
    return $false
}

# Kiểm tra agent đã loại bỏ field deprecated chưa — chỉ dùng token đầu (tên field thật)
function Test-AgentRemovedField {
    param([string]$AgentName, [string]$Field, [string]$AgentsDir, [string]$ContractDir)
    $target = Get-AgentTargetFile -AgentName $AgentName -AgentsDir $AgentsDir -ContractDir $ContractDir
    if (-not $target) { return $false }
    $content = Get-Content -LiteralPath $target -Raw -Encoding utf8
    $primary = ($Field -split '\s+')[0] -replace '[()]', ''
    if ($primary.Length -lt 3) { $primary = (Get-FieldTokens -Field $Field)[0] }
    return -not ($content -match [regex]::Escape($primary))
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
            
            # Generate migration tasks — verify agent file thực tế trước khi tạo
            if ($addedFields.Count -gt 0) {
                $unsupported = @($addedFields | Where-Object { -not (Test-AgentSupportsField -AgentName $agentName -Field $_ -AgentsDir $agentsDir -ContractDir $contractDir) })
                if ($unsupported.Count -gt 0) {
                    $results.tasks += @{
                        type = "ADD_FIELD_SUPPORT"
                        agent = $agentName
                        fields = $unsupported
                        action = "Update agent prompt/contract to support new fields"
                        priority = "HIGH"
                        status = "PENDING"
                    }
                }
            }
            
            if ($removedFields.Count -gt 0) {
                $stillPresent = @($removedFields | Where-Object { -not (Test-AgentRemovedField -AgentName $agentName -Field $_ -AgentsDir $agentsDir -ContractDir $contractDir) })
                if ($stillPresent.Count -gt 0) {
                    $results.tasks += @{
                        type = "REMOVE_FIELD_SUPPORT"
                        agent = $agentName
                        fields = $stillPresent
                        action = "Remove deprecated fields from agent prompt/contract"
                        priority = "HIGH"
                        status = "PENDING"
                    }
                    $results.all_pass = $false
                }
            }
            
            # Add downstream migration tasks
            foreach ($down in $downstream) {
                $results.tasks += @{
                    type = "DOWNSTREAM_MIGRATION"
                    agent = $down
                    source = $agentName
                    action = "Update $down to handle changes from $agentName ($versionKey)"
                    priority = if ($breaking -eq 'true') { "CRITICAL" } else { "MEDIUM" }
                    status = "PENDING"
                }
                $results.affected_agents += $down
            }
            
            $results.affected_agents += $agentName
        }
    }
}

# Unique affected agents
$results.affected_agents = $results.affected_agents | Sort-Object -Unique

# Pending items = tasks chưa thực sự hỗ trợ (chỉ ADD/REMOVE, bỏ DOWNSTREAM trùng)
$pendingTasks = @($results.tasks | Where-Object { $_.type -ne "DOWNSTREAM_MIGRATION" -and $_.status -ne "DONE" })
$results.all_pass = ($pendingTasks.Count -eq 0)

# Generate pending items
if ($pendingTasks.Count -gt 0) {
    $results.pending = $pendingTasks | Where-Object { $_.priority -eq "HIGH" -or $_.priority -eq "CRITICAL" } | ForEach-Object {
        "Update $($_.agent): $($_.action)"
    }
}

$results.summary = "Migration: " + $results.migration_plan.Count + " schema changes, " + $pendingTasks.Count + " pending task(s), " + $results.affected_agents.Count + " affected agents"
if ($pendingTasks.Count -eq 0) {
    $results.summary = "Migration: All contracts up to date - agents verified against schema"
    $results.all_pass = $true
}

# Write report
$reportPath = "$outputDir/migration-system-$timestamp.json"
$results | ConvertTo-Json -Depth 5 | Out-File -LiteralPath $reportPath -Encoding utf8

Write-Host "=== Migration System Report ===" -ForegroundColor Cyan
Write-Host "  Schema changes: $($results.migration_plan.Count)" -ForegroundColor White
Write-Host "  Tasks:          $($pendingTasks.Count)" -ForegroundColor $(if ($pendingTasks.Count -eq 0) { "Green" } else { "Yellow" })
Write-Host "  Affected:       $($results.affected_agents.Count) agents" -ForegroundColor $(if ($results.affected_agents.Count -eq 0) { "Green" } else { "Yellow" })
Write-Host "  All pass:       $($results.all_pass)" -ForegroundColor $(if ($results.all_pass) { "Green" } else { "Red" })
Write-Host "  Report:         $reportPath" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

return $results
