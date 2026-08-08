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

# ---------- W3-001: W003 responsibilities ----------
$w003 = Join-Path $spec2 'W003'
foreach ($f in @('responsibilities.md','responsibilities.yaml','responsibilities.schema.json','ownership.yaml','responsibility-mapping.yaml','responsibility-matrix.yaml','responsibility-registry.yaml')) {
  if (-not (Test-Path (Join-Path $w003 $f))) { $errors += "W3-001: missing W003/$f" }
}

# ---------- W3-002: responsibilities.yaml ----------
$rw = Join-Path $w003 'responsibilities.yaml'
if (Test-Path $rw) {
  $resp = Get-Content -LiteralPath $rw -Raw -Encoding utf8
  if ($resp -notmatch '(?m)^responsibilities:') { $errors += "W3-002: responsibilities.yaml thieu 'responsibilities:'" }
  foreach ($r in @('WRR-001','WRR-003','WRR-006','WRR-014','WRR-017')) {
    if ($resp -notmatch [regex]::Escape($r)) { $errors += "W3-002: thieu $r" }
  }
  foreach ($field in @('name','group','owner','authority','input','output','metric','requirements','principles')) {
    if ($resp -notmatch "(?m)^    ${field}:") { $warnings += "W3-002: responsibilities.yaml thieu field '$field'" }
  }
}

# ---------- W3-003: moi WRR co requirements + principles ----------
foreach ($r in @('WRR-001','WRR-006','WRR-010','WRR-016','WRR-018')) {
  $block = [regex]::Match($resp, "(?ms)^  ${r}:.*?^    rules:.*$")
  if (-not $block.Success) { $errors += "W3-003: $r thieu block" }
  else {
    if ($block.Value -notmatch '(?m)^    requirements:') { $errors += "W3-003: $r thieu requirements" }
    if ($block.Value -notmatch '(?m)^    principles:') { $errors += "W3-003: $r thieu principles" }
  }
}

# ---------- W3-004: mapping ----------
$mp = Join-Path $w003 'responsibility-mapping.yaml'
if (Test-Path $mp) {
  $m = Get-Content -LiteralPath $mp -Raw -Encoding utf8
  foreach ($r in @('WRR-001','WRR-012','WRR-018')) {
    if ($m -notmatch [regex]::Escape($r)) { $errors += "W3-004: mapping thieu $r" }
  }
}

# ---------- W3-005: responsibilities.md ----------
$rm = Join-Path $w003 'responsibilities.md'
if (Test-Path $rm) {
  $mm = Get-Content -LiteralPath $rm -Raw -Encoding utf8
  foreach ($sec in @('Invariants','Delegation','Responsibilities','Machine-readable')) {
    if ($mm -notmatch [regex]::Escape("## $sec")) { $errors += "W3-005: responsibilities.md thieu section '$sec'" }
  }
}

# ---------- W4-001: W004 boundaries ----------
$w004 = Join-Path $spec2 'W004'
foreach ($f in @('boundaries.md','boundaries.yaml','boundaries.schema.json','boundary-matrix.yaml','boundary-ownership-matrix.yaml','boundary-registry.yaml','declaration-boundary.yaml','execution-boundary.yaml','state-boundary.yaml','policy-boundary.yaml')) {
  if (-not (Test-Path (Join-Path $w004 $f))) { $errors += "W4-001: missing W004/$f" }
}

# ---------- W4-002: boundaries.yaml ----------
$bw = Join-Path $w004 'boundaries.yaml'
if (Test-Path $bw) {
  $bd = Get-Content -LiteralPath $bw -Raw -Encoding utf8
  foreach ($sec in @('hierarchy','decision','invariants','validation','boundaries','mapping','metrics')) {
    if ($bd -notmatch "(?m)^${sec}:") { $errors += "W4-002: boundaries.yaml thieu '$sec'" }
  }
  foreach ($b in @('WB001-declaration','WB002-registry','WB003-validation','WB004-execution','WB005-interface','WB006-dependency','WB007-state','WB008-policy','WB009-governance')) {
    if ($bd -notmatch [regex]::Escape($b)) { $errors += "W4-002: thieu $b" }
  }
}

# ---------- W4-003: moi boundary co severity + principles ----------
foreach ($b in @('WB001-declaration','WB004-execution','WB007-state','WB009-governance')) {
  $block = [regex]::Match($bd, "(?ms)^  ${b}:.*?^    rules:.*$")
  if (-not $block.Success) { $errors += "W4-003: $b thieu block" }
  else {
    if ($block.Value -notmatch '(?m)^    severity:\s*(\w+)') { $errors += "W4-003: $b thieu severity" }
    elseif ($Matches[1] -notin @('Critical','High','Medium','Low')) { $errors += "W4-003: $b severity sai" }
    if ($block.Value -notmatch '(?m)^    principles:') { $errors += "W4-003: $b thieu principles" }
  }
}

# ---------- W4-004: mapping ----------
$mp4 = Join-Path $w004 'boundaries.yaml'
if (Test-Path $mp4) {
  $m4 = Get-Content -LiteralPath $mp4 -Raw -Encoding utf8
  if ($m4 -notmatch '(?m)^mapping:') { $errors += "W4-004: thieu mapping" }
}

# ---------- W4-005: boundaries.md ----------
$bmd = Join-Path $w004 'boundaries.md'
if (Test-Path $bmd) {
  $bm = Get-Content -LiteralPath $bmd -Raw -Encoding utf8
  foreach ($sec in @('Hierarchy','Decision','Invariants','Validation','Boundaries','Mapping','Metrics','Machine-readable')) {
    if ($bm -notmatch [regex]::Escape("## $sec")) { $errors += "W4-005: boundaries.md thieu section '$sec'" }
  }
}

# ---------- W5-001: W005 architecture ----------
$w005 = Join-Path $spec2 'W005'
foreach ($f in @('architecture.md','architecture.yaml','architecture.schema.json','layer-model.yaml','domain-model.yaml','dependency-rules.yaml','communication-rules.yaml','architecture-matrix.yaml','architecture-decision-log.yaml','architecture-registry.yaml')) {
  if (-not (Test-Path (Join-Path $w005 $f))) { $errors += "W5-001: missing W005/$f" }
}

# ---------- W5-002: architecture.yaml ----------
$aw = Join-Path $w005 'architecture.yaml'
if (Test-Path $aw) {
  $ar = Get-Content -LiteralPath $aw -Raw -Encoding utf8
  foreach ($sec in @('vision','decisions','layers','domains','dependency_rules','communication_rules','invariants','views','quality','constraints','stability','metrics','validation','mapping')) {
    if ($ar -notmatch "(?m)^${sec}:") { $errors += "W5-002: architecture thieu '$sec'" }
  }
  foreach ($l in @('Command','Declaration','Definition','Validation','Resolution','Orchestration','Publication')) {
    if ($ar -notmatch [regex]::Escape($l)) { $errors += "W5-002: thieu layer $l" }
  }
  foreach ($d in @('Definition','Validation','Execution','Coordination','Capability','Observability')) {
    if ($ar -notmatch [regex]::Escape($d)) { $errors += "W5-002: thieu domain $d" }
  }
}

# ---------- W5-003: moi layer co invariant + principle ----------
foreach ($l in @('Command','Declaration','Validation','Orchestration','Publication')) {
  $block = [regex]::Match($ar, "(?ms)^  ${l}:.*?^    principle:.*$")
  if (-not $block.Success) { $errors += "W5-003: $l thieu block" }
  else {
    if ($block.Value -notmatch '(?m)^    invariant:') { $errors += "W5-003: $l thieu invariant" }
    if ($block.Value -notmatch '(?m)^    principle:') { $errors += "W5-003: $l thieu principle" }
  }
}

# ---------- W5-004: layer-model.yaml ----------
$lm = Join-Path $w005 'layer-model.yaml'
if (Test-Path $lm) {
  $lmm = Get-Content -LiteralPath $lm -Raw -Encoding utf8
  $layerCount = ([regex]::Matches($lmm, '(?m)^  - name:')).Count
  if ($layerCount -lt 7) { $errors += "W5-004: layer-model chi co $layerCount layers (can >=7)" }
}

# ---------- W5-005: architecture.md ----------
$amd = Join-Path $w005 'architecture.md'
if (Test-Path $amd) {
  $am = Get-Content -LiteralPath $amd -Raw -Encoding utf8
  foreach ($sec in @('Architectural Decisions','Layers','Domains','Dependency Rules','Communication Rules','Invariants','Views','Quality','Constraints','Stability','Validation','Machine-readable')) {
    if ($am -notmatch [regex]::Escape("## $sec")) { $errors += "W5-005: architecture.md thieu section '$sec'" }
  }
}

# ---------- W6-001: W006 components ----------
$w006 = Join-Path $spec2 'W006'
foreach ($f in @('components.md','components.yaml','components.schema.json','component-model.yaml','component-lifecycle.yaml','component-ownership.yaml','component-contracts.yaml','component-dependencies.yaml','component-mapping.yaml','component-metrics.yaml','component-validation.yaml','component-registry.yaml')) {
  if (-not (Test-Path (Join-Path $w006 $f))) { $errors += "W6-001: missing W006/$f" }
}

# ---------- W6-002: components.yaml ----------
$cw = Join-Path $w006 'components.yaml'
if (Test-Path $cw) {
  $cp = Get-Content -LiteralPath $cw -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','component_model','groups','lifecycles','components','not_in_runtime')) {
    if ($cp -notmatch "(?m)^${sec}:") { $errors += "W6-002: components thieu '$sec'" }
  }
  foreach ($c in @('WCP-001','WCP-004','WCP-006','WCP-008')) {
    if ($cp -notmatch [regex]::Escape($c)) { $errors += "W6-002: thieu $c" }
  }
  foreach ($n in @('Workflow Engine','Definition Manager','Validation Engine','Workflow Orchestrator','Workflow Loader','Step Resolver','Workflow Registrar','Workflow Event Dispatcher')) {
    if ($cp -notmatch [regex]::Escape($n)) { $errors += "W6-002: thieu component '$n'" }
  }
}

# ---------- W6-003: moi component co layer/domain/requirements ----------
foreach ($c in @('WCP-001','WCP-004','WCP-006')) {
  $block = [regex]::Match($cp, "(?ms)^  ${c}:.*?^    principles:.*$")
  if (-not $block.Success) { $errors += "W6-003: $c thieu block" }
  else {
    if ($block.Value -notmatch '(?m)^    layer:') { $errors += "W6-003: $c thieu layer" }
    if ($block.Value -notmatch '(?m)^    domain:') { $errors += "W6-003: $c thieu domain" }
    if ($block.Value -notmatch '(?m)^    requirements:') { $errors += "W6-003: $c thieu requirements" }
  }
}

# ---------- W6-004: not_in_runtime ----------
if (Test-Path $cw) {
  $cp4 = Get-Content -LiteralPath $cw -Raw -Encoding utf8
  if ($cp4 -notmatch '(?m)^not_in_runtime:') { $errors += "W6-004: thieu not_in_runtime" }
}

# ---------- W6-005: components.md ----------
$cmd = Join-Path $w006 'components.md'
if (Test-Path $cmd) {
  $cm = Get-Content -LiteralPath $cmd -Raw -Encoding utf8
  foreach ($sec in @('Philosophy','Principles','Groups','Components','Not in Workflow Engine','Contracts','Dependencies','Lifecycles','Validation','Machine-readable')) {
    if ($cm -notmatch [regex]::Escape("## $sec")) { $errors += "W6-005: components.md thieu section '$sec'" }
  }
}

# ---------- W7-001: W007 contracts ----------
$w007 = Join-Path $spec2 'W007'
foreach ($f in @('contracts.md','contracts.yaml','contracts.schema.json','contract-model.yaml','contract-categories.yaml','contract-types.yaml','contract-compatibility.yaml','contract-mapping.yaml','contract-quality.yaml','contract-anti-patterns.yaml','communication-matrix.yaml','contract-registry.yaml')) {
  if (-not (Test-Path (Join-Path $w007 $f))) { $errors += "W7-001: missing W007/$f" }
}

# ---------- W7-002: contracts.yaml ----------
$cw7 = Join-Path $w007 'contracts.yaml'
if (Test-Path $cw7) {
  $ct = Get-Content -LiteralPath $cw7 -Raw -Encoding utf8
  if ($ct -notmatch '(?m)^contracts:') { $errors += "W7-002: contracts.yaml thieu 'contracts:'" }
  foreach ($c in @('WCT-001','WCT-002','WCT-003','WCT-004','WCT-005','WCT-006')) {
    if ($ct -notmatch [regex]::Escape($c)) { $errors += "W7-002: thieu $c" }
  }
  foreach ($n in @('Workflow Contract','Definition Contract','Validation Contract','Orchestrator Contract','Registry Contract','Event Contract')) {
    if ($ct -notmatch [regex]::Escape($n)) { $errors += "W7-002: thieu contract '$n'" }
  }
}

# ---------- W7-003: moi contract co component/principles ----------
foreach ($c in @('WCT-001','WCT-004','WCT-006')) {
  $block = [regex]::Match($ct, "(?ms)^  ${c}:.*?^    compatibility:.*$")
  if (-not $block.Success) { $errors += "W7-003: $c thieu block" }
  else {
    if ($block.Value -notmatch '(?m)^    owner:') { $errors += "W7-003: $c thieu owner" }
    if ($block.Value -notmatch '(?m)^    preconditions:') { $errors += "W7-003: $c thieu preconditions" }
    if ($block.Value -notmatch '(?m)^    invariants:') { $errors += "W7-003: $c thieu invariants" }
  }
}

# ---------- W7-004: communication-matrix ----------
$mm7 = Join-Path $w007 'communication-matrix.yaml'
if (Test-Path $mm7) {
  $m7 = Get-Content -LiteralPath $mm7 -Raw -Encoding utf8
  $edgeCount = ([regex]::Matches($m7, '(?m)^  - \[')).Count
  if ($edgeCount -lt 10) { $errors += "W7-004: communication-matrix chi co $edgeCount edges (can >=10)" }
}

# ---------- W7-005: contracts.md ----------
$cmd7 = Join-Path $w007 'contracts.md'
if (Test-Path $cmd7) {
  $cm7 = Get-Content -LiteralPath $cmd7 -Raw -Encoding utf8
  foreach ($sec in @('Contracts','Contract Quality','Anti-patterns','Communication Matrix','Machine-readable')) {
    if ($cm7 -notmatch [regex]::Escape("## $sec")) { $errors += "W7-005: contracts.md thieu section '$sec'" }
  }
}

# ---------- W8-001: appendix workflow-models ----------
$wm = Join-Path $spec2 'workflow-models'
foreach ($f in @('README.md','workflow-models.yaml','workflow-model-registry.yaml','workflow-model-relationships.yaml','workflow-model-validation.yaml','workflow-models.schema.json')) {
  if (-not (Test-Path (Join-Path $wm $f))) { $errors += "W8-001: missing workflow-models/$f" }
}
$wmYaml = Join-Path $wm 'workflow-models.yaml'
if (Test-Path $wmYaml) {
  $wmy = Get-Content -LiteralPath $wmYaml -Raw -Encoding utf8
  if ($wmy -notmatch '(?m)^aggregate_root:\s*Workflow') { $errors += "W8-001: aggregate_root phai la Workflow" }
  foreach ($m in @('WM-001','WM-002','WM-008')) {
    if ($wmy -notmatch [regex]::Escape($m)) { $errors += "W8-001: thieu model $m" }
  }
}

# ---------- W8-002: W008 data model files ----------
$w008 = Join-Path $spec2 'W008'
foreach ($f in @('data-model.md','workflow-data-model.yaml','workflow-data.schema.json','workflow-entities.yaml','workflow-identities.yaml','workflow-invariants.yaml','workflow-lifecycle.yaml','workflow-ownership.yaml','workflow-references.yaml','workflow-relations.yaml','workflow-validation.yaml')) {
  if (-not (Test-Path (Join-Path $w008 $f))) { $errors += "W8-002: missing W008/$f" }
}

# ---------- W8-003: workflow-data-model.yaml ----------
$dm8 = Join-Path $w008 'workflow-data-model.yaml'
if (Test-Path $dm8) {
  $dm = Get-Content -LiteralPath $dm8 -Raw -Encoding utf8
  foreach ($sec in @('aggregate_root','aggregate_rules','classification','invariants','consistency','dependencies')) {
    if ($dm -notmatch "(?m)^${sec}:") { $errors += "W8-003: workflow-data-model thieu '$sec'" }
  }
  if ($dm -notmatch 'Workflow') { $errors += "W8-003: aggregate_root phai la Workflow" }
}

# ---------- W8-004: entities ----------
$en8 = Join-Path $w008 'workflow-entities.yaml'
if (Test-Path $en8) {
  $en = Get-Content -LiteralPath $en8 -Raw -Encoding utf8
  $entCount = ([regex]::Matches($en, '(?m)^  ENT-W\d+:')).Count
  if ($entCount -lt 15) { $errors += "W8-004: workflow-entities chi co $entCount (can >=15)" }
  foreach ($e in @('ENT-W001','ENT-W002','ENT-W008','ENT-W014')) {
    if ($en -notmatch [regex]::Escape($e)) { $errors += "W8-004: thieu $e" }
  }
}

# ---------- W8-005: data-model.md ----------
$dmd8 = Join-Path $w008 'data-model.md'
if (Test-Path $dmd8) {
  $dm8m = Get-Content -LiteralPath $dmd8 -Raw -Encoding utf8
  for ($i = 1; $i -le 15; $i++) {
    $sec = "WF{0:D3}" -f $i
    if ($dm8m -notmatch [regex]::Escape($sec)) { $errors += "W8-005: thieu section $sec" }
  }
}

# ---------- W9-001: W009 state machine ----------
$w009 = Join-Path $spec2 'W009'
foreach ($f in @('state-machine.md','workflow-state-machine.yaml','workflow.schema.json','workflow-states.yaml','workflow-transitions.yaml','workflow-transition-guards.yaml','workflow-transition-triggers.yaml','workflow-transition-types.yaml','workflow-transition-matrix.yaml','workflow-state-events.yaml','workflow-state-history.yaml','workflow-state-metrics.yaml','workflow-state-machine-validation.yaml','workflow-state-machine-registry.yaml')) {
  if (-not (Test-Path (Join-Path $w009 $f))) { $errors += "W9-001: missing W009/$f" }
}

# ---------- W9-002: workflow-state-machine.yaml ----------
$sm9 = Join-Path $w009 'workflow-state-machine.yaml'
if (Test-Path $sm9) {
  $sm = Get-Content -LiteralPath $sm9 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','structure','categories','states','initial_state','terminal_states','run_mapping','terminal_rules','triggers','transitions')) {
    if ($sm -notmatch "(?m)^${sec}:") { $errors += "W9-002: thieu '$sec'" }
  }
  foreach ($s in @('WST-001','WST-003','WST-005','WST-006')) {
    if ($sm -notmatch [regex]::Escape($s)) { $errors += "W9-002: thieu state $s" }
  }
  if ($sm -notmatch '(?m)^initial_state:') { $errors += "W9-002: thieu initial_state" }
  if ($sm -notmatch '(?m)^terminal_states:') { $errors += "W9-002: thieu terminal_states" }
  if ($sm -notmatch '(?m)^transitions:') { $errors += "W9-002: thieu transitions" }
}

# ---------- W9-003: run_mapping sang S009 ----------
if (Test-Path $sm9) {
  $sm3 = Get-Content -LiteralPath $sm9 -Raw -Encoding utf8
  if ($sm3 -notmatch 'run_mapping') { $errors += "W9-003: thieu run_mapping (S009)" }
  foreach ($st in @('ST-001','ST-008','ST-009','ST-014')) {
    if ($sm3 -notmatch [regex]::Escape($st)) { $errors += "W9-003: run_mapping thieu $st" }
  }
}

# ---------- W9-004: transitions >= 7 ----------
if (Test-Path $sm9) {
  $sm4 = Get-Content -LiteralPath $sm9 -Raw -Encoding utf8
  $trCount = ([regex]::Matches($sm4, '(?m)^  - from:')).Count
  if ($trCount -lt 7) { $errors += "W9-004: chi co $trCount transitions (can >=7)" }
}

# ---------- W9-005: state-machine.md ----------
$smd9 = Join-Path $w009 'state-machine.md'
if (Test-Path $smd9) {
  $sm9m = Get-Content -LiteralPath $smd9 -Raw -Encoding utf8
  for ($i = 1; $i -le 17; $i++) {
    $sec = "WS{0:D3}" -f $i
    if ($sm9m -notmatch [regex]::Escape($sec)) { $errors += "W9-005: thieu section $sec" }
  }
}

# ---------- W10-001: W010 execution flow ----------
$w010 = Join-Path $spec2 'W010'
foreach ($f in @('execution-flow.md','workflow-execution-flow.yaml','workflow-execution-flow.schema.json','workflow-stages.yaml','workflow-sequential.yaml','workflow-parallel.yaml','workflow-gate.yaml','workflow-retry.yaml','workflow-timeout.yaml','workflow-compensation.yaml','workflow-failure.yaml','workflow-lineage.yaml','workflow-outcome.yaml','workflow-policies.yaml','workflow-validation.yaml')) {
  if (-not (Test-Path (Join-Path $w010 $f))) { $errors += "W10-001: missing W010/$f" }
}

# ---------- W10-002: workflow-execution-flow.yaml ----------
$ef10 = Join-Path $w010 'workflow-execution-flow.yaml'
if (Test-Path $ef10) {
  $ef = Get-Content -LiteralPath $ef10 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','stages','canonical_flow','workflow_flows','rules')) {
    if ($ef -notmatch "(?m)^${sec}:") { $errors += "W10-002: thieu '$sec'" }
  }
  foreach ($st in @('Initialize','Validate','Prepare','Execute','Coordinate','Finalize','Complete')) {
    if ($ef -notmatch [regex]::Escape($st)) { $errors += "W10-002: thieu stage $st" }
  }
}

# ---------- W10-003: canonical_flow 8 buoc ----------
if (Test-Path $ef10) {
  $ef3 = Get-Content -LiteralPath $ef10 -Raw -Encoding utf8
  foreach ($step in @('Command','Load','Validate','Normalize','Resolve Steps','Orchestrate','Finalize','Complete')) {
    if ($ef3 -notmatch [regex]::Escape($step)) { $errors += "W10-003: canonical_flow thieu $step" }
  }
}

# ---------- W10-004: workflow_flows 7 loai ----------
if (Test-Path $ef10) {
  $ef4 = Get-Content -LiteralPath $ef10 -Raw -Encoding utf8
  foreach ($fl in @('Sequential','Parallel','Gate','Retry','Timeout','Compensation','Failure')) {
    if ($ef4 -notmatch [regex]::Escape($fl)) { $errors += "W10-004: thieu flow $fl" }
  }
}

# ---------- W10-005: execution-flow.md ----------
$efmd = Join-Path $w010 'execution-flow.md'
if (Test-Path $efmd) {
  $efm = Get-Content -LiteralPath $efmd -Raw -Encoding utf8
  for ($i = 1; $i -le 19; $i++) {
    $sec = "FL{0:D3}" -f $i
    if ($efm -notmatch [regex]::Escape($sec)) { $errors += "W10-005: thieu section $sec" }
  }
}

# ---------- W11-001: W011 observability ----------
$w011 = Join-Path $spec2 'W011'
foreach ($f in @('observability.md','workflow-observability.yaml','workflow-observability.schema.json','workflow-events.yaml','workflow-metrics.yaml','workflow-traces.yaml','workflow-audit.yaml','workflow-correlation.yaml','workflow-health.yaml','workflow-dashboard.yaml','workflow-observability-mapping.yaml')) {
  if (-not (Test-Path (Join-Path $w011 $f))) { $errors += "W11-001: missing W011/$f" }
}

# ---------- W11-002: workflow-observability.yaml ----------
$ob11 = Join-Path $w011 'workflow-observability.yaml'
if (Test-Path $ob11) {
  $ob = Get-Content -LiteralPath $ob11 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','domains','boundary','correlation_model','doctor_checks','evolution_integration','machine_readable','success_criteria')) {
    if ($ob -notmatch "(?m)^${sec}:") { $errors += "W11-002: thieu '$sec'" }
  }
  foreach ($d in @('Events','Metrics','Trace','Audit','Health')) {
    if ($ob -notmatch [regex]::Escape($d)) { $warnings += "W11-002: thieu domain '$d'" }
  }
}

# ---------- W11-003: boundary ----------
if (Test-Path $ob11) {
  $ob3 = Get-Content -LiteralPath $ob11 -Raw -Encoding utf8
  if ($ob3 -notmatch '(?m)^  observes:') { $errors += "W11-003: thieu observes" }
  if ($ob3 -notmatch '(?m)^  not_observes:') { $errors += "W11-003: thieu not_observes" }
  if ($ob3 -notmatch 'Business Data') { $errors += "W11-003: thieu not_observes Business Data" }
}

# ---------- W11-004: events ----------
$ev11 = Join-Path $w011 'workflow-events.yaml'
if (Test-Path $ev11) {
  $ev = Get-Content -LiteralPath $ev11 -Raw -Encoding utf8
  foreach ($e in @('WORKFLOW_VALIDATING','WORKFLOW_PUBLISHED','WORKFLOW_REJECTED','WORKFLOW_DEPRECATED','WORKFLOW_REACTIVATED','WORKFLOW_RETIRED')) {
    if ($ev -notmatch [regex]::Escape($e)) { $errors += "W11-004: thieu event $e" }
  }
}

# ---------- W11-005: observability.md ----------
$obmd = Join-Path $w011 'observability.md'
if (Test-Path $obmd) {
  $obm = Get-Content -LiteralPath $obmd -Raw -Encoding utf8
  for ($i = 1; $i -le 16; $i++) {
    $sec = "WO{0:D3}" -f $i
    if ($obm -notmatch [regex]::Escape($sec)) { $errors += "W11-005: thieu section $sec" }
  }
  foreach ($sec in @('WO003A','WO011A')) {
    if ($obm -notmatch [regex]::Escape($sec)) { $errors += "W11-005: thieu section $sec" }
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
