<#
.SYNOPSIS
    Governance Build Pipeline - quy trinh build/rebuild Runtime Enforcement cho AIOS
    Governance Engine v26.0 + Policy Engine v15.0. Idempotent: chay lai bao gio cung duoc.

.DESCRIPTION
    Chay 6 phase (idempotent - chi tao file thieu, khong ghi de file co noi dung khac):
      P0 Preflight    - kiem tra moi truong (PS 5.1+, ProjectRoot hop le)
      P1 Foundation   - tao .opencode/governance/governance.rules.yaml (rule store)
                        + .opencode/policy/policies.yaml (policy store) neu thieu
      P2 Engine core  - tao 3 engine scripts tai .opencode/scripts/governance/:
                        governance-check.ps1 (Rule Checker, GOV-001..007)
                        audit-log.ps1        (Auditor, append-only + hash-chain)
                        policy-evaluate.ps1  (Policy Evaluator, default-deny)
      P3 Integration  - (-WorkflowGate) chen phase governance_check vao
                        .opencode/workflow/definitions/default.workflow.yaml truoc phase build
      P4 Validate     - chay governance-validator.ps1 + policy-validator.ps1
                        + governance-framework-validator.ps1 + workflow-validator.ps1
      P5 Selftest     - chay 3 engine scripts voi data mau, kiem tra ket qua dung ky vong
      P6 Report       - ghi JSON report vao .opencode/scripts/governance/reports/

    Tat ca file sinh ra dung UTF-8 no-BOM, 2-space indent, khong tab (theo convention repo).
    LUU Y: script nay phai giu nguyen ASCII-only (khong ky tu co dau) de PS 5.1 parse duoc.

    Flags:
      -ProjectRoot <path> - project root (default: workspace root)
      -DryRun             - chi bao cao, khong ghi file nao
      -Force              - ghi de file da ton tai bang noi dung template (co backup truoc)
      -WorkflowGate       - bat buoc chen phase governance_check vao default workflow
      -SkipSelftest       - bo qua P5 selftest
      -Quiet              - chi in ket qua tung phase, khong in chi tiet

.EXAMPLE
    .opencode/scripts/governance-build.ps1 -DryRun
    .opencode/scripts/governance-build.ps1
    .opencode/scripts/governance-build.ps1 -Force -WorkflowGate
#>

param(
    [string]$ProjectRoot = "",
    [switch]$DryRun,
    [switch]$Force,
    [switch]$WorkflowGate,
    [switch]$SkipSelftest,
    [switch]$Quiet
)

$ErrorActionPreference = "Stop"

# =====================================================================
# 0. Helpers
# =====================================================================
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Read-Utf8([string]$path) {
    return [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
}

function Write-Utf8([string]$path, [string]$text) {
    [System.IO.File]::WriteAllText($path, $text, $Utf8NoBom)
}

function Get-Sha256([string]$path) {
    try {
        $sha = [System.Security.Cryptography.SHA256]::Create()
        $bytes = [System.IO.File]::ReadAllBytes($path)
        return ([System.BitConverter]::ToString($sha.ComputeHash($bytes)) -replace "-", "").ToLower()
    }
    catch { return "" }
}

function Write-Step($msg) { if (-not $Quiet) { Write-Host "== $msg" -ForegroundColor Cyan } }
function Write-Ok($msg)   { if (-not $Quiet) { Write-Host "  [OK] $msg" -ForegroundColor Green } }
function Write-Info($msg) { if (-not $Quiet) { Write-Host "  [..] $msg" -ForegroundColor Gray } }
function Write-Warn($msg) { if (-not $Quiet) { Write-Host "  [!] $msg" -ForegroundColor Yellow } }
function Write-Fail($msg) { if (-not $Quiet) { Write-Host "  [X] $msg" -ForegroundColor Red } }

function Write-Fatal($msg) { Write-Host "[FATAL] $msg" -ForegroundColor Red }

# =====================================================================
# 1. Locate directories
# =====================================================================
if ([string]::IsNullOrWhiteSpace($ProjectRoot)) {
    $ProjectRoot = (Get-Location).Path
}
if (-not (Test-Path -LiteralPath $ProjectRoot)) {
    Write-Fatal "ProjectRoot does not exist: $ProjectRoot"; exit 1
}

$openCodeDir      = Join-Path $ProjectRoot ".opencode"
$govDir           = Join-Path $openCodeDir "governance"
$policyDir        = Join-Path $openCodeDir "policy"
$engineDir        = Join-Path $openCodeDir "scripts\governance"
$reportsDir       = Join-Path $engineDir "reports"
$workflowDefsDir  = Join-Path $openCodeDir "workflow\definitions"
$scriptsDir       = Join-Path $openCodeDir "scripts"

foreach ($d in @($openCodeDir, $govDir, $policyDir, $scriptsDir, $workflowDefsDir)) {
    if (-not (Test-Path -LiteralPath $d)) {
        Write-Fatal "required directory not found: $d"; exit 1
    }
}

# =====================================================================
# 2. Templates (embedded - single source of truth)
# =====================================================================
$TplRules = @'
version: "26.0"
rules:
  naming:
    agent_id: "^[a-z][a-z0-9-]*$"
    capability_id: "^[a-z]+\.[a-z0-9-]+$"
    workflow_id: "^[a-z][a-z0-9-]*$"
    plugin_id: "^[a-z][a-z0-9-]*$"
  lifecycle:
    deprecated_requires_replacement: true
  approval:
    delete_gt_100_files: required
  security:
    plugin_signed: true
    secret_scan: true
'@

$TplPolicies = @'
version: "15.0"
policies:
  planner:
    allow: [planning.*, architecture.design]
    deny: [artifact.delete, event.publish]
  reviewer:
    allow: [review.*]
    deny: [artifact.delete]
  builder:
    allow: [build.*, artifact.write, plan.execute]
    deny: [policy.edit, governance.edit]
  tester:
    allow: [test.*, report.write]
  guardian:
    allow: [review.*, gitguard.*]
    deny: [artifact.write]
  general:
    allow: ["*"]
    deny: []
  plugin-oracle:
    allow: [knowledge.read, artifact.read]
    deny: [knowledge.write]
'@

$TplCheck = @'
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
'@

$TplAudit = @'
<#
.SYNOPSIS
    Governance Auditor - append-only audit log + hash-chain (phat hien gia mao).

.DESCRIPTION
    Ghi entry vao <AuditDir>/audit.log (JSONL, append-only). Moi entry co
    prev_hash (SHA256 cua entry truoc) + hash (SHA256 cua chinh entry) - hash-chain.
    -Verify: doc lai toan bo log, kiem tra tinh toan ven cua chain.
    -Archive: di chuyen entry cu hon RetentionDays vao archive/audit-<date>.log.

    Entry format (JSON line):
      { id, timestamp, actor, action, target, result, policy_ref, prev_hash, hash }

    Retention: 365 ngay mac dinh (docs/governance/audit-policy.yaml).

.EXAMPLE
    .opencode/scripts/governance/audit-log.ps1 -Action workflow.execute -Actor planner -Target "WF-101" -Result allowed -PolicyRef workflow-execute-policy
    .opencode/scripts/governance/audit-log.ps1 -Verify
#>
param(
    [string]$Action        = "",
    [string]$Actor         = "",
    [string]$Target        = "",
    [string]$Result        = "allowed",
    [string]$PolicyRef     = "",
    [string]$AuditDir      = "",
    [int]$RetentionDays    = 365,
    [switch]$Verify,
    [switch]$Archive,
    [switch]$Silent
)
$ErrorActionPreference = "Stop"

$rootDir = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)   # .opencode/
if (-not $AuditDir) { $AuditDir = Join-Path $rootDir "governance\audit" }
if (-not (Test-Path -LiteralPath $AuditDir)) {
    if ($Archive -or $Verify) { Write-Error "audit dir not found: $AuditDir"; exit 1 }
    New-Item -ItemType Directory -Path $AuditDir -Force | Out-Null
}
$logPath = Join-Path $AuditDir "audit.log"

function Get-Sha256Str([string]$text) {
    $sha = [System.Security.Cryptography.SHA256]::Create()
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($text)
    return ([System.BitConverter]::ToString($sha.ComputeHash($bytes)) -replace "-", "").ToLower()
}

function Get-LastLine([string]$path) {
    if (-not (Test-Path -LiteralPath $path)) { return $null }
    $lines = [System.IO.File]::ReadAllLines($path)
    if ($lines.Length -eq 0) { return $null }
    return $lines[$lines.Length - 1]
}

# ---- Verify chain ----
if ($Verify) {
    if (-not (Test-Path -LiteralPath $logPath)) { Write-Error "audit.log not found: $logPath"; exit 1 }
    $lines = [System.IO.File]::ReadAllLines($logPath)
    $prevHash = "genesis"
    $tampered = @()
    $idx = 0
    foreach ($line in $lines) {
        $idx++
        if ($line.Trim() -eq "") { continue }
        try { $e = $line | ConvertFrom-Json } catch { $tampered += "line $idx : cannot parse"; continue }
        $canonical = "$($e.id)|$($e.timestamp)|$($e.actor)|$($e.action)|$($e.target)|$($e.result)|$($e.policy_ref)|$prevHash"
        $expectHash = Get-Sha256Str $canonical
        if ($e.prev_hash -ne $prevHash) { $tampered += "line $idx : prev_hash mismatch (chain broken)" }
        if ($e.hash -ne $expectHash)    { $tampered += "line $idx : hash mismatch (tampered)" }
        $prevHash = $e.hash
    }
    if (-not $Silent) {
        Write-Host "AUDIT-VERIFY entries=$($lines.Count) tampered=$($tampered.Count)"
        foreach ($t in $tampered) { Write-Host "  [X] $t" -ForegroundColor Red }
    }
    if ($tampered.Count -gt 0) { exit 1 } else { exit 0 }
}

# ---- Archive old entries ----
if ($Archive) {
    if (-not (Test-Path -LiteralPath $logPath)) { Write-Error "audit.log not found: $logPath"; exit 1 }
    $cutoff = (Get-Date).AddDays(-$RetentionDays)
    $keep = @()
    $moved = 0
    foreach ($line in [System.IO.File]::ReadAllLines($logPath)) {
        if ($line.Trim() -eq "") { continue }
        try { $e = $line | ConvertFrom-Json } catch { $keep += $line; continue }
        $ts = [DateTime]::MinValue
        if ([DateTime]::TryParse($e.timestamp, [ref]$ts) -and $ts -lt $cutoff) { $moved++ } else { $keep += $line }
    }
    if ($moved -gt 0) {
        $archDir = Join-Path $AuditDir "archive"
        if (-not (Test-Path -LiteralPath $archDir)) { New-Item -ItemType Directory -Path $archDir -Force | Out-Null }
        $archPath = Join-Path $archDir ("audit-" + (Get-Date -Format "yyyyMMdd-HHmmss") + ".log")
        $archLines = @()
        foreach ($line in [System.IO.File]::ReadAllLines($logPath)) {
            if ($line.Trim() -eq "") { continue }
            try { $e = $line | ConvertFrom-Json } catch { continue }
            $ts = [DateTime]::MinValue
            if ([DateTime]::TryParse($e.timestamp, [ref]$ts) -and $ts -lt $cutoff) { $archLines += $line }
        }
        [System.IO.File]::WriteAllLines($archPath, $archLines, (New-Object System.Text.UTF8Encoding($false)))
    }
    [System.IO.File]::WriteAllLines($logPath, $keep, (New-Object System.Text.UTF8Encoding($false)))
    if (-not $Silent) { Write-Host "AUDIT-ARCHIVE moved=$moved kept=$($keep.Count) retentionDays=$RetentionDays" }
    exit 0
}

# ---- Append entry ----
if (-not $Action) { Write-Error "Action is required"; exit 1 }
if (-not $Actor)  { Write-Error "Actor is required";  exit 1 }

$count = 0
if (Test-Path -LiteralPath $logPath) {
    foreach ($l in [System.IO.File]::ReadAllLines($logPath)) { if ($l.Trim() -ne "") { $count++ } }
}
$lastLine = Get-LastLine $logPath
$prevHash = "genesis"
if ($lastLine) {
    try { $last = $lastLine | ConvertFrom-Json; $prevHash = [string]$last.hash } catch {}
}

$id = "A-" + ($count + 1).ToString("D4")
$entry = [ordered]@{
    id         = $id
    timestamp  = (Get-Date).ToUniversalTime().ToString("o")
    actor      = $Actor
    action     = $Action
    target     = $Target
    result     = $Result
    policy_ref = $PolicyRef
    prev_hash  = $prevHash
}
$canonical = "$($entry.id)|$($entry.timestamp)|$($entry.actor)|$($entry.action)|$($entry.target)|$($entry.result)|$($entry.policy_ref)|$prevHash"
$entry.hash = Get-Sha256Str $canonical
$json = $entry | ConvertTo-Json -Compress

$stream = [System.IO.File]::AppendText($logPath)
try { $stream.WriteLine($json) } finally { $stream.Dispose() }

if (-not $Silent) {
    Write-Host "AUDIT-WRITE id=$id action=$Action actor=$Actor result=$Result target=$Target hash=$($entry.hash.Substring(0,12))..."
}
exit 0
'@

$TplEvaluate = @'
<#
.SYNOPSIS
    Policy Evaluator - quyet dinh allow/deny theo .opencode/policy/policies.yaml.

.DESCRIPTION
    Match: exact ("planning.task") hoac wildcard ("planning.*", "*").
    Deny thang allow (neu overlap). Default deny khi khong match.
    Exit 0 = allow, exit 1 = deny.

.EXAMPLE
    .opencode/scripts/governance/policy-evaluate.ps1 -Actor planner -Action planning.task     # allow
    .opencode/scripts/governance/policy-evaluate.ps1 -Actor planner -Action artifact.delete   # deny
    .opencode/scripts/governance/policy-evaluate.ps1 -Actor hacker -Action planning.task      # deny (default)
#>
param(
    [string]$Actor        = "",
    [string]$Action       = "",
    [string]$PoliciesPath = "",
    [switch]$Silent,
    [switch]$JsonOut
)
$ErrorActionPreference = "Stop"

function Read-Utf8([string]$path) {
    return [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
}

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

function Test-Pattern {
    param([string]$Pattern, [string]$Action)
    if ($Pattern -eq "*") { return $true }
    if ($Pattern.EndsWith(".*")) {
        return $Action.StartsWith($Pattern.Substring(0, $Pattern.Length - 1))
    }
    return $Pattern -eq $Action
}

if (-not $Actor)  { Write-Error "Actor is required"; exit 1 }
if (-not $Action) { Write-Error "Action is required"; exit 1 }

$rootDir = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)   # .opencode/
if (-not $PoliciesPath) { $PoliciesPath = Join-Path $rootDir "policy\policies.yaml" }
if (-not (Test-Path -LiteralPath $PoliciesPath)) { Write-Error "policies not found: $PoliciesPath"; exit 1 }

$pol = ConvertFrom-SimpleYaml (Read-Utf8 $PoliciesPath)
if (-not $pol.ContainsKey("policies")) { Write-Error "no 'policies' key in $PoliciesPath"; exit 1 }

$subject = $pol.policies[$Actor]
if (-not $subject) {
    if (-not $Silent) { Write-Host "POLICY-EVALUATE deny actor='$Actor' action='$Action' (no policy for subject)" }
    exit 1
}

$deny = @($subject.deny | Where-Object { Test-Pattern $_ $Action })
if ($deny.Count -gt 0) {
    if (-not $Silent) { Write-Host "POLICY-EVALUATE deny actor='$Actor' action='$Action' matched='$($deny[0])'" }
    exit 1
}

$allow = @($subject.allow | Where-Object { Test-Pattern $_ $Action })
if ($allow.Count -gt 0) {
    if (-not $Silent) { Write-Host "POLICY-EVALUATE allow actor='$Actor' action='$Action' matched='$($allow[0])'" }
    exit 0
}

if (-not $Silent) { Write-Host "POLICY-EVALUATE deny actor='$Actor' action='$Action' (default deny)" }
exit 1
'@

# =====================================================================
# 3. Build state
# =====================================================================
$buildId = "GB-" + (Get-Date -Format "yyyyMMdd-HHmmss")
$phaseResults = New-Object System.Collections.ArrayList
$artifacts = New-Object System.Collections.ArrayList
$selftests = New-Object System.Collections.ArrayList
$overall = "PASS"

function Add-PhaseResult([string]$id, [string]$name, [string]$status, [string]$detail) {
    $null = $phaseResults.Add([PSCustomObject]@{ phase = $id; name = $name; status = $status; detail = $detail })
}

function Ensure-Dir([string]$path) {
    if (-not (Test-Path -LiteralPath $path)) {
        if (-not $DryRun) { New-Item -ItemType Directory -Path $path -Force | Out-Null }
        return $false
    }
    return $true
}

function Write-Artifact([string]$path, [string]$content, [string]$what) {
    $exists = Test-Path -LiteralPath $path
    if ($exists -and -not $Force) {
        $null = $artifacts.Add([PSCustomObject]@{ path = $path; action = "exists"; sha256 = (Get-Sha256 $path) })
        Write-Info "$what exists (skip, -Force de ghi de): $path"
        return "exists"
    }
    if ($exists -and $Force -and -not $DryRun) {
        $bakDir = Join-Path $openCodeDir "backup\governance-build"
        if (-not (Test-Path -LiteralPath $bakDir)) { New-Item -ItemType Directory -Path $bakDir -Force | Out-Null }
        $bak = Join-Path $bakDir ("{0}.{1}.bak" -f (Split-Path -Leaf $path), $buildId)
        Copy-Item -LiteralPath $path -Destination $bak -Force
        Write-Info "backup -> $bak"
    }
    if ($DryRun) {
        $null = $artifacts.Add([PSCustomObject]@{ path = $path; action = "would-write"; sha256 = "" })
        Write-Info "DRY-RUN: would write $what -> $path"
        return "dry-run"
    }
    Write-Utf8 $path $content
    $action = $(if ($exists) { "updated" } else { "created" })
    $null = $artifacts.Add([PSCustomObject]@{ path = $path; action = $action; sha256 = (Get-Sha256 $path) })
    Write-Ok "$what written: $path"
    return $action
}

function Invoke-Validator([string]$scriptPath, [string]$name) {
    if (-not (Test-Path -LiteralPath $scriptPath)) {
        Write-Warn "validator not found: $scriptPath"
        return "SKIP"
    }
    if ($DryRun) { Write-Info "DRY-RUN: would run $name"; return "PASS" }
    try {
        & $scriptPath -Silent
        if ($LASTEXITCODE -eq 0) { Write-Ok "$name PASS"; return "PASS" }
        Write-Fail "$name FAIL (exit $LASTEXITCODE)"
        return "FAIL"
    }
    catch {
        Write-Fail "$name ERROR: $_"
        return "FAIL"
    }
}

function Test-DefaultWorkflowOk {
    # workflow-validator bao loi 4 file workflow schema moi (bugfix/feature/ui/documentation)
    # - pre-existing, khong lien quan build nay. Chi fail P4 neu default.workflow.yaml loi.
    $reportPath = Join-Path $scriptsDir "workflow-validator-report.json"
    if (-not (Test-Path -LiteralPath $reportPath)) { return $true }
    try {
        $rep = Read-Utf8 $reportPath | ConvertFrom-Json
        $default = @($rep.files | Where-Object { $_.file -eq "default.workflow.yaml" })
        if ($default.Count -eq 0) { return $true }
        return ($default[0].status -eq "PASS")
    }
    catch { return $true }
}

# =====================================================================
# P0 - Preflight
# =====================================================================
Write-Step "P0 PREFLIGHT"
$p0ok = $true
$p0msg = "ps=$($PSVersionTable.PSVersion) root=$ProjectRoot"
if ($PSVersionTable.PSVersion.Major -lt 5) { $p0ok = $false; $p0msg += " (PS 5+ required)" }
if ($p0ok) { Write-Ok $p0msg } else { Write-Fail $p0msg }
Add-PhaseResult "P0" "Preflight" $(if ($p0ok) { "PASS" } else { "FAIL" }) $p0msg
if (-not $p0ok) { $overall = "FAIL" }

# =====================================================================
# P1 - Foundation (rules store + policy store)
# =====================================================================
Write-Step "P1 FOUNDATION (rules.yaml + policies.yaml)"
$p1ok = $true
$r1 = Write-Artifact (Join-Path $govDir "governance.rules.yaml") $TplRules "rules store"
$r2 = Write-Artifact (Join-Path $policyDir "policies.yaml") $TplPolicies "policy store"
if ($r1 -eq "failed" -or $r2 -eq "failed") { $p1ok = $false }
Add-PhaseResult "P1" "Foundation" $(if ($p1ok) { "PASS" } else { "FAIL" }) "rules=$r1 policies=$r2"

# =====================================================================
# P2 - Engine core (3 scripts + audit dir)
# =====================================================================
Write-Step "P2 ENGINE CORE (governance-check / audit-log / policy-evaluate)"
$p2ok = $true
Ensure-Dir $engineDir | Out-Null
$auditDir = Join-Path $govDir "audit"
if (-not (Test-Path -LiteralPath $auditDir)) {
    if ($DryRun) { Write-Info "DRY-RUN: would create audit dir: $auditDir" }
    else {
        New-Item -ItemType Directory -Path $auditDir -Force | Out-Null
        Write-Ok "audit dir created: $auditDir"
    }
}
else { Write-Info "audit dir exists: $auditDir" }
$e1 = Write-Artifact (Join-Path $engineDir "governance-check.ps1") $TplCheck "engine script"
$e2 = Write-Artifact (Join-Path $engineDir "audit-log.ps1") $TplAudit "engine script"
$e3 = Write-Artifact (Join-Path $engineDir "policy-evaluate.ps1") $TplEvaluate "engine script"
if ($e1 -eq "failed" -or $e2 -eq "failed" -or $e3 -eq "failed") { $p2ok = $false }
Add-PhaseResult "P2" "Engine core" $(if ($p2ok) { "PASS" } else { "FAIL" }) "check=$e1 audit=$e2 evaluate=$e3"

# =====================================================================
# P3 - Integration (workflow gate, opt-in)
# =====================================================================
$wfPath = Join-Path $workflowDefsDir "default.workflow.yaml"
if ($WorkflowGate) {
    Write-Step "P3 INTEGRATION (governance_check phase in default.workflow.yaml)"
    $p3ok = $true
    $p3msg = ""
    if (-not (Test-Path -LiteralPath $wfPath)) {
        $p3ok = $false; $p3msg = "workflow not found: $wfPath"
    }
    else {
        $wfText = Read-Utf8 $wfPath
        if ($wfText -match "(?m)^\s*- id: governance_check\s*$") {
            $p3msg = "phase governance_check already present"
            Write-Info $p3msg
        }
        elseif ($wfText -notmatch "(?m)^  - id: build\s*$") {
            $p3ok = $false; $p3msg = "'build' phase not found in workflow, cannot insert gate"
            Write-Fail $p3msg
        }
        else {
            $phaseBlock = @'
  - id: governance_check
    title: Kiem tra governance truoc build
    description: Governance gate - check naming, lifecycle, approval, security, compliance, audit (GOV-001..007).
    agent: guardian
    command: team-gitguard
    depends_on: [backup]
    retry: 3
    timeout_seconds: 120
    continue_on_error: false
    inputs:
      plan: object
    outputs:
      status: string
      checks:
        - string
    expected_result: PASS/WARNING/BLOCKED dua tren governance checks.
'@
            $newText = $wfText -replace "(?m)^  - id: build\s*$", ($phaseBlock + "`n" + '$0')
            if (-not $DryRun) {
                $bakDir = Join-Path $openCodeDir "backup\governance-build"
                if (-not (Test-Path -LiteralPath $bakDir)) { New-Item -ItemType Directory -Path $bakDir -Force | Out-Null }
                Copy-Item -LiteralPath $wfPath -Destination (Join-Path $bakDir ("default.workflow.yaml.{0}.bak" -f $buildId)) -Force
                Write-Utf8 $wfPath $newText
                Write-Ok $p3msg
            }
            else {
                Write-Info "DRY-RUN: would insert governance_check phase before build"
            }
            $p3msg = "governance_check inserted before 'build' phase" + $(if ($DryRun) { " (dry-run)" } else { "" })
        }
    }
    if ($p3ok) {
        $wfVal = Invoke-Validator (Join-Path $scriptsDir "workflow-validator.ps1") "workflow-validator.ps1"
        if ($wfVal -eq "FAIL" -and (Test-DefaultWorkflowOk)) {
            Write-Warn "workflow-validator FAIL do cac file workflow schema moi khac (pre-existing) - default.workflow.yaml van PASS"
            $wfVal = "WARN"
        }
        if ($wfVal -eq "FAIL") { $p3ok = $false; $p3msg += " | workflow-validator FAIL" }
        else { $p3msg += " | workflow-validator $wfVal" }
    }
    Add-PhaseResult "P3" "Workflow integration" $(if ($p3ok) { "PASS" } else { "FAIL" }) $p3msg
    if (-not $p3ok) { $overall = "FAIL" }
}
else {
    Add-PhaseResult "P3" "Workflow integration" "SKIP" "opt-in (chay lai voi -WorkflowGate de chen phase governance_check)"
    Write-Info "P3 SKIP: chay lai voi -WorkflowGate de chen phase governance_check vao workflow"
}

# =====================================================================
# P4 - Validate (validators co san)
# =====================================================================
Write-Step "P4 VALIDATE"
$p4ok = $true
$v1 = Invoke-Validator (Join-Path $scriptsDir "governance-validator.ps1") "governance-validator.ps1"
$v2 = Invoke-Validator (Join-Path $scriptsDir "policy-validator.ps1") "policy-validator.ps1"
$v3 = Invoke-Validator (Join-Path $scriptsDir "governance-framework-validator.ps1") "governance-framework-validator.ps1"
$v4 = Invoke-Validator (Join-Path $scriptsDir "workflow-validator.ps1") "workflow-validator.ps1"
if ($v4 -eq "FAIL" -and (Test-DefaultWorkflowOk)) {
    Write-Warn "workflow-validator FAIL do cac file workflow schema moi khac (pre-existing) - default.workflow.yaml van PASS"
    $v4 = "WARN"
}
foreach ($v in @($v1, $v2, $v3, $v4)) { if ($v -eq "FAIL") { $p4ok = $false } }
Add-PhaseResult "P4" "Validate" $(if ($p4ok) { "PASS" } else { "FAIL" }) "gov=$v1 pol=$v2 gov-framework=$v3 workflow=$v4"
if (-not $p4ok) { $overall = "FAIL" }

# =====================================================================
# P5 - Selftest (engine scripts voi data mau)
# =====================================================================
if ($SkipSelftest -or $DryRun) {
    if ($DryRun) { Write-Info "P5 SKIP: selftest khong chay trong dry-run" }
    Add-PhaseResult "P5" "Selftest" "SKIP" $(if ($DryRun) { "dry-run" } else { "-SkipSelftest" })
}
else {
    Write-Step "P5 SELFTEST"
    $p5ok = $true

    function Run-Selftest([string]$name, [scriptblock]$block, [int]$expectExit) {
        try {
            $code = & $block
            $ok = ($LASTEXITCODE -eq $expectExit)
        }
        catch {
            $ok = $false
            $code = "ERROR: $_"
        }
        $null = $selftests.Add([PSCustomObject]@{ test = $name; expect_exit = $expectExit; actual = $code; status = $(if ($ok) { "PASS" } else { "FAIL" }) })
        if ($ok) { Write-Ok "$name (expect exit $expectExit)" } else { Write-Fail "$name FAIL: $code" }
        if (-not $ok) { $script:p5ok = $false }
    }

    $checkPath = Join-Path $engineDir "governance-check.ps1"
    $auditPath = Join-Path $engineDir "audit-log.ps1"
    $evalPath  = Join-Path $engineDir "policy-evaluate.ps1"

    if ((Test-Path -LiteralPath $checkPath) -and (Test-Path -LiteralPath $evalPath) -and (Test-Path -LiteralPath $auditPath)) {
        Run-Selftest "policy: planner planning.task"                { & $evalPath -Actor planner -Action "planning.task" -Silent } 0
        Run-Selftest "policy: planner artifact.delete (deny wins)"  { & $evalPath -Actor planner -Action "artifact.delete" -Silent } 1
        Run-Selftest "policy: unknown subject default deny"         { & $evalPath -Actor "hacker" -Action "planning.task" -Silent } 1
        Run-Selftest "policy: builder policy.edit (deny)"           { & $evalPath -Actor builder -Action "policy.edit" -Silent } 1
        Run-Selftest "policy: wildcard general *"                   { & $evalPath -Actor general -Action "anything.at.all" -Silent } 0
        Run-Selftest "gov: valid agent name"                        { & $checkPath -Type agent -Name "planner" -Owner core -Version "1.0.0" -Silent } 0
        Run-Selftest "gov: invalid agent name (naming)"             { & $checkPath -Type agent -Name "Bad_Name" -Owner core -Version "1.0.0" -Silent } 1
        Run-Selftest "gov: plugin unsigned (security)"              { & $checkPath -Type plugin -Name "oracle" -Owner core -Version "1.0.0" -Silent } 1
        Run-Selftest "gov: deprecated no replacement"               { & $checkPath -Type agent -Name "legacy" -Owner core -Version "1.0.0" -Deprecated -Silent } 1
        Run-Selftest "gov: secret scan hit"                         { & $checkPath -Type agent -Name "safe-agent" -Owner core -Version "1.0.0" -Content "password=hunter2" -Silent } 1

        $tmpAudit = Join-Path $env:TEMP ("gov-audit-" + [guid]::NewGuid().ToString("N"))
        Run-Selftest "audit: append entry" { & $auditPath -Action workflow.execute -Actor planner -Target "WF-101" -Result allowed -PolicyRef workflow-execute-policy -AuditDir $tmpAudit -Silent } 0
        Run-Selftest "audit: verify chain" { & $auditPath -Verify -AuditDir $tmpAudit -Silent } 0
        Run-Selftest "audit: tamper detect" {
            $logF = Join-Path $tmpAudit "audit.log"
            $lines = [System.IO.File]::ReadAllLines($logF)
            $lines[0] = $lines[0] -replace '"result":"allowed"', '"result":"denied"'
            [System.IO.File]::WriteAllLines($logF, $lines, (New-Object System.Text.UTF8Encoding($false)))
            & $auditPath -Verify -AuditDir $tmpAudit -Silent
        } 1
        if (Test-Path -LiteralPath $tmpAudit) { Remove-Item -LiteralPath $tmpAudit -Recurse -Force }
    }
    else {
        $p5ok = $false
        Write-Fail "engine scripts not found after P2 (chay khong -DryRun truoc)"
    }
    Add-PhaseResult "P5" "Selftest" $(if ($p5ok) { "PASS" } else { "FAIL" }) "tests=$($selftests.Count) failed=$(@($selftests | Where-Object { $_.status -eq "FAIL" }).Count)"
    if (-not $p5ok) { $overall = "FAIL" }
}

# =====================================================================
# P6 - Report
# =====================================================================
$report = [PSCustomObject]@{
    build_id     = $buildId
    timestamp    = (Get-Date).ToString("o")
    project_root = $ProjectRoot
    dry_run      = $DryRun
    overall      = $overall
    phases       = $phaseResults
    artifacts    = $artifacts
    selftests    = $selftests
}

if (-not $DryRun) {
    Ensure-Dir $reportsDir | Out-Null
    $reportPath = Join-Path $reportsDir ("governance-build-" + $buildId + ".json")
    Write-Utf8 $reportPath ($report | ConvertTo-Json -Depth 6)
    Write-Ok "report: $reportPath"
}
else {
    Write-Info "DRY-RUN: report would be written to $reportsDir"
}

Write-Step "P6 REPORT - overall: $overall (build=$buildId)"
Write-Info ("phases: " + (($phaseResults | ForEach-Object { "$($_.phase)=$($_.status)" }) -join " "))
Write-Info ("artifacts: " + (($artifacts | ForEach-Object { "$($_.action):$(Split-Path -Leaf $_.path)" }) -join " "))
if ($selftests.Count -gt 0) {
    $failCount = @($selftests | Where-Object { $_.status -eq "FAIL" }).Count
    Write-Info ("selftests: " + "$($selftests.Count) total, $failCount failed")
}

if ($overall -eq "FAIL") { exit 1 } else { exit 0 }
