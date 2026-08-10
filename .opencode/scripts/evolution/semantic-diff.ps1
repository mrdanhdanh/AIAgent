<#
.SYNOPSIS
Semantic Diff Engine v1.0 — Phát hiện schema/contract/workflow/breaking changes
.DESCRIPTION
So sánh semantic giữa các phiên bản của Agent/Workflow/Schema contracts.
Không chỉ phát hiện "file changed" mà còn "semantic changed" — thay đổi ý nghĩa
của schema, contract, workflow, dependency.
.PARAMETER oldFile
File contract cũ (YAML)
.PARAMETER newFile
File contract mới (YAML)
.PARAMETER type
Loại: schema | contract | workflow | dependency | knowledge
.PARAMETER agentName
Tên agent cần diff (optional — nếu có, tự tìm contract cũ/mới)
.PARAMETER outputDir
Thư mục output (mặc định: .opencode/scripts/evolution/reports/)
#>

param(
    [string]$oldFile,
    [string]$newFile,
    [string]$agentName,
    [ValidateSet("schema", "contract", "workflow", "dependency", "knowledge")]
    [string]$type = "schema",
    [string]$outputDir = ".opencode/scripts/evolution/reports"
)

$ErrorActionPreference = "Stop"
$toolVersion = "1.0.0"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

# Ensure output directory
if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }

function Parse-YamlFile {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return $null }
    $content = Get-Content -LiteralPath $Path -Raw -Encoding utf8
    return $content
}

function Get-YamlField {
    param([string]$Content, [string]$Field)
    if (-not $Content) { return $null }
    if ($Content -match "^\s*$Field\s*:\s*(.+)$" -or $Content -match "(?m)^$Field\s*:\s*(.+)$") {
        return $Matches[1].Trim()
    }
    return $null
}

function Get-YamlBlock {
    param([string]$Content, [string]$Field)
    if (-not $Content) { return $null }
    $pattern = "(?ms)^$Field\s*:\s*\n(.+?)(?:\n\n|\z|^\w)"
    if ($Content -match $pattern) {
        return $Matches[1].Trim()
    }
    return $null
}

function Get-FieldNames {
    param([string]$Content)
    $fields = @()
    if (-not $Content) { return $fields }
    $fieldPattern = [regex]::Matches($Content, '(?m)^\s*(\w[\w_-]*)\s*:')
    foreach ($match in $fieldPattern) {
        $fields += $match.Groups[1].Value
    }
    return $fields | Sort-Object -Unique
}

function Compare-StringVersion {
    param([string]$v1, [string]$v2)
    if ($v1 -and $v2 -and $v1 -ne $v2) {
        $parts1 = $v1 -split '\.'
        $parts2 = $v2 -split '\.'
        for ($i = 0; $i -lt [Math]::Max($parts1.Length, $parts2.Length); $i++) {
            $p1 = if ($i -lt $parts1.Length) { [int]$parts1[$i] } else { 0 }
            $p2 = if ($i -lt $parts2.Length) { [int]$parts2[$i] } else { 0 }
            if ($p1 -lt $p2) { return "upgraded" }
            if ($p1 -gt $p2) { return "downgraded" }
        }
        return "different"
    }
    return "same"
}

# Main logic
$results = @{
    tool = "semantic-diff.ps1"
    version = $toolVersion
    timestamp = $timestamp
    type = $type
    changes = @()
    change_type_counts = @{
        schema_change = 0
        contract_change = 0
        workflow_change = 0
        dependency_change = 0
        knowledge_change = 0
        breaking_change = 0
    }
    summary = ""
    all_pass = $true
}

if ($agentName) {
    # Agent mode: find old and new contracts
    Write-Host "Running Semantic Diff in agent mode: $agentName" -ForegroundColor Cyan
    $contractPath = ".opencode/system/contracts/$agentName.yaml"
    if (-not (Test-Path $contractPath)) {
        $results.all_pass = $false
        $results.summary = "Contract not found for agent: $agentName"
        return $results
    }
    $newContent = Parse-YamlFile -Path $contractPath
    $results.new_file = $contractPath
    $results.agent = $agentName
    
    # For now, compare with embedded migration_rules
    $oldSchemaVer = Get-YamlField -Content $newContent -Field "contract_version"
    $supportedVers = Get-YamlBlock -Content $newContent -Field "supported_versions"
    $migrationRules = Get-YamlBlock -Content $newContent -Field "migration_rules"
    
    $results.changes += @{
        type = "contract_change"
        field = "contract_version"
        old_value = "unknown"
        new_value = $oldSchemaVer
        severity = "INFO"
        description = "Agent $agentName contract version: $oldSchemaVer"
    }
    
    # Parse migration rules
    if ($migrationRules) {
        $ruleMatches = [regex]::Matches($migrationRules, '(?m)^\s*"([^"]+)"\s*:')
        foreach ($rule in $ruleMatches) {
            $ver = $rule.Groups[1].Value
            $blockContent = Get-YamlBlock -Content $migrationRules -Field $ver.Replace('.', '_')
            
            $addedFields = @()
            $removedFields = @()
            $breaking = "false"
            
            if ($migrationRules -match "$ver.*?breaking:\s*(\w+)") {
                $breaking = $Matches[1]
            }
            
            $addedMatch = [regex]::Match($migrationRules, "(?ms)$ver.*?added:\s*\n(.+?)(?:\n\s+\w+|\z)")
            if ($addedMatch.Success) {
                $lines = $addedMatch.Groups[1].Value -split '\n'
                foreach ($line in $lines) {
                    if ($line -match '^\s*-\s*(.+)') {
                        $addedFields += $Matches[1].Trim()
                    }
                }
            }
            
            $removedMatch = [regex]::Match($migrationRules, "(?ms)$ver.*?removed:\s*\n(.+?)(?:\n\s+\w+|\z)")
            if ($removedMatch.Success) {
                $lines = $removedMatch.Groups[1].Value -split '\n'
                foreach ($line in $lines) {
                    if ($line -match '^\s*-\s*(.+)') {
                        $removedFields += $Matches[1].Trim()
                    }
                }
            }
            
            if ($addedFields.Count -gt 0) {
                $results.changes += @{
                    type = "schema_change"
                    field = "added_fields"
                    old_value = "none"
                    new_value = ($addedFields -join ', ')
                    severity = if ($breaking -eq 'true') { "BREAKING" } else { "MINOR" }
                    description = "Added fields: $($addedFields -join ', ')"
                    breaking = ($breaking -eq 'true')
                }
                $results.change_type_counts.schema_change++
                if ($breaking -eq 'true') { $results.change_type_counts.breaking_change++ }
            }
            
            if ($removedFields.Count -gt 0) {
                $results.changes += @{
                    type = if ($breaking -eq 'true') { "breaking_change" } else { "schema_change" }
                    field = "removed_fields"
                    old_value = ($removedFields -join ', ')
                    new_value = "removed"
                    severity = if ($breaking -eq 'true') { "BREAKING" } else { "MINOR" }
                    description = "Removed fields: $($removedFields -join ', ')"
                    breaking = ($breaking -eq 'true')
                }
                $results.change_type_counts.schema_change++
                if ($breaking -eq 'true') { $results.change_type_counts.breaking_change++ }
            }
        }
    }
    
} else {
    # Default to "no operation" if neither agent nor files specified
    $results.summary = "Semantic diff: No agent or files specified - running agent mode on planner"
    $results.all_pass = $true
}

if ($oldFile -and $newFile -and -not $agentName) {
    # File mode: compare two files
    Write-Host "Running Semantic Diff in file mode" -ForegroundColor Cyan
    $oldContent = Parse-YamlFile -Path $oldFile
    $newContent = Parse-YamlFile -Path $newFile
    
    $results.old_file = $oldFile
    $results.new_file = $newFile
    
    if (-not $oldContent -and $newContent) {
        $results.changes += @{
            type = $type
            field = "file"
            old_value = "not found"
            new_value = "created"
            severity = "MAJOR"
            description = "New file created: $newFile"
        }
        $results.change_type_counts."${type}_change"++
    } elseif ($oldContent -and -not $newContent) {
        $results.changes += @{
            type = $type
            field = "file"
            old_value = "existed"
            new_value = "deleted"
            severity = "BREAKING"
            description = "File deleted: $oldFile"
        }
        $results.change_type_counts.breaking_change++
    } elseif ($oldContent -and $newContent) {
        # Compare fields
        $oldFields = Get-FieldNames -Content $oldContent
        $newFields = Get-FieldNames -Content $newContent
        
        $addedFields = $newFields | Where-Object { $_ -notin $oldFields }
        $removedFields = $oldFields | Where-Object { $_ -notin $newFields }
        
        foreach ($f in $addedFields) {
            $results.changes += @{
                type = "$type_change"
                field = $f
                old_value = "not present"
                new_value = "added"
                severity = "MAJOR"
                description = "New field added: $f"
            }
            $results.change_type_counts."${type}_change"++
        }
        
        foreach ($f in $removedFields) {
            $results.changes += @{
                type = "$type_change"
                field = $f
                old_value = "existed"
                new_value = "removed"
                severity = "BREAKING"
                description = "Field removed: $f"
            }
            $results.change_type_counts.breaking_change++
        }
        
        # Check schema version
        $oldVer = Get-YamlField -Content $oldContent -Field "schema_version"
        $newVer = Get-YamlField -Content $newContent -Field "schema_version"
        if ($oldVer -and $newVer) {
            $verComparison = Compare-StringVersion -v1 $oldVer -v2 $newVer
            if ($verComparison -eq "upgraded") {
                $results.changes += @{
                    type = "schema_change"
                    field = "schema_version"
                    old_value = $oldVer
                    new_value = $newVer
                    severity = "MAJOR"
                    description = "Schema upgraded: $oldVer → $newVer"
                }
                $results.change_type_counts.schema_change++
            } elseif ($verComparison -eq "downgraded") {
                $results.changes += @{
                    type = "breaking_change"
                    field = "schema_version"
                    old_value = $oldVer
                    new_value = $newVer
                    severity = "BREAKING"
                    description = "Schema DOWNGRADED: $oldVer → $newVer"
                }
                $results.change_type_counts.breaking_change++
            }
        }
    }
}

# Compute summary
$totalChanges = $results.changes.Count
$breakingCount = ($results.changes | Where-Object { $_.severity -eq "BREAKING" }).Count
$majorCount = ($results.changes | Where-Object { $_.severity -eq "MAJOR" }).Count

$results.summary = "Semantic diff: " + $totalChanges + " changes (" + $breakingCount + " breaking, " + $majorCount + " major)"
if ($breakingCount -gt 0) { $results.all_pass = $false }

# Write report
$reportPath = "$outputDir/semantic-diff-$timestamp.json"
$results | ConvertTo-Json -Depth 5 | Out-File -LiteralPath $reportPath -Encoding utf8

Write-Host "=== Semantic Diff Engine Report ===" -ForegroundColor Cyan
Write-Host "  Type:         $type" -ForegroundColor White
Write-Host "  Changes:      $totalChanges" -ForegroundColor $(if ($totalChanges -eq 0) { "Green" } else { "Yellow" })
Write-Host "  Breaking:     $breakingCount" -ForegroundColor $(if ($breakingCount -eq 0) { "Green" } else { "Red" })
Write-Host "  Report:       $reportPath" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan

return $results
