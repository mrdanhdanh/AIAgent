# principles-validator.ps1
# Validator cho Principles (D003)
# Checks PRN-001..005 (20 principle files, template, INDEX.yaml, README)
# ASCII-only (PS 5.1 ANSI).
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate AIOS Core Principles.
.DESCRIPTION
  Kiem tra 20 principle files P001-P020, template D003, INDEX.yaml, README.
  Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$prinDir = Join-Path $root '..\docs\principles'

if (-not (Test-Path $prinDir)) { Write-Error "principles/ not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

# ---------- PRN-001: 20 principle files ----------
$principles = @(
  @{ id='P001'; file='P001-runtime-first.md' },
  @{ id='P002'; file='P002-contract-first.md' },
  @{ id='P003'; file='P003-metadata-first.md' },
  @{ id='P004'; file='P004-everything-is-versioned.md' },
  @{ id='P005'; file='P005-event-driven.md' },
  @{ id='P006'; file='P006-stateless-agent.md' },
  @{ id='P007'; file='P007-capability-driven.md' },
  @{ id='P008'; file='P008-single-responsibility.md' },
  @{ id='P009'; file='P009-single-source-of-truth.md' },
  @{ id='P010'; file='P010-immutable-artifact.md' },
  @{ id='P011'; file='P011-explicit-dependency.md' },
  @{ id='P012'; file='P012-plugin-first.md' },
  @{ id='P013'; file='P013-simulation-before-execution.md' },
  @{ id='P014'; file='P014-observability-first.md' },
  @{ id='P015'; file='P015-fail-safe.md' },
  @{ id='P016'; file='P016-human-approval.md' },
  @{ id='P017'; file='P017-ai-native.md' },
  @{ id='P018'; file='P018-evolvable.md' },
  @{ id='P019'; file='P019-open-extension-closed-core.md' },
  @{ id='P020'; file='P020-constitution-first.md' }
)
foreach ($p in $principles) {
  if (-not (Test-Path (Join-Path $prinDir $p.file))) {
    $errors += "PRN-001: missing $($p.file)"
  }
}

# ---------- PRN-002: template fields per file ----------
$template = @('id','name','status','category','statement','rationale',
  'rules','implications','anti_patterns','exceptions','related','examples')
foreach ($p in $principles) {
  $f = Join-Path $prinDir $p.file
  if (-not (Test-Path $f)) { continue }
  $text = Get-Content -LiteralPath $f -Raw -Encoding utf8
  foreach ($field in $template) {
    if ($text -notmatch "(?m)^$field\s*:") { $errors += "PRN-002: $($p.file) thieu field '$field'" }
  }
  # id dung
  if ($text -notmatch "(?m)^id:\s*$($p.id)\b") { $errors += "PRN-002: $($p.file) id phai la $($p.id)" }
}

# ---------- PRN-003: metadata them (severity, enforced_by, related) ----------
foreach ($p in $principles) {
  $f = Join-Path $prinDir $p.file
  if (-not (Test-Path $f)) { continue }
  $text = Get-Content -LiteralPath $f -Raw -Encoding utf8
  foreach ($field in @('severity','enforced_by','implemented_in','breaking_change')) {
    if ($text -notmatch "(?m)^$field\s*:") { $warnings += "PRN-003: $($p.file) thieu metadata '$field'" }
  }
}

# ---------- PRN-004: INDEX.yaml ----------
$index = Join-Path $prinDir 'INDEX.yaml'
if (-not (Test-Path $index)) {
  $errors += "PRN-004: missing INDEX.yaml"
} else {
  $it = Get-Content -LiteralPath $index -Raw -Encoding utf8
  if ($it -notmatch '(?m)^principles:') { $errors += "PRN-004: INDEX.yaml thieu 'principles:'" }
  if ($it -notmatch '(?m)^dependencies:') { $errors += "PRN-004: INDEX.yaml thieu 'dependencies:'" }
  if ($it -notmatch '(?m)^categories:') { $errors += "PRN-004: INDEX.yaml thieu 'categories:'" }
  foreach ($p in $principles) {
    if ($it -notmatch [regex]::Escape($p.id)) { $warnings += "PRN-004: INDEX.yaml thieu $($p.id)" }
  }
}

# ---------- PRN-005: README.md ----------
if (-not (Test-Path (Join-Path $prinDir 'README.md'))) {
  $errors += "PRN-005: missing README.md"
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== Principles Validation (D003) ==="
  "principle files: $($principles.Count)"
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }
