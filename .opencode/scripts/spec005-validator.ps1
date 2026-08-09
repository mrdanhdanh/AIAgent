# spec005-validator.ps1
# Validator cho SPEC-005 — Registry
# Checks R1-001..N (R001 vision, cau truc, traceability)
# ASCII-only (PS 5.1 ANSI). Exit 0 = PASS.
<#
.SYNOPSIS
  Validate SPEC-005 Registry.
.DESCRIPTION
  Kiem tra SPEC-005: README, R001-vision.md, SPEC.yaml.
  Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$spec5 = Join-Path $root '..\docs\specs\SPEC-005'

if (-not (Test-Path $spec5)) { Write-Error "SPEC-005 not found"; exit 1 }

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

# ---------- R1-001: README ----------
foreach ($f in @('README.md')) {
  if (-not (Test-Path (Join-Path $spec5 $f))) { $errors += "R1-001: missing SPEC-005/$f" }
}

# ---------- R1-002: R001 vision ----------
if (-not (Test-Path (Join-Path $spec5 'R001-vision.md'))) { $errors += "R1-002: missing R001-vision.md" }
else {
  $vRaw = Get-Content -LiteralPath (Join-Path $spec5 'R001-vision.md') -Raw -Encoding utf8
  $v = Strip-Diacritics $vRaw
  foreach ($sec in @('Mission','Vision','Position','Design Philosophy','Invariants','Scope')) {
    if ($v -notmatch [regex]::Escape("## $sec")) { $errors += "R1-002: R001 thieu section '$sec'" }
  }
  foreach ($inv in @('Registry la SSOT duy nhat cho Runtime Metadata.','Moi Entry versioned, immutable khi Published (S014 RG010).','Moi Resolution di qua Compatibility + Governance.','Registry khong chua Business Data.','Registry khong dinh nghia lai S014')) {
    if ($v -notmatch [regex]::Escape($inv)) { $warnings += "R1-002: R001 thieu invariant '$inv'" }
  }
}

# ---------- R1-003: frontmatter ----------
$mdFiles = Get-ChildItem -Path $spec5 -Filter '*.md' -Recurse
foreach ($md in $mdFiles) {
  $c = Get-Content -LiteralPath $md.FullName -Raw -Encoding utf8
  if ($c -notmatch '(?m)^---\s*$') { $errors += "R1-003: $($md.Name) thieu frontmatter" }
  elseif ($c -notmatch '(?m)^name:\s*\S+') { $errors += "R1-003: $($md.Name) thieu name trong frontmatter" }
  elseif ($c -notmatch '(?m)^description:') { $errors += "R1-003: $($md.Name) thieu description trong frontmatter" }
}

# ---------- R1-004: encoding (BOM/tab) ----------
foreach ($f in (Get-ChildItem -Path $spec5 -File -Recurse)) {
  $b = [System.IO.File]::ReadAllBytes($f.FullName)
  if ($b.Length -ge 3 -and $b[0] -eq 0xEF -and $b[1] -eq 0xBB) { $warnings += "R1-004: $($f.Name) co BOM" }
  $text = [System.Text.Encoding]::UTF8.GetString($b)
  if ($text -match "`t") { $warnings += "R1-004: $($f.Name) co tab (dung 2-space)" }
}

# ---------- R2-R20: sections ----------
$secChecks = @(
  @{d='R002'; files=@('requirements.md','requirements.yaml','requirements.schema.json','requirement-traceability.yaml','requirement-priority.yaml','requirement-metrics.yaml','requirements-index.yaml','requirement-categories.yaml','requirement-lifecycle.yaml','CHANGELOG.md'); prefix=''; count=0; mdsections=@('Functional Requirements','Non-Functional Requirements','Constraints','Acceptance Criteria')},
  @{d='R003'; files=@('responsibilities.md','responsibilities.yaml','responsibilities.schema.json','ownership.yaml','responsibility-mapping.yaml','responsibility-matrix.yaml','responsibility-registry.yaml'); prefix=''; count=0; mdsections=@('Invariants','Delegation','Responsibilities')},
  @{d='R004'; files=@('boundaries.md','boundaries.yaml','boundaries.schema.json','boundary-matrix.yaml','boundary-ownership-matrix.yaml','boundary-registry.yaml'); prefix=''; count=0; mdsections=@('Hierarchy','Boundaries','Mapping')},
  @{d='R005'; files=@('architecture.md','architecture.yaml','architecture.schema.json','layer-model.yaml','domain-model.yaml','dependency-rules.yaml','communication-rules.yaml','architecture-matrix.yaml','architecture-decision-log.yaml','architecture-registry.yaml'); prefix=''; count=0; mdsections=@('Architectural Decisions','Layers','Domains')},
  @{d='R006'; files=@('components.md','components.yaml','components.schema.json','component-model.yaml','component-lifecycle.yaml','component-ownership.yaml','component-contracts.yaml','component-dependencies.yaml','component-mapping.yaml','component-metrics.yaml','component-validation.yaml','component-registry.yaml'); prefix=''; count=0; mdsections=@('Philosophy','Components','Contracts')},
  @{d='R007'; files=@('contracts.md','contracts.yaml','contracts.schema.json','contract-model.yaml','contract-categories.yaml','contract-types.yaml','contract-compatibility.yaml','contract-mapping.yaml','contract-quality.yaml','contract-anti-patterns.yaml','communication-matrix.yaml','contract-registry.yaml'); prefix=''; count=0; mdsections=@('Contracts','Contract Quality','Anti-patterns')},
  @{d='registry-models'; files=@('README.md','registry-models.yaml','registry-model-registry.yaml','registry-model-relationships.yaml','registry-model-validation.yaml','registry-models.schema.json'); prefix=''; count=0; mdsections=@()},
  @{d='R008'; files=@('data-model.md','registry-data-model.yaml','registry-data.schema.json','registry-entities.yaml','registry-identities.yaml','registry-invariants.yaml','registry-lifecycle.yaml','registry-ownership.yaml','registry-references.yaml','registry-relations.yaml','registry-validation.yaml'); prefix='RDM'; count=15; mdsections=@()},
  @{d='R009'; files=@('state-machine.md','registry-state-machine.yaml','registry.schema.json','registry-states.yaml','registry-transitions.yaml','registry-transition-guards.yaml','registry-transition-triggers.yaml','registry-transition-types.yaml','registry-transition-matrix.yaml','registry-state-events.yaml','registry-state-history.yaml','registry-state-metrics.yaml','registry-state-machine-validation.yaml','registry-state-machine-registry.yaml'); prefix='RS'; count=17; mdsections=@()},
  @{d='R010'; files=@('execution-flow.md','registry-execution-flow.yaml','registry-execution-flow.schema.json','registry-stages.yaml','registry-storage.yaml','registry-resolution.yaml','registry-query.yaml','registry-failure.yaml','registry-lineage.yaml','registry-outcome.yaml','registry-policies.yaml','registry-validation.yaml'); prefix='RF'; count=19; mdsections=@()},
  @{d='R011'; files=@('observability.md','registry-observability.yaml','registry-observability.schema.json','registry-events.yaml','registry-metrics.yaml','registry-traces.yaml','registry-audit.yaml','registry-correlation.yaml','registry-health.yaml','registry-dashboard.yaml','registry-observability-mapping.yaml'); prefix='RO'; count=16; mdsections=@()},
  @{d='R012'; files=@('policies.md','registry-policies.yaml','registry-policies.schema.json','registry-policy-model.yaml','registry-policy-lifecycle.yaml','registry-policy-categories.yaml','registry-policy-resolution.yaml','registry-policy-validation.yaml','registry-policy-traceability.yaml','retry-binding.yaml','timeout-binding.yaml','approval-binding.yaml'); prefix='RPO'; count=17; mdsections=@()},
  @{d='R013'; files=@('governance.md','registry-governance.yaml','registry-governance.schema.json','registry-governance-stack.yaml','registry-binding-enforcement.yaml','registry-governance-matrix.yaml','registry-governance-events.yaml','registry-governance-decisions.yaml','registry-governance-lifecycle.yaml','registry-governance-metrics.yaml','registry-governance-registry.yaml'); prefix='RGV'; count=18; mdsections=@()},
  @{d='R014'; files=@('registry-of-registries.md','registry-of-registries.yaml','registry-of-registries-registry.yaml','registry-of-registries.schema.json'); prefix='RRG'; count=15; mdsections=@()},
  @{d='R015'; files=@('resources.md','registry-resources.yaml','registry-resources.schema.json','registry-resource-model.yaml','registry-resource-categories.yaml','registry-resource-lifecycle.yaml','registry-resource-allocation.yaml','registry-resource-access.yaml','registry-resource-events.yaml','registry-resource-metrics.yaml','registry-resource-validation.yaml'); prefix='RRS'; count=17; mdsections=@()},
  @{d='R016'; files=@('compliance.md','registry-compliance.yaml','registry-compliance.schema.json','registry-validation-rules.yaml','registry-compliance-matrix.yaml','registry-health-score.yaml','registry-readiness-checklist.yaml','registry-certification.yaml','registry-compliance-events.yaml','registry-compliance-metrics.yaml','registry-compliance-report.yaml'); prefix='RMC'; count=16; mdsections=@()},
  @{d='R017'; files=@('extensions.md','registry-extensions.yaml','registry-extensions.schema.json','registry-extension-model.yaml','registry-extension-categories.yaml','registry-extension-lifecycle.yaml','registry-extension-installation.yaml','registry-extension-isolation.yaml','registry-extension-events.yaml','registry-extension-metrics.yaml','registry-extension-validation.yaml'); prefix='RXE'; count=17; mdsections=@()},
  @{d='R018'; files=@('evolution.md','registry-evolution.yaml','registry-evolution.schema.json','registry-evolution-scope.yaml','registry-evolution-pipeline.yaml','registry-evolution-proposal.yaml','registry-evolution-approval.yaml','registry-evolution-events.yaml','registry-evolution-metrics.yaml','registry-evolution-validation.yaml'); prefix='RVE'; count=16; mdsections=@()},
  @{d='R019'; files=@('doctor.md','registry-doctor.yaml','registry-doctor.schema.json','registry-doctor-scope.yaml','registry-doctor-checks.yaml','registry-doctor-pipeline.yaml','registry-doctor-self-repair.yaml','registry-doctor-report.yaml','registry-doctor-events.yaml','registry-doctor-metrics.yaml','registry-doctor-validation.yaml'); prefix='RDR'; count=16; mdsections=@()},
  @{d='R020'; files=@('dashboard.md','registry-dashboard.yaml','registry-dashboard.schema.json','registry-dashboard-scope.yaml','registry-dashboard-views.yaml','registry-dashboard-read-model.yaml','registry-dashboard-refresh.yaml','registry-dashboard-events.yaml','registry-dashboard-metrics.yaml','registry-dashboard-validation.yaml'); prefix='RDB'; count=16; mdsections=@()}
)
$i = 2
foreach ($sc in $secChecks) {
  $dir = Join-Path $spec5 $sc.d
  foreach ($f in $sc.files) {
    if (-not (Test-Path (Join-Path $dir $f))) { $errors += "R$i-001: missing $($sc.d)/$f" }
  }
  if ($sc.prefix -ne '' -and $sc.count -gt 0) {
    $mdFile = Get-ChildItem -Path $dir -Filter '*.md' | Where-Object { $_.Name -ne 'CHANGELOG.md' } | Select-Object -First 1
    if ($mdFile) {
      $mm = Get-Content -LiteralPath $mdFile.FullName -Raw -Encoding utf8
      for ($j = 1; $j -le $sc.count; $j++) {
        $sec = "{0}{1:D3}" -f $sc.prefix, $j
        if ($mm -notmatch [regex]::Escape($sec)) { $errors += "R$i-005: $($sc.d) thieu section $sec" }
      }
    }
  }
  foreach ($ms in $sc.mdsections) {
    $mdFile = Get-ChildItem -Path $dir -Filter '*.md' | Where-Object { $_.Name -ne 'CHANGELOG.md' } | Select-Object -First 1
    if ($mdFile) {
      $mm = Get-Content -LiteralPath $mdFile.FullName -Raw -Encoding utf8
      if ($mm -notmatch "(?m)^## $([regex]::Escape($ms))") { $errors += "R$i-005: $($sc.d) thieu section '$ms'" }
    }
  }
  $i++
}

# ---------- R1-005: SPEC.yaml ----------
$specFile = Join-Path $spec5 'SPEC.yaml'
if (Test-Path $specFile) {
  $st = Get-Content -LiteralPath $specFile -Raw -Encoding utf8
  if ($st -notmatch '(?m)^id:\s*SPEC-005') { $errors += "R1-005: SPEC.yaml id phai la SPEC-005" }
  if ($st -notmatch '(?m)^implements:') { $errors += "R1-005: SPEC.yaml thieu implements" }
  foreach ($d in @('SPEC-000','SPEC-001')) { if ($st -notmatch [regex]::Escape($d)) { $errors += "R1-005: thieu dependency $d" } }
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== SPEC-005 Registry Validation ==="
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)     { ""; "INFOS ($($infos.Count)):";      $infos     | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }
