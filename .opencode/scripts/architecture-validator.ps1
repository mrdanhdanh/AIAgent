# architecture-validator.ps1
# Validator cho AIOS_ARCHITECTURE.md — 7 tầng kiến trúc
# Checks ARC-001..004 (cấu trúc layer doc)
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate AIOS 7-layer architecture doc.
.DESCRIPTION
  Kiểm tra AIOS_ARCHITECTURE.md đủ 7 layer + map phase 0-25.
  Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$archFile = Join-Path $root 'AIOS_ARCHITECTURE.md'

if (-not (Test-Path $archFile)) { Write-Error "AIOS_ARCHITECTURE.md not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

$text = Get-Content -LiteralPath $archFile -Raw

# ---------- ARC-001: 7 layers ----------
$layers = @('Layer 1 - Kernel','Layer 2 - Data','Layer 3 - Communication',
  'Layer 4 - Intelligence','Layer 5 - Extension','Layer 6 - Operations',
  'Layer 7 - Infrastructure')
foreach ($l in $layers) {
  if ($text -notmatch [regex]::Escape($l)) { $errors += "ARC-001: thieu '$l'" }
}

# ---------- ARC-002: map phase hiện có (0-13) ----------
$existing = @('workflow-runtime','context','artifacts','knowledge-graph','registry',
  'agents','events','simulation','doctor','evolution','plugins','aios-sdk','dashboard')
foreach ($p in $existing) {
  if ($text -notmatch "\.opencode/$p") { $warnings += "ARC-002: thieu map thư mục '$p'" }
}

# ---------- ARC-003: map phase đề xuất (14-25) ----------
$proposed = @('14 Runtime Kernel','16 Resource Manager','17 Model Router','19 Memory Engine',
  '18 Prompt Registry','15 Policy Engine','20 Observability Platform','22 Release Manager',
  '21 AI Evaluation','25 AI Marketplace','23 Multi Workspace','24 Distributed Runtime')
foreach ($p in $proposed) {
  if ($text -notmatch [regex]::Escape($p)) { $warnings += "ARC-003: thieu map phase '$p'" }
}

# ---------- ARC-004: 5 phase xương sống ----------
$spine = @('Runtime Kernel','Capability Registry','Context & Memory Engine',
  'Artifact Store + Event Bus','Knowledge Graph')
foreach ($s in $spine) {
  if ($text -notmatch [regex]::Escape($s)) { $errors += "ARC-004: thieu spine '$s'" }
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== AIOS Architecture Validation (7 layers) ==="
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings  | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)     { ""; "INFOS ($($infos.Count)):";      $infos     | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }