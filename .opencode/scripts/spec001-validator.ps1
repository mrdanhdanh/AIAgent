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

# ---------- S1-009: S004 boundaries ----------
$s004 = Join-Path $spec1 'S004'
foreach ($f in @('boundaries.md','boundaries.yaml','boundaries.schema.json','boundary-registry.yaml','ownership-boundary.yaml','delegation-boundary.yaml','dependency-boundary.yaml','interface-boundary.yaml','boundary-matrix.yaml','boundary-ownership-matrix.yaml')) {
  if (-not (Test-Path (Join-Path $s004 $f))) { $errors += "S1-009: missing S004/$f" }
}
$bdYaml = Join-Path $s004 'boundaries.yaml'
if (Test-Path $bdYaml) {
  $bd = Get-Content -LiteralPath $bdYaml -Raw -Encoding utf8
  foreach ($b in @('B001-ownership','B002-permission','B003-delegation','B004-dependency','B005-interface','B006-state','B007-data','B008-failure','B009-security')) {
    if ($bd -notmatch [regex]::Escape($b)) { $errors += "S1-009: thieu $b" }
  }
  foreach ($sec in @('hierarchy','decision','invariants','validation','mapping')) {
    if ($bd -notmatch "(?m)^${sec}:") { $errors += "S1-009: boundaries.yaml thieu '$sec'" }
  }
  foreach ($b in @('B001-ownership','B002-permission','B003-delegation','B004-dependency','B005-interface','B006-state','B007-data','B008-failure','B009-security')) {
    # tim block cua boundary, kiem tra co severity + principles
    $idx = $bd.IndexOf("$b" + ':')
    if ($idx -lt 0) { continue }
    $nextIdx = $bd.Length
    foreach ($nb in @('B001-ownership','B002-permission','B003-delegation','B004-dependency','B005-interface','B006-state','B007-data','B008-failure','B009-security')) {
      $n = $bd.IndexOf("$nb" + ':', $idx + 1)
      if ($n -gt 0 -and $n -lt $nextIdx) { $nextIdx = $n }
    }
    $block = $bd.Substring($idx, $nextIdx - $idx)
    if ($block -notmatch '(?m)^    severity:\s*(\w+)') { $errors += "S1-009: $b thieu severity" }
    elseif ($Matches[1] -notin @('Critical','High','Medium','Low')) { $errors += "S1-009: $b severity sai" }
    if ($block -notmatch '(?m)^    principles:') { $errors += "S1-009: $b thieu principles" }
  }
}

# ---------- S1-011: S005 architecture ----------
$s005 = Join-Path $spec1 'S005'
foreach ($f in @('architecture.md','architecture.yaml','architecture.schema.json','architecture-registry.yaml','layer-model.yaml','dependency-rules.yaml','communication-rules.yaml','domain-model.yaml','architecture-matrix.yaml','architecture-decision-log.yaml')) {
  if (-not (Test-Path (Join-Path $s005 $f))) { $errors += "S1-011: missing S005/$f" }
}
$archYaml = Join-Path $s005 'architecture.yaml'
if (Test-Path $archYaml) {
  $ar = Get-Content -LiteralPath $archYaml -Raw -Encoding utf8
  foreach ($l in @('Command','Workflow','Execution','Coordination','Capability','Resolution','State','Event','Publication')) {
    if ($ar -notmatch [regex]::Escape($l)) { $errors += "S1-011: thieu layer $l" }
  }
  foreach ($d in @('Execution','Coordination','Capability','State','Observability','Publication')) {
    if ($ar -notmatch [regex]::Escape($d)) { $errors += "S1-011: thieu domain $d" }
  }
  foreach ($sec in @('decisions','dependency_rules','communication_rules','invariants','views','quality','constraints','stability','metrics','validation','mapping')) {
    if ($ar -notmatch "(?m)^${sec}:") { $errors += "S1-011: architecture.yaml thieu '$sec'" }
  }
}

# ---------- S1-013: S006 components ----------
$s006 = Join-Path $spec1 'S006'
foreach ($f in @('components.md','components.yaml','components.schema.json','component-model.yaml','component-registry.yaml','component-dependencies.yaml','component-lifecycle.yaml','component-contracts.yaml','component-ownership.yaml','component-mapping.yaml','component-metrics.yaml','component-validation.yaml')) {
  if (-not (Test-Path (Join-Path $s006 $f))) { $errors += "S1-013: missing S006/$f" }
}
$cmpYaml = Join-Path $s006 'components.yaml'
if (Test-Path $cmpYaml) {
  $cp = Get-Content -LiteralPath $cmpYaml -Raw -Encoding utf8
  if ($cp -notmatch '(?m)^components:') { $errors += "S1-013: components.yaml thieu 'components:'" }
  for ($i = 1; $i -le 12; $i++) {
    $c = "CMP-{0:D3}" -f $i
    if ($cp -notmatch [regex]::Escape($c)) { $errors += "S1-013: thieu $c" }
  }
  foreach ($n in @('Execution Manager','Execution Orchestrator','Context Manager','State Manager','Policy Engine','Workflow Loader','Capability Resolver','Registry Resolver','Event Dispatcher','Artifact Dispatcher','Metrics Collector','Execution Resource Manager')) {
    if ($cp -notmatch [regex]::Escape($n)) { $errors += "S1-013: thieu component '$n'" }
  }
  foreach ($g in @('Core','Resolution','Infrastructure')) {
    if ($cp -notmatch [regex]::Escape($g)) { $errors += "S1-013: thieu group $g" }
  }
  foreach ($sec in @('groups','lifecycles','component_model','philosophy','principles')) {
    if ($cp -notmatch "(?m)^${sec}:") { $errors += "S1-013: components.yaml thieu '$sec'" }
  }
  if ($cp -notmatch '(?m)^not_in_runtime:') { $errors += "S1-013: components.yaml thieu not_in_runtime" }
}
# mapping: moi CMP co layer + requirement + principle
$cmpMap = Join-Path $s006 'component-mapping.yaml'
if (Test-Path $cmpMap) {
  $cm = Get-Content -LiteralPath $cmpMap -Raw -Encoding utf8
  for ($i = 1; $i -le 12; $i++) {
    $c = "CMP-{0:D3}" -f $i
    $block = [regex]::Match($cm, "(?s)${c}:\s*layer:\s*(\w+)\s*domain:\s*(\w+).*?responsibilities:\s*\[([^\]]*)\]\s*requirements:\s*\[([^\]]*)\]")
    if (-not $block.Success) { $errors += "S1-013: $c thieu layer/domain/requirements" }
    elseif ([string]::IsNullOrWhiteSpace($block.Groups[4].Value)) { $errors += "S1-013: $c khong co requirement nao" }
  }
}

# ---------- S1-015: S007 contracts ----------
$s007 = Join-Path $spec1 'S007'
foreach ($f in @('contracts.md','contracts.yaml','contracts.schema.json','contract-model.yaml','contract-registry.yaml','communication-matrix.yaml','contract-compatibility.yaml','contract-mapping.yaml','contract-types.yaml','contract-categories.yaml','contract-anti-patterns.yaml','contract-quality.yaml')) {
  if (-not (Test-Path (Join-Path $s007 $f))) { $errors += "S1-015: missing S007/$f" }
}
$ctrYaml = Join-Path $s007 'contracts.yaml'
if (Test-Path $ctrYaml) {
  $ct = Get-Content -LiteralPath $ctrYaml -Raw -Encoding utf8
  if ($ct -notmatch '(?m)^contracts:') { $errors += "S1-015: contracts.yaml thieu 'contracts:'" }
  for ($i = 1; $i -le 12; $i++) {
    $c = "CTR-{0:D3}" -f $i
    if ($ct -notmatch [regex]::Escape($c)) { $errors += "S1-015: thieu $c" }
  }
  foreach ($field in @('purpose','inputs','outputs','preconditions','postconditions','invariants','dependencies','category','direction','pattern')) {
    if ($ct -notmatch "(?m)^    ${field}:") { $warnings += "S1-015: contracts.yaml thieu field '$field'" }
  }
}
# runtime-models
$rmDir = Join-Path $spec1 'runtime-models'
foreach ($f in @('README.md','runtime-models.yaml')) {
  if (-not (Test-Path (Join-Path $rmDir $f))) { $errors += "S1-015: missing runtime-models/$f" }
}
# mapping: moi CTR co component + principle
$ctrMap = Join-Path $s007 'contract-mapping.yaml'
if (Test-Path $ctrMap) {
  $cm = Get-Content -LiteralPath $ctrMap -Raw -Encoding utf8
  for ($i = 1; $i -le 12; $i++) {
    $c = "CTR-{0:D3}" -f $i
    $block = [regex]::Match($cm, "(?s)${c}:\s*component:\s*(\w[\w ]*?)\s*capability:.*?principle:\s*([^\r\n]*)")
    if (-not $block.Success) { $errors += "S1-015: $c thieu component/principles" }
    elseif ([string]::IsNullOrWhiteSpace($block.Groups[1].Value)) { $errors += "S1-015: $c khong co component" }
  }
}
# communication matrix: it nhat 10 edges
$comFile = Join-Path $s007 'communication-matrix.yaml'
if (Test-Path $comFile) {
  $co = Get-Content -LiteralPath $comFile -Raw -Encoding utf8
  $edgeCount = ([regex]::Matches($co, '(?m)^  - from:')).Count
  if ($edgeCount -lt 10) { $errors += "S1-015: communication-matrix chi co $edgeCount edges (can >=10)" }
}

# ---------- S1-016: SPEC.yaml ----------
$specFile = Join-Path $spec1 'SPEC.yaml'
if (Test-Path $specFile) {
  $st = Get-Content -LiteralPath $specFile -Raw -Encoding utf8
  if ($st -notmatch '(?m)^id:\s*SPEC-001') { $errors += "S1-016: SPEC.yaml id phai la SPEC-001" }
  if ($st -notmatch '(?m)^implements:') { $errors += "S1-016: SPEC.yaml thieu implements" }
  foreach ($d in @('SPEC-000')) { if ($st -notmatch [regex]::Escape($d)) { $errors += "S1-016: thieu dependency $d" } }
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
