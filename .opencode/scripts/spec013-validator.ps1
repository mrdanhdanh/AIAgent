# spec013-validator.ps1
# Validator cho SPEC-013 — Evolution
# Checks X1-001..005 (X001 vision, cau truc, traceability) + X2-001..005 (sections)
# ASCII-only (PS 5.1 ANSI). Exit 0 = PASS.
<#
.SYNOPSIS
  Validate SPEC-013 Evolution.
.DESCRIPTION
  Kiem tra SPEC-013: README, X001-vision.md, SPEC.yaml va cac section X002-X020.
  Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$spec7 = Join-Path $root '..\docs\specs\SPEC-013'

if (-not (Test-Path $spec7)) { Write-Error "SPEC-013 not found"; exit 1 }

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

# ---------- X1-001: README ----------
foreach ($f in @('README.md')) {
  if (-not (Test-Path (Join-Path $spec7 $f))) { $errors += "X1-001: missing SPEC-013/$f" }
}

# ---------- X1-002: X001 vision ----------
if (-not (Test-Path (Join-Path $spec7 'X001-vision.md'))) { $errors += "X1-002: missing X001-vision.md" }
else {
  $vRaw = Get-Content -LiteralPath (Join-Path $spec7 'X001-vision.md') -Raw -Encoding utf8
  $v = Strip-Diacritics $vRaw
  foreach ($sec in @('Mission','Vision','Position','Design Philosophy','Invariants','Scope')) {
    if ($v -notmatch [regex]::Escape("## $sec")) { $errors += "X1-002: X001 thieu section '$sec'" }
  }
  foreach ($inv in @('Evolution khong pha vo he thong (P013).','Moi thay doi giu backward compatibility.','Moi thay doi co migration plan.','Evolution khong chua Business Data (S011 OB003A).')) {
    if ($v -notmatch [regex]::Escape($inv)) { $warnings += "X1-002: X001 thieu invariant '$inv'" }
  }
}

# ---------- X1-003: frontmatter ----------
$mdFiles = Get-ChildItem -Path $spec7 -Filter '*.md' -Recurse
foreach ($md in $mdFiles) {
  $c = Get-Content -LiteralPath $md.FullName -Raw -Encoding utf8
  if ($c -notmatch '(?m)^---\s*$') { $errors += "X1-003: $($md.Name) thieu frontmatter" }
  elseif ($c -notmatch '(?m)^name:\s*\S+') { $errors += "X1-003: $($md.Name) thieu name trong frontmatter" }
  elseif ($c -notmatch '(?m)^description:') { $errors += "X1-003: $($md.Name) thieu description trong frontmatter" }
}

# ---------- X1-004: encoding (BOM/tab) ----------
foreach ($f in (Get-ChildItem -Path $spec7 -File -Recurse)) {
  $b = [System.IO.File]::ReadAllBytes($f.FullName)
  if ($b.Length -ge 3 -and $b[0] -eq 0xEF -and $b[1] -eq 0xBB) { $warnings += "X1-004: $($f.Name) co BOM" }
  $text = [System.Text.Encoding]::UTF8.GetString($b)
  if ($text -match "`t") { $warnings += "X1-004: $($f.Name) co tab (dung 2-space)" }
}

# ---------- X1-005: SPEC.yaml ----------
$specFile = Join-Path $spec7 'SPEC.yaml'
if (Test-Path $specFile) {
  $st = Get-Content -LiteralPath $specFile -Raw -Encoding utf8
  if ($st -notmatch '(?m)^id:\s*SPEC-013') { $errors += "X1-005: SPEC.yaml id phai la SPEC-013" }
  if ($st -notmatch '(?m)^implements:') { $errors += "X1-005: SPEC.yaml thieu implements" }
  foreach ($d in @('SPEC-000','SPEC-001','SPEC-005')) { if ($st -notmatch [regex]::Escape($d)) { $errors += "X1-005: thieu dependency $d" } }
}

# ---------- X2-001: X002-X020 section files ----------
$required = @{
  'X002' = @('requirements.md','requirements.yaml','requirements.schema.json')
  'X003' = @('responsibilities.md','responsibilities.yaml','responsibilities.schema.json')
  'X004' = @('boundaries.md','boundaries.yaml','boundaries.schema.json')
  'X005' = @('architecture.md','architecture.yaml','architecture.schema.json')
  'X006' = @('components.md','components.yaml','components.schema.json')
  'X007' = @('contracts.md','contracts.yaml','contracts.schema.json')
  'X008' = @('data-model.md','Evolution-data-model.yaml','Evolution-data.schema.json')
  'X009' = @('state-machine.md','Evolution-states.yaml','Evolution-transitions.yaml','Evolution.schema.json')
  'X010' = @('execution-flow.md','Evolution-execution-flow.yaml','Evolution-execution-flow.schema.json')
  'X011' = @('observability.md','Evolution-events.yaml','Evolution-observability.schema.json')
  'X012' = @('policies.md','Evolution-policies.yaml','Evolution-policies.schema.json')
  'X013' = @('governance.md','Evolution-governance.yaml','Evolution-governance.schema.json')
  'X014' = @('registry.md','Evolution-registry.yaml','Evolution-registry.schema.json')
  'X015' = @('resources.md','Evolution-resource-model.yaml','Evolution-resources.schema.json')
  'X016' = @('compliance.md','Evolution-compliance.yaml','Evolution-compliance.schema.json')
  'X017' = @('extensions.md','Evolution-extensions.yaml')
  'X018' = @('evolution.md','Evolution-versioning.yaml')
  'X019' = @('doctor.md','Evolution-doctor-checks.yaml')
  'X020' = @('dashboard.md','Evolution-dashboard-panels.yaml')
}
foreach ($d in $required.Keys) {
  foreach ($f in $required[$d]) {
    if (-not (Test-Path (Join-Path $spec7 (Join-Path $d $f)))) { $errors += "X2-001: missing SPEC-013/$d/$f" }
  }
}

# ---------- X2-002: appendix Evolution-models ----------
$cm = Join-Path $spec7 'Evolution-models'
foreach ($f in @('README.md','Evolution-models.yaml','Evolution-models.schema.json')) {
  if (-not (Test-Path (Join-Path $cm $f))) { $errors += "X2-002: missing Evolution-models/$f" }
}

# ---------- X2-003: section content markers ----------
function Assert-Contains($file, $pattern, $label) {
  if (Test-Path $file) {
    $c = Get-Content -LiteralPath $file -Raw -Encoding utf8
    if ($c -notmatch $pattern) { $errors += "X2-003: $label thieu '$pattern'" }
  }
}
Assert-Contains (Join-Path $spec7 'X002\requirements.yaml') '(?m)^functional:' 'X002'
Assert-Contains (Join-Path $spec7 'X008\Evolution-entities.yaml') '(?m)^entities:' 'X008'
Assert-Contains (Join-Path $spec7 'X009\Evolution-states.yaml') '(?m)^initial_state:' 'X009'
Assert-Contains (Join-Path $spec7 'X010\Evolution-execution-flow.yaml') '(?m)^stages:' 'X010'
Assert-Contains (Join-Path $spec7 'X011\Evolution-events.yaml') '(?m)^definition_events:' 'X011'
Assert-Contains (Join-Path $spec7 'X012\Evolution-policies.yaml') '(?m)^policies:' 'X012'
Assert-Contains (Join-Path $spec7 'X016\Evolution-compliance.yaml') '(?m)^compliance_rules:' 'X016'
Assert-Contains (Join-Path $spec7 'X019\Evolution-doctor-checks.yaml') '(?m)^checks:' 'X019'

# ---------- X2-004: YAML parseable (subset) ----------
$yamls = Get-ChildItem -Path $spec7 -Filter '*.yaml' -Recurse
foreach ($yf in $yamls) {
  $lines = Get-Content -LiteralPath $yf.FullName -Encoding utf8
  foreach ($ln in $lines) {
    if ($ln -match '^\s+-\s*$') { $warnings += "X2-004: $($yf.Name) co list item rong" }
  }
  if ($lines.Count -lt 3) { $warnings += "X2-004: $($yf.Name) qua ngan (suspect)" }
}

# ---------- X2-005: cross-references ----------
$specRefs = @('SPEC-000','SPEC-001','SPEC-005')
foreach ($d in $required.Keys) {
  $mdFile = Join-Path $spec7 (Join-Path $d (($required[$d] | Where-Object { $_ -like '*.md' })))
  if (Test-Path $mdFile) {
    $c = Get-Content -LiteralPath $mdFile -Raw -Encoding utf8
    $hasSpecRef = $false
    foreach ($r in $specRefs) { if ($c -match [regex]::Escape($r)) { $hasSpecRef = $true } }
    if (-not $hasSpecRef) { $warnings += "X2-005: $d khong tham chieu SPEC-000/001/005" }
  }
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== SPEC-013 Evolution Validation ==="
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)     { ""; "INFOS ($($infos.Count)):";      $infos     | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }
