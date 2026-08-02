# spec000-validator.ps1
# Validator cho SPEC-000 — AIOS Constitution (Enterprise)
# Checks SPC-001..006 (7 Part files, 30 chuong, 15 principles P001-P015, appendix)
# ASCII-only (PS 5.1 ANSI).
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate SPEC-000 Constitution.
.DESCRIPTION
  Kiem tra SPEC-000-constitution: 7 part files, 30 chuong, P001-P015, appendix A-H.
  Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$s000 = Join-Path $root 'spec\SPEC-000-constitution'

if (-not (Test-Path $s000)) { Write-Error "SPEC-000-constitution not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

# ---------- SPC-001: part files ----------
$files = @('README.md','SUMMARY.md','foundation.md','principles.md','architecture.md',
  'governance.md','lifecycle.md','quality.md','ai-native.md','glossary.md','changelog.md')
foreach ($f in $files) {
  if (-not (Test-Path (Join-Path $s000 $f))) { $errors += "SPC-001: missing $f" }
}

# ---------- SPC-002: 15 principles P001-P015 ----------
$principlesFile = Join-Path $s000 'principles.md'
if (Test-Path $principlesFile) {
  $text = Get-Content -LiteralPath $principlesFile -Raw -Encoding utf8
  for ($i = 1; $i -le 15; $i++) {
    $p = "P{0:D3}" -f $i
    if ($text -notmatch [regex]::Escape($p)) { $errors += "SPC-002: thieu $p" }
  }
}

# ---------- SPC-003: appendices A-H ----------
$appendixFiles = @('glossary.md','appendices/object-catalog.md','appendices/metadata-catalog.md',
  'appendices/state-catalog.md','appendices/error-catalog.md','appendices/event-catalog.md',
  'appendices/capability-catalog.md','appendices/references.md')
foreach ($a in $appendixFiles) {
  if (-not (Test-Path (Join-Path $s000 $a))) { $errors += "SPC-003: missing appendix $a" }
}

# ---------- SPC-004: 30 chuong trong 6 part (principles.md khong co chuong) ----------
$partFiles = @(@('foundation.md',1,5),@('architecture.md',6,11),
  @('governance.md',12,16),@('lifecycle.md',17,20),@('quality.md',21,24),@('ai-native.md',25,30))
foreach ($pf in $partFiles) {
  $file = Join-Path $s000 $pf[0]
  if (-not (Test-Path $file)) { continue }
  $t = Get-Content -LiteralPath $file -Raw -Encoding utf8
  $start = $pf[1]; $end = $pf[2]
  for ($c = $start; $c -le $end; $c++) {
    if ($t -notmatch "Chuong $c\b" -and $t -notmatch "Ch[^ ]*ng $c\b") {
      $warnings += "SPC-004: $($pf[0]) thieu Chuong $c"
    }
  }
}

# ---------- SPC-005: khong chua implementation ----------
foreach ($f in @('foundation.md','principles.md','architecture.md','governance.md','lifecycle.md','quality.md','ai-native.md')) {
  $t = Get-Content -LiteralPath (Join-Path $s000 $f) -Raw -Encoding utf8
  foreach ($bad in @('class ','def ','function ','interface ','TODO: implement')) {
    if ($t -match [regex]::Escape($bad)) { $warnings += "SPC-005: $f co the chua implementation" }
  }
}

# ---------- SPC-006: DoD + Decision Hierarchy ----------
$readme = Get-Content -LiteralPath (Join-Path $s000 'README.md') -Raw -Encoding utf8
if ($readme -notmatch 'Definition of Done') { $errors += "SPC-006: thieu Definition of Done" }
if ($readme -notmatch 'Decision Hierarchy') { $warnings += "SPC-006: thieu Decision Hierarchy" }
if ($readme -notmatch 'Constitution') { $errors += "SPC-006: thieu thuong hieu Constitution" }

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== SPEC-000 Constitution Validation ==="
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)     { ""; "INFOS ($($infos.Count)):";      $infos     | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }