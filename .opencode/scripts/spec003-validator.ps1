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

# ---------- C4-001: C004 boundaries ----------
$c004 = Join-Path $spec3 'C004'
foreach ($f in @('boundaries.md','boundaries.yaml','boundaries.schema.json','boundary-matrix.yaml','boundary-ownership-matrix.yaml','boundary-registry.yaml','declaration-boundary.yaml','resolution-boundary.yaml','mapping-boundary.yaml','policy-boundary.yaml')) {
  if (-not (Test-Path (Join-Path $c004 $f))) { $errors += "C4-001: missing C004/$f" }
}

# ---------- C4-002: boundaries.yaml ----------
$bw4 = Join-Path $c004 'boundaries.yaml'
if (Test-Path $bw4) {
  $bd4 = Get-Content -LiteralPath $bw4 -Raw -Encoding utf8
  foreach ($sec in @('hierarchy','decision','invariants','validation','boundaries','mapping','metrics')) {
    if ($bd4 -notmatch "(?m)^${sec}:") { $errors += "C4-002: boundaries.yaml thieu '$sec'" }
  }
  foreach ($b in @('CB001-declaration','CB002-registry','CB003-validation','CB004-resolution','CB005-interface','CB006-dependency','CB007-mapping','CB008-policy','CB009-governance')) {
    if ($bd4 -notmatch [regex]::Escape($b)) { $errors += "C4-002: thieu $b" }
  }
}

# ---------- C4-003: moi boundary co severity + principles ----------
foreach ($b in @('CB001-declaration','CB004-resolution','CB007-mapping','CB009-governance')) {
  $block = [regex]::Match($bd4, "(?ms)^  ${b}:.*?^    rules:.*$")
  if (-not $block.Success) { $errors += "C4-003: $b thieu block" }
  else {
    if ($block.Value -notmatch '(?m)^    severity:\s*(\w+)') { $errors += "C4-003: $b thieu severity" }
    elseif ($Matches[1] -notin @('Critical','High','Medium','Low')) { $errors += "C4-003: $b severity sai" }
    if ($block.Value -notmatch '(?m)^    principles:') { $errors += "C4-003: $b thieu principles" }
  }
}

# ---------- C4-004: mapping ----------
$mp4b = Join-Path $c004 'boundaries.yaml'
if (Test-Path $mp4b) {
  $m4b = Get-Content -LiteralPath $mp4b -Raw -Encoding utf8
  if ($m4b -notmatch '(?m)^mapping:') { $errors += "C4-004: thieu mapping" }
}

# ---------- C4-005: boundaries.md ----------
$bmd4 = Join-Path $c004 'boundaries.md'
if (Test-Path $bmd4) {
  $bm4 = Get-Content -LiteralPath $bmd4 -Raw -Encoding utf8
  foreach ($sec in @('Hierarchy','Decision','Invariants','Validation','Boundaries','Mapping','Metrics','Machine-readable')) {
    if ($bm4 -notmatch [regex]::Escape("## $sec")) { $errors += "C4-005: boundaries.md thieu section '$sec'" }
  }
}

# ---------- C5-001: C005 architecture ----------
$c005 = Join-Path $spec3 'C005'
foreach ($f in @('architecture.md','architecture.yaml','architecture.schema.json','layer-model.yaml','domain-model.yaml','dependency-rules.yaml','communication-rules.yaml','architecture-matrix.yaml','architecture-decision-log.yaml','architecture-registry.yaml')) {
  if (-not (Test-Path (Join-Path $c005 $f))) { $errors += "C5-001: missing C005/$f" }
}

# ---------- C5-002: architecture.yaml ----------
$aw5 = Join-Path $c005 'architecture.yaml'
if (Test-Path $aw5) {
  $ar5 = Get-Content -LiteralPath $aw5 -Raw -Encoding utf8
  foreach ($sec in @('vision','decisions','layers','domains','dependency_rules','communication_rules','invariants','views','quality','constraints','stability','metrics','validation','mapping')) {
    if ($ar5 -notmatch "(?m)^${sec}:") { $errors += "C5-002: architecture thieu '$sec'" }
  }
  foreach ($l in @('Command','Declaration','Definition','Validation','Registration','Resolution','Publication')) {
    if ($ar5 -notmatch [regex]::Escape($l)) { $errors += "C5-002: thieu layer $l" }
  }
  foreach ($d in @('Definition','Validation','Mapping','Capability','Execution','Observability')) {
    if ($ar5 -notmatch [regex]::Escape($d)) { $errors += "C5-002: thieu domain $d" }
  }
}

# ---------- C5-003: moi layer co invariant + principle ----------
foreach ($l in @('Command','Declaration','Validation','Registration','Resolution','Publication')) {
  $block = [regex]::Match($ar5, "(?ms)^  ${l}:.*?^    principle:.*$")
  if (-not $block.Success) { $errors += "C5-003: $l thieu block" }
  else {
    if ($block.Value -notmatch '(?m)^    invariant:') { $errors += "C5-003: $l thieu invariant" }
    if ($block.Value -notmatch '(?m)^    principle:') { $errors += "C5-003: $l thieu principle" }
  }
}

# ---------- C5-004: layer-model.yaml ----------
$lm5 = Join-Path $c005 'layer-model.yaml'
if (Test-Path $lm5) {
  $lmm5 = Get-Content -LiteralPath $lm5 -Raw -Encoding utf8
  $layerCount5 = ([regex]::Matches($lmm5, '(?m)^  - name:')).Count
  if ($layerCount5 -lt 7) { $errors += "C5-004: layer-model chi co $layerCount5 layers (can >=7)" }
}

# ---------- C5-005: architecture.md ----------
$amd5 = Join-Path $c005 'architecture.md'
if (Test-Path $amd5) {
  $am5 = Get-Content -LiteralPath $amd5 -Raw -Encoding utf8
  foreach ($sec in @('Architectural Decisions','Layers','Domains','Dependency Rules','Communication Rules','Invariants','Views','Quality','Constraints','Stability','Validation','Machine-readable')) {
    if ($am5 -notmatch [regex]::Escape("## $sec")) { $errors += "C5-005: architecture.md thieu section '$sec'" }
  }
}

# ---------- C6-001: C006 components ----------
$c006 = Join-Path $spec3 'C006'
foreach ($f in @('components.md','components.yaml','components.schema.json','component-model.yaml','component-lifecycle.yaml','component-ownership.yaml','component-contracts.yaml','component-dependencies.yaml','component-mapping.yaml','component-metrics.yaml','component-validation.yaml','component-registry.yaml')) {
  if (-not (Test-Path (Join-Path $c006 $f))) { $errors += "C6-001: missing C006/$f" }
}

# ---------- C6-002: components.yaml ----------
$cw6 = Join-Path $c006 'components.yaml'
if (Test-Path $cw6) {
  $cp6 = Get-Content -LiteralPath $cw6 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','component_model','groups','lifecycles','components','not_in_runtime')) {
    if ($cp6 -notmatch "(?m)^${sec}:") { $errors += "C6-002: components thieu '$sec'" }
  }
  foreach ($c in @('CCP-001','CCP-004','CCP-005','CCP-008')) {
    if ($cp6 -notmatch [regex]::Escape($c)) { $errors += "C6-002: thieu $c" }
  }
  foreach ($n in @('Capability Engine','Declaration Manager','Validation Engine','Registration Manager','Capability Resolver','Discovery Provider','Binding Registrar','Capability Event Dispatcher')) {
    if ($cp6 -notmatch [regex]::Escape($n)) { $errors += "C6-002: thieu component '$n'" }
  }
}

# ---------- C6-003: moi component co layer/domain/requirements ----------
foreach ($c in @('CCP-001','CCP-004','CCP-005')) {
  $block = [regex]::Match($cp6, "(?ms)^  ${c}:.*?^    principles:.*$")
  if (-not $block.Success) { $errors += "C6-003: $c thieu block" }
  else {
    if ($block.Value -notmatch '(?m)^    layer:') { $errors += "C6-003: $c thieu layer" }
    if ($block.Value -notmatch '(?m)^    domain:') { $errors += "C6-003: $c thieu domain" }
    if ($block.Value -notmatch '(?m)^    requirements:') { $errors += "C6-003: $c thieu requirements" }
  }
}

# ---------- C6-004: not_in_runtime ----------
if (Test-Path $cw6) {
  $cp6b = Get-Content -LiteralPath $cw6 -Raw -Encoding utf8
  if ($cp6b -notmatch '(?m)^not_in_runtime:') { $errors += "C6-004: thieu not_in_runtime" }
}

# ---------- C6-005: components.md ----------
$cmd6 = Join-Path $c006 'components.md'
if (Test-Path $cmd6) {
  $cm6 = Get-Content -LiteralPath $cmd6 -Raw -Encoding utf8
  foreach ($sec in @('Philosophy','Principles','Groups','Components','Not in Capability System','Contracts','Dependencies','Lifecycles','Validation','Machine-readable')) {
    if ($cm6 -notmatch [regex]::Escape("## $sec")) { $errors += "C6-005: components.md thieu section '$sec'" }
  }
}

# ---------- C7-001: C007 contracts ----------
$c007 = Join-Path $spec3 'C007'
foreach ($f in @('contracts.md','contracts.yaml','contracts.schema.json','contract-model.yaml','contract-categories.yaml','contract-types.yaml','contract-compatibility.yaml','contract-mapping.yaml','contract-quality.yaml','contract-anti-patterns.yaml','communication-matrix.yaml','contract-registry.yaml')) {
  if (-not (Test-Path (Join-Path $c007 $f))) { $errors += "C7-001: missing C007/$f" }
}

# ---------- C7-002: contracts.yaml ----------
$cw7 = Join-Path $c007 'contracts.yaml'
if (Test-Path $cw7) {
  $ct7 = Get-Content -LiteralPath $cw7 -Raw -Encoding utf8
  if ($ct7 -notmatch '(?m)^contracts:') { $errors += "C7-002: contracts.yaml thieu 'contracts:'" }
  foreach ($c in @('CCT-001','CCT-002','CCT-003','CCT-004','CCT-005','CCT-006')) {
    if ($ct7 -notmatch [regex]::Escape($c)) { $errors += "C7-002: thieu $c" }
  }
  foreach ($n in @('Capability Contract','Declaration Contract','Validation Contract','Registration Contract','Registry Contract','Event Contract')) {
    if ($ct7 -notmatch [regex]::Escape($n)) { $errors += "C7-002: thieu contract '$n'" }
  }
}

# ---------- C7-003: moi contract co owner/preconditions/invariants ----------
foreach ($c in @('CCT-001','CCT-004','CCT-006')) {
  $block = [regex]::Match($ct7, "(?ms)^  ${c}:.*?^    compatibility:.*$")
  if (-not $block.Success) { $errors += "C7-003: $c thieu block" }
  else {
    if ($block.Value -notmatch '(?m)^    owner:') { $errors += "C7-003: $c thieu owner" }
    if ($block.Value -notmatch '(?m)^    preconditions:') { $errors += "C7-003: $c thieu preconditions" }
    if ($block.Value -notmatch '(?m)^    invariants:') { $errors += "C7-003: $c thieu invariants" }
  }
}

# ---------- C7-004: communication-matrix ----------
$mm7 = Join-Path $c007 'communication-matrix.yaml'
if (Test-Path $mm7) {
  $m7c = Get-Content -LiteralPath $mm7 -Raw -Encoding utf8
  $edgeCount7 = ([regex]::Matches($m7c, '(?m)^  - \[')).Count
  if ($edgeCount7 -lt 10) { $errors += "C7-004: communication-matrix chi co $edgeCount7 edges (can >=10)" }
}

# ---------- C7-005: contracts.md ----------
$cmd7 = Join-Path $c007 'contracts.md'
if (Test-Path $cmd7) {
  $cm7c = Get-Content -LiteralPath $cmd7 -Raw -Encoding utf8
  foreach ($sec in @('Contracts','Contract Quality','Anti-patterns','Communication Matrix','Machine-readable')) {
    if ($cm7c -notmatch [regex]::Escape("## $sec")) { $errors += "C7-005: contracts.md thieu section '$sec'" }
  }
}

# ---------- C8-001: appendix capability-models ----------
$cm8 = Join-Path $spec3 'capability-models'
foreach ($f in @('README.md','capability-models.yaml','capability-model-registry.yaml','capability-model-relationships.yaml','capability-model-validation.yaml','capability-models.schema.json')) {
  if (-not (Test-Path (Join-Path $cm8 $f))) { $errors += "C8-001: missing capability-models/$f" }
}
$cmYaml = Join-Path $cm8 'capability-models.yaml'
if (Test-Path $cmYaml) {
  $cmy = Get-Content -LiteralPath $cmYaml -Raw -Encoding utf8
  if ($cmy -notmatch '(?m)^aggregate_root:\s*Capability') { $errors += "C8-001: aggregate_root phai la Capability" }
  foreach ($m in @('CM-001','CM-002','CM-004','CM-008')) {
    if ($cmy -notmatch [regex]::Escape($m)) { $errors += "C8-001: thieu model $m" }
  }
}

# ---------- C8-002: C008 data model files ----------
$c008 = Join-Path $spec3 'C008'
foreach ($f in @('data-model.md','capability-data-model.yaml','capability-data.schema.json','capability-entities.yaml','capability-identities.yaml','capability-invariants.yaml','capability-lifecycle.yaml','capability-ownership.yaml','capability-references.yaml','capability-relations.yaml','capability-validation.yaml')) {
  if (-not (Test-Path (Join-Path $c008 $f))) { $errors += "C8-002: missing C008/$f" }
}

# ---------- C8-003: capability-data-model.yaml ----------
$dm8 = Join-Path $c008 'capability-data-model.yaml'
if (Test-Path $dm8) {
  $dm = Get-Content -LiteralPath $dm8 -Raw -Encoding utf8
  foreach ($sec in @('aggregate_root','aggregate_rules','classification','invariants','consistency','dependencies')) {
    if ($dm -notmatch "(?m)^${sec}:") { $errors += "C8-003: capability-data-model thieu '$sec'" }
  }
  if ($dm -notmatch 'Capability') { $errors += "C8-003: aggregate_root phai la Capability" }
}

# ---------- C8-004: entities ----------
$en8 = Join-Path $c008 'capability-entities.yaml'
if (Test-Path $en8) {
  $en = Get-Content -LiteralPath $en8 -Raw -Encoding utf8
  $entCount = ([regex]::Matches($en, '(?m)^  ENT-C\d+:')).Count
  if ($entCount -lt 15) { $errors += "C8-004: capability-entities chi co $entCount (can >=15)" }
  foreach ($e in @('ENT-C001','ENT-C002','ENT-C008','ENT-C014')) {
    if ($en -notmatch [regex]::Escape($e)) { $errors += "C8-004: thieu $e" }
  }
}

# ---------- C8-005: data-model.md ----------
$dmd8 = Join-Path $c008 'data-model.md'
if (Test-Path $dmd8) {
  $dm8m = Get-Content -LiteralPath $dmd8 -Raw -Encoding utf8
  for ($i = 1; $i -le 15; $i++) {
    $sec = "CDM{0:D3}" -f $i
    if ($dm8m -notmatch [regex]::Escape($sec)) { $errors += "C8-005: thieu section $sec" }
  }
}

# ---------- C9-001: C009 state machine ----------
$c009 = Join-Path $spec3 'C009'
foreach ($f in @('state-machine.md','capability-state-machine.yaml','capability.schema.json','capability-states.yaml','capability-transitions.yaml','capability-transition-guards.yaml','capability-transition-triggers.yaml','capability-transition-types.yaml','capability-transition-matrix.yaml','capability-state-events.yaml','capability-state-history.yaml','capability-state-metrics.yaml','capability-state-machine-validation.yaml','capability-state-machine-registry.yaml')) {
  if (-not (Test-Path (Join-Path $c009 $f))) { $errors += "C9-001: missing C009/$f" }
}

# ---------- C9-002: capability-state-machine.yaml ----------
$sm9 = Join-Path $c009 'capability-state-machine.yaml'
if (Test-Path $sm9) {
  $sm = Get-Content -LiteralPath $sm9 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','structure','categories','states','initial_state','terminal_states','run_mapping','terminal_rules','triggers','transitions')) {
    if ($sm -notmatch "(?m)^${sec}:") { $errors += "C9-002: thieu '$sec'" }
  }
  foreach ($s in @('CST-001','CST-003','CST-005','CST-006')) {
    if ($sm -notmatch [regex]::Escape($s)) { $errors += "C9-002: thieu state $s" }
  }
  if ($sm -notmatch '(?m)^initial_state:') { $errors += "C9-002: thieu initial_state" }
  if ($sm -notmatch '(?m)^transitions:') { $errors += "C9-002: thieu transitions" }
}

# ---------- C9-003: run_mapping sang S009 ----------
if (Test-Path $sm9) {
  $sm3 = Get-Content -LiteralPath $sm9 -Raw -Encoding utf8
  if ($sm3 -notmatch 'run_mapping') { $errors += "C9-003: thieu run_mapping (S009)" }
  foreach ($st in @('ST-001','ST-008','ST-009','ST-014')) {
    if ($sm3 -notmatch [regex]::Escape($st)) { $errors += "C9-003: run_mapping thieu $st" }
  }
}

# ---------- C9-004: transitions >= 7 ----------
if (Test-Path $sm9) {
  $sm4 = Get-Content -LiteralPath $sm9 -Raw -Encoding utf8
  $trCount = ([regex]::Matches($sm4, '(?m)^  - "?from:')).Count
  if ($trCount -lt 7) { $errors += "C9-004: chi co $trCount transitions (can >=7)" }
}

# ---------- C9-005: state-machine.md ----------
$smd9 = Join-Path $c009 'state-machine.md'
if (Test-Path $smd9) {
  $sm9m = Get-Content -LiteralPath $smd9 -Raw -Encoding utf8
  for ($i = 1; $i -le 17; $i++) {
    $sec = "CS{0:D3}" -f $i
    if ($sm9m -notmatch [regex]::Escape($sec)) { $errors += "C9-005: thieu section $sec" }
  }
}

# ---------- C10-001: C010 execution flow ----------
$c010 = Join-Path $spec3 'C010'
foreach ($f in @('execution-flow.md','capability-execution-flow.yaml','capability-execution-flow.schema.json','capability-stages.yaml','capability-registration.yaml','capability-resolution.yaml','capability-fallback.yaml','capability-failure.yaml','capability-lineage.yaml','capability-outcome.yaml','capability-policies.yaml','capability-validation.yaml')) {
  if (-not (Test-Path (Join-Path $c010 $f))) { $errors += "C10-001: missing C010/$f" }
}

# ---------- C10-002: capability-execution-flow.yaml ----------
$ef10 = Join-Path $c010 'capability-execution-flow.yaml'
if (Test-Path $ef10) {
  $ef = Get-Content -LiteralPath $ef10 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','stages','canonical_flow','capability_flows','rules')) {
    if ($ef -notmatch "(?m)^${sec}:") { $errors += "C10-002: thieu '$sec'" }
  }
  foreach ($st in @('Initialize','Validate','Prepare','Execute','Coordinate','Finalize','Complete')) {
    if ($ef -notmatch [regex]::Escape($st)) { $errors += "C10-002: thieu stage $st" }
  }
}

# ---------- C10-003: canonical_flow 8 buoc ----------
if (Test-Path $ef10) {
  $ef3 = Get-Content -LiteralPath $ef10 -Raw -Encoding utf8
  foreach ($step in @('Command','Declare','Validate','Register','Resolve','Execute','Finalize','Complete')) {
    if ($ef3 -notmatch [regex]::Escape($step)) { $errors += "C10-003: canonical_flow thieu $step" }
  }
}

# ---------- C10-004: capability_flows 7 loai ----------
if (Test-Path $ef10) {
  $ef4 = Get-Content -LiteralPath $ef10 -Raw -Encoding utf8
  foreach ($fl in @('Registration','Resolution','Fallback','Gate','Retry','Timeout','Failure')) {
    if ($ef4 -notmatch [regex]::Escape($fl)) { $errors += "C10-004: thieu flow $fl" }
  }
}

# ---------- C10-005: execution-flow.md ----------
$efmd = Join-Path $c010 'execution-flow.md'
if (Test-Path $efmd) {
  $efm = Get-Content -LiteralPath $efmd -Raw -Encoding utf8
  for ($i = 1; $i -le 19; $i++) {
    $sec = "CF{0:D3}" -f $i
    if ($efm -notmatch [regex]::Escape($sec)) { $errors += "C10-005: thieu section $sec" }
  }
}

# ---------- C11-001: C011 observability ----------
$c011 = Join-Path $spec3 'C011'
foreach ($f in @('observability.md','capability-observability.yaml','capability-observability.schema.json','capability-events.yaml','capability-metrics.yaml','capability-traces.yaml','capability-audit.yaml','capability-correlation.yaml','capability-health.yaml','capability-dashboard.yaml','capability-observability-mapping.yaml')) {
  if (-not (Test-Path (Join-Path $c011 $f))) { $errors += "C11-001: missing C011/$f" }
}

# ---------- C11-002: capability-observability.yaml ----------
$ob11 = Join-Path $c011 'capability-observability.yaml'
if (Test-Path $ob11) {
  $ob = Get-Content -LiteralPath $ob11 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','domains','boundary','correlation_model','doctor_checks','evolution_integration','machine_readable','success_criteria')) {
    if ($ob -notmatch "(?m)^${sec}:") { $errors += "C11-002: thieu '$sec'" }
  }
  foreach ($d in @('Events','Metrics','Trace','Audit','Health')) {
    if ($ob -notmatch [regex]::Escape($d)) { $warnings += "C11-002: thieu domain '$d'" }
  }
}

# ---------- C11-003: boundary ----------
if (Test-Path $ob11) {
  $ob3 = Get-Content -LiteralPath $ob11 -Raw -Encoding utf8
  if ($ob3 -notmatch '(?m)^  observes:') { $errors += "C11-003: thieu observes" }
  if ($ob3 -notmatch '(?m)^  not_observes:') { $errors += "C11-003: thieu not_observes" }
  if ($ob3 -notmatch 'Business Data') { $errors += "C11-003: thieu not_observes Business Data" }
}

# ---------- C11-004: events ----------
$ev11 = Join-Path $c011 'capability-events.yaml'
if (Test-Path $ev11) {
  $ev = Get-Content -LiteralPath $ev11 -Raw -Encoding utf8
  foreach ($e in @('CAPABILITY_VALIDATING','CAPABILITY_PUBLISHED','CAPABILITY_REJECTED','CAPABILITY_DEPRECATED','CAPABILITY_REACTIVATED','CAPABILITY_RETIRED')) {
    if ($ev -notmatch [regex]::Escape($e)) { $errors += "C11-004: thieu event $e" }
  }
}

# ---------- C11-005: observability.md ----------
$obmd = Join-Path $c011 'observability.md'
if (Test-Path $obmd) {
  $obm = Get-Content -LiteralPath $obmd -Raw -Encoding utf8
  for ($i = 1; $i -le 16; $i++) {
    $sec = "CO{0:D3}" -f $i
    if ($obm -notmatch [regex]::Escape($sec)) { $errors += "C11-005: thieu section $sec" }
  }
  foreach ($sec in @('CO003A','CO011A')) {
    if ($obm -notmatch [regex]::Escape($sec)) { $errors += "C11-005: thieu section $sec" }
  }
}

# ---------- C12-001: C012 policies ----------
$c012 = Join-Path $spec3 'C012'
foreach ($f in @('policies.md','capability-policies.yaml','capability-policies.schema.json','capability-policy-model.yaml','capability-policy-lifecycle.yaml','capability-policy-categories.yaml','capability-policy-resolution.yaml','capability-policy-validation.yaml','capability-policy-traceability.yaml','retry-binding.yaml','timeout-binding.yaml','approval-binding.yaml')) {
  if (-not (Test-Path (Join-Path $c012 $f))) { $errors += "C12-001: missing C012/$f" }
}

# ---------- C12-002: capability-policies.yaml ----------
$pl12 = Join-Path $c012 'capability-policies.yaml'
if (Test-Path $pl12) {
  $pl = Get-Content -LiteralPath $pl12 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','binding_model','lifecycle','categories','bindings','responsibility_chain')) {
    if ($pl -notmatch "(?m)^${sec}:") { $errors += "C12-002: thieu '$sec'" }
  }
  foreach ($b in @('CPB-001','CPB-005','CPB-010')) {
    if ($pl -notmatch [regex]::Escape($b)) { $errors += "C12-002: thieu $b" }
  }
}

# ---------- C12-003: moi binding tro den POL-* ----------
if (Test-Path $pl12) {
  $pl3 = Get-Content -LiteralPath $pl12 -Raw -Encoding utf8
  foreach ($pol in @('POL-RETRY-001','POL-TIMEOUT-001','POL-APPROVAL-001','POL-RES-001','POL-PARALLEL-001','POL-COMP-001','POL-SCHED-001','POL-ISOL-001','POL-SEC-001','POL-RESACC-001')) {
    if ($pl3 -notmatch [regex]::Escape($pol)) { $errors += "C12-003: thieu binding toi $pol" }
  }
}

# ---------- C12-004: binding model ----------
$bm12 = Join-Path $c012 'capability-policy-model.yaml'
if (Test-Path $bm12) {
  $bm = Get-Content -LiteralPath $bm12 -Raw -Encoding utf8
  if ($bm -notmatch 'policy_ref') { $errors += "C12-004: binding model thieu policy_ref" }
  if ($bm -notmatch 'parameters') { $errors += "C12-004: binding model thieu parameters" }
  if ($bm -notmatch 'scope') { $errors += "C12-004: binding model thieu scope" }
}

# ---------- C12-005: policies.md ----------
$plmd = Join-Path $c012 'policies.md'
if (Test-Path $plmd) {
  $plm = Get-Content -LiteralPath $plmd -Raw -Encoding utf8
  for ($i = 1; $i -le 17; $i++) {
    $sec = "CP{0:D3}" -f $i
    if ($plm -notmatch [regex]::Escape($sec)) { $errors += "C12-005: thieu section $sec" }
  }
  foreach ($sec in @('CP002A','CP002B')) {
    if ($plm -notmatch [regex]::Escape($sec)) { $errors += "C12-005: thieu section $sec" }
  }
}

# ---------- C13-001: C013 governance ----------
$c013 = Join-Path $spec3 'C013'
foreach ($f in @('governance.md','capability-governance.yaml','capability-governance.schema.json','capability-governance-stack.yaml','capability-binding-enforcement.yaml','capability-governance-matrix.yaml','capability-governance-events.yaml','capability-governance-decisions.yaml','capability-governance-lifecycle.yaml','capability-governance-metrics.yaml','capability-governance-registry.yaml')) {
  if (-not (Test-Path (Join-Path $c013 $f))) { $errors += "C13-001: missing C013/$f" }
}

# ---------- C13-002: capability-governance.yaml ----------
$gv13 = Join-Path $c013 'capability-governance.yaml'
if (Test-Path $gv13) {
  $gv = Get-Content -LiteralPath $gv13 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','scope','version_governance','compatibility_governance','validation_pipeline','decisions','traceability')) {
    if ($gv -notmatch "(?m)^${sec}:") { $errors += "C13-002: thieu '$sec'" }
  }
  foreach ($e in @('Constitution (SPEC-000)','Policy Binding (C012)','Contract (C007)','Boundary (C004)','Permission (S013)','Version Compatibility')) {
    if ($gv -notmatch [regex]::Escape($e)) { $errors += "C13-002: thieu enforces '$e'" }
  }
}

# ---------- C13-003: validation_pipeline 5 buoc ----------
if (Test-Path $gv13) {
  $gv3 = Get-Content -LiteralPath $gv13 -Raw -Encoding utf8
  foreach ($step in @('Constitution','Boundary (C004)','Contract (C007)','Policy Binding (C012)','Resolution (Runtime EF007)')) {
    if ($gv3 -notmatch [regex]::Escape($step)) { $errors += "C13-003: pipeline thieu $step" }
  }
}

# ---------- C13-004: binding enforcement ----------
$be13 = Join-Path $c013 'capability-binding-enforcement.yaml'
if (Test-Path $be13) {
  $be = Get-Content -LiteralPath $be13 -Raw -Encoding utf8
  if ($be -notmatch 'Resolve binding') { $errors += "C13-004: thieu resolve binding" }
  if ($be -notmatch 'Apply') { $errors += "C13-004: thieu apply" }
  if ($be -notmatch 'Audit') { $errors += "C13-004: thieu audit" }
}

# ---------- C13-005: governance.md ----------
$gvmd = Join-Path $c013 'governance.md'
if (Test-Path $gvmd) {
  $gvm = Get-Content -LiteralPath $gvmd -Raw -Encoding utf8
  for ($i = 1; $i -le 18; $i++) {
    $sec = "CG{0:D3}" -f $i
    if ($gvm -notmatch [regex]::Escape($sec)) { $errors += "C13-005: thieu section $sec" }
  }
  foreach ($sec in @('CG003A','CG005A','CG011A','CG012A','CG014A')) {
    if ($gvm -notmatch [regex]::Escape($sec)) { $errors += "C13-005: thieu section $sec" }
  }
}

# ---------- C14-001: C014 registry ----------
$c014 = Join-Path $spec3 'C014'
foreach ($f in @('registry.md','capability-registry.yaml','capability-registry.schema.json','capability-registry-model.yaml','capability-registry-domains.yaml','capability-registry-resolution.yaml','capability-registry-events.yaml','capability-registry-lifecycle.yaml','capability-registry-constraints.yaml','capability-registry-traceability.yaml','capability-registry-metrics.yaml','capability-registry-validation.yaml','capability-registry-registry.yaml')) {
  if (-not (Test-Path (Join-Path $c014 $f))) { $errors += "C14-001: missing C014/$f" }
}

# ---------- C14-002: capability-registry.yaml ----------
$rg14 = Join-Path $c014 'capability-registry.yaml'
if (Test-Path $rg14) {
  $rg = Get-Content -LiteralPath $rg14 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','categories','domains','entry_model','ownership','lifecycle','governance','constraints','resolution','resolution_rules','resolution_priority','resolution_failures','version_resolution','relationships','dependency','traceability','events','metrics')) {
    if ($rg -notmatch "(?m)^${sec}:") { $errors += "C14-002: thieu '$sec'" }
  }
}

# ---------- C14-003: resolution 8 buoc ----------
if (Test-Path $rg14) {
  $rg3 = Get-Content -LiteralPath $rg14 -Raw -Encoding utf8
  foreach ($step in @('Request','Normalize','Lookup','Candidate Selection','Compatibility Check','Policy Binding Check','Governance Check','Resolved')) {
    if ($rg3 -notmatch [regex]::Escape($step)) { $errors += "C14-003: resolution thieu $step" }
  }
}

# ---------- C14-004: entry_model 10 fields ----------
if (Test-Path $rg14) {
  $rg4 = Get-Content -LiteralPath $rg14 -Raw -Encoding utf8
  if ($rg4 -notmatch 'fields: \[id, type, category, version, status, owner, references, compatibility, lifecycle, metadata\]') { $errors += "C14-004: entry_model phai co 10 fields" }
  if ($rg4 -notmatch 'Hardcode Mapping') { $errors += "C14-004: thieu constraint Hardcode Mapping (CB007)" }
}

# ---------- C14-005: registry.md ----------
$rgmd = Join-Path $c014 'registry.md'
if (Test-Path $rgmd) {
  $rgm = Get-Content -LiteralPath $rgmd -Raw -Encoding utf8
  for ($i = 1; $i -le 15; $i++) {
    $sec = "CR{0:D3}" -f $i
    if ($rgm -notmatch [regex]::Escape($sec)) { $errors += "C14-005: thieu section $sec" }
  }
  foreach ($sec in @('CR003A','CR005A','CR005B','CR008A','CR009A','CR010A')) {
    if ($rgm -notmatch [regex]::Escape($sec)) { $errors += "C14-005: thieu section $sec" }
  }
}

# ---------- C15-001: C015 resources ----------
$c015 = Join-Path $spec3 'C015'
foreach ($f in @('resources.md','capability-resources.yaml','capability-resources.schema.json','capability-resource-model.yaml','capability-resource-categories.yaml','capability-resource-lifecycle.yaml','capability-resource-allocation.yaml','capability-resource-access.yaml','capability-resource-events.yaml','capability-resource-metrics.yaml','capability-resource-validation.yaml')) {
  if (-not (Test-Path (Join-Path $c015 $f))) { $errors += "C15-001: missing C015/$f" }
}

# ---------- C15-002: capability-resources.yaml ----------
$rs15 = Join-Path $c015 'capability-resources.yaml'
if (Test-Path $rs15) {
  $rs = Get-Content -LiteralPath $rs15 -Raw -Encoding utf8
  foreach ($sec in @('philosophy','principles','categories','resource_model','lifecycle','allocation','access','ownership','constraints','registry_reference','traceability','events','metrics')) {
    if ($rs -notmatch "(?m)^${sec}:") { $errors += "C15-002: thieu '$sec'" }
  }
  foreach ($cat in @('Capability','Memory','Compute','Quota','Token')) {
    if ($rs -notmatch [regex]::Escape($cat)) { $warnings += "C15-002: thieu category '$cat'" }
  }
}

# ---------- C15-003: allocation qua binding ----------
if (Test-Path $rs15) {
  $rs3 = Get-Content -LiteralPath $rs15 -Raw -Encoding utf8
  if ($rs3 -notmatch 'CPB-004') { $errors += "C15-003: allocation thieu binding CPB-004 (POL-RES-001)" }
  if ($rs3 -notmatch 'CPB-010') { $errors += "C15-003: access thieu binding CPB-010 (POL-RESACC-001)" }
}

# ---------- C15-004: resource_model 10 fields ----------
if (Test-Path $rs15) {
  $rs4 = Get-Content -LiteralPath $rs15 -Raw -Encoding utf8
  if ($rs4 -notmatch 'fields: \[id, type, category, owner, status, capacity, allocated, quota, references, metadata\]') { $errors += "C15-004: resource_model phai co 10 fields" }
}

# ---------- C15-005: resources.md ----------
$rsmd = Join-Path $c015 'resources.md'
if (Test-Path $rsmd) {
  $rsm = Get-Content -LiteralPath $rsmd -Raw -Encoding utf8
  for ($i = 1; $i -le 17; $i++) {
    $sec = "CRC{0:D3}" -f $i
    if ($rsm -notmatch [regex]::Escape($sec)) { $errors += "C15-005: thieu section $sec" }
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
