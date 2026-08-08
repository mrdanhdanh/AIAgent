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

# ---------- W12-001: W012 policies ----------
$w012 = Join-Path $spec2 'W012'
foreach ($f in @('policies.md','workflow-policies.yaml','workflow-policies.schema.json','workflow-policy-model.yaml','workflow-policy-lifecycle.yaml','workflow-policy-categories.yaml','workflow-policy-resolution.yaml','workflow-policy-validation.yaml','workflow-policy-traceability.yaml','retry-binding.yaml','timeout-binding.yaml','approval-binding.yaml')) {
  if (-not (Test-Path (Join-Path $w012 $f))) { $errors += "W12-001: missing W012/$f" }
}

# ---------- W12-002: workflow-policies.yaml ----------
$pl12 = Join-Path $w012 'workflow-policies.yaml'
if (Test-Path $pl12) {
  $pl = Get-Content -LiteralPath $pl12 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','binding_model','lifecycle','categories','bindings','responsibility_chain')) {
    if ($pl -notmatch "(?m)^${sec}:") { $errors += "W12-002: thieu '$sec'" }
  }
  foreach ($b in @('WPB-001','WPB-005','WPB-010')) {
    if ($pl -notmatch [regex]::Escape($b)) { $errors += "W12-002: thieu $b" }
  }
}

# ---------- W12-003: moi binding tro den POL-* ----------
if (Test-Path $pl12) {
  $pl3 = Get-Content -LiteralPath $pl12 -Raw -Encoding utf8
  foreach ($pol in @('POL-RETRY-001','POL-TIMEOUT-001','POL-APPROVAL-001','POL-RES-001','POL-PARALLEL-001','POL-COMP-001','POL-SCHED-001','POL-ISOL-001','POL-SEC-001','POL-RESACC-001')) {
    if ($pl3 -notmatch [regex]::Escape($pol)) { $errors += "W12-003: thieu binding toi $pol" }
  }
}

# ---------- W12-004: binding model ----------
$bm12 = Join-Path $w012 'workflow-policy-model.yaml'
if (Test-Path $bm12) {
  $bm = Get-Content -LiteralPath $bm12 -Raw -Encoding utf8
  if ($bm -notmatch 'policy_ref') { $errors += "W12-004: binding model thieu policy_ref" }
  if ($bm -notmatch 'parameters') { $errors += "W12-004: binding model thieu parameters" }
  if ($bm -notmatch 'scope') { $errors += "W12-004: binding model thieu scope" }
}

# ---------- W12-005: policies.md ----------
$plmd = Join-Path $w012 'policies.md'
if (Test-Path $plmd) {
  $plm = Get-Content -LiteralPath $plmd -Raw -Encoding utf8
  for ($i = 1; $i -le 17; $i++) {
    $sec = "WP{0:D3}" -f $i
    if ($plm -notmatch [regex]::Escape($sec)) { $errors += "W12-005: thieu section $sec" }
  }
  foreach ($sec in @('WP002A','WP002B')) {
    if ($plm -notmatch [regex]::Escape($sec)) { $errors += "W12-005: thieu section $sec" }
  }
}

# ---------- W13-001: W013 governance ----------
$w013 = Join-Path $spec2 'W013'
foreach ($f in @('governance.md','workflow-governance.yaml','workflow-governance.schema.json','workflow-governance-stack.yaml','workflow-binding-enforcement.yaml','workflow-governance-matrix.yaml','workflow-governance-events.yaml','workflow-governance-decisions.yaml','workflow-governance-lifecycle.yaml','workflow-governance-metrics.yaml','workflow-governance-registry.yaml')) {
  if (-not (Test-Path (Join-Path $w013 $f))) { $errors += "W13-001: missing W013/$f" }
}

# ---------- W13-002: workflow-governance.yaml ----------
$gv13 = Join-Path $w013 'workflow-governance.yaml'
if (Test-Path $gv13) {
  $gv = Get-Content -LiteralPath $gv13 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','scope','version_governance','compatibility_governance','validation_pipeline','decisions','traceability')) {
    if ($gv -notmatch "(?m)^${sec}:") { $errors += "W13-002: thieu '$sec'" }
  }
  foreach ($e in @('Constitution (SPEC-000)','Policy Binding (W012)','Contract (W007)','Boundary (W004)','Permission (S013)','Version Compatibility')) {
    if ($gv -notmatch [regex]::Escape($e)) { $errors += "W13-002: thieu enforces '$e'" }
  }
}

# ---------- W13-003: validation_pipeline 5 buoc ----------
if (Test-Path $gv13) {
  $gv3 = Get-Content -LiteralPath $gv13 -Raw -Encoding utf8
  foreach ($step in @('Constitution','Boundary (W004)','Contract (W007)','Policy Binding (W012)','Execution (Runtime S010)')) {
    if ($gv3 -notmatch [regex]::Escape($step)) { $errors += "W13-003: pipeline thieu $step" }
  }
}

# ---------- W13-004: binding enforcement ----------
$be13 = Join-Path $w013 'workflow-binding-enforcement.yaml'
if (Test-Path $be13) {
  $be = Get-Content -LiteralPath $be13 -Raw -Encoding utf8
  if ($be -notmatch 'Resolve binding') { $errors += "W13-004: thieu resolve binding" }
  if ($be -notmatch 'Apply') { $errors += "W13-004: thieu apply" }
  if ($be -notmatch 'Audit') { $errors += "W13-004: thieu audit" }
}

# ---------- W13-005: governance.md ----------
$gvmd = Join-Path $w013 'governance.md'
if (Test-Path $gvmd) {
  $gvm = Get-Content -LiteralPath $gvmd -Raw -Encoding utf8
  for ($i = 1; $i -le 18; $i++) {
    $sec = "WG{0:D3}" -f $i
    if ($gvm -notmatch [regex]::Escape($sec)) { $errors += "W13-005: thieu section $sec" }
  }
  foreach ($sec in @('WG003A','WG005A','WG011A','WG012A','WG014A')) {
    if ($gvm -notmatch [regex]::Escape($sec)) { $errors += "W13-005: thieu section $sec" }
  }
}

# ---------- W14-001: W014 registry ----------
$w014 = Join-Path $spec2 'W014'
foreach ($f in @('registry.md','workflow-registry.yaml','workflow-registry.schema.json','workflow-registry-model.yaml','workflow-registry-domains.yaml','workflow-registry-resolution.yaml','workflow-registry-events.yaml','workflow-registry-lifecycle.yaml','workflow-registry-constraints.yaml','workflow-registry-traceability.yaml','workflow-registry-metrics.yaml','workflow-registry-validation.yaml','workflow-registry-registry.yaml')) {
  if (-not (Test-Path (Join-Path $w014 $f))) { $errors += "W14-001: missing W014/$f" }
}

# ---------- W14-002: workflow-registry.yaml ----------
$rg14 = Join-Path $w014 'workflow-registry.yaml'
if (Test-Path $rg14) {
  $rg = Get-Content -LiteralPath $rg14 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','categories','domains','entry_model','ownership','lifecycle','governance','constraints','resolution','resolution_rules','resolution_priority','resolution_failures','version_resolution','relationships','dependency','traceability','events','metrics')) {
    if ($rg -notmatch "(?m)^${sec}:") { $errors += "W14-002: thieu '$sec'" }
  }
}

# ---------- W14-003: resolution 8 buoc ----------
if (Test-Path $rg14) {
  $rg3 = Get-Content -LiteralPath $rg14 -Raw -Encoding utf8
  foreach ($step in @('Request','Normalize','Lookup','Candidate Selection','Compatibility Check','Policy Binding Check','Governance Check','Resolved')) {
    if ($rg3 -notmatch [regex]::Escape($step)) { $errors += "W14-003: resolution thieu $step" }
  }
}

# ---------- W14-004: entry_model 10 fields ----------
if (Test-Path $rg14) {
  $rg4 = Get-Content -LiteralPath $rg14 -Raw -Encoding utf8
  if ($rg4 -notmatch 'fields: \[id, type, category, version, status, owner, references, compatibility, lifecycle, metadata\]') { $errors += "W14-004: entry_model phai co 10 fields" }
}

# ---------- W14-005: registry.md ----------
$rgmd = Join-Path $w014 'registry.md'
if (Test-Path $rgmd) {
  $rgm = Get-Content -LiteralPath $rgmd -Raw -Encoding utf8
  for ($i = 1; $i -le 15; $i++) {
    $sec = "WR{0:D3}" -f $i
    if ($rgm -notmatch [regex]::Escape($sec)) { $errors += "W14-005: thieu section $sec" }
  }
  foreach ($sec in @('WR003A','WR005A','WR005B','WR008A','WR009A','WR010A')) {
    if ($rgm -notmatch [regex]::Escape($sec)) { $errors += "W14-005: thieu section $sec" }
  }
}

# ---------- W15-001: W015 resources ----------
$w015 = Join-Path $spec2 'W015'
foreach ($f in @('resources.md','workflow-resources.yaml','workflow-resources.schema.json','workflow-resource-model.yaml','workflow-resource-categories.yaml','workflow-resource-lifecycle.yaml','workflow-resource-allocation.yaml','workflow-resource-access.yaml','workflow-resource-events.yaml','workflow-resource-metrics.yaml','workflow-resource-validation.yaml')) {
  if (-not (Test-Path (Join-Path $w015 $f))) { $errors += "W15-001: missing W015/$f" }
}

# ---------- W15-002: workflow-resources.yaml ----------
$rs15 = Join-Path $w015 'workflow-resources.yaml'
if (Test-Path $rs15) {
  $rs = Get-Content -LiteralPath $rs15 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','categories','resource_model','lifecycle','allocation','access','ownership','constraints','registry_reference','traceability','events','metrics')) {
    if ($rs -notmatch "(?m)^${sec}:") { $errors += "W15-002: thieu '$sec'" }
  }
  foreach ($cat in @('Capability','Memory','Compute','Quota','Token')) {
    if ($rs -notmatch [regex]::Escape($cat)) { $warnings += "W15-002: thieu category '$cat'" }
  }
}

# ---------- W15-003: allocation qua binding ----------
if (Test-Path $rs15) {
  $rs3 = Get-Content -LiteralPath $rs15 -Raw -Encoding utf8
  if ($rs3 -notmatch 'WPB-004') { $errors += "W15-003: allocation thieu binding WPB-004 (POL-RES-001)" }
  if ($rs3 -notmatch 'WPB-010') { $errors += "W15-003: access thieu binding WPB-010 (POL-RESACC-001)" }
}

# ---------- W15-004: resource_model 10 fields ----------
if (Test-Path $rs15) {
  $rs4 = Get-Content -LiteralPath $rs15 -Raw -Encoding utf8
  if ($rs4 -notmatch 'fields: \[id, type, category, owner, status, capacity, allocated, quota, references, metadata\]') { $errors += "W15-004: resource_model phai co 10 fields" }
}

# ---------- W15-005: resources.md ----------
$rsmd = Join-Path $w015 'resources.md'
if (Test-Path $rsmd) {
  $rsm = Get-Content -LiteralPath $rsmd -Raw -Encoding utf8
  for ($i = 1; $i -le 17; $i++) {
    $sec = "WRC{0:D3}" -f $i
    if ($rsm -notmatch [regex]::Escape($sec)) { $errors += "W15-005: thieu section $sec" }
  }
}

# ---------- W16-001: W016 compliance ----------
$w016 = Join-Path $spec2 'W016'
foreach ($f in @('compliance.md','workflow-compliance.yaml','workflow-compliance.schema.json','workflow-validation-rules.yaml','workflow-compliance-matrix.yaml','workflow-health-score.yaml','workflow-readiness-checklist.yaml','workflow-certification.yaml','workflow-compliance-events.yaml','workflow-compliance-metrics.yaml','workflow-compliance-report.yaml')) {
  if (-not (Test-Path (Join-Path $w016 $f))) { $errors += "W16-001: missing W016/$f" }
}

# ---------- W16-002: workflow-compliance.yaml ----------
$cm16 = Join-Path $w016 'workflow-compliance.yaml'
if (Test-Path $cm16) {
  $cm = Get-Content -LiteralPath $cm16 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','scope','validation_rules','health_score','readiness_checklist','certification','pipeline','events','metrics')) {
    if ($cm -notmatch "(?m)^${sec}:") { $errors += "W16-002: thieu '$sec'" }
  }
  foreach ($v in @('Constitution (SPEC-000)','Boundary (W004)','Contract (W007)','Policy Binding (W012)','Governance (W013)','Registry (W014)','Resources (W015)','Observability (W011)')) {
    if ($cm -notmatch [regex]::Escape($v)) { $errors += "W16-002: thieu verifies '$v'" }
  }
}

# ---------- W16-003: validation_rules 12 ----------
if (Test-Path $cm16) {
  $cm3 = Get-Content -LiteralPath $cm16 -Raw -Encoding utf8
  $ruleCount = ([regex]::Matches($cm3, '(?m)^  - ')).Count
  if ($ruleCount -lt 12) { $errors += "W16-003: validation_rules chi co $ruleCount (can >=12)" }
}

# ---------- W16-004: certification ----------
if (Test-Path $cm16) {
  $cm4 = Get-Content -LiteralPath $cm16 -Raw -Encoding utf8
  if ($cm4 -notmatch 'Not Certified') { $errors += "W16-004: certification thieu Not Certified" }
  if ($cm4 -notmatch '100% validation rules Pass') { $errors += "W16-004: certification thieu 100% Pass" }
}

# ---------- W16-005: compliance.md ----------
$cmmd = Join-Path $w016 'compliance.md'
if (Test-Path $cmmd) {
  $cmm = Get-Content -LiteralPath $cmmd -Raw -Encoding utf8
  for ($i = 1; $i -le 16; $i++) {
    $sec = "WMC{0:D3}" -f $i
    if ($cmm -notmatch [regex]::Escape($sec)) { $errors += "W16-005: thieu section $sec" }
  }
}

# ---------- W17-001: W017 extensions ----------
$w017 = Join-Path $spec2 'W017'
foreach ($f in @('extensions.md','workflow-extensions.yaml','workflow-extensions.schema.json','workflow-extension-model.yaml','workflow-extension-categories.yaml','workflow-extension-lifecycle.yaml','workflow-extension-installation.yaml','workflow-extension-isolation.yaml','workflow-extension-events.yaml','workflow-extension-metrics.yaml','workflow-extension-validation.yaml')) {
  if (-not (Test-Path (Join-Path $w017 $f))) { $errors += "W17-001: missing W017/$f" }
}

# ---------- W17-002: workflow-extensions.yaml ----------
$ex17 = Join-Path $w017 'workflow-extensions.yaml'
if (Test-Path $ex17) {
  $ex = Get-Content -LiteralPath $ex17 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','categories','extension_model','lifecycle','installation','activation_rules','isolation','security','resources','compatibility','events','metrics')) {
    if ($ex -notmatch "(?m)^${sec}:") { $errors += "W17-002: thieu '$sec'" }
  }
  foreach ($cat in @('Step Extension','Gate Extension','Condition Extension','Formatter Extension','Binding Extension')) {
    if ($ex -notmatch [regex]::Escape($cat)) { $errors += "W17-002: thieu category '$cat'" }
  }
}

# ---------- W17-003: activation 4 dieu kien ----------
if (Test-Path $ex17) {
  $ex3 = Get-Content -LiteralPath $ex17 -Raw -Encoding utf8
  if ($ex3 -notmatch 'Contract hop le') { $errors += "W17-003: activation thieu Contract hop le" }
  if ($ex3 -notmatch 'Governance allow') { $errors += "W17-003: activation thieu Governance allow" }
  if ($ex3 -notmatch 'Isolation dam bao') { $errors += "W17-003: activation thieu Isolation" }
}

# ---------- W17-004: isolation ----------
if (Test-Path $ex17) {
  $ex4 = Get-Content -LiteralPath $ex17 -Raw -Encoding utf8
  if ($ex4 -notmatch 'Agent Internal State') { $errors += "W17-004: isolation thieu Agent Internal State" }
  if ($ex4 -notmatch 'qua Contract') { $errors += "W17-004: isolation thieu goi qua Contract" }
}

# ---------- W17-005: extensions.md ----------
$exmd = Join-Path $w017 'extensions.md'
if (Test-Path $exmd) {
  $exm = Get-Content -LiteralPath $exmd -Raw -Encoding utf8
  for ($i = 1; $i -le 17; $i++) {
    $sec = "WXE{0:D3}" -f $i
    if ($exm -notmatch [regex]::Escape($sec)) { $errors += "W17-005: thieu section $sec" }
  }
}

# ---------- W18-001: W018 evolution ----------
$w018 = Join-Path $spec2 'W018'
foreach ($f in @('evolution.md','workflow-evolution.yaml','workflow-evolution.schema.json','workflow-evolution-scope.yaml','workflow-evolution-pipeline.yaml','workflow-evolution-proposal.yaml','workflow-evolution-approval.yaml','workflow-evolution-events.yaml','workflow-evolution-metrics.yaml','workflow-evolution-validation.yaml')) {
  if (-not (Test-Path (Join-Path $w018 $f))) { $errors += "W18-001: missing W018/$f" }
}

# ---------- W18-002: workflow-evolution.yaml ----------
$ev18 = Join-Path $w018 'workflow-evolution.yaml'
if (Test-Path $ev18) {
  $ev = Get-Content -LiteralPath $ev18 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','scope','pipeline','proposal_model','proposal_status','approval','safety','application','traceability','events','metrics')) {
    if ($ev -notmatch "(?m)^${sec}:") { $errors += "W18-002: thieu '$sec'" }
  }
  foreach ($r in @('Workflow Event (W011)','Workflow Metrics (W011)','Workflow Trace (W011)','Workflow Audit (W011)','Compliance Report (W016)','Registry (W014)')) {
    if ($ev -notmatch [regex]::Escape($r)) { $warnings += "W18-002: thieu reads '$r'" }
  }
}

# ---------- W18-003: pipeline 6 buoc ----------
if (Test-Path $ev18) {
  $ev3 = Get-Content -LiteralPath $ev18 -Raw -Encoding utf8
  foreach ($step in @('Collect','Analyze','Learn','Propose','Approval Gate','Apply')) {
    if ($ev3 -notmatch [regex]::Escape($step)) { $errors += "W18-003: pipeline thieu $step" }
  }
}

# ---------- W18-004: approval 4 muc ----------
if (Test-Path $ev18) {
  $ev4 = Get-Content -LiteralPath $ev18 -Raw -Encoding utf8
  if ($ev4 -notmatch 'auto-approve') { $errors += "W18-004: approval thieu auto-approve" }
  if ($ev4 -notmatch 'Human approval bat buoc') { $errors += "W18-004: approval thieu Human bat buoc" }
}

# ---------- W18-005: evolution.md ----------
$evmd = Join-Path $w018 'evolution.md'
if (Test-Path $evmd) {
  $evm = Get-Content -LiteralPath $evmd -Raw -Encoding utf8
  for ($i = 1; $i -le 16; $i++) {
    $sec = "WVE{0:D3}" -f $i
    if ($evm -notmatch [regex]::Escape($sec)) { $errors += "W18-005: thieu section $sec" }
  }
}

# ---------- W19-001: W019 doctor ----------
$w019 = Join-Path $spec2 'W019'
foreach ($f in @('doctor.md','workflow-doctor.yaml','workflow-doctor.schema.json','workflow-doctor-scope.yaml','workflow-doctor-checks.yaml','workflow-doctor-pipeline.yaml','workflow-doctor-self-repair.yaml','workflow-doctor-report.yaml','workflow-doctor-events.yaml','workflow-doctor-metrics.yaml','workflow-doctor-validation.yaml')) {
  if (-not (Test-Path (Join-Path $w019 $f))) { $errors += "W19-001: missing W019/$f" }
}

# ---------- W19-002: workflow-doctor.yaml ----------
$dr19 = Join-Path $w019 'workflow-doctor.yaml'
if (Test-Path $dr19) {
  $dr = Get-Content -LiteralPath $dr19 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','scope','check_sources','health_score','pipeline','self_repair','report','events','metrics','traceability')) {
    if ($dr -notmatch "(?m)^${sec}:") { $errors += "W19-002: thieu '$sec'" }
  }
  foreach ($d in @('Constitution (SPEC-000)','Contracts (W007)','Policy Binding (W012)','Governance (W013)','Registry (W014)','Resources (W015)','Compliance (W016)','Extensions (W017)','Observability (W011)')) {
    if ($dr -notmatch [regex]::Escape($d)) { $errors += "W19-002: thieu domain '$d'" }
  }
}

# ---------- W19-003: check_sources 7 nguon ----------
if (Test-Path $dr19) {
  $dr3 = Get-Content -LiteralPath $dr19 -Raw -Encoding utf8
  $srcCount = ([regex]::Matches($dr3, '(?m)^  - W\d{3} ')).Count
  if ($srcCount -lt 7) { $errors += "W19-003: check_sources chi co $srcCount (can >=7)" }
}

# ---------- W19-004: self_repair ----------
if (Test-Path $dr19) {
  $dr4 = Get-Content -LiteralPath $dr19 -Raw -Encoding utf8
  if ($dr4 -notmatch 'Chi Low impact') { $errors += "W19-004: self_repair thieu Low impact" }
  if ($dr4 -notmatch 'Khong sua implementation') { $errors += "W19-004: self_repair thieu khong sua implementation" }
}

# ---------- W19-005: doctor.md ----------
$drmd = Join-Path $w019 'doctor.md'
if (Test-Path $drmd) {
  $drm = Get-Content -LiteralPath $drmd -Raw -Encoding utf8
  for ($i = 1; $i -le 16; $i++) {
    $sec = "WDR{0:D3}" -f $i
    if ($drm -notmatch [regex]::Escape($sec)) { $errors += "W19-005: thieu section $sec" }
  }
}

# ---------- W20-001: W020 dashboard ----------
$w020 = Join-Path $spec2 'W020'
foreach ($f in @('dashboard.md','workflow-dashboard.yaml','workflow-dashboard.schema.json','workflow-dashboard-scope.yaml','workflow-dashboard-views.yaml','workflow-dashboard-read-model.yaml','workflow-dashboard-refresh.yaml','workflow-dashboard-events.yaml','workflow-dashboard-metrics.yaml','workflow-dashboard-validation.yaml')) {
  if (-not (Test-Path (Join-Path $w020 $f))) { $errors += "W20-001: missing W020/$f" }
}

# ---------- W20-002: workflow-dashboard.yaml ----------
$db20 = Join-Path $w020 'workflow-dashboard.yaml'
if (Test-Path $db20) {
  $db = Get-Content -LiteralPath $db20 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','scope','views','read_model','refresh','events','metrics')) {
    if ($db -notmatch "(?m)^${sec}:") { $errors += "W20-002: thieu '$sec'" }
  }
  foreach ($r in @('Workflow Events (W011)','Workflow Metrics (W011)','Workflow Trace (W011)','Workflow Audit (W011)','Health (W011)','Registry (W014)','Governance (W013)','Compliance (W016)','Doctor (W019)')) {
    if ($db -notmatch [regex]::Escape($r)) { $warnings += "W20-002: thieu reads '$r'" }
  }
}

# ---------- W20-003: views 7 ----------
if (Test-Path $db20) {
  $db3 = Get-Content -LiteralPath $db20 -Raw -Encoding utf8
  foreach ($v in @('Workflow View','Definition View','Registry View','Governance View','Resource View','Health View','Compliance + Doctor View')) {
    if ($db3 -notmatch [regex]::Escape($v)) { $errors += "W20-003: thieu view '$v'" }
  }
}

# ---------- W20-004: refresh event-driven ----------
if (Test-Path $db20) {
  $db4 = Get-Content -LiteralPath $db20 -Raw -Encoding utf8
  if ($db4 -notmatch 'Event Driven') { $errors += "W20-004: refresh thieu Event Driven" }
  if ($db4 -notmatch 'Khong polling') { $errors += "W20-004: refresh thieu khong polling" }
}

# ---------- W20-005: dashboard.md ----------
$dbmd = Join-Path $w020 'dashboard.md'
if (Test-Path $dbmd) {
  $dbm = Get-Content -LiteralPath $dbmd -Raw -Encoding utf8
  for ($i = 1; $i -le 16; $i++) {
    $sec = "WDB{0:D3}" -f $i
    if ($dbm -notmatch [regex]::Escape($sec)) { $errors += "W20-005: thieu section $sec" }
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
