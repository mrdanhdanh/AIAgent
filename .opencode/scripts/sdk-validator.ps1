# sdk-validator.ps1
# Validator cho Phase 13 — AIOS SDK
# Checks SDK-001..004 (cấu trúc aios-sdk/)
# Parser YAML subset thủ công (không ConvertFrom-Yaml).
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate AIOS SDK structure + schema.
.DESCRIPTION
  Kiểm tra aios-sdk.schema.yaml và 11 SDK components.
  Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$sdkDir = Join-Path $root 'aios-sdk'

if (-not (Test-Path $sdkDir)) { Write-Error "aios-sdk/ not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

# ---------- SDK-001: schema ----------
if (-not (Test-Path (Join-Path $sdkDir 'aios-sdk.schema.yaml'))) {
  $errors += "SDK-001: missing aios-sdk.schema.yaml"
}

# ---------- SDK-002: schema fields ----------
$schemaFile = Join-Path $sdkDir 'aios-sdk.schema.yaml'
if (Test-Path $schemaFile) {
  $sText = Get-Content -LiteralPath $schemaFile -Raw
  foreach ($req in @('version','components')) {
    if ($sText -notmatch "(?m)^  - $req\b") {
      $errors += "SDK-002: schema thieu required field '$req'"
    }
  }
}

# ---------- SDK-003: components ----------
$components = @('agent','plugin','workflow','context','artifact','event',
  'registry','doctor','simulation','evolution','dashboard')

foreach ($c in $components) {
  if (-not (Test-Path (Join-Path $sdkDir "$c-sdk.md"))) {
    $errors += "SDK-003: missing $c-sdk.md"
  }
}

# ---------- SDK-004: core modules ----------
foreach ($m in @('README.md','architecture.md','security.md','versioning.md','tests.md')) {
  if (-not (Test-Path (Join-Path $sdkDir $m))) {
    $errors += "SDK-004: missing module $m"
  }
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== AIOS SDK Validation (Phase 13) ==="
  "components: $($components.Count)"
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings  | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)     { ""; "INFOS ($($infos.Count)):";      $infos     | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }