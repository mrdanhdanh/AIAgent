<#
.SYNOPSIS
    Failure Analyzer — normalize + SHA256 DETERMINISTIC cho Failure Agent.

.DESCRIPTION
    Giai quyet BUG-A: LLM khong tinh duoc hash xac dinh -> script lam.
      1. Normalize: lowercase, trim, strip timestamp/guid/memory-address/path/file:line/stack-frame
      2. Truncate >10KB (truoc hash) + marker " truncated"
      3. error_hash = SHA256(error_normalized), 16 hex dau (thay 12 -> chong collision)
    Output JSON de failure-agent/orchestrator tieu thu.
    Chay boi: failure-agent (bash:allow - CHI chay script nay) hoac orchestrator.

.PARAMETER RawError  - Error message truc tiep.
.PARAMETER FilePath  - Duong dan file chua error log (FILE_NOT_FOUND neu khong ton tai).
.PARAMETER MaxLen    - Gioi han do dai (mac dinh 10000).

.EXAMPLE
    .opencode/scripts/failure-analyzer.ps1 -RawError "error CS0246: The type 'Foo' could not be found"
    .opencode/scripts/failure-analyzer.ps1 -FilePath build.log | ConvertFrom-Json
#>
param(
    [string]$RawError = "",
    [string]$FilePath = "",
    [int]$MaxLen = 10000
)

$ErrorActionPreference = "Stop"

function Get-NormalizedError {
    param([string]$Text)
    $s = $Text

    $s = $s -replace "`r`n", "`n"
    $s = $s.Trim()

    # timestamp ISO-8601 + variants: 2026-08-05T10:20:30.123Z / 2026-08-05 10:20:30 / 08/05/2026 10:20
    $s = $s -replace '\b\d{4}[-/.]\d{1,2}[-/.]\d{1,2}[T ]\d{1,2}:\d{2}(?::\d{2}(?:[.,]\d+)?)?(?:Z|[+-]\d{2}:?\d{2})?\b', ' '

    # GUID
    $s = $s -replace '\{[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}\}', ' '

    # memory address 0x...
    $s = $s -replace '\b0x[0-9A-Fa-f]{4,16}\b', ' '

    # absolute path Windows (C:\...) + Unix (/...)
    $s = $s -replace '[A-Za-z]:\\(?:[^\s\\]+\\)*[^\s\\]*', ' '
    $s = $s -replace '(?<![\w/])(?:/[\w.\-]+)+', ' '

    # assembly version (.NET): Version=1.0.0.0
    $s = $s -replace '(?i)\bversion=\d+\.\d+\.\d+\.\d+\b', ' '

    # file:line:col / line N col M
    $s = $s -replace '(?i)\bline\s+\d+(?:\s*[,:]\s*(?:col(?:umn)?\s*)?\d+)?', ' '
    $s = $s -replace ':\d+:\d+', ' '

    # bo stack trace lines (at ...)
    $lines = $s -split "`n" | Where-Object { $_ -notmatch '^\s*at\s+' }
    $s = $lines -join ' '

    # lowercase + collapse whitespace + trim punctuation
    $s = $s.ToLowerInvariant()
    $s = $s -replace '\s+', ' '
    $s = $s.Trim(' ', '.', ':', ';', ',', '"', "'", '(', ')', '!', '?')

    return $s
}

# ---- input resolution ----
if (-not [string]::IsNullOrWhiteSpace($FilePath)) {
    if (-not (Test-Path -LiteralPath $FilePath)) {
        Write-Output ('{ "status": "FILE_NOT_FOUND", "file": "' + $FilePath + '" }')
        exit 1
    }
    $RawError = [System.IO.File]::ReadAllText($FilePath, [System.Text.Encoding]::UTF8)
}
if ([string]::IsNullOrWhiteSpace($RawError)) {
    $pipe = [Console]::In.ReadToEnd()
    if (-not [string]::IsNullOrWhiteSpace($pipe)) { $RawError = $pipe }
}
if ([string]::IsNullOrWhiteSpace($RawError)) {
    Write-Output '{ "status": "EMPTY_ERROR" }'
    exit 1
}

# ---- truncate (TRUOC hash) ----
$truncated = $false
if ($RawError.Length -gt $MaxLen) {
    $RawError = $RawError.Substring(0, $MaxLen)
    $truncated = $true
}

# ---- normalize ----
$normalized = Get-NormalizedError -Text $RawError
if ([string]::IsNullOrWhiteSpace($normalized)) { $normalized = 'unparsable_error' }
if ($truncated) { $normalized = $normalized + ' truncated' }

# ---- SHA256 first 16 hex ----
$sha = [System.Security.Cryptography.SHA256]::Create()
$bytes = [System.Text.Encoding]::UTF8.GetBytes($normalized)
$hash = ($sha.ComputeHash($bytes) | ForEach-Object { $_.ToString('x2') }) -join ''
$hash16 = $hash.Substring(0, [Math]::Min(16, $hash.Length))

$result = [PSCustomObject]@{
    status           = "READY"
    error_normalized = $normalized
    error_hash       = $hash16
    error_hash_full  = $hash
    truncated        = $truncated
    char_count_raw   = $RawError.Length
    char_count_norm  = $normalized.Length
    analyzer_version = "2.0"
}
Write-Output ($result | ConvertTo-Json -Depth 3)
