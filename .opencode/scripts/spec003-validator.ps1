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

# ---------- C2-001: C002 requirements files ----------
$c002 = Join-Path $spec3 'C002'
foreach ($f in @('requirements.md','requirements.yaml','requirements.schema.json','requirement-categories.yaml','requirement-lifecycle.yaml','requirement-priority.yaml','requirement-traceability.yaml','requirement-metrics.yaml','requirements-index.yaml','CHANGELOG.md')) {
  if (-not (Test-Path (Join-Path $c002 $f))) { $errors += "C2-001: missing C002/$f" }
}

# ---------- C2-002: requirements.yaml - FR/NFR/constraints/acceptance ----------
$rt2 = Join-Path $c002 'requirements.yaml'
if (Test-Path $rt2) {
  $r2 = Get-Content -LiteralPath $rt2 -Raw -Encoding utf8
  foreach ($sec in @('functional','non_functional','constraints','assumptions','dependencies','external_interfaces','quality_attributes','acceptance')) {
    if ($r2 -notmatch "(?m)^${sec}:") { $errors += "C2-002: requirements.yaml thieu '$sec'" }
  }
  foreach ($fr in @('CFR-001','CFR-002','CFR-003','CFR-006','CFR-010','CFR-012')) {
    if ($r2 -notmatch [regex]::Escape($fr)) { $errors += "C2-002: thieu $fr" }
  }
  foreach ($nfr in @('CNFR-001','CNFR-002','CNFR-003','CNFR-010')) {
    if ($r2 -notmatch [regex]::Escape($nfr)) { $errors += "C2-002: thieu $nfr" }
  }
  foreach ($c in @('CC-001','CC-002','CC-003')) {
    if ($r2 -notmatch [regex]::Escape($c)) { $errors += "C2-002: thieu $c" }
  }
  foreach ($ar in @('CAR-001','CAR-002','CAR-006')) {
    if ($r2 -notmatch [regex]::Escape($ar)) { $errors += "C2-002: thieu $ar" }
  }
}

# ---------- C2-003: traceability - moi req co principle ----------
$tr2 = Join-Path $c002 'requirement-traceability.yaml'
if (Test-Path $tr2) {
  $tb2 = Get-Content -LiteralPath $tr2 -Raw -Encoding utf8
  foreach ($id in @('CFR-001','CFR-016','CNFR-001','CNFR-012')) {
    $block = [regex]::Match($tb2, "(?m)^\s*${id}:\s*(\[.*\])")
    if (-not $block.Success) { $errors += "C2-003: $id thieu principles trong traceability" }
    elseif ([string]::IsNullOrWhiteSpace($block.Groups[1].Value)) { $errors += "C2-003: $id khong co principle nao" }
  }
}

# ---------- C2-004: priority ----------
$pr2 = Join-Path $c002 'requirement-priority.yaml'
if (Test-Path $pr2) {
  $pp2 = Get-Content -LiteralPath $pr2 -Raw -Encoding utf8
  foreach ($p in @('Critical','High','Medium')) {
    if ($pp2 -notmatch [regex]::Escape($p)) { $warnings += "C2-004: priority thieu $p" }
  }
}

# ---------- C2-005: requirements.md - sections ----------
$rm2 = Join-Path $c002 'requirements.md'
if (Test-Path $rm2) {
  $m2 = Get-Content -LiteralPath $rm2 -Raw -Encoding utf8
  foreach ($sec in @('Functional Requirements','Non-Functional Requirements','Constraints','Assumptions','Quality Attributes','Acceptance Criteria','Machine-readable')) {
    if ($m2 -notmatch [regex]::Escape("## $sec")) { $errors += "C2-005: requirements.md thieu section '$sec'" }
  }
}

# ---------- C3-001: C003 responsibilities ----------
$c003 = Join-Path $spec3 'C003'
foreach ($f in @('responsibilities.md','responsibilities.yaml','responsibilities.schema.json','ownership.yaml','responsibility-mapping.yaml','responsibility-matrix.yaml','responsibility-registry.yaml')) {
  if (-not (Test-Path (Join-Path $c003 $f))) { $errors += "C3-001: missing C003/$f" }
}

# ---------- C3-002: responsibilities.yaml ----------
$rw3 = Join-Path $c003 'responsibilities.yaml'
if (Test-Path $rw3) {
  $resp3 = Get-Content -LiteralPath $rw3 -Raw -Encoding utf8
  if ($resp3 -notmatch '(?m)^responsibilities:') { $errors += "C3-002: responsibilities.yaml thieu 'responsibilities:'" }
  foreach ($r in @('CRR-001','CRR-002','CRR-005','CRR-006','CRR-010','CRR-017')) {
    if ($resp3 -notmatch [regex]::Escape($r)) { $errors += "C3-002: thieu $r" }
  }
  foreach ($field in @('name','group','owner','authority','input','output','metric','requirements','principles')) {
    if ($resp3 -notmatch "(?m)^    ${field}:") { $warnings += "C3-002: responsibilities.yaml thieu field '$field'" }
  }
}

# ---------- C3-003: moi CRR co requirements + principles ----------
foreach ($r in @('CRR-001','CRR-005','CRR-010','CRR-012','CRR-018')) {
  $block = [regex]::Match($resp3, "(?ms)^  ${r}:.*?^    rules:.*$")
  if (-not $block.Success) { $errors += "C3-003: $r thieu block" }
  else {
    if ($block.Value -notmatch '(?m)^    requirements:') { $errors += "C3-003: $r thieu requirements" }
    if ($block.Value -notmatch '(?m)^    principles:') { $errors += "C3-003: $r thieu principles" }
  }
}

# ---------- C3-004: mapping ----------
$mp3 = Join-Path $c003 'responsibility-mapping.yaml'
if (Test-Path $mp3) {
  $m3 = Get-Content -LiteralPath $mp3 -Raw -Encoding utf8
  foreach ($r in @('CRR-001','CRR-016','CRR-018')) {
    if ($m3 -notmatch [regex]::Escape($r)) { $errors += "C3-004: mapping thieu $r" }
  }
}

# ---------- C3-005: responsibilities.md ----------
$rm3 = Join-Path $c003 'responsibilities.md'
if (Test-Path $rm3) {
  $mm3 = Get-Content -LiteralPath $rm3 -Raw -Encoding utf8
  foreach ($sec in @('Invariants','Delegation','Responsibilities','Machine-readable')) {
    if ($mm3 -notmatch [regex]::Escape("## $sec")) { $errors += "C3-005: responsibilities.md thieu section '$sec'" }
  }
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
