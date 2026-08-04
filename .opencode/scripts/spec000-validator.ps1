# spec000-validator.ps1
# Validator cho SPEC-000 - AIOS Constitution (Assemble)
# Checks SPC-001..008 (SPEC.yaml, INDEX, 5 parts, 3 yaml matrices, schema)
# ASCII-only (PS 5.1 ANSI).
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate SPEC-000 Constitution.
.DESCRIPTION
  Kiem tra SPEC-000 assemble: SPEC.yaml, INDEX.yaml, 5 parts (01-05),
  cross-reference, dependency-map, compliance-matrix, constitution.schema.json.
  Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$s000 = Join-Path $root '..\docs\specs\SPEC-000'

if (-not (Test-Path $s000)) { Write-Error "SPEC-000 not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

# ---------- SPC-001: files chinh ----------
$files = @('README.md','SPEC.yaml','INDEX.yaml','constitution.schema.json',
  '01-manifest.md','02-glossary.md','03-principles.md','04-rules.md','05-governance.md',
  'cross-reference.yaml','dependency-map.yaml','compliance-matrix.yaml','changelog.md')
foreach ($f in $files) {
  if (-not (Test-Path (Join-Path $s000 $f))) { $errors += "SPC-001: missing $f" }
}

# ---------- SPC-002: SPEC.yaml fields ----------
$spec = Join-Path $s000 'SPEC.yaml'
if (Test-Path $spec) {
  $text = Get-Content -LiteralPath $spec -Raw -Encoding utf8
  foreach ($field in @('id','name','version','status','type','description','includes','authoritative','breaking_change_requires','references')) {
    if ($text -notmatch "(?m)^${field}:") { $errors += "SPC-002: SPEC.yaml thieu field '$field'" }
  }
  if ($text -notmatch '(?m)^id:\s*SPEC-000') { $errors += "SPC-002: id phai la SPEC-000" }
  foreach ($d in @('D001','D002','D003','D004','D005')) {
    if ($text -notmatch [regex]::Escape($d)) { $errors += "SPC-002: includes thieu $d" }
  }
}

# ---------- SPC-003: INDEX.yaml ----------
$index = Join-Path $s000 'INDEX.yaml'
if (Test-Path $index) {
  $it = Get-Content -LiteralPath $index -Raw -Encoding utf8
  foreach ($sec in @('documents','principles','rules','policies','glossary_terms')) {
    if ($it -notmatch "(?m)^${sec}:") { $errors += "SPC-003: INDEX.yaml thieu '$sec'" }
  }
  for ($i = 1; $i -le 20; $i++) {
    $p = "P{0:D3}" -f $i
    if ($it -notmatch [regex]::Escape($p)) { $warnings += "SPC-003: INDEX thieu $p" }
  }
}

# ---------- SPC-004: cross-reference P001-P020 ----------
$cr = Join-Path $s000 'cross-reference.yaml'
if (Test-Path $cr) {
  $ct = Get-Content -LiteralPath $cr -Raw -Encoding utf8
  for ($i = 1; $i -le 20; $i++) {
    $p = "P{0:D3}" -f $i
    if ($ct -notmatch [regex]::Escape($p)) { $warnings += "SPC-004: cross-reference thieu $p" }
  }
  # moi principle phai co >=1 rule va >=1 policy
  for ($i = 1; $i -le 20; $i++) {
    $p = "P{0:D3}" -f $i
    $block = [regex]::Match($ct, "(?s)${p}:\s*rules:\s*\[([^\]]*)\]\s*policies:\s*\[([^\]]*)\]")
    if ($block.Success) {
      $r = $block.Groups[1].Value; $pl = $block.Groups[2].Value
      if ([string]::IsNullOrWhiteSpace($r)) { $errors += "SPC-004: $p khong co rule nao" }
      if ([string]::IsNullOrWhiteSpace($pl)) { $errors += "SPC-004: $p khong co policy nao" }
    }
  }
}

# ---------- SPC-005: compliance matrix 16 components ----------
$cm = Join-Path $s000 'compliance-matrix.yaml'
if (Test-Path $cm) {
  $mt = Get-Content -LiteralPath $cm -Raw -Encoding utf8
  for ($i = 1; $i -le 16; $i++) {
    $t = "TERM-{0:D3}" -f $i
    if ($mt -notmatch [regex]::Escape($t)) { $warnings += "SPC-005: compliance-matrix thieu $t" }
  }
}

# ---------- SPC-006: dependency-map ----------
$dm = Join-Path $s000 'dependency-map.yaml'
if (Test-Path $dm) {
  $dt = Get-Content -LiteralPath $dm -Raw -Encoding utf8
  foreach ($c in @('Manifest','Glossary','Principles','Rules','Governance')) {
    if ($dt -notmatch [regex]::Escape($c)) { $errors += "SPC-006: dependency-map thieu $c" }
  }
  if ($dt -notmatch '(?m)^dependency_chain:') { $errors += "SPC-006: dependency-map thieu dependency_chain" }
}

# ---------- SPC-007: README noi dung (ASCII-safe markers) ----------
$readme = Get-Content -LiteralPath (Join-Path $s000 'README.md') -Raw -Encoding utf8
if ($readme -notmatch 'Definition of Done') { $errors += "SPC-007: thieu Definition of Done" }
if ($readme -notmatch 'Decision Hierarchy') { $warnings += "SPC-007: thieu Decision Hierarchy" }
if ($readme -notmatch 'Assemble') { $errors += "SPC-007: thieu thuong hieu Assemble" }
if ($readme -notmatch 'compliance-matrix.yaml') { $warnings += "SPC-007: thieu compliance-matrix tham chieu" }

# ---------- SPC-008: khong chua implementation ----------
foreach ($f in @('01-manifest.md','02-glossary.md','03-principles.md','04-rules.md','05-governance.md')) {
  $t = Get-Content -LiteralPath (Join-Path $s000 $f) -Raw -Encoding utf8
  foreach ($bad in @('class ','def ','function ','interface ','TODO: implement')) {
    if ($t -match [regex]::Escape($bad)) { $warnings += "SPC-008: $f co the chua implementation" }
  }
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== SPEC-000 Constitution Validation (Assemble) ==="
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)     { ""; "INFOS ($($infos.Count)):";      $infos     | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }
