# principles-validator.ps1
# Validator cho Principles (Sprint 1-3)
# Checks PRN-001..004 (15 principles, architecture, governance)
# ASCII-only (PS 5.1 ANSI).
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate AIOS Principles building blocks.
.DESCRIPTION
  Kiem tra core principles P001-P015, architecture A-001..006, governance G-001..007.
  Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$prinDir = Join-Path $root 'principles'

if (-not (Test-Path $prinDir)) { Write-Error "principles/ not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

# ---------- PRN-001: files ----------
foreach ($f in @('principles.md','architecture-principles.md','governance.md')) {
  if (-not (Test-Path (Join-Path $prinDir $f))) { $errors += "PRN-001: missing $f" }
}

# ---------- PRN-002: 15 core principles ----------
$coreFile = Join-Path $prinDir 'principles.md'
if (Test-Path $coreFile) {
  $text = Get-Content -LiteralPath $coreFile -Raw -Encoding utf8
  for ($i = 1; $i -le 15; $i++) {
    $p = "P{0:D3}" -f $i
    if ($text -notmatch [regex]::Escape($p)) { $errors += "PRN-002: thieu $p" }
  }
  foreach ($sec in @('Purpose','Statement','Rationale','Implications')) {
    if ($text -notmatch $sec) { $warnings += "PRN-002: thieu section '$sec'" }
  }
}

# ---------- PRN-003: architecture ----------
$archFile = Join-Path $prinDir 'architecture-principles.md'
if (Test-Path $archFile) {
  $t = Get-Content -LiteralPath $archFile -Raw -Encoding utf8
  for ($i = 1; $i -le 6; $i++) {
    $a = "A-{0:D3}" -f $i
    if ($t -notmatch [regex]::Escape($a)) { $warnings += "PRN-003: thieu $a" }
  }
}

# ---------- PRN-004: governance ----------
$govFile = Join-Path $prinDir 'governance.md'
if (Test-Path $govFile) {
  $t = Get-Content -LiteralPath $govFile -Raw -Encoding utf8
  for ($i = 1; $i -le 7; $i++) {
    $g = "G-{0:D3}" -f $i
    if ($t -notmatch [regex]::Escape($g)) { $warnings += "PRN-004: thieu $g" }
  }
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== Principles Validation (Sprint 1-3) ==="
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }