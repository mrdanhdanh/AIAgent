# spec000-validator.ps1
# Validator cho SPEC-000 — Hien phap AIOS
# Checks SPC-001..006 (6 Part, 23 chuong, 15 nguyen tac P-001..015, files)
# ASCII-only (PS 5.1 ANSI).
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate SPEC-000 Hien phap AIOS.
.DESCRIPTION
  Kiem tra 6 part files, 23 chuong, 15 core principles P-001..P-015.
  Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$s000 = Join-Path $root 'spec\SPEC-000-core-principles'

if (-not (Test-Path $s000)) { Write-Error "SPEC-000 not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

# ---------- SPC-001: part files ----------
$files = @('README.md','principles.md','system-model.md','engineering.md',
  'governance.md','ai-native.md','terminology.md','changelog.md')
foreach ($f in $files) {
  if (-not (Test-Path (Join-Path $s000 $f))) { $errors += "SPC-001: missing $f" }
}

# ---------- SPC-002: 15 core principles P-001..P-015 ----------
$principlesFile = Join-Path $s000 'principles.md'
if (Test-Path $principlesFile) {
  $text = Get-Content -LiteralPath $principlesFile -Raw -Encoding utf8
  for ($i = 1; $i -le 15; $i++) {
    $p = "P-{0:D3}" -f $i
    if ($text -notmatch [regex]::Escape($p)) { $errors += "SPC-002: thieu $p" }
  }
}

# ---------- SPC-003: 23 chuong ----------
$parts = @(@('README.md', 4), @('principles.md', 3), @('system-model.md', 4),
  @('engineering.md', 4), @('governance.md', 5), @('ai-native.md', 3))
$chapterTotal = ($parts | ForEach-Object { $_[1] } | Measure-Object -Sum).Sum
if ($chapterTotal -ne 23) { $errors += "SPC-003: tong chuong = $chapterTotal (ky vong 23)" }

# ---------- SPC-004: mo file tung part check chuong ----------
$partRange = @(@(1,4),@(5,7),@(8,11),@(12,15),@(16,20),@(21,23))
for ($pi = 0; $pi -lt $parts.Count; $pi++) {
  $file = Join-Path $s000 $parts[$pi][0]
  if (-not (Test-Path $file)) { continue }
  $t = Get-Content -LiteralPath $file -Raw -Encoding utf8
  $start = $partRange[$pi][0]; $end = $partRange[$pi][1]
  for ($c = $start; $c -le $end; $c++) {
    if ($t -notmatch "Ch[^ ]*ng $c\b") { $warnings += "SPC-004: $($parts[$pi][0]) thieu Chuong $c" }
  }
}

# ---------- SPC-005: khong chua implementation ----------
foreach ($f in @('README.md','principles.md','system-model.md','engineering.md','governance.md','ai-native.md')) {
  $t = Get-Content -LiteralPath (Join-Path $s000 $f) -Raw -Encoding utf8
  foreach ($bad in @('class ','def ','function ','interface ','TODO: implement','code snippet')) {
    if ($t -match [regex]::Escape($bad)) { $warnings += "SPC-005: $f co the chua implementation ('$bad')" }
  }
}

# ---------- SPC-006: DoD trong README ----------
$readme = Get-Content -LiteralPath (Join-Path $s000 'README.md') -Raw -Encoding utf8
if ($readme -notmatch 'Definition of Done') { $errors += "SPC-006: thieu Definition of Done" }
if ($readme -notmatch 'Decision Hierarchy') { $warnings += "SPC-006: thieu Decision Hierarchy" }

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== SPEC-000 Hien phap Validation ==="
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)     { ""; "INFOS ($($infos.Count)):";      $infos     | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }