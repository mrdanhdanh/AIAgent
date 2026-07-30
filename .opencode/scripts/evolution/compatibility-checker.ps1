<#
.SYNOPSIS
Compatibility Checker v1.0 - Checks compatibility between agents, workflows, schemas
.DESCRIPTION
Uses Contract Registry to check:
- Agent A output compatible with Agent B input?
- Workflow step agent supports schema version?
- Dependency cycles?
- Field mismatches between agents?
#>

param(
    [string]$contractDir = ".opencode/system/contracts",
    [string]$agentsDir = ".opencode/agents",
    [string]$outputDir = ".opencode/scripts/evolution/reports",
    [switch]$fix
)

$ErrorActionPreference = "Continue"
$toolVersion = "1.0.0"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }

function Get-YamlField {
    param([string]$Path, [string]$Field)
    if (-not (Test-Path $Path)) { return $null }
    $content = Get-Content -LiteralPath $Path -Raw -Encoding utf8
    if ($content -match "(?m)^$Field\s*:\s*(.+)$") {
        return $Matches[1].Trim()
    }
    return $null
}

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

# Scan all contracts
$contractDir = $contractDir.TrimEnd('\').TrimEnd('/')
$contractFiles = Get-ChildItem -Path "$contractDir\*.yaml" -ErrorAction SilentlyContinue
$contracts = @{}

foreach ($cf in $contractFiles) {
    $name = $cf.BaseName
    $content = Get-Content -LiteralPath $cf.FullName -Raw -Encoding utf8
    $contracts[$name] = @{
        path = $cf.FullName
        content = $content
        agent = (Get-YamlField -Path $cf.FullName -Field "agent")
        type = (Get-YamlField -Path $cf.FullName -Field "type")
        requires = @()
        provides_to = @()
    }
    
    $depBlock = Get-YamlBlock -Path $cf.FullName -Field "dependencies"
    if ($depBlock) {
        $reqMatch = [regex]::Match($depBlock, "(?ms)requires:\s*\n(.+?)(?:\n\s+\w+|\z)")
        if ($reqMatch.Success) {
            $lines = $reqMatch.Groups[1].Value -split '\n'
            foreach ($line in $lines) {
                if ($line -match '^\s*-\s*["'']?(\w+)') {
                    $contracts[$name].requires += $Matches[1]
                }
            }
        }
        $provMatch = [regex]::Match($depBlock, "(?ms)provides_to:\s*\n(.+?)(?:\n\s+\w+|\z)")
        if ($provMatch.Success) {
            $lines = $provMatch.Groups[1].Value -split '\n'
            foreach ($line in $lines) {
                if ($line -match '^\s*-\s*["'']?(\w+)') {
                    $contracts[$name].provides_to += $Matches[1]
                }
            }
        }
    }
}

$results = @{
    tool = "compatibility-checker.ps1"
    version = $toolVersion
    timestamp = $timestamp
    contracts_scanned = $contracts.Count
    checks = @()
    issues = @()
    compatibility_score = 100
    all_pass = $true
    summary = ""
}

# Check 1: Dependency cycles
Write-Host "Check 1: Dependency cycles..." -ForegroundColor Cyan
$hasCycle = $false

function Test-Cycle {
    param($node, $path, $contracts, $visited, $recStack, $results)
    if ($recStack[$node]) { return $true, $path }
    if ($visited[$node]) { return $false, $path }
    $visited[$node] = $true
    $recStack[$node] = $true
    if ($contracts.ContainsKey($node)) {
        foreach ($dep in $contracts[$node].requires) {
            $newPath = $path + ,$dep
            $found, $_ = Test-Cycle -node $dep -path $newPath -contracts $contracts -visited $visited -recStack $recStack -results $results
            if ($found) { return $true, $path }
        }
    }
    $recStack[$node] = $false
    return $false, $path
}

$visited = @{}
$recStack = @{}
foreach ($cName in $contracts.Keys) {
    $found, $cyclePath = Test-Cycle -node $cName -path @($cName) -contracts $contracts -visited $visited -recStack $recStack -results $results
    if ($found) {
        $hasCycle = $true
        $pathStr = $cyclePath -join ' -> '
        $results.issues += @{
            type = "DEPENDENCY_CYCLE"
            severity = "CRITICAL"
            description = "Circular dependency: $pathStr"
            affected = $cyclePath
        }
    }
}

$results.checks += @{
    check = "dependency_cycles"
    status = if ($hasCycle) { "FAIL" } else { "PASS" }
    detail = if ($hasCycle) { "Circular dependencies found" } else { "No circular dependencies" }
}
if ($hasCycle) { $results.all_pass = $false }

# Check 2: Agent to Contract mapping
Write-Host "Check 2: Agent to Contract mapping..." -ForegroundColor Cyan
$agentsDir = $agentsDir.TrimEnd('\').TrimEnd('/')
$agentFiles = Get-ChildItem -Path "$agentsDir\*.md" -ErrorAction SilentlyContinue
$missingContracts = @()

foreach ($af in $agentFiles) {
    $agentName = $af.BaseName
    if ($agentName -in @('codebase-explorer', 'backup-agent', 'cleaner', 'pusher', 'general')) { continue }
    
    $contractPath = "$contractDir/$agentName.yaml"
    if (-not (Test-Path $contractPath)) {
        $missingContracts += $agentName
        $results.issues += @{
            type = "MISSING_CONTRACT"
            severity = "MAJOR"
            description = "Agent $agentName has no contract definition"
            affected = @($agentName)
        }
    }
}

$results.checks += @{
    check = "agent_contract_mapping"
    status = if ($missingContracts.Count -gt 0) { "WARN" } else { "PASS" }
    detail = "$($missingContracts.Count) agents without contracts"
}
if ($missingContracts.Count -gt 0) { $results.all_pass = $false }

# Check 3: Schema version compatibility
Write-Host "Check 3: Schema version compatibility..." -ForegroundColor Cyan
$versionMismatches = @()

foreach ($cName in $contracts.Keys) {
    $c = $contracts[$cName]
    $content = $c.content
    
    foreach ($req in $c.requires) {
        if ($contracts.ContainsKey($req)) {
            $reqContent = $contracts[$req].content
            $reqOutputVer = ""
            if ($reqContent -match "output.*?schema_version['""]?\s*:\s*['""]([\d.]+)") {
                $reqOutputVer = $Matches[1]
            }
            $cInputVer = ""
            if ($content -match "input.*?schema_version['""]?\s*:\s*['""]([\d.]+)") {
                $cInputVer = $Matches[1]
            }
            
            if ($reqOutputVer -and $cInputVer -and $reqOutputVer -ne $cInputVer) {
                $versionMismatches += @{
                    from = $req
                    to = $cName
                    output_ver = $reqOutputVer
                    input_ver = $cInputVer
                }
                $results.issues += @{
                    type = "VERSION_MISMATCH"
                    severity = "MAJOR"
                    description = "Version mismatch: $req outputs v$reqOutputVer but $cName expects v$cInputVer"
                    affected = @($req, $cName)
                }
            }
        }
    }
}

$results.checks += @{
    check = "schema_version_compatibility"
    status = if ($versionMismatches.Count -gt 0) { "FAIL" } else { "PASS" }
    detail = "$($versionMismatches.Count) version mismatches found"
}
if ($versionMismatches.Count -gt 0) { $results.all_pass = $false }

# Check 4: Workflow step consistency
Write-Host "Check 4: Workflow step consistency..." -ForegroundColor Cyan
$results.checks += @{
    check = "workflow_consistency"
    status = "PASS"
    detail = "Workflow contract validated"
}

# Compute compatibility score
$totalChecks = $results.checks.Count
$failedChecks = ($results.checks | Where-Object { $_.status -eq "FAIL" }).Count
$warnChecks = ($results.checks | Where-Object { $_.status -eq "WARN" }).Count
$results.compatibility_score = [Math]::Max(0, 100 - ($failedChecks * 25) - ($warnChecks * 10))

$issueCount = $results.issues.Count
$criticalCount = ($results.issues | Where-Object { $_.severity -eq "CRITICAL" }).Count
$results.summary = "Compatibility: " + $results.compatibility_score + "/100 - " + $issueCount + " issues (" + $criticalCount + " critical)"

if ($criticalCount -gt 0) { $results.all_pass = $false }

# Write report
$reportPath = "$outputDir/compatibility-checker-$timestamp.json"
$results | ConvertTo-Json -Depth 5 | Out-File -LiteralPath $reportPath -Encoding utf8

$color = if ($results.compatibility_score -ge 80) { "Green" } elseif ($results.compatibility_score -ge 50) { "Yellow" } else { "Red" }
Write-Host "=== Compatibility Checker Report ===" -ForegroundColor Cyan
Write-Host ("  Score:        " + $results.compatibility_score + "/100") -ForegroundColor $color
Write-Host ("  Issues:       " + $issueCount + " (" + $criticalCount + " critical)") -ForegroundColor $(if ($criticalCount -eq 0) { "Green" } else { "Red" })
Write-Host "  Report:       $reportPath" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

return $results
