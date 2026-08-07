<#
.SYNOPSIS
    Governance Rule Checker - validate object (agent/capability/workflow/plugin/...)
    theo governance.rules.yaml. Trien khai GOV-001..GOV-007.

.DESCRIPTION
    Doc .opencode/governance/governance.rules.yaml (YAML subset, parser tu viet
    vi ConvertFrom-Yaml khong co tren PS 5.1). Kiem tra object truyen qua params
    hoac -ObjectPath (JSON file).

    Checks:
      GOV-001 naming     - id format theo regex per type (rules.naming.<type>_id)
      GOV-002 lifecycle  - deprecated phai co replacement (neu rule bat buoc)
      GOV-003 approval   - delete > 100 files can approval (neu rule bat buoc)
      GOV-004 review     - critical code can review (rules.review.critical_requires_review)
      GOV-005 security   - plugin phai signed (rules.security.plugin_signed);
                           secret scan tren Content (rules.security.secret_scan)
      GOV-006 compliance - rules store + policies store ton tai va parse duoc
      GOV-007 audit      - audit log dir ton tai (default .opencode/governance/audit)

    Exit 0 = PASS, exit 1 = FAIL. Output JSON report via -ReportPath.

.EXAMPLE
    .opencode/scripts/governance/governance-check.ps1 -Type agent -Name "planner" -Owner "core" -Version "1.0.0"
    .opencode/scripts/governance/governance-check.ps1 -Type plugin -Name "oracle" -Signed -Content "<file content de scan secret>"
    .opencode/scripts/governance/governance-check.ps1 -ObjectPath .opencode/registry/agents.json
#>
param(
    [string]$ObjectPath   = "",
    [string]$RulesPath    = "",
    [string]$PoliciesPath = "",
    [string]$Type         = "agent",
    [string]$Name         = "",
    [string]$Owner        = "",
    [string]$Version      = "",
    [string]$Checksum     = "",
    [int]$DeleteCount     = 0,
    [switch]$Deprecated,
    [string]$Replacement  = "",
    [switch]$Critical,
    [switch]$Reviewed,
    [switch]$Approved,
    [switch]$Signed,
    [string]$Content      = "",
    [switch]$Silent,
    [string]$ReportPath   = ""
)
$ErrorActionPreference = "Stop"

function Read-Utf8([string]$path) {
    return [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
}

# ---- YAML subset parser: key: value, nested maps, inline [list] ----
function ConvertFrom-SimpleYaml {
    param([string]$Text)
    $root = @{}
    $stack = New-Object System.Collections.ArrayList
    foreach ($line in ($Text -split "`r?`n")) {
        if ($line.Trim() -eq "") { continue }
        if ($line.Trim().StartsWith("#")) { continue }
        $indent = 0
        while ($indent -lt $line.Length -and $line[$indent] -eq " ") { $indent++ }
        $trimmed = $line.Trim()
        if ($trimmed -notmatch "^([^:]+):\s*(.*)$") { continue }
        $key = $Matches[1].Trim()
        $val = $Matches[2].Trim()
        while ($stack.Count -gt 0 -and $stack[$stack.Count-1].indent -ge $indent) {
            $stack.RemoveAt($stack.Count - 1)
        }
        $parent = if ($stack.Count -gt 0) { $stack[$stack.Count-1].node } else { $root }
        if ($val -eq "" -or $val -eq "|") {
            $child = @{}
            $parent[$key] = $child
            $null = $stack.Add(@{ indent = $indent; node = $child })
        }
        elseif ($val.StartsWith("[") -and $val.EndsWith("]")) {
            $items = @()
            foreach ($item in ($val.Substring(1, $val.Length - 2) -split ",")) {
                $items += $item.Trim().Trim('"').Trim("'")
            }
            $parent[$key] = $items
        }
        else {
            $parent[$key] = $val.Trim('"').Trim("'")
        }
    }
    return $root
}

# ---- defaults ----
$rootDir = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)   # .opencode/
if (-not $RulesPath)    { $RulesPath    = Join-Path $rootDir "governance\governance.rules.yaml" }
if (-not $PoliciesPath) { $PoliciesPath = Join-Path $rootDir "policy\policies.yaml" }

# ---- load object ----
if ($ObjectPath -and (Test-Path -LiteralPath $ObjectPath)) {
    try {
        $obj = Read-Utf8 $ObjectPath | ConvertFrom-Json
        if (-not $Name)     { $Name     = [string]$obj.name }
        if (-not $Type)     { $Type     = [string]$obj.type }
        if (-not $Owner)    { $Owner    = [string]$obj.owner }
        if (-not $Version)  { $Version  = [string]$obj.version }
        if (-not $Checksum) { $Checksum = [string]$obj.checksum }
        if ($obj.deprecated) { $Deprecated = $true }
        if (-not $Replacement -and $obj.replacement) { $Replacement = [string]$obj.replacement }
    }
    catch { Write-Error "cannot parse ObjectPath: $_"; exit 1 }
}

# ---- load rules ----
$rules = $null
$rulesOk = $false
$rulesMsg = "missing"
if (Test-Path -LiteralPath $RulesPath) {
    try {
        $rules = ConvertFrom-SimpleYaml (Read-Utf8 $RulesPath)
        $rulesOk = $true
        $rulesMsg = "loaded"
    }
    catch { $rulesMsg = "parse error: $_" }
}

# ---- GOV-006: compliance (rules + policies store) ----
$policiesOk = $false
$policiesMsg = "missing"
if (Test-Path -LiteralPath $PoliciesPath) {
    try {
        $pol = ConvertFrom-SimpleYaml (Read-Utf8 $PoliciesPath)
        if ($pol.ContainsKey("policies")) { $policiesOk = $true; $policiesMsg = "loaded" }
        else { $policiesMsg = "no 'policies' key" }
    }
    catch { $policiesMsg = "parse error: $_" }
}

# ---- GOV-007: audit dir ----
$auditDir = Join-Path $rootDir "governance\audit"
$auditOk = Test-Path -LiteralPath $auditDir

# ---- GOV-001: naming regex per type ----
$pattern = "^[a-z][a-z0-9-]*$"
if ($rulesOk -and $rules.ContainsKey("rules") -and $rules.rules.ContainsKey("naming")) {
    $naming = $rules.rules.naming
    $keyName = $Type + "_id"
    if ($naming.ContainsKey($keyName)) { $pattern = [string]$naming[$keyName] }
}
$namingOk = ($Name -and $Name -match $pattern)

# ---- GOV-002: lifecycle ----
$lifecycleRequired = $true
if ($rulesOk -and $rules.ContainsKey("rules") -and $rules.rules.ContainsKey("lifecycle") -and $rules.rules.lifecycle.ContainsKey("deprecated_requires_replacement")) {
    $lifecycleRequired = [bool]::Parse([string]$rules.rules.lifecycle.deprecated_requires_replacement)
}
$lifecycleOk = (-not $Deprecated) -or (-not $lifecycleRequired) -or (-not [string]::IsNullOrWhiteSpace($Replacement))

# ---- GOV-003: approval ----
$approvalRequired = "required"
if ($rulesOk -and $rules.ContainsKey("rules") -and $rules.rules.ContainsKey("approval") -and $rules.rules.approval.ContainsKey("delete_gt_100_files")) {
    $approvalRequired = [string]$rules.rules.approval.delete_gt_100_files
}
$approvalOk = ($DeleteCount -le 100) -or ($approvalRequired -ne "required") -or $Approved

# ---- GOV-004: review ----
$reviewRequired = $true
if ($rulesOk -and $rules.ContainsKey("rules") -and $rules.rules.ContainsKey("review") -and $rules.rules.review.ContainsKey("critical_requires_review")) {
    $reviewRequired = [bool]::Parse([string]$rules.rules.review.critical_requires_review)
}
$reviewOk = (-not $Critical) -or (-not $reviewRequired) -or $Reviewed

# ---- GOV-005: security ----
$signedRequired = $true
if ($rulesOk -and $rules.ContainsKey("rules") -and $rules.rules.ContainsKey("security") -and $rules.rules.security.ContainsKey("plugin_signed")) {
    $signedRequired = [bool]::Parse([string]$rules.rules.security.plugin_signed)
}
$signedOk = ($Type -ne "plugin") -or (-not $signedRequired) -or $Signed

$secretOk = $true
$secretHit = ""
$secretScan = $true
if ($rulesOk -and $rules.ContainsKey("rules") -and $rules.rules.ContainsKey("security") -and $rules.rules.security.ContainsKey("secret_scan")) {
    $secretScan = [bool]::Parse([string]$rules.rules.security.secret_scan)
}
if ($secretScan -and $Content) {
    $patterns = @("(?i)api[_-]?key\s*[=:]", "(?i)password\s*[=:]", "(?i)secret\s*[=:]", "(?i)token\s*[=:]", "BEGIN [A-Z ]*PRIVATE KEY")
    foreach ($p in $patterns) {
        if ($Content -match $p) { $secretOk = $false; $secretHit = $p; break }
    }
}

# ---- report ----
$checks = @(
    @{ code = "GOV-001"; name = "naming";     pass = $namingOk;     detail = "type=$Type name='$Name' pattern='$pattern'" }
    @{ code = "GOV-002"; name = "lifecycle";  pass = $lifecycleOk;  detail = "deprecated=$Deprecated replacement='$Replacement'" }
    @{ code = "GOV-003"; name = "approval";   pass = $approvalOk;   detail = "deleteCount=$DeleteCount approved=$Approved" }
    @{ code = "GOV-004"; name = "review";     pass = $reviewOk;     detail = "critical=$Critical reviewed=$Reviewed" }
    @{ code = "GOV-005"; name = "security";   pass = ($signedOk -and $secretOk); detail = "signed=$Signed secretScan=$secretScan hit='$secretHit'" }
    @{ code = "GOV-006"; name = "compliance"; pass = ($rulesOk -and $policiesOk); detail = "rules=$rulesMsg policies=$policiesMsg" }
    @{ code = "GOV-007"; name = "audit";      pass = $auditOk;      detail = "auditDir=$auditDir" }
)
$allPass = -not ($checks | Where-Object { -not $_.pass })

$report = @{
    status = if ($allPass) { "PASS" } else { "FAIL" }
    type   = $Type
    name   = $Name
    checks = $checks
}

if ($ReportPath) {
    $dir = Split-Path -Parent $ReportPath
    if ($dir -and -not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    Write-Utf8 $ReportPath ($report | ConvertTo-Json -Depth 5)
}
elseif (-not $Silent) {
    Write-Host "GOVERNANCE-CHECK $($report.status)  type=$Type name='$Name'"
    foreach ($c in $checks) {
        Write-Host ("  {0} {1,-10} {2}" -f $(if ($c.pass) { "[PASS]" } else { "[FAIL]" }), $c.code, $c.detail)
    }
}

if ($allPass) { exit 0 } else { exit 1 }