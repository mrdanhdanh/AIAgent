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
foreach ($f in @('requirements.md','requirements.yaml','requirements.schema.json','requirement-traceability.yaml','requirement-priority.yaml')) {
  if (-not (Test-Path (Join-Path $s002 $f))) { $errors += "S1-002: missing S002/$f" }
}

# ---------- S1-003: requirements.yaml — FR/NFR/constraints/acceptance ----------
$reqYaml = Join-Path $s002 'requirements.yaml'
if (Test-Path $reqYaml) {
  $rt = Get-Content -LiteralPath $reqYaml -Raw -Encoding utf8
  foreach ($sec in @('functional','non_functional','constraints','assumptions','dependencies','external_interfaces','quality_attributes','acceptance')) {
    if ($rt -notmatch "(?m)^${sec}:") { $errors += "S1-003: requirements.yaml thieu '$sec'" }
  }
  # FR-001..012
  for ($i = 1; $i -le 12; $i++) {
    $fr = "FR-{0:D3}" -f $i
    if ($rt -notmatch [regex]::Escape($fr)) { $errors += "S1-003: thieu $fr" }
  }
  # NFR-001..008
  for ($i = 1; $i -le 8; $i++) {
    $nfr = "NFR-{0:D3}" -f $i
    if ($rt -notmatch [regex]::Escape($nfr)) { $errors += "S1-003: thieu $nfr" }
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
  $ids += 1..12 | ForEach-Object { "FR-{0:D3}" -f $_ }
  $ids += 1..8 | ForEach-Object { "NFR-{0:D3}" -f $_ }
  $ids += 1..7 | ForEach-Object { "C-{0:D3}" -f $_ }
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

# ---------- S1-006: SPEC.yaml ----------
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
