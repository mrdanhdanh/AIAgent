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
