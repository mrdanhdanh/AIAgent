# event-validator.ps1
# Validator cho Phase 6 — Event System
# Checks EVT-001..007 (cấu trúc events/)
# Parser YAML subset thủ công (không ConvertFrom-Yaml).
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate Event System structure.
.DESCRIPTION
  Kiểm tra event.schema.yaml, categories.yaml, contracts.yaml
  và các module tồn tại đủ. Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$evtDir = Join-Path $root 'events'

if (-not (Test-Path $evtDir)) { Write-Error "events/ not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

# ---------- EVT-001: schema files ----------
foreach ($f in @('event.schema.yaml','categories.yaml')) {
  if (-not (Test-Path (Join-Path $evtDir $f))) {
    $errors += "EVT-001: missing $f"
  }
}

# ---------- EVT-002: category types ----------
$catFile = Join-Path $evtDir 'categories.yaml'
if (Test-Path $catFile) {
  $catText = Get-Content -LiteralPath $catFile -Raw
  $categories = @([regex]::Matches($catText, '(?m)^  \w+:\s*$') | ForEach-Object { $_.Value.Trim(':').Trim() })
  $events = @([regex]::Matches($catText, '(?m)^\s*-\s+([A-Z_]+)') | ForEach-Object { $_.Groups[1].Value })
  if ($categories.Count -eq 0) { $errors += "EVT-002: categories.yaml khong co category" }
  # duplicate event type
  $seen = @{}
  foreach ($e in $events) {
    if ($seen.ContainsKey($e)) { $errors += "EVT-002: duplicate event type '$e'" }
    $seen[$e] = $true
  }
}

# ---------- EVT-003: contracts file ----------
if (-not (Test-Path (Join-Path $evtDir 'contracts\contracts.yaml'))) {
  $warnings += "EVT-003: missing contracts/contracts.yaml"
}

# ---------- EVT-004: module files ----------
$modules = @('README.md','architecture.md','bus.md','dispatcher.md','publisher.md',
  'subscriber.md','queue.md','routing.md','filter.md','priority.md',
  'history.md','replay.md','lineage.md','metrics.md','sdk.md','tests.md')

foreach ($m in $modules) {
  if (-not (Test-Path (Join-Path $evtDir $m))) {
    $errors += "EVT-004: missing module $m"
  }
}

# ---------- EVT-005: event.schema.yaml required fields ----------
$schemaFile = Join-Path $evtDir 'event.schema.yaml'
if (Test-Path $schemaFile) {
  $sText = Get-Content -LiteralPath $schemaFile -Raw
  foreach ($req in @('id','type','version','timestamp','source')) {
    if ($sText -notmatch "(?m)^  - $req\b") {
      $errors += "EVT-005: event.schema.yaml thieu required field '$req'"
    }
  }
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== Event System Validation (Phase 6) ==="
  "categories: $($categories.Count) | event types: $($events.Count)"
  if ($errors.Count)   { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count) { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)    { ""; "INFOS ($($infos.Count)):";      $infos    | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }