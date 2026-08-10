# spec015-validator.ps1
# Validator cho SPEC-015 — SDK
# Checks X1-001..005 (X001 vision, cau truc, traceability) + X2-001..005 (sections)
# ASCII-only (PS 5.1 ANSI). Exit 0 = PASS.
<#
.SYNOPSIS
  Validate SPEC-015 SDK.
.DESCRIPTION
  Kiem tra SPEC-015: README, X001-vision.md, SPEC.yaml va cac section X002-X020.
  Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$spec7 = Join-Path $root '..\docs\specs\SPEC-015'

if (-not (Test-Path $spec7)) { Write-Error "SPEC-015 not found"; exit 1 }

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
  if (-not (Test-Path (Join-Path $spec7 $f))) { $errors += "X1-001: missing SPEC-015/$f" }
}

# ---------- X1-002: X001 vision ----------
if (-not (Test-Path (Join-Path $spec7 'X001-vision.md'))) { $errors += "X1-002: missing X001-vision.md" }
else {
  $vRaw = Get-Content -LiteralPath (Join-Path $spec7 'X001-vision.md') -Raw -Encoding utf8
  $v = Strip-Diacritics $vRaw
  foreach ($sec in @('Mission','Vision','Position','Design Philosophy','Invariants','Scope')) {
    if ($v -notmatch [regex]::Escape("## $sec")) { $errors += "X1-002: X001 thieu section '$sec'" }
  }
  foreach ($inv in @('SDK truy cap AIOS qua Contract - khong vao Core truc tiep (P006).','SDK cung cap typed client cho 11 components.','SDK version theo semver (aios-sdk v13).','SDK khong chua Business Data (S011 OB003A).')) {
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
  if ($st -notmatch '(?m)^id:\s*SPEC-015') { $errors += "X1-005: SPEC.yaml id phai la SPEC-015" }
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
  'X008' = @('data-model.md','SDK-data-model.yaml','SDK-data.schema.json')
  'X009' = @('state-machine.md','SDK-states.yaml','SDK-transitions.yaml','SDK.schema.json')
  'X010' = @('execution-flow.md','SDK-execution-flow.yaml','SDK-execution-flow.schema.json')
  'X011' = @('observability.md','SDK-events.yaml','SDK-observability.schema.json')
  'X012' = @('policies.md','SDK-policies.yaml','SDK-policies.schema.json')
  'X013' = @('governance.md','SDK-governance.yaml','SDK-governance.schema.json')
  'X014' = @('registry.md','SDK-registry.yaml','SDK-registry.schema.json')
  'X015' = @('resources.md','SDK-resource-model.yaml','SDK-resources.schema.json')
  'X016' = @('compliance.md','SDK-compliance.yaml','SDK-compliance.schema.json')
  'X017' = @('extensions.md','SDK-extensions.yaml')
  'X018' = @('evolution.md','sdk-evolution-metrics.yaml')
  'X019' = @('doctor.md','SDK-doctor-checks.yaml')
  'X020' = @('dashboard.md','sdk-panels.yaml')
}
foreach ($d in $required.Keys) {
  foreach ($f in $required[$d]) {
    if (-not (Test-Path (Join-Path $spec7 (Join-Path $d $f)))) { $errors += "X2-001: missing SPEC-015/$d/$f" }
  }
}

# ---------- X2-002: appendix SDK-models ----------
$cm = Join-Path $spec7 'SDK-models'
foreach ($f in @('README.md','SDK-models.yaml','SDK-models.schema.json')) {
  if (-not (Test-Path (Join-Path $cm $f))) { $errors += "X2-002: missing SDK-models/$f" }
}

# ---------- X2-003: section content markers ----------
function Assert-Contains($file, $pattern, $label) {
  if (Test-Path $file) {
    $c = Get-Content -LiteralPath $file -Raw -Encoding utf8
    if ($c -notmatch $pattern) { $errors += "X2-003: $label thieu '$pattern'" }
  }
}
Assert-Contains (Join-Path $spec7 'X002\requirements.yaml') '(?m)^functional:' 'X002'
Assert-Contains (Join-Path $spec7 'X008\SDK-entities.yaml') '(?m)^entities:' 'X008'
Assert-Contains (Join-Path $spec7 'X009\SDK-states.yaml') '(?m)^initial_state:' 'X009'
Assert-Contains (Join-Path $spec7 'X010\SDK-execution-flow.yaml') '(?m)^stages:' 'X010'
Assert-Contains (Join-Path $spec7 'X011\SDK-events.yaml') '(?m)^definition_events:' 'X011'
Assert-Contains (Join-Path $spec7 'X012\SDK-policies.yaml') '(?m)^policies:' 'X012'
Assert-Contains (Join-Path $spec7 'X016\SDK-compliance.yaml') '(?m)^compliance_rules:' 'X016'
Assert-Contains (Join-Path $spec7 'X019\SDK-doctor-checks.yaml') '(?m)^checks:' 'X019'

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
  "=== SPEC-015 SDK Validation ==="
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)     { ""; "INFOS ($($infos.Count)):";      $infos     | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }
