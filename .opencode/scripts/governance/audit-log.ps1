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