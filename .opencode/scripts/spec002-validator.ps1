# spec002-validator.ps1
# Validator cho SPEC-002 — Workflow Engine
# Checks W1-001..N (W001 vision, cau truc, traceability)
# ASCII-only (PS 5.1 ANSI). Exit 0 = PASS.
<#
.SYNOPSIS
  Validate SPEC-002 Workflow Engine.
.DESCRIPTION
  Kiem tra SPEC-002: README, W001-vision.md, va cac section theo roadmap.
  Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$spec2 = Join-Path $root '..\docs\specs\SPEC-002'

if (-not (Test-Path $spec2)) { Write-Error "SPEC-002 not found"; exit 1 }

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

# ---------- W1-001: README ----------
foreach ($f in @('README.md')) {
  if (-not (Test-Path (Join-Path $spec2 $f))) { $errors += "W1-001: missing SPEC-002/$f" }
}

# ---------- W1-002: W001 vision ----------
if (-not (Test-Path (Join-Path $spec2 'W001-vision.md'))) { $errors += "W1-002: missing W001-vision.md" }
else {
  $vRaw = Get-Content -LiteralPath (Join-Path $spec2 'W001-vision.md') -Raw -Encoding utf8
  $v = Strip-Diacritics $vRaw
  foreach ($sec in @('Mission','Vision','Position','Design Philosophy','Invariants','Scope')) {
    if ($v -notmatch [regex]::Escape("## $sec")) { $errors += "W1-002: W001 thieu section '$sec'" }
  }
  foreach ($inv in @('Moi Workflow deu chay nhu mot Execution cua Runtime (SPEC-001).','Moi Workflow deu duoc validate truoc khi chay.','Workflow khong chua Business Logic','Workflow khong dinh nghia lai')) {
    if ($v -notmatch [regex]::Escape($inv)) { $warnings += "W1-002: W001 thieu invariant '$inv'" }
  }
}

# ---------- W1-003: frontmatter ----------
$mdFiles = Get-ChildItem -Path $spec2 -Filter '*.md' -Recurse
foreach ($md in $mdFiles) {
  $c = Get-Content -LiteralPath $md.FullName -Raw -Encoding utf8
  if ($c -notmatch '(?m)^---\s*$') { $errors += "W1-003: $($md.Name) thieu frontmatter" }
  elseif ($c -notmatch '(?m)^name:\s*\S+') { $errors += "W1-003: $($md.Name) thieu name trong frontmatter" }
  elseif ($c -notmatch '(?m)^description:') { $errors += "W1-003: $($md.Name) thieu description trong frontmatter" }
}

# ---------- W1-004: encoding (BOM/tab) ----------
foreach ($f in (Get-ChildItem -Path $spec2 -File)) {
  $b = [System.IO.File]::ReadAllBytes($f.FullName)
  if ($b.Length -ge 3 -and $b[0] -eq 0xEF -and $b[1] -eq 0xBB) { $warnings += "W1-004: $($f.Name) co BOM" }
  $text = [System.Text.Encoding]::UTF8.GetString($b)
  if ($text -match "`t") { $warnings += "W1-004: $($f.Name) co tab (dung 2-space)" }
}

# ---------- W1-005: SPEC.yaml ----------
$specFile = Join-Path $spec2 'SPEC.yaml'
if (Test-Path $specFile) {
  $st = Get-Content -LiteralPath $specFile -Raw -Encoding utf8
  if ($st -notmatch '(?m)^id:\s*SPEC-002') { $errors += "W1-005: SPEC.yaml id phai la SPEC-002" }
  if ($st -notmatch '(?m)^implements:') { $errors += "W1-005: SPEC.yaml thieu implements" }
  foreach ($d in @('SPEC-000','SPEC-001')) { if ($st -notmatch [regex]::Escape($d)) { $errors += "W1-005: thieu dependency $d" } }
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== SPEC-002 Workflow Engine Validation ==="
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)     { ""; "INFOS ($($infos.Count)):";      $infos     | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }
