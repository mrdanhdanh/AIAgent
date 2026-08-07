# spec002-validator.ps1
# Validator cho SPEC-002 — Workflow Engine
# Checks W1-001..N (W001 vision, W002 requirements, cau truc, traceability)
# ASCII-only (PS 5.1 ANSI). Exit 0 = PASS.
<#
.SYNOPSIS
  Validate SPEC-002 Workflow Engine.
.DESCRIPTION
  Kiem tra SPEC-002: README, W001-vision.md, W002 requirements, va cac section.
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
foreach ($f in (Get-ChildItem -Path $spec2 -File -Recurse)) {
  $b = [System.IO.File]::ReadAllBytes($f.FullName)
  if ($b.Length -ge 3 -and $b[0] -eq 0xEF -and $b[1] -eq 0xBB) { $warnings += "W1-004: $($f.Name) co BOM" }
  $text = [System.Text.Encoding]::UTF8.GetString($b)
  if ($text -match "`t") { $warnings += "W1-004: $($f.Name) co tab (dung 2-space)" }
}

# ---------- W2-001: W002 requirements files ----------
$w002 = Join-Path $spec2 'W002'
foreach ($f in @('requirements.md','requirements.yaml','requirements.schema.json','requirement-categories.yaml','requirement-lifecycle.yaml','requirement-priority.yaml','requirement-traceability.yaml','requirement-metrics.yaml','requirements-index.yaml','CHANGELOG.md')) {
  if (-not (Test-Path (Join-Path $w002 $f))) { $errors += "W2-001: missing W002/$f" }
}

# ---------- W2-002: requirements.yaml - FR/NFR/constraints/acceptance ----------
$rt = Join-Path $w002 'requirements.yaml'
if (Test-Path $rt) {
  $r = Get-Content -LiteralPath $rt -Raw -Encoding utf8
  foreach ($sec in @('functional','non_functional','constraints','assumptions','dependencies','external_interfaces','quality_attributes','acceptance')) {
    if ($r -notmatch "(?m)^${sec}:") { $errors += "W2-002: requirements.yaml thieu '$sec'" }
  }
  foreach ($fr in @('WFR-001','WFR-003','WFR-006','WFR-014','WFR-016')) {
    if ($r -notmatch [regex]::Escape($fr)) { $errors += "W2-002: thieu $fr" }
  }
  foreach ($nfr in @('WNFR-001','WNFR-002','WNFR-003','WNFR-010')) {
    if ($r -notmatch [regex]::Escape($nfr)) { $errors += "W2-002: thieu $nfr" }
  }
  foreach ($c in @('WC-001','WC-002','WC-003')) {
    if ($r -notmatch [regex]::Escape($c)) { $errors += "W2-002: thieu $c" }
  }
  foreach ($ar in @('WAR-001','WAR-002','WAR-006')) {
    if ($r -notmatch [regex]::Escape($ar)) { $errors += "W2-002: thieu $ar" }
  }
}

# ---------- W2-003: traceability - moi req co principle ----------
$tr = Join-Path $w002 'requirement-traceability.yaml'
if (Test-Path $tr) {
  $tb = Get-Content -LiteralPath $tr -Raw -Encoding utf8
  foreach ($id in @('WFR-001','WFR-016','WNFR-001','WNFR-012')) {
    $block = [regex]::Match($tb, "(?m)^\s*${id}:\s*(\[.*\])")
    if (-not $block.Success) { $errors += "W2-003: $id thieu principles trong traceability" }
    elseif ([string]::IsNullOrWhiteSpace($block.Groups[1].Value)) { $errors += "W2-003: $id khong co principle nao" }
  }
}

# ---------- W2-004: priority ----------
$pr = Join-Path $w002 'requirement-priority.yaml'
if (Test-Path $pr) {
  $pp = Get-Content -LiteralPath $pr -Raw -Encoding utf8
  foreach ($p in @('Critical','High','Medium')) {
    if ($pp -notmatch [regex]::Escape($p)) { $warnings += "W2-004: priority thieu $p" }
  }
}

# ---------- W2-005: requirements.md - sections ----------
$rm = Join-Path $w002 'requirements.md'
if (Test-Path $rm) {
  $m = Get-Content -LiteralPath $rm -Raw -Encoding utf8
  foreach ($sec in @('Functional Requirements','Non-Functional Requirements','Constraints','Assumptions','Quality Attributes','Acceptance Criteria','Machine-readable')) {
    if ($m -notmatch [regex]::Escape("## $sec")) { $errors += "W2-005: requirements.md thieu section '$sec'" }
  }
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
