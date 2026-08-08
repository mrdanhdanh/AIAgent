# spec003-validator.ps1
# Validator cho SPEC-003 — Capability System
# Checks C1-001..N (C001 vision, cau truc, traceability)
# ASCII-only (PS 5.1 ANSI). Exit 0 = PASS.
<#
.SYNOPSIS
  Validate SPEC-003 Capability System.
.DESCRIPTION
  Kiem tra SPEC-003: README, C001-vision.md, SPEC.yaml.
  Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$spec3 = Join-Path $root '..\docs\specs\SPEC-003'

if (-not (Test-Path $spec3)) { Write-Error "SPEC-003 not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

function Strip-Diacritics([string]$s) {
  $s = $s.Replace([char]0x0111, 'd').Replace([char]0x0110, 'D')
  $s = $s.Normalize([Text.NormalizationForm]::FormD)
  $sb = New-Object System.Text.StringBuilder
  foreach ($ch in $s.ToCharArray()) {
    if ([Globalization.CharUnicodeInfo]::GetUnicodeCategory($ch) -ne [Globalization.UnicodeCategory]::NonSpacingMark) {
      [void]$sb.Append($ch)
    }
  }
  return $sb.ToString()
}

# ---------- C1-001: README ----------
foreach ($f in @('README.md')) {
  if (-not (Test-Path (Join-Path $spec3 $f))) { $errors += "C1-001: missing SPEC-003/$f" }
}

# ---------- C1-002: C001 vision ----------
if (-not (Test-Path (Join-Path $spec3 'C001-vision.md'))) { $errors += "C1-002: missing C001-vision.md" }
else {
  $vRaw = Get-Content -LiteralPath (Join-Path $spec3 'C001-vision.md') -Raw -Encoding utf8
  $v = Strip-Diacritics $vRaw
  foreach ($sec in @('Mission','Vision','Position','Design Philosophy','Invariants','Scope')) {
    if ($v -notmatch [regex]::Escape("## $sec")) { $errors += "C1-002: C001 thieu section '$sec'" }
  }
  foreach ($inv in @('Moi capability deu dang ky trong Registry (S014 capability-registry).','Moi resolution deu di qua Runtime (S010 EF007).','Capability khong chua Business Logic','Capability khong dinh nghia lai')) {
    if ($v -notmatch [regex]::Escape($inv)) { $warnings += "C1-002: C001 thieu invariant '$inv'" }
  }
}

# ---------- C1-003: frontmatter ----------
$mdFiles = Get-ChildItem -Path $spec3 -Filter '*.md' -Recurse
foreach ($md in $mdFiles) {
  $c = Get-Content -LiteralPath $md.FullName -Raw -Encoding utf8
  if ($c -notmatch '(?m)^---\s*$') { $errors += "C1-003: $($md.Name) thieu frontmatter" }
  elseif ($c -notmatch '(?m)^name:\s*\S+') { $errors += "C1-003: $($md.Name) thieu name trong frontmatter" }
  elseif ($c -notmatch '(?m)^description:') { $errors += "C1-003: $($md.Name) thieu description trong frontmatter" }
}

# ---------- C1-004: encoding (BOM/tab) ----------
foreach ($f in (Get-ChildItem -Path $spec3 -File -Recurse)) {
  $b = [System.IO.File]::ReadAllBytes($f.FullName)
  if ($b.Length -ge 3 -and $b[0] -eq 0xEF -and $b[1] -eq 0xBB) { $warnings += "C1-004: $($f.Name) co BOM" }
  $text = [System.Text.Encoding]::UTF8.GetString($b)
  if ($text -match "`t") { $warnings += "C1-004: $($f.Name) co tab (dung 2-space)" }
}

# ---------- C1-005: SPEC.yaml ----------
$specFile = Join-Path $spec3 'SPEC.yaml'
if (Test-Path $specFile) {
  $st = Get-Content -LiteralPath $specFile -Raw -Encoding utf8
  if ($st -notmatch '(?m)^id:\s*SPEC-003') { $errors += "C1-005: SPEC.yaml id phai la SPEC-003" }
  if ($st -notmatch '(?m)^implements:') { $errors += "C1-005: SPEC.yaml thieu implements" }
  foreach ($d in @('SPEC-000','SPEC-001','SPEC-002')) { if ($st -notmatch [regex]::Escape($d)) { $errors += "C1-005: thieu dependency $d" } }
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== SPEC-003 Capability System Validation ==="
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)     { ""; "INFOS ($($infos.Count)):";      $infos     | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }
