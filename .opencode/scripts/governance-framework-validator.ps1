# governance-framework-validator.ps1
# Validator cho Governance Framework (D005)
# Checks GOV-001..008 (14 policies, 6 lifecycles, decisions, templates, registries)
# ASCII-only (PS 5.1 ANSI).
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate AIOS Governance Framework (D005).
.DESCRIPTION
  Kiem tra docs/governance/ co du 14 policies, 6 lifecycles, decisions, templates,
  governance-registry.yaml, INDEX.yaml, 5 support registries. Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$govDir = Join-Path $root '..\docs\governance'

if (-not (Test-Path $govDir)) { Write-Error "governance/ not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

# ---------- GOV-001: 14 policy files ----------
$policies = @(
  @{ id='POLICY-001'; file='policies/POLICY-001-approval.md' },
  @{ id='POLICY-002'; file='policies/POLICY-002-version.md' },
  @{ id='POLICY-003'; file='policies/POLICY-003-compatibility.md' },
  @{ id='POLICY-004'; file='policies/POLICY-004-deprecation.md' },
  @{ id='POLICY-005'; file='policies/POLICY-005-release.md' },
  @{ id='POLICY-006'; file='policies/POLICY-006-documentation.md' },
  @{ id='POLICY-007'; file='policies/POLICY-007-naming.md' },
  @{ id='POLICY-008'; file='policies/POLICY-008-plugin.md' },
  @{ id='POLICY-009'; file='policies/POLICY-009-security.md' },
  @{ id='POLICY-010'; file='policies/POLICY-010-quality.md' },
  @{ id='POLICY-011'; file='policies/POLICY-011-traceability.md' },
  @{ id='POLICY-012'; file='policies/POLICY-012-ownership.md' },
  @{ id='POLICY-013'; file='policies/POLICY-013-change-impact-analysis.md' },
  @{ id='POLICY-014'; file='policies/POLICY-014-exception.md' }
)
foreach ($p in $policies) {
  if (-not (Test-Path (Join-Path $govDir $p.file))) {
    $errors += "GOV-001: missing $($p.file)"
  }
}

# ---------- GOV-002: policy template ----------
$template = @('id','name','status','version','category','scope','statement','purpose',
  'rules','allowed','forbidden','related_principles','examples')
foreach ($p in $policies) {
  $f = Join-Path $govDir $p.file
  if (-not (Test-Path $f)) { continue }
  $text = Get-Content -LiteralPath $f -Raw -Encoding utf8
  foreach ($field in $template) {
    if ($text -notmatch "(?m)^$field\s*:") { $errors += "GOV-002: $($p.file) thieu field '$field'" }
  }
  if ($text -notmatch "(?m)^id:\s*$($p.id)\b") { $errors += "GOV-002: $($p.file) id phai la $($p.id)" }
  if ($text -notmatch '(?m)^  applies_to:') { $errors += "GOV-002: $($p.file) thieu scope.applies_to" }
}

# ---------- GOV-003: 6 lifecycle files ----------
$lifecycles = @('entity-lifecycle.md','workflow-lifecycle.md','plugin-lifecycle.md',
  'artifact-lifecycle.md','specification-lifecycle.md','policy-lifecycle.md')
foreach ($l in $lifecycles) {
  if (-not (Test-Path (Join-Path $govDir "lifecycle\$l"))) { $errors += "GOV-003: missing lifecycle/$l" }
}

# ---------- GOV-004: decisions ----------
foreach ($d in @('ADR.md','RFC.md','DECISION_TREE.md')) {
  if (-not (Test-Path (Join-Path $govDir "decisions\$d"))) { $errors += "GOV-004: missing decisions/$d" }
}

# ---------- GOV-005: templates ----------
foreach ($t in @('ADR-template.md','RFC-template.md','CHANGELOG-template.md')) {
  if (-not (Test-Path (Join-Path $govDir "templates\$t"))) { $errors += "GOV-005: missing templates/$t" }
}

# ---------- GOV-006: registry + index + schema + readme ----------
foreach ($f in @('governance-registry.yaml','INDEX.yaml','governance.schema.json','README.md','CHANGELOG.md')) {
  if (-not (Test-Path (Join-Path $govDir $f))) { $errors += "GOV-006: thieu $f" }
}
$reg = Get-Content -LiteralPath (Join-Path $govDir 'governance-registry.yaml') -Raw -Encoding utf8
if ($reg -notmatch '(?m)^policies:') { $errors += "GOV-006: registry thieu policies" }
if ($reg -notmatch '(?m)^lifecycle:') { $errors += "GOV-006: registry thieu lifecycle" }
if ($reg -notmatch '(?m)^decision:') { $errors += "GOV-006: registry thieu decision" }
if ($reg -notmatch '(?m)^events:') { $warnings += "GOV-006: registry thieu events" }

# ---------- GOV-007: support registries ----------
foreach ($f in @('roles.yaml','compliance.yaml','review-cycle.yaml','metrics.yaml','audit-policy.yaml')) {
  if (-not (Test-Path (Join-Path $govDir $f))) { $errors += "GOV-007: thieu $f" }
}
$roles = Get-Content -LiteralPath (Join-Path $govDir 'roles.yaml') -Raw -Encoding utf8
if ($roles -notmatch '(?m)^roles:') { $errors += "GOV-007: roles.yaml thieu roles" }
$comp = Get-Content -LiteralPath (Join-Path $govDir 'compliance.yaml') -Raw -Encoding utf8
if ($comp -notmatch '(?m)^compliance:') { $errors += "GOV-007: compliance.yaml thieu compliance" }
if ($comp -notmatch '(?m)^principles_mapping:') { $warnings += "GOV-007: compliance thieu principles_mapping" }
$rc = Get-Content -LiteralPath (Join-Path $govDir 'review-cycle.yaml') -Raw -Encoding utf8
if ($rc -notmatch '(?m)^review_cycle:') { $errors += "GOV-007: review-cycle.yaml thieu review_cycle" }
$met = Get-Content -LiteralPath (Join-Path $govDir 'metrics.yaml') -Raw -Encoding utf8
if ($met -notmatch '(?m)^metrics:') { $errors += "GOV-007: metrics.yaml thieu metrics" }
$aud = Get-Content -LiteralPath (Join-Path $govDir 'audit-policy.yaml') -Raw -Encoding utf8
if ($aud -notmatch '(?m)^audit_trail:') { $errors += "GOV-007: audit-policy.yaml thieu audit_trail" }
if ($aud -notmatch '(?m)^events:') { $warnings += "GOV-007: audit-policy thieu events" }

# ---------- GOV-008: emergency path ----------
$tree = Get-Content -LiteralPath (Join-Path $govDir 'decisions\DECISION_TREE.md') -Raw -Encoding utf8
if ($tree -notmatch 'Emergency Path') { $warnings += "GOV-008: DECISION_TREE thieu Emergency Path" }

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== Governance Framework Validation (D005) ==="
  "policy files: $($policies.Count)"
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }
