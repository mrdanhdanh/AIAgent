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
foreach ($f in @('README.md','runtime-models.yaml','runtime-models.schema.json','runtime-model-registry.yaml','runtime-model-relationships.yaml','runtime-model-validation.yaml')) {
  if (-not (Test-Path (Join-Path $rmDir $f))) { $errors += "S1-015: missing runtime-models/$f" }
}
$rmYaml = Join-Path $rmDir 'runtime-models.yaml'
if (Test-Path $rmYaml) {
  $rm = Get-Content -LiteralPath $rmYaml -Raw -Encoding utf8
  for ($i = 1; $i -le 12; $i++) {
    $m = "RM-{0:D3}" -f $i
    if ($rm -notmatch [regex]::Escape($m)) { $errors += "S1-015: runtime-models thieu $m" }
  }
  foreach ($n in @('Execution','Workflow','Phase','Task','Context','State','Event','Artifact','Contract','Capability','Metadata','Execution Result')) {
    if ($rm -notmatch [regex]::Escape($n)) { $warnings += "S1-015: runtime-models thieu model '$n'" }
  }
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

# ---------- S1-017: S009 state machine ----------
$s009 = Join-Path $spec1 'S009'
foreach ($f in @('state-machine.md','state-machine.yaml','state.schema.json','states.yaml','transitions.yaml','transition-types.yaml','transition-triggers.yaml','transition-matrix.yaml','transition-guards.yaml','state-events.yaml','state-history.yaml','state-metrics.yaml','retry-model.yaml','replay-model.yaml','state-machine-registry.yaml','state-machine-validation.yaml')) {
  if (-not (Test-Path (Join-Path $s009 $f))) { $errors += "S1-017: missing S009/$f" }
}
$smYaml = Join-Path $s009 'state-machine.yaml'
if (Test-Path $smYaml) {
  $sm = Get-Content -LiteralPath $smYaml -Raw -Encoding utf8
  if ($sm -notmatch '(?m)^states:') { $errors += "S1-017: thieu 'states:'" }
  for ($i = 1; $i -le 14; $i++) {
    $s = "ST-{0:D3}" -f $i
    if ($sm -notmatch [regex]::Escape($s)) { $errors += "S1-017: thieu state $s" }
  }
  if ($sm -notmatch '(?m)^initial_state:') { $errors += "S1-017: thieu initial_state" }
  if ($sm -notmatch '(?m)^terminal_states:') { $errors += "S1-017: thieu terminal_states" }
  if ($sm -notmatch '(?m)^transitions:') { $errors += "S1-017: thieu transitions" }
  $trCount = ([regex]::Matches($sm, '(?m)^  - from:')).Count
  if ($trCount -lt 10) { $errors += "S1-017: chi co $trCount transitions (can >=10)" }
  foreach ($sec in @('philosophy','principles','categories','concurrency_rules','composite_states','terminal_rules','triggers','invalid_transitions','invariants','ownership')) {
    if ($sm -notmatch "(?m)^${sec}:") { $errors += "S1-017: thieu '$sec'" }
  }
}

# ---------- S1-016: S008 data model ----------
$s008 = Join-Path $spec1 'S008'
foreach ($f in @('data-model.md','runtime-data-model.yaml','runtime-entities.yaml','runtime-relations.yaml','runtime-lifecycle.yaml','runtime-ownership.yaml','runtime-references.yaml','runtime-validation.yaml','runtime-identities.yaml','runtime-invariants.yaml','runtime-data.schema.json')) {
  if (-not (Test-Path (Join-Path $s008 $f))) { $errors += "S1-016: missing S008/$f" }
}
$entYaml = Join-Path $s008 'runtime-entities.yaml'
if (Test-Path $entYaml) {
  $en = Get-Content -LiteralPath $entYaml -Raw -Encoding utf8
  for ($i = 1; $i -le 15; $i++) {
    $e = "ENT-{0:D3}" -f $i
    if ($en -notmatch [regex]::Escape($e)) { $errors += "S1-016: thieu $e" }
  }
  foreach ($n in @('Execution','Execution Context','Execution State','Workflow Reference','Capability Reference','Agent Assignment','Event','Artifact','Metrics','Trace','Resource Allocation','Execution Result','Execution Snapshot','Execution Lineage','Execution Metadata')) {
    if ($en -notmatch [regex]::Escape($n)) { $warnings += "S1-016: thieu entity '$n'" }
  }
}
$dmYaml = Join-Path $s008 'runtime-data-model.yaml'
if (Test-Path $dmYaml) {
  $dm = Get-Content -LiteralPath $dmYaml -Raw -Encoding utf8
  foreach ($sec in @('aggregate_root','aggregate_rules','classification','invariants','consistency','dependencies')) {
    if ($dm -notmatch "(?m)^${sec}:") { $errors += "S1-016: runtime-data-model thieu '$sec'" }
  }
  if ($dm -notmatch 'Execution') { $errors += "S1-016: aggregate_root phai la Execution" }
}
# validation: 20 rules
$valYaml = Join-Path $s008 'runtime-validation.yaml'
if (Test-Path $valYaml) {
  $vl = Get-Content -LiteralPath $valYaml -Raw -Encoding utf8
  $ruleCount = ([regex]::Matches($vl, '(?m)^  - ')).Count
  if ($ruleCount -lt 15) { $errors += "S1-016: runtime-validation chi co $ruleCount rules (can >=15)" }
}

# ---------- S1-019: S010 execution flow ----------
$s010 = Join-Path $spec1 'S010'
foreach ($f in @('execution-flow.md','execution-flow.yaml','execution-flow.schema.json','execution-stages.yaml','execution-transitions.yaml','execution-validation.yaml','workflow-flow.yaml','capability-flow.yaml','context-flow.yaml','event-flow.yaml','artifact-flow.yaml','retry-flow.yaml','approval-flow.yaml','timeout-flow.yaml','replay-flow.yaml','failure-flow.yaml','parallel-flow.yaml','compensation-flow.yaml','execution-lineage.yaml','execution-outcome.yaml','execution-policies.yaml','execution-guarantees.yaml')) {
  if (-not (Test-Path (Join-Path $s010 $f))) { $errors += "S1-019: missing S010/$f" }
}
$efYaml = Join-Path $s010 'execution-flow.yaml'
if (Test-Path $efYaml) {
  $ef = Get-Content -LiteralPath $efYaml -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','lifecycle_overview','stages','canonical_flow')) {
    if ($ef -notmatch "(?m)^${sec}:") { $errors += "S1-019: execution-flow thieu '$sec'" }
  }
  foreach ($st in @('Initialize','Validate','Prepare','Execute','Coordinate','Finalize','Complete')) {
    if ($ef -notmatch [regex]::Escape($st)) { $errors += "S1-019: thieu stage $st" }
  }
}
# md: 26 sections EF001-EF026
$efMd = Join-Path $s010 'execution-flow.md'
if (Test-Path $efMd) {
  $em = Get-Content -LiteralPath $efMd -Raw -Encoding utf8
  for ($i = 1; $i -le 26; $i++) {
    $sec = "EF{0:D3}" -f $i
    if ($em -notmatch [regex]::Escape($sec)) { $errors += "S1-019: thieu section $sec" }
  }
}

# ---------- S1-021: S011 observability ----------
$s011 = Join-Path $spec1 'S011'
foreach ($f in @('observability.md','observability.yaml','observability.schema.json','events.yaml','metrics.yaml','traces.yaml','audit.yaml','health.yaml','dashboard.yaml','correlation.yaml','lineage.yaml','observability-mapping.yaml')) {
  if (-not (Test-Path (Join-Path $s011 $f))) { $errors += "S1-021: missing S011/$f" }
}
$obYaml = Join-Path $s011 'observability.yaml'
if (Test-Path $obYaml) {
  $ob = Get-Content -LiteralPath $obYaml -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','domains','boundary','correlation_model','doctor_checks','evolution_integration','machine_readable','success_criteria','traceability')) {
    if ($ob -notmatch "(?m)^${sec}:") { $errors += "S1-021: observability thieu '$sec'" }
  }
  foreach ($d in @('Events','Metrics','Trace','Audit','Health')) {
    if ($ob -notmatch [regex]::Escape($d)) { $warnings += "S1-021: thieu domain '$d'" }
  }
}
# md: 18 sections OB001-OB016 + OB003A + OB011A
$obMd = Join-Path $s011 'observability.md'
if (Test-Path $obMd) {
  $om = Get-Content -LiteralPath $obMd -Raw -Encoding utf8
  for ($i = 1; $i -le 16; $i++) {
    $sec = "OB{0:D3}" -f $i
    if ($om -notmatch [regex]::Escape($sec)) { $errors += "S1-021: thieu section $sec" }
  }
  foreach ($sec in @('OB003A','OB011A')) {
    if ($om -notmatch [regex]::Escape($sec)) { $errors += "S1-021: thieu section $sec" }
  }
}

# ---------- S1-022: S012 policies ----------
$s012 = Join-Path $spec1 'S012'
foreach ($f in @('policies.md','policies.yaml','policies.schema.json','policy-model.yaml','policy-lifecycle.yaml','policy-categories.yaml','policy-conflicts.yaml','retry-policy.yaml','timeout-policy.yaml','approval-policy.yaml','resource-policy.yaml','parallel-policy.yaml','compensation-policy.yaml','scheduling-policy.yaml','isolation-policy.yaml','security-policy.yaml','resource-access-policy.yaml','policy-resolution.yaml','policy-validation.yaml','policy-traceability.yaml')) {
  if (-not (Test-Path (Join-Path $s012 $f))) { $errors += "S1-022: missing S012/$f" }
}
$poYaml = Join-Path $s012 'policies.yaml'
if (Test-Path $poYaml) {
  $po = Get-Content -LiteralPath $poYaml -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','policy_model','lifecycle','scopes','categories','policies','responsibility_chain')) {
    if ($po -notmatch "(?m)^${sec}:") { $errors += "S1-022: policies thieu '$sec'" }
  }
  foreach ($polId in @('POL-RETRY-001','POL-TIMEOUT-001','POL-APPROVAL-001','POL-RES-001','POL-PARALLEL-001','POL-COMP-001','POL-SCHED-001','POL-ISOL-001','POL-SEC-001','POL-RESACC-001')) {
    if ($po -notmatch [regex]::Escape($polId)) { $errors += "S1-022: thieu policy $polId" }
  }
}
# md: 17 sections RP001-RP017 + RP002A + RP002B + RP012A + RP013A
$poMd = Join-Path $s012 'policies.md'
if (Test-Path $poMd) {
  $pm = Get-Content -LiteralPath $poMd -Raw -Encoding utf8
  for ($i = 1; $i -le 17; $i++) {
    $sec = "RP{0:D3}" -f $i
    if ($pm -notmatch [regex]::Escape($sec)) { $errors += "S1-022: thieu section $sec" }
  }
  foreach ($sec in @('RP002A','RP002B','RP012A','RP013A')) {
    if ($pm -notmatch [regex]::Escape($sec)) { $errors += "S1-022: thieu section $sec" }
  }
}

# ---------- S1-023: S013 governance ----------
$s013 = Join-Path $spec1 'S013'
foreach ($f in @('governance.md','governance.yaml','governance.schema.json','constitution-enforcement.yaml','policy-enforcement.yaml','contract-enforcement.yaml','boundary-enforcement.yaml','permission-enforcement.yaml','governance-metrics.yaml')) {
  if (-not (Test-Path (Join-Path $s013 $f))) { $errors += "S1-023: missing S013/$f" }
}
$gvYaml = Join-Path $s013 'governance.yaml'
if (Test-Path $gvYaml) {
  $gv = Get-Content -LiteralPath $gvYaml -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','scope','version_governance','compatibility_governance','validation_pipeline','decisions','traceability')) {
    if ($gv -notmatch "(?m)^${sec}:") { $errors += "S1-023: governance thieu '$sec'" }
  }
  foreach ($e in @('Constitution','Policy','Contract','Boundary','Permission','Version Compatibility')) {
    if ($gv -notmatch [regex]::Escape($e)) { $warnings += "S1-023: thieu enforces '$e'" }
  }
}
# md: 18 sections GV001-GV018
$gvMd = Join-Path $s013 'governance.md'
if (Test-Path $gvMd) {
  $gm = Get-Content -LiteralPath $gvMd -Raw -Encoding utf8
  for ($i = 1; $i -le 18; $i++) {
    $sec = "GV{0:D3}" -f $i
    if ($gm -notmatch [regex]::Escape($sec)) { $errors += "S1-023: thieu section $sec" }
  }
}

# ---------- S1-024: SPEC.yaml ----------
$specFile = Join-Path $spec1 'SPEC.yaml'
if (Test-Path $specFile) {
  $st = Get-Content -LiteralPath $specFile -Raw -Encoding utf8
  if ($st -notmatch '(?m)^id:\s*SPEC-001') { $errors += "S1-020: SPEC.yaml id phai la SPEC-001" }
  if ($st -notmatch '(?m)^implements:') { $errors += "S1-020: SPEC.yaml thieu implements" }
  foreach ($d in @('SPEC-000')) { if ($st -notmatch [regex]::Escape($d)) { $errors += "S1-020: thieu dependency $d" } }
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
