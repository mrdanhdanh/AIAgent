# spec004-validator.ps1
# Validator cho SPEC-004 — Agent System
# Checks A1-001..N (A001 vision, cau truc, traceability)
# ASCII-only (PS 5.1 ANSI). Exit 0 = PASS.
<#
.SYNOPSIS
  Validate SPEC-004 Agent System.
.DESCRIPTION
  Kiem tra SPEC-004: README, A001-vision.md, SPEC.yaml.
  Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$spec4 = Join-Path $root '..\docs\specs\SPEC-004'

if (-not (Test-Path $spec4)) { Write-Error "SPEC-004 not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

function Strip-Diacritics([string]$s) {
  $s = $s.Replace([char]0x0111, 'd').Replace([char]0x0110, 'D').Replace([char]0x2014, '-')
  $s = $s.Normalize([Text.NormalizationForm]::FormD)
  $sb = New-Object System.Text.StringBuilder
  foreach ($ch in $s.ToCharArray()) {
    if ([Globalization.CharUnicodeInfo]::GetUnicodeCategory($ch) -ne [Globalization.UnicodeCategory]::NonSpacingMark) {
      [void]$sb.Append($ch)
    }
  }
  return $sb.ToString()
}

# ---------- A1-001: README ----------
foreach ($f in @('README.md')) {
  if (-not (Test-Path (Join-Path $spec4 $f))) { $errors += "A1-001: missing SPEC-004/$f" }
}

# ---------- A1-002: A001 vision ----------
if (-not (Test-Path (Join-Path $spec4 'A001-vision.md'))) { $errors += "A1-002: missing A001-vision.md" }
else {
  $vRaw = Get-Content -LiteralPath (Join-Path $spec4 'A001-vision.md') -Raw -Encoding utf8
  $v = Strip-Diacritics $vRaw
  foreach ($sec in @('Mission','Vision','Position','Design Philosophy','Invariants','Scope')) {
    if ($v -notmatch [regex]::Escape("## $sec")) { $errors += "A1-002: A001 thieu section '$sec'" }
  }
  foreach ($inv in @('Moi Agent deu dang ky trong Registry (S014 agent-registry).','Moi Agent expose capability qua Capability System (SPEC-003).','Moi Agent chay qua Runtime (SPEC-001) - khong tu chay.','Agent System khong dinh nghia lai')) {
    if ($v -notmatch [regex]::Escape($inv)) { $warnings += "A1-002: A001 thieu invariant '$inv'" }
  }
}

# ---------- A1-003: frontmatter ----------
$mdFiles = Get-ChildItem -Path $spec4 -Filter '*.md' -Recurse
foreach ($md in $mdFiles) {
  $c = Get-Content -LiteralPath $md.FullName -Raw -Encoding utf8
  if ($c -notmatch '(?m)^---\s*$') { $errors += "A1-003: $($md.Name) thieu frontmatter" }
  elseif ($c -notmatch '(?m)^name:\s*\S+') { $errors += "A1-003: $($md.Name) thieu name trong frontmatter" }
  elseif ($c -notmatch '(?m)^description:') { $errors += "A1-003: $($md.Name) thieu description trong frontmatter" }
}

# ---------- A1-004: encoding (BOM/tab) ----------
foreach ($f in (Get-ChildItem -Path $spec4 -File -Recurse)) {
  $b = [System.IO.File]::ReadAllBytes($f.FullName)
  if ($b.Length -ge 3 -and $b[0] -eq 0xEF -and $b[1] -eq 0xBB) { $warnings += "A1-004: $($f.Name) co BOM" }
  $text = [System.Text.Encoding]::UTF8.GetString($b)
  if ($text -match "`t") { $warnings += "A1-004: $($f.Name) co tab (dung 2-space)" }
}

# ---------- A1-005: SPEC.yaml ----------
$specFile = Join-Path $spec4 'SPEC.yaml'
if (Test-Path $specFile) {
  $st = Get-Content -LiteralPath $specFile -Raw -Encoding utf8
  if ($st -notmatch '(?m)^id:\s*SPEC-004') { $errors += "A1-005: SPEC.yaml id phai la SPEC-004" }
  if ($st -notmatch '(?m)^implements:') { $errors += "A1-005: SPEC.yaml thieu implements" }
  foreach ($d in @('SPEC-000','SPEC-001','SPEC-002','SPEC-003')) { if ($st -notmatch [regex]::Escape($d)) { $errors += "A1-005: thieu dependency $d" } }
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== SPEC-004 Agent System Validation ==="
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)     { ""; "INFOS ($($infos.Count)):";      $infos     | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }
