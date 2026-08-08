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
