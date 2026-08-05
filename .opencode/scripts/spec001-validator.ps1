# spec001-validator.ps1
# Validator cho SPEC-001 — Runtime Kernel
# Checks S1-001..006 (S001 vision, S002 requirements, cau truc, traceability)
# ASCII-only (PS 5.1 ANSI).
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate SPEC-001 Runtime Kernel.
.DESCRIPTION
  Kiem tra SPEC-001: S001-vision.md, S002/requirements, traceability, priority.
  Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$spec1 = Join-Path $root '..\docs\specs\SPEC-001'

if (-not (Test-Path $spec1)) { Write-Error "SPEC-001 not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

# ---------- S1-001: S001 vision ----------
if (-not (Test-Path (Join-Path $spec1 'S001-vision.md'))) { $errors += "S1-001: missing S001-vision.md" }
else {
  $v = Get-Content -LiteralPath (Join-Path $spec1 'S001-vision.md') -Raw -Encoding utf8
  foreach ($sec in @('Mission','Vision','Position','Design Philosophy','Design Goals','Design Constraints','Runtime Boundaries','Runtime Responsibilities','Runtime Invariants','Success Criteria','Architectural Promise')) {
    if ($v -notmatch [regex]::Escape($sec)) { $warnings += "S1-001: S001 thieu section '$sec'" }
  }
}

# ---------- S1-002: S002 requirements files ----------
$s002 = Join-Path $spec1 'S002'
foreach ($f in @('requirements.md','requirements.yaml','requirements.schema.json','requirement-traceability.yaml','requirement-priority.yaml','requirements-index.yaml','requirement-categories.yaml','requirement-lifecycle.yaml','requirement-metrics.yaml')) {
  if (-not (Test-Path (Join-Path $s002 $f))) { $errors += "S1-002: missing S002/$f" }
}

# ---------- S1-003: requirements.yaml — FR/NFR/constraints/acceptance ----------
$reqYaml = Join-Path $s002 'requirements.yaml'
if (Test-Path $reqYaml) {
  $rt = Get-Content -LiteralPath $reqYaml -Raw -Encoding utf8
  foreach ($sec in @('functional','non_functional','constraints','assumptions','dependencies','external_interfaces','quality_attributes','acceptance')) {
    if ($rt -notmatch "(?m)^${sec}:") { $errors += "S1-003: requirements.yaml thieu '$sec'" }
  }
  # FR-001..020
  for ($i = 1; $i -le 20; $i++) {
    $fr = "FR-{0:D3}" -f $i
    if ($rt -notmatch [regex]::Escape($fr)) { $errors += "S1-003: thieu $fr" }
  }
  # NFR-001..015
  for ($i = 1; $i -le 15; $i++) {
    $nfr = "NFR-{0:D3}" -f $i
    if ($rt -notmatch [regex]::Escape($nfr)) { $errors += "S1-003: thieu $nfr" }
  }
  # C-001..009
  for ($i = 1; $i -le 9; $i++) {
    $c = "C-{0:D3}" -f $i
    if ($rt -notmatch [regex]::Escape($c)) { $warnings += "S1-003: thieu $c" }
  }
  # AR-001..006
  for ($i = 1; $i -le 6; $i++) {
    $ar = "AR-{0:D3}" -f $i
    if ($rt -notmatch [regex]::Escape($ar)) { $warnings += "S1-003: thieu $ar" }
  }
}

# ---------- S1-004: traceability — moi req co principle ----------
$trFile = Join-Path $s002 'requirement-traceability.yaml'
if (Test-Path $trFile) {
  $tr = Get-Content -LiteralPath $trFile -Raw -Encoding utf8
  $ids = @()
  $ids += 1..20 | ForEach-Object { "FR-{0:D3}" -f $_ }
  $ids += 1..15 | ForEach-Object { "NFR-{0:D3}" -f $_ }
  $ids += 1..9 | ForEach-Object { "C-{0:D3}" -f $_ }
  $ids += 1..6 | ForEach-Object { "AR-{0:D3}" -f $_ }
  foreach ($id in $ids) {
    $block = [regex]::Match($tr, "(?s)${id}:\s*principles:\s*\[([^\]]*)\]")
    if (-not $block.Success) { $errors += "S1-004: $id thieu principles trong traceability" }
    elseif ([string]::IsNullOrWhiteSpace($block.Groups[1].Value)) { $errors += "S1-004: $id khong co principle nao" }
  }
}

# ---------- S1-005: priority ----------
$prFile = Join-Path $s002 'requirement-priority.yaml'
if (Test-Path $prFile) {
  $pr = Get-Content -LiteralPath $prFile -Raw -Encoding utf8
  foreach ($p in @('Critical','High','Medium')) {
    if ($pr -notmatch [regex]::Escape($p)) { $warnings += "S1-005: priority thieu $p" }
  }
}

# ---------- S1-007: S003 responsibilities ----------
$s003 = Join-Path $spec1 'S003'
foreach ($f in @('responsibilities.md','responsibilities.yaml','responsibilities.schema.json','responsibility-registry.yaml','responsibility-mapping.yaml','responsibility-matrix.yaml','ownership.yaml')) {
  if (-not (Test-Path (Join-Path $s003 $f))) { $errors += "S1-007: missing S003/$f" }
}
$respYaml = Join-Path $s003 'responsibilities.yaml'
if (Test-Path $respYaml) {
  $resp = Get-Content -LiteralPath $respYaml -Raw -Encoding utf8
  if ($resp -notmatch '(?m)^responsibilities:') { $errors += "S1-007: responsibilities.yaml thieu 'responsibilities:'" }
  for ($i = 1; $i -le 35; $i++) {
    $r = "RR-{0:D3}" -f $i
    if ($resp -notmatch [regex]::Escape($r)) { $errors += "S1-007: thieu $r" }
  }
  foreach ($field in @('invariants','delegation')) {
    if ($resp -notmatch "(?m)^${field}:") { $warnings += "S1-007: responsibilities.yaml thieu '$field'" }
  }
}
# mapping: moi RR co requirement + principle
$respMap = Join-Path $s003 'responsibility-mapping.yaml'
if (Test-Path $respMap) {
  $tr = Get-Content -LiteralPath $respMap -Raw -Encoding utf8
  for ($i = 1; $i -le 35; $i++) {
    $r = "RR-{0:D3}" -f $i
    $block = [regex]::Match($tr, "(?s)${r}:\s*requirements:\s*\[([^\]]*)\]\s*principles:\s*\[([^\]]*)\]")
    if (-not $block.Success) { $errors += "S1-007: $r thieu requirements/principles" }
    elseif ([string]::IsNullOrWhiteSpace($block.Groups[1].Value)) { $errors += "S1-007: $r khong co requirement nao" }
    elseif ([string]::IsNullOrWhiteSpace($block.Groups[2].Value)) { $errors += "S1-007: $r khong co principle nao" }
  }
}

# ---------- S1-008: SPEC.yaml ----------
$specFile = Join-Path $spec1 'SPEC.yaml'
if (Test-Path $specFile) {
  $st = Get-Content -LiteralPath $specFile -Raw -Encoding utf8
  if ($st -notmatch '(?m)^id:\s*SPEC-001') { $errors += "S1-006: SPEC.yaml id phai la SPEC-001" }
  if ($st -notmatch '(?m)^implements:') { $errors += "S1-006: SPEC.yaml thieu implements" }
  foreach ($d in @('SPEC-000')) { if ($st -notmatch [regex]::Escape($d)) { $errors += "S1-006: thieu dependency $d" } }
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== SPEC-001 Runtime Kernel Validation ==="
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)     { ""; "INFOS ($($infos.Count)):";      $infos     | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }
