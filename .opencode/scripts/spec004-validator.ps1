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

# ---------- A2-001: A002 requirements files ----------
$a002 = Join-Path $spec4 'A002'
foreach ($f in @('requirements.md','requirements.yaml','requirements.schema.json','requirement-categories.yaml','requirement-lifecycle.yaml','requirement-priority.yaml','requirement-traceability.yaml','requirement-metrics.yaml','requirements-index.yaml','CHANGELOG.md')) {
  if (-not (Test-Path (Join-Path $a002 $f))) { $errors += "A2-001: missing A002/$f" }
}

# ---------- A2-002: requirements.yaml - FR/NFR/constraints/acceptance ----------
$rt2 = Join-Path $a002 'requirements.yaml'
if (Test-Path $rt2) {
  $r2 = Get-Content -LiteralPath $rt2 -Raw -Encoding utf8
  foreach ($sec in @('functional','non_functional','constraints','assumptions','dependencies','external_interfaces','quality_attributes','acceptance')) {
    if ($r2 -notmatch "(?m)^${sec}:") { $errors += "A2-002: requirements.yaml thieu '$sec'" }
  }
  foreach ($fr in @('AFR-001','AFR-002','AFR-003','AFR-004','AFR-006','AFR-016')) {
    if ($r2 -notmatch [regex]::Escape($fr)) { $errors += "A2-002: thieu $fr" }
  }
  foreach ($nfr in @('ANFR-001','ANFR-002','ANFR-003','ANFR-010')) {
    if ($r2 -notmatch [regex]::Escape($nfr)) { $errors += "A2-002: thieu $nfr" }
  }
  foreach ($c in @('AC-001','AC-002','AC-003')) {
    if ($r2 -notmatch [regex]::Escape($c)) { $errors += "A2-002: thieu $c" }
  }
  foreach ($ar in @('AAR-001','AAR-002','AAR-006')) {
    if ($r2 -notmatch [regex]::Escape($ar)) { $errors += "A2-002: thieu $ar" }
  }
}

# ---------- A2-003: traceability - moi req co principle ----------
$tr2 = Join-Path $a002 'requirement-traceability.yaml'
if (Test-Path $tr2) {
  $tb2 = Get-Content -LiteralPath $tr2 -Raw -Encoding utf8
  foreach ($id in @('AFR-001','AFR-016','ANFR-001','ANFR-012')) {
    $block = [regex]::Match($tb2, "(?m)^\s*${id}:\s*(\[.*\])")
    if (-not $block.Success) { $errors += "A2-003: $id thieu principles trong traceability" }
    elseif ([string]::IsNullOrWhiteSpace($block.Groups[1].Value)) { $errors += "A2-003: $id khong co principle nao" }
  }
}

# ---------- A2-004: priority ----------
$pr2 = Join-Path $a002 'requirement-priority.yaml'
if (Test-Path $pr2) {
  $pp2 = Get-Content -LiteralPath $pr2 -Raw -Encoding utf8
  foreach ($p in @('Critical','High','Medium')) {
    if ($pp2 -notmatch [regex]::Escape($p)) { $warnings += "A2-004: priority thieu $p" }
  }
}

# ---------- A2-005: requirements.md - sections ----------
$rm2 = Join-Path $a002 'requirements.md'
if (Test-Path $rm2) {
  $m2 = Get-Content -LiteralPath $rm2 -Raw -Encoding utf8
  foreach ($sec in @('Functional Requirements','Non-Functional Requirements','Constraints','Assumptions','Quality Attributes','Acceptance Criteria','Machine-readable')) {
    if ($m2 -notmatch [regex]::Escape("## $sec")) { $errors += "A2-005: requirements.md thieu section '$sec'" }
  }
}

# ---------- A3-001: A003 responsibilities ----------
$a003 = Join-Path $spec4 'A003'
foreach ($f in @('responsibilities.md','responsibilities.yaml','responsibilities.schema.json','ownership.yaml','responsibility-mapping.yaml','responsibility-matrix.yaml','responsibility-registry.yaml')) {
  if (-not (Test-Path (Join-Path $a003 $f))) { $errors += "A3-001: missing A003/$f" }
}

# ---------- A3-002: responsibilities.yaml ----------
$rw3 = Join-Path $a003 'responsibilities.yaml'
if (Test-Path $rw3) {
  $resp3 = Get-Content -LiteralPath $rw3 -Raw -Encoding utf8
  if ($resp3 -notmatch '(?m)^responsibilities:') { $errors += "A3-002: responsibilities.yaml thieu 'responsibilities:'" }
  foreach ($r in @('ARR-001','ARR-002','ARR-005','ARR-006','ARR-010','ARR-017')) {
    if ($resp3 -notmatch [regex]::Escape($r)) { $errors += "A3-002: thieu $r" }
  }
  foreach ($field in @('name','group','owner','authority','input','output','metric','requirements','principles')) {
    if ($resp3 -notmatch "(?m)^    ${field}:") { $warnings += "A3-002: responsibilities.yaml thieu field '$field'" }
  }
}

# ---------- A3-003: moi ARR co requirements + principles ----------
foreach ($r in @('ARR-001','ARR-005','ARR-010','ARR-012','ARR-018')) {
  $block = [regex]::Match($resp3, "(?ms)^  ${r}:.*?^    rules:.*$")
  if (-not $block.Success) { $errors += "A3-003: $r thieu block" }
  else {
    if ($block.Value -notmatch '(?m)^    requirements:') { $errors += "A3-003: $r thieu requirements" }
    if ($block.Value -notmatch '(?m)^    principles:') { $errors += "A3-003: $r thieu principles" }
  }
}

# ---------- A3-004: mapping ----------
$mp3 = Join-Path $a003 'responsibility-mapping.yaml'
if (Test-Path $mp3) {
  $m3 = Get-Content -LiteralPath $mp3 -Raw -Encoding utf8
  foreach ($r in @('ARR-001','ARR-016','ARR-018')) {
    if ($m3 -notmatch [regex]::Escape($r)) { $errors += "A3-004: mapping thieu $r" }
  }
}

# ---------- A3-005: responsibilities.md ----------
$rm3 = Join-Path $a003 'responsibilities.md'
if (Test-Path $rm3) {
  $mm3 = Get-Content -LiteralPath $rm3 -Raw -Encoding utf8
  foreach ($sec in @('Invariants','Delegation','Responsibilities','Machine-readable')) {
    if ($mm3 -notmatch [regex]::Escape("## $sec")) { $errors += "A3-005: responsibilities.md thieu section '$sec'" }
  }
}

# ---------- A4-001: A004 boundaries ----------
$a004 = Join-Path $spec4 'A004'
foreach ($f in @('boundaries.md','boundaries.yaml','boundaries.schema.json','boundary-matrix.yaml','boundary-ownership-matrix.yaml','boundary-registry.yaml','declaration-boundary.yaml','execution-boundary.yaml','capability-boundary.yaml','policy-boundary.yaml')) {
  if (-not (Test-Path (Join-Path $a004 $f))) { $errors += "A4-001: missing A004/$f" }
}

# ---------- A4-002: boundaries.yaml ----------
$bw4 = Join-Path $a004 'boundaries.yaml'
if (Test-Path $bw4) {
  $bd4 = Get-Content -LiteralPath $bw4 -Raw -Encoding utf8
  foreach ($sec in @('hierarchy','decision','invariants','validation','boundaries','mapping','metrics')) {
    if ($bd4 -notmatch "(?m)^${sec}:") { $errors += "A4-002: boundaries.yaml thieu '$sec'" }
  }
  foreach ($b in @('AB001-declaration','AB002-registry','AB003-validation','AB004-execution','AB005-interface','AB006-dependency','AB007-capability','AB008-policy','AB009-governance')) {
    if ($bd4 -notmatch [regex]::Escape($b)) { $errors += "A4-002: thieu $b" }
  }
}

# ---------- A4-003: moi boundary co severity + principles ----------
foreach ($b in @('AB001-declaration','AB004-execution','AB007-capability','AB009-governance')) {
  $block = [regex]::Match($bd4, "(?ms)^  ${b}:.*?^    rules:.*$")
  if (-not $block.Success) { $errors += "A4-003: $b thieu block" }
  else {
    if ($block.Value -notmatch '(?m)^    severity:\s*(\w+)') { $errors += "A4-003: $b thieu severity" }
    elseif ($Matches[1] -notin @('Critical','High','Medium','Low')) { $errors += "A4-003: $b severity sai" }
    if ($block.Value -notmatch '(?m)^    principles:') { $errors += "A4-003: $b thieu principles" }
  }
}

# ---------- A4-004: mapping ----------
$mp4b = Join-Path $a004 'boundaries.yaml'
if (Test-Path $mp4b) {
  $m4b = Get-Content -LiteralPath $mp4b -Raw -Encoding utf8
  if ($m4b -notmatch '(?m)^mapping:') { $errors += "A4-004: thieu mapping" }
}

# ---------- A4-005: boundaries.md ----------
$bmd4 = Join-Path $a004 'boundaries.md'
if (Test-Path $bmd4) {
  $bm4 = Get-Content -LiteralPath $bmd4 -Raw -Encoding utf8
  foreach ($sec in @('Hierarchy','Decision','Invariants','Validation','Boundaries','Mapping','Metrics','Machine-readable')) {
    if ($bm4 -notmatch [regex]::Escape("## $sec")) { $errors += "A4-005: boundaries.md thieu section '$sec'" }
  }
}

# ---------- A5-001: A005 architecture ----------
$a005 = Join-Path $spec4 'A005'
foreach ($f in @('architecture.md','architecture.yaml','architecture.schema.json','layer-model.yaml','domain-model.yaml','dependency-rules.yaml','communication-rules.yaml','architecture-matrix.yaml','architecture-decision-log.yaml','architecture-registry.yaml')) {
  if (-not (Test-Path (Join-Path $a005 $f))) { $errors += "A5-001: missing A005/$f" }
}

# ---------- A5-002: architecture.yaml ----------
$aw5 = Join-Path $a005 'architecture.yaml'
if (Test-Path $aw5) {
  $ar5 = Get-Content -LiteralPath $aw5 -Raw -Encoding utf8
  foreach ($sec in @('vision','decisions','layers','domains','dependency_rules','communication_rules','invariants','views','quality','constraints','stability','metrics','validation','mapping')) {
    if ($ar5 -notmatch "(?m)^${sec}:") { $errors += "A5-002: architecture thieu '$sec'" }
  }
  foreach ($l in @('Command','Declaration','Definition','Validation','Registration','Orchestration','Publication')) {
    if ($ar5 -notmatch [regex]::Escape($l)) { $errors += "A5-002: thieu layer $l" }
  }
  foreach ($d in @('Definition','Validation','Mapping','Orchestration','Execution','Observability')) {
    if ($ar5 -notmatch [regex]::Escape($d)) { $errors += "A5-002: thieu domain $d" }
  }
}

# ---------- A5-003: moi layer co invariant + principle ----------
foreach ($l in @('Command','Declaration','Validation','Registration','Orchestration','Publication')) {
  $block = [regex]::Match($ar5, "(?ms)^  ${l}:.*?^    principle:.*$")
  if (-not $block.Success) { $errors += "A5-003: $l thieu block" }
  else {
    if ($block.Value -notmatch '(?m)^    invariant:') { $errors += "A5-003: $l thieu invariant" }
    if ($block.Value -notmatch '(?m)^    principle:') { $errors += "A5-003: $l thieu principle" }
  }
}

# ---------- A5-004: layer-model.yaml ----------
$lm5 = Join-Path $a005 'layer-model.yaml'
if (Test-Path $lm5) {
  $lmm5 = Get-Content -LiteralPath $lm5 -Raw -Encoding utf8
  $layerCount5 = ([regex]::Matches($lmm5, '(?m)^  - name:')).Count
  if ($layerCount5 -lt 7) { $errors += "A5-004: layer-model chi co $layerCount5 layers (can >=7)" }
}

# ---------- A5-005: architecture.md ----------
$amd5 = Join-Path $a005 'architecture.md'
if (Test-Path $amd5) {
  $am5 = Get-Content -LiteralPath $amd5 -Raw -Encoding utf8
  foreach ($sec in @('Architectural Decisions','Layers','Domains','Dependency Rules','Communication Rules','Invariants','Views','Quality','Constraints','Stability','Validation','Machine-readable')) {
    if ($am5 -notmatch [regex]::Escape("## $sec")) { $errors += "A5-005: architecture.md thieu section '$sec'" }
  }
}

# ---------- A6-001: A006 components ----------
$a006 = Join-Path $spec4 'A006'
foreach ($f in @('components.md','components.yaml','components.schema.json','component-model.yaml','component-lifecycle.yaml','component-ownership.yaml','component-contracts.yaml','component-dependencies.yaml','component-mapping.yaml','component-metrics.yaml','component-validation.yaml','component-registry.yaml')) {
  if (-not (Test-Path (Join-Path $a006 $f))) { $errors += "A6-001: missing A006/$f" }
}

# ---------- A6-002: components.yaml ----------
$cw6 = Join-Path $a006 'components.yaml'
if (Test-Path $cw6) {
  $cp6 = Get-Content -LiteralPath $cw6 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','component_model','groups','lifecycles','components','not_in_runtime')) {
    if ($cp6 -notmatch "(?m)^${sec}:") { $errors += "A6-002: components thieu '$sec'" }
  }
  foreach ($c in @('ACP-001','ACP-004','ACP-005','ACP-008')) {
    if ($cp6 -notmatch [regex]::Escape($c)) { $errors += "A6-002: thieu $c" }
  }
  foreach ($n in @('Agent Engine','Declaration Manager','Validation Engine','Registration Manager','Orchestration Provider','Discovery Provider','Binding Registrar','Agent Event Dispatcher')) {
    if ($cp6 -notmatch [regex]::Escape($n)) { $errors += "A6-002: thieu component '$n'" }
  }
}

# ---------- A6-003: moi component co layer/domain/requirements ----------
foreach ($c in @('ACP-001','ACP-004','ACP-005')) {
  $block = [regex]::Match($cp6, "(?ms)^  ${c}:.*?^    principles:.*$")
  if (-not $block.Success) { $errors += "A6-003: $c thieu block" }
  else {
    if ($block.Value -notmatch '(?m)^    layer:') { $errors += "A6-003: $c thieu layer" }
    if ($block.Value -notmatch '(?m)^    domain:') { $errors += "A6-003: $c thieu domain" }
    if ($block.Value -notmatch '(?m)^    requirements:') { $errors += "A6-003: $c thieu requirements" }
  }
}

# ---------- A6-004: not_in_runtime ----------
if (Test-Path $cw6) {
  $cp6b = Get-Content -LiteralPath $cw6 -Raw -Encoding utf8
  if ($cp6b -notmatch '(?m)^not_in_runtime:') { $errors += "A6-004: thieu not_in_runtime" }
}

# ---------- A6-005: components.md ----------
$cmd6 = Join-Path $a006 'components.md'
if (Test-Path $cmd6) {
  $cm6 = Get-Content -LiteralPath $cmd6 -Raw -Encoding utf8
  foreach ($sec in @('Philosophy','Principles','Groups','Components','Not in Agent System','Contracts','Dependencies','Lifecycles','Validation','Machine-readable')) {
    if ($cm6 -notmatch [regex]::Escape("## $sec")) { $errors += "A6-005: components.md thieu section '$sec'" }
  }
}

# ---------- A7-001: A007 contracts ----------
$a007 = Join-Path $spec4 'A007'
foreach ($f in @('contracts.md','contracts.yaml','contracts.schema.json','contract-model.yaml','contract-categories.yaml','contract-types.yaml','contract-compatibility.yaml','contract-mapping.yaml','contract-quality.yaml','contract-anti-patterns.yaml','communication-matrix.yaml','contract-registry.yaml')) {
  if (-not (Test-Path (Join-Path $a007 $f))) { $errors += "A7-001: missing A007/$f" }
}

# ---------- A7-002: contracts.yaml ----------
$cw7 = Join-Path $a007 'contracts.yaml'
if (Test-Path $cw7) {
  $ct7 = Get-Content -LiteralPath $cw7 -Raw -Encoding utf8
  if ($ct7 -notmatch '(?m)^contracts:') { $errors += "A7-002: contracts.yaml thieu 'contracts:'" }
  foreach ($c in @('ACT-001','ACT-002','ACT-003','ACT-004','ACT-005','ACT-006','ACT-007')) {
    if ($ct7 -notmatch [regex]::Escape($c)) { $errors += "A7-002: thieu $c" }
  }
  foreach ($n in @('Agent Contract','Declaration Contract','Validation Contract','Registration Contract','Orchestration Contract','Registry Contract','Event Contract')) {
    if ($ct7 -notmatch [regex]::Escape($n)) { $errors += "A7-002: thieu contract '$n'" }
  }
}

# ---------- A7-003: moi contract co owner/preconditions/invariants ----------
foreach ($c in @('ACT-001','ACT-004','ACT-005','ACT-007')) {
  $block = [regex]::Match($ct7, "(?ms)^  ${c}:.*?^    compatibility:.*$")
  if (-not $block.Success) { $errors += "A7-003: $c thieu block" }
  else {
    if ($block.Value -notmatch '(?m)^    owner:') { $errors += "A7-003: $c thieu owner" }
    if ($block.Value -notmatch '(?m)^    preconditions:') { $errors += "A7-003: $c thieu preconditions" }
    if ($block.Value -notmatch '(?m)^    invariants:') { $errors += "A7-003: $c thieu invariants" }
  }
}

# ---------- A7-004: communication-matrix ----------
$mm7 = Join-Path $a007 'communication-matrix.yaml'
if (Test-Path $mm7) {
  $m7c = Get-Content -LiteralPath $mm7 -Raw -Encoding utf8
  $edgeCount7 = ([regex]::Matches($m7c, '(?m)^  - \[')).Count
  if ($edgeCount7 -lt 11) { $errors += "A7-004: communication-matrix chi co $edgeCount7 edges (can >=11)" }
}

# ---------- A7-005: contracts.md ----------
$cmd7 = Join-Path $a007 'contracts.md'
if (Test-Path $cmd7) {
  $cm7c = Get-Content -LiteralPath $cmd7 -Raw -Encoding utf8
  foreach ($sec in @('Contracts','Contract Quality','Anti-patterns','Communication Matrix','Machine-readable')) {
    if ($cm7c -notmatch [regex]::Escape("## $sec")) { $errors += "A7-005: contracts.md thieu section '$sec'" }
  }
}

# ---------- A8-001: appendix agent-models ----------
$am8 = Join-Path $spec4 'agent-models'
foreach ($f in @('README.md','agent-models.yaml','agent-model-registry.yaml','agent-model-relationships.yaml','agent-model-validation.yaml','agent-models.schema.json')) {
  if (-not (Test-Path (Join-Path $am8 $f))) { $errors += "A8-001: missing agent-models/$f" }
}
$amYaml = Join-Path $am8 'agent-models.yaml'
if (Test-Path $amYaml) {
  $amy = Get-Content -LiteralPath $amYaml -Raw -Encoding utf8
  if ($amy -notmatch '(?m)^aggregate_root:\s*Agent') { $errors += "A8-001: aggregate_root phai la Agent" }
  foreach ($m in @('AM-001','AM-002','AM-004','AM-008')) {
    if ($amy -notmatch [regex]::Escape($m)) { $errors += "A8-001: thieu model $m" }
  }
}

# ---------- A8-002: A008 data model files ----------
$a008 = Join-Path $spec4 'A008'
foreach ($f in @('data-model.md','agent-data-model.yaml','agent-data.schema.json','agent-entities.yaml','agent-identities.yaml','agent-invariants.yaml','agent-lifecycle.yaml','agent-ownership.yaml','agent-references.yaml','agent-relations.yaml','agent-validation.yaml')) {
  if (-not (Test-Path (Join-Path $a008 $f))) { $errors += "A8-002: missing A008/$f" }
}

# ---------- A8-003: agent-data-model.yaml ----------
$dm8 = Join-Path $a008 'agent-data-model.yaml'
if (Test-Path $dm8) {
  $dm = Get-Content -LiteralPath $dm8 -Raw -Encoding utf8
  foreach ($sec in @('aggregate_root','aggregate_rules','classification','invariants','consistency','dependencies')) {
    if ($dm -notmatch "(?m)^${sec}:") { $errors += "A8-003: agent-data-model thieu '$sec'" }
  }
  if ($dm -notmatch 'Agent') { $errors += "A8-003: aggregate_root phai la Agent" }
}

# ---------- A8-004: entities ----------
$en8 = Join-Path $a008 'agent-entities.yaml'
if (Test-Path $en8) {
  $en = Get-Content -LiteralPath $en8 -Raw -Encoding utf8
  $entCount = ([regex]::Matches($en, '(?m)^  ENT-A\d+:')).Count
  if ($entCount -lt 15) { $errors += "A8-004: agent-entities chi co $entCount (can >=15)" }
  foreach ($e in @('ENT-A001','ENT-A002','ENT-A008','ENT-A014')) {
    if ($en -notmatch [regex]::Escape($e)) { $errors += "A8-004: thieu $e" }
  }
}

# ---------- A8-005: data-model.md ----------
$dmd8 = Join-Path $a008 'data-model.md'
if (Test-Path $dmd8) {
  $dm8m = Get-Content -LiteralPath $dmd8 -Raw -Encoding utf8
  for ($i = 1; $i -le 15; $i++) {
    $sec = "ADM{0:D3}" -f $i
    if ($dm8m -notmatch [regex]::Escape($sec)) { $errors += "A8-005: thieu section $sec" }
  }
}

# ---------- A9-001: A009 state machine ----------
$a009 = Join-Path $spec4 'A009'
foreach ($f in @('state-machine.md','agent-state-machine.yaml','agent.schema.json','agent-states.yaml','agent-transitions.yaml','agent-transition-guards.yaml','agent-transition-triggers.yaml','agent-transition-types.yaml','agent-transition-matrix.yaml','agent-state-events.yaml','agent-state-history.yaml','agent-state-metrics.yaml','agent-state-machine-validation.yaml','agent-state-machine-registry.yaml')) {
  if (-not (Test-Path (Join-Path $a009 $f))) { $errors += "A9-001: missing A009/$f" }
}

# ---------- A9-002: agent-state-machine.yaml ----------
$sm9 = Join-Path $a009 'agent-state-machine.yaml'
if (Test-Path $sm9) {
  $sm = Get-Content -LiteralPath $sm9 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','structure','categories','states','initial_state','terminal_states','run_mapping','terminal_rules','triggers','transitions')) {
    if ($sm -notmatch "(?m)^${sec}:") { $errors += "A9-002: thieu '$sec'" }
  }
  foreach ($s in @('AST-001','AST-003','AST-005','AST-006')) {
    if ($sm -notmatch [regex]::Escape($s)) { $errors += "A9-002: thieu state $s" }
  }
  if ($sm -notmatch '(?m)^initial_state:') { $errors += "A9-002: thieu initial_state" }
  if ($sm -notmatch '(?m)^transitions:') { $errors += "A9-002: thieu transitions" }
}

# ---------- A9-003: run_mapping sang S009 ----------
if (Test-Path $sm9) {
  $sm3 = Get-Content -LiteralPath $sm9 -Raw -Encoding utf8
  if ($sm3 -notmatch 'run_mapping') { $errors += "A9-003: thieu run_mapping (S009)" }
  foreach ($st in @('ST-001','ST-008','ST-009','ST-014')) {
    if ($sm3 -notmatch [regex]::Escape($st)) { $errors += "A9-003: run_mapping thieu $st" }
  }
}

# ---------- A9-004: transitions >= 7 ----------
if (Test-Path $sm9) {
  $sm4 = Get-Content -LiteralPath $sm9 -Raw -Encoding utf8
  $trCount = ([regex]::Matches($sm4, '(?m)^  - "?from:')).Count
  if ($trCount -lt 7) { $errors += "A9-004: chi co $trCount transitions (can >=7)" }
}

# ---------- A9-005: state-machine.md ----------
$smd9 = Join-Path $a009 'state-machine.md'
if (Test-Path $smd9) {
  $sm9m = Get-Content -LiteralPath $smd9 -Raw -Encoding utf8
  for ($i = 1; $i -le 17; $i++) {
    $sec = "AS{0:D3}" -f $i
    if ($sm9m -notmatch [regex]::Escape($sec)) { $errors += "A9-005: thieu section $sec" }
  }
}

# ---------- A10-001: A010 execution flow ----------
$a010 = Join-Path $spec4 'A010'
foreach ($f in @('execution-flow.md','agent-execution-flow.yaml','agent-execution-flow.schema.json','agent-stages.yaml','agent-registration.yaml','agent-orchestration.yaml','agent-fallback.yaml','agent-failure.yaml','agent-lineage.yaml','agent-outcome.yaml','agent-policies.yaml','agent-validation.yaml')) {
  if (-not (Test-Path (Join-Path $a010 $f))) { $errors += "A10-001: missing A010/$f" }
}

# ---------- A10-002: agent-execution-flow.yaml ----------
$ef10 = Join-Path $a010 'agent-execution-flow.yaml'
if (Test-Path $ef10) {
  $ef = Get-Content -LiteralPath $ef10 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','stages','canonical_flow','agent_flows','rules')) {
    if ($ef -notmatch "(?m)^${sec}:") { $errors += "A10-002: thieu '$sec'" }
  }
  foreach ($st in @('Initialize','Validate','Prepare','Execute','Coordinate','Finalize','Complete')) {
    if ($ef -notmatch [regex]::Escape($st)) { $errors += "A10-002: thieu stage $st" }
  }
}

# ---------- A10-003: canonical_flow 8 buoc ----------
if (Test-Path $ef10) {
  $ef3 = Get-Content -LiteralPath $ef10 -Raw -Encoding utf8
  foreach ($step in @('Command','Declare','Validate','Register','Orchestrate','Execute','Finalize','Complete')) {
    if ($ef3 -notmatch [regex]::Escape($step)) { $errors += "A10-003: canonical_flow thieu $step" }
  }
}

# ---------- A10-004: agent_flows 7 loai ----------
if (Test-Path $ef10) {
  $ef4 = Get-Content -LiteralPath $ef10 -Raw -Encoding utf8
  foreach ($fl in @('Registration','Orchestration','Fallback','Gate','Retry','Timeout','Failure')) {
    if ($ef4 -notmatch [regex]::Escape($fl)) { $errors += "A10-004: thieu flow $fl" }
  }
}

# ---------- A10-005: execution-flow.md ----------
$efmd = Join-Path $a010 'execution-flow.md'
if (Test-Path $efmd) {
  $efm = Get-Content -LiteralPath $efmd -Raw -Encoding utf8
  for ($i = 1; $i -le 19; $i++) {
    $sec = "AF{0:D3}" -f $i
    if ($efm -notmatch [regex]::Escape($sec)) { $errors += "A10-005: thieu section $sec" }
  }
}

# ---------- A11-001: A011 observability ----------
$a011 = Join-Path $spec4 'A011'
foreach ($f in @('observability.md','agent-observability.yaml','agent-observability.schema.json','agent-events.yaml','agent-metrics.yaml','agent-traces.yaml','agent-audit.yaml','agent-correlation.yaml','agent-health.yaml','agent-dashboard.yaml','agent-observability-mapping.yaml')) {
  if (-not (Test-Path (Join-Path $a011 $f))) { $errors += "A11-001: missing A011/$f" }
}
$ob11 = Join-Path $a011 'agent-observability.yaml'
if (Test-Path $ob11) {
  $ob = Get-Content -LiteralPath $ob11 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','domains','boundary','correlation_model','doctor_checks','evolution_integration','machine_readable','success_criteria')) {
    if ($ob -notmatch "(?m)^${sec}:") { $errors += "A11-002: thieu '$sec'" }
  }
  if ($ob -notmatch 'Business Data') { $errors += "A11-003: thieu not_observes Business Data" }
}
$obmd = Join-Path $a011 'observability.md'
if (Test-Path $obmd) {
  $obm = Get-Content -LiteralPath $obmd -Raw -Encoding utf8
  for ($i = 1; $i -le 16; $i++) { $sec = "AO{0:D3}" -f $i; if ($obm -notmatch [regex]::Escape($sec)) { $errors += "A11-005: thieu section $sec" } }
  foreach ($sec in @('AO003A','AO011A')) { if ($obm -notmatch [regex]::Escape($sec)) { $errors += "A11-005: thieu section $sec" } }
}

# ---------- A12-001: A012 policies ----------
$a012 = Join-Path $spec4 'A012'
foreach ($f in @('policies.md','agent-policies.yaml','agent-policies.schema.json','agent-policy-model.yaml','agent-policy-lifecycle.yaml','agent-policy-categories.yaml','agent-policy-resolution.yaml','agent-policy-validation.yaml','agent-policy-traceability.yaml','retry-binding.yaml','timeout-binding.yaml','approval-binding.yaml')) {
  if (-not (Test-Path (Join-Path $a012 $f))) { $errors += "A12-001: missing A012/$f" }
}
$pl12 = Join-Path $a012 'agent-policies.yaml'
if (Test-Path $pl12) {
  $pl = Get-Content -LiteralPath $pl12 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','binding_model','lifecycle','categories','bindings','responsibility_chain')) {
    if ($pl -notmatch "(?m)^${sec}:") { $errors += "A12-002: thieu '$sec'" }
  }
  foreach ($pol in @('POL-RETRY-001','POL-TIMEOUT-001','POL-APPROVAL-001','POL-RES-001','POL-PARALLEL-001','POL-COMP-001','POL-SCHED-001','POL-ISOL-001','POL-SEC-001','POL-RESACC-001')) {
    if ($pl -notmatch [regex]::Escape($pol)) { $errors += "A12-003: thieu binding toi $pol" }
  }
}
$plmd = Join-Path $a012 'policies.md'
if (Test-Path $plmd) {
  $plm = Get-Content -LiteralPath $plmd -Raw -Encoding utf8
  for ($i = 1; $i -le 17; $i++) { $sec = "AP{0:D3}" -f $i; if ($plm -notmatch [regex]::Escape($sec)) { $errors += "A12-005: thieu section $sec" } }
  foreach ($sec in @('AP002A','AP002B')) { if ($plm -notmatch [regex]::Escape($sec)) { $errors += "A12-005: thieu section $sec" } }
}

# ---------- A13-001: A013 governance ----------
$a013 = Join-Path $spec4 'A013'
foreach ($f in @('governance.md','agent-governance.yaml','agent-governance.schema.json','agent-governance-stack.yaml','agent-binding-enforcement.yaml','agent-governance-matrix.yaml','agent-governance-events.yaml','agent-governance-decisions.yaml','agent-governance-lifecycle.yaml','agent-governance-metrics.yaml','agent-governance-registry.yaml')) {
  if (-not (Test-Path (Join-Path $a013 $f))) { $errors += "A13-001: missing A013/$f" }
}
$gv13 = Join-Path $a013 'agent-governance.yaml'
if (Test-Path $gv13) {
  $gv = Get-Content -LiteralPath $gv13 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','scope','version_governance','compatibility_governance','validation_pipeline','decisions','traceability')) {
    if ($gv -notmatch "(?m)^${sec}:") { $errors += "A13-002: thieu '$sec'" }
  }
  foreach ($step in @('Constitution','Boundary (A004)','Contract (A007)','Policy Binding (A012)','Execution (Runtime SPEC-001)')) {
    if ($gv -notmatch [regex]::Escape($step)) { $errors += "A13-003: pipeline thieu $step" }
  }
}
$gvmd = Join-Path $a013 'governance.md'
if (Test-Path $gvmd) {
  $gvm = Get-Content -LiteralPath $gvmd -Raw -Encoding utf8
  for ($i = 1; $i -le 18; $i++) { $sec = "AG{0:D3}" -f $i; if ($gvm -notmatch [regex]::Escape($sec)) { $errors += "A13-005: thieu section $sec" } }
  foreach ($sec in @('AG003A','AG005A','AG011A','AG012A','AG014A')) { if ($gvm -notmatch [regex]::Escape($sec)) { $errors += "A13-005: thieu section $sec" } }
}

# ---------- A14-001: A014 registry ----------
$a014 = Join-Path $spec4 'A014'
foreach ($f in @('registry.md','agent-registry.yaml','agent-registry.schema.json','agent-registry-model.yaml','agent-registry-domains.yaml','agent-registry-resolution.yaml','agent-registry-events.yaml','agent-registry-lifecycle.yaml','agent-registry-constraints.yaml','agent-registry-traceability.yaml','agent-registry-metrics.yaml','agent-registry-validation.yaml','agent-registry-registry.yaml')) {
  if (-not (Test-Path (Join-Path $a014 $f))) { $errors += "A14-001: missing A014/$f" }
}
$rg14 = Join-Path $a014 'agent-registry.yaml'
if (Test-Path $rg14) {
  $rg = Get-Content -LiteralPath $rg14 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','categories','domains','entry_model','ownership','lifecycle','governance','constraints','resolution','resolution_rules','resolution_priority','resolution_failures','version_resolution','relationships','dependency','traceability','events','metrics')) {
    if ($rg -notmatch "(?m)^${sec}:") { $errors += "A14-002: thieu '$sec'" }
  }
  foreach ($step in @('Request','Normalize','Lookup','Candidate Selection','Compatibility Check','Policy Binding Check','Governance Check','Resolved')) {
    if ($rg -notmatch [regex]::Escape($step)) { $errors += "A14-003: resolution thieu $step" }
  }
  if ($rg -notmatch 'fields: \[id, type, category, version, status, owner, references, compatibility, lifecycle, metadata\]') { $errors += "A14-004: entry_model phai co 10 fields" }
}
$rgmd = Join-Path $a014 'registry.md'
if (Test-Path $rgmd) {
  $rgm = Get-Content -LiteralPath $rgmd -Raw -Encoding utf8
  for ($i = 1; $i -le 15; $i++) { $sec = "AR{0:D3}" -f $i; if ($rgm -notmatch [regex]::Escape($sec)) { $errors += "A14-005: thieu section $sec" } }
  foreach ($sec in @('AR003A','AR005A','AR005B','AR008A','AR009A','AR010A')) { if ($rgm -notmatch [regex]::Escape($sec)) { $errors += "A14-005: thieu section $sec" } }
}

# ---------- A15-001: A015 resources ----------
$a015 = Join-Path $spec4 'A015'
foreach ($f in @('resources.md','agent-resources.yaml','agent-resources.schema.json','agent-resource-model.yaml','agent-resource-categories.yaml','agent-resource-lifecycle.yaml','agent-resource-allocation.yaml','agent-resource-access.yaml','agent-resource-events.yaml','agent-resource-metrics.yaml','agent-resource-validation.yaml')) {
  if (-not (Test-Path (Join-Path $a015 $f))) { $errors += "A15-001: missing A015/$f" }
}
$rs15 = Join-Path $a015 'agent-resources.yaml'
if (Test-Path $rs15) {
  $rs = Get-Content -LiteralPath $rs15 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','categories','resource_model','lifecycle','allocation','access','ownership','constraints','registry_reference','traceability','events','metrics')) {
    if ($rs -notmatch "(?m)^${sec}:") { $errors += "A15-002: thieu '$sec'" }
  }
  if ($rs -notmatch 'APB-004') { $errors += "A15-003: allocation thieu binding APB-004" }
  if ($rs -notmatch 'APB-010') { $errors += "A15-003: access thieu binding APB-010" }
}
$rsmd = Join-Path $a015 'resources.md'
if (Test-Path $rsmd) {
  $rsm = Get-Content -LiteralPath $rsmd -Raw -Encoding utf8
  for ($i = 1; $i -le 17; $i++) { $sec = "ARC{0:D3}" -f $i; if ($rsm -notmatch [regex]::Escape($sec)) { $errors += "A15-005: thieu section $sec" } }
}

# ---------- A16-001: A016 compliance ----------
$a016 = Join-Path $spec4 'A016'
foreach ($f in @('compliance.md','agent-compliance.yaml','agent-compliance.schema.json','agent-validation-rules.yaml','agent-compliance-matrix.yaml','agent-health-score.yaml','agent-readiness-checklist.yaml','agent-certification.yaml','agent-compliance-events.yaml','agent-compliance-metrics.yaml','agent-compliance-report.yaml')) {
  if (-not (Test-Path (Join-Path $a016 $f))) { $errors += "A16-001: missing A016/$f" }
}
$cm16 = Join-Path $a016 'agent-compliance.yaml'
if (Test-Path $cm16) {
  $cm = Get-Content -LiteralPath $cm16 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','scope','validation_rules','health_score','readiness_checklist','certification','pipeline','events','metrics')) {
    if ($cm -notmatch "(?m)^${sec}:") { $errors += "A16-002: thieu '$sec'" }
  }
  $ruleCount = ([regex]::Matches($cm, '(?m)^  - ')).Count
  if ($ruleCount -lt 12) { $errors += "A16-003: validation_rules chi co $ruleCount (can >=12)" }
  if ($cm -notmatch 'Not Certified') { $errors += "A16-004: certification thieu Not Certified" }
}
$cmmd = Join-Path $a016 'compliance.md'
if (Test-Path $cmmd) {
  $cmm = Get-Content -LiteralPath $cmmd -Raw -Encoding utf8
  for ($i = 1; $i -le 16; $i++) { $sec = "AMC{0:D3}" -f $i; if ($cmm -notmatch [regex]::Escape($sec)) { $errors += "A16-005: thieu section $sec" } }
}

# ---------- A17-001: A017 extensions ----------
$a017 = Join-Path $spec4 'A017'
foreach ($f in @('extensions.md','agent-extensions.yaml','agent-extensions.schema.json','agent-extension-model.yaml','agent-extension-categories.yaml','agent-extension-lifecycle.yaml','agent-extension-installation.yaml','agent-extension-isolation.yaml','agent-extension-events.yaml','agent-extension-metrics.yaml','agent-extension-validation.yaml')) {
  if (-not (Test-Path (Join-Path $a017 $f))) { $errors += "A17-001: missing A017/$f" }
}
$ex17 = Join-Path $a017 'agent-extensions.yaml'
if (Test-Path $ex17) {
  $ex = Get-Content -LiteralPath $ex17 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','categories','extension_model','lifecycle','installation','activation_rules','isolation','security','resources','compatibility','events','metrics')) {
    if ($ex -notmatch "(?m)^${sec}:") { $errors += "A17-002: thieu '$sec'" }
  }
  if ($ex -notmatch 'Agent Internal State') { $errors += "A17-004: isolation thieu Agent Internal State" }
}
$exmd = Join-Path $a017 'extensions.md'
if (Test-Path $exmd) {
  $exm = Get-Content -LiteralPath $exmd -Raw -Encoding utf8
  for ($i = 1; $i -le 17; $i++) { $sec = "AXE{0:D3}" -f $i; if ($exm -notmatch [regex]::Escape($sec)) { $errors += "A17-005: thieu section $sec" } }
}

# ---------- A18-001: A018 evolution ----------
$a018 = Join-Path $spec4 'A018'
foreach ($f in @('evolution.md','agent-evolution.yaml','agent-evolution.schema.json','agent-evolution-scope.yaml','agent-evolution-pipeline.yaml','agent-evolution-proposal.yaml','agent-evolution-approval.yaml','agent-evolution-events.yaml','agent-evolution-metrics.yaml','agent-evolution-validation.yaml')) {
  if (-not (Test-Path (Join-Path $a018 $f))) { $errors += "A18-001: missing A018/$f" }
}
$ev18 = Join-Path $a018 'agent-evolution.yaml'
if (Test-Path $ev18) {
  $ev = Get-Content -LiteralPath $ev18 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','scope','pipeline','proposal_model','proposal_status','approval','safety','application','traceability','events','metrics')) {
    if ($ev -notmatch "(?m)^${sec}:") { $errors += "A18-002: thieu '$sec'" }
  }
  foreach ($step in @('Collect','Analyze','Learn','Propose','Approval Gate','Apply')) {
    if ($ev -notmatch [regex]::Escape($step)) { $errors += "A18-003: pipeline thieu $step" }
  }
  if ($ev -notmatch 'Human approval bat buoc') { $errors += "A18-004: approval thieu Human bat buoc" }
}
$evmd = Join-Path $a018 'evolution.md'
if (Test-Path $evmd) {
  $evm = Get-Content -LiteralPath $evmd -Raw -Encoding utf8
  for ($i = 1; $i -le 16; $i++) { $sec = "AVE{0:D3}" -f $i; if ($evm -notmatch [regex]::Escape($sec)) { $errors += "A18-005: thieu section $sec" } }
}

# ---------- A19-001: A019 doctor ----------
$a019 = Join-Path $spec4 'A019'
foreach ($f in @('doctor.md','agent-doctor.yaml','agent-doctor.schema.json','agent-doctor-scope.yaml','agent-doctor-checks.yaml','agent-doctor-pipeline.yaml','agent-doctor-self-repair.yaml','agent-doctor-report.yaml','agent-doctor-events.yaml','agent-doctor-metrics.yaml','agent-doctor-validation.yaml')) {
  if (-not (Test-Path (Join-Path $a019 $f))) { $errors += "A19-001: missing A019/$f" }
}
$dr19 = Join-Path $a019 'agent-doctor.yaml'
if (Test-Path $dr19) {
  $dr = Get-Content -LiteralPath $dr19 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','scope','check_sources','health_score','pipeline','self_repair','report','events','metrics','traceability')) {
    if ($dr -notmatch "(?m)^${sec}:") { $errors += "A19-002: thieu '$sec'" }
  }
  $srcCount = ([regex]::Matches($dr, '(?m)^  - "?A\d{3} ')).Count
  if ($srcCount -lt 7) { $errors += "A19-003: check_sources chi co $srcCount (can >=7)" }
  if ($dr -notmatch 'Chi Low impact') { $errors += "A19-004: self_repair thieu Low impact" }
}
$drmd = Join-Path $a019 'doctor.md'
if (Test-Path $drmd) {
  $drm = Get-Content -LiteralPath $drmd -Raw -Encoding utf8
  for ($i = 1; $i -le 16; $i++) { $sec = "ADR{0:D3}" -f $i; if ($drm -notmatch [regex]::Escape($sec)) { $errors += "A19-005: thieu section $sec" } }
}

# ---------- A20-001: A020 dashboard ----------
$a020 = Join-Path $spec4 'A020'
foreach ($f in @('dashboard.md','agent-dashboard.yaml','agent-dashboard.schema.json','agent-dashboard-scope.yaml','agent-dashboard-views.yaml','agent-dashboard-read-model.yaml','agent-dashboard-refresh.yaml','agent-dashboard-events.yaml','agent-dashboard-metrics.yaml','agent-dashboard-validation.yaml')) {
  if (-not (Test-Path (Join-Path $a020 $f))) { $errors += "A20-001: missing A020/$f" }
}
$db20 = Join-Path $a020 'agent-dashboard.yaml'
if (Test-Path $db20) {
  $db = Get-Content -LiteralPath $db20 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','scope','views','read_model','refresh','events','metrics')) {
    if ($db -notmatch "(?m)^${sec}:") { $errors += "A20-002: thieu '$sec'" }
  }
  foreach ($v in @('Agent View','Definition View','Registry View','Governance View','Resource View','Health View','Compliance + Doctor View')) {
    if ($db -notmatch [regex]::Escape($v)) { $errors += "A20-003: thieu view '$v'" }
  }
  if ($db -notmatch 'Event Driven') { $errors += "A20-004: refresh thieu Event Driven" }
}
$dbmd = Join-Path $a020 'dashboard.md'
if (Test-Path $dbmd) {
  $dbm = Get-Content -LiteralPath $dbmd -Raw -Encoding utf8
  for ($i = 1; $i -le 16; $i++) { $sec = "ADB{0:D3}" -f $i; if ($dbm -notmatch [regex]::Escape($sec)) { $errors += "A20-005: thieu section $sec" } }
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
