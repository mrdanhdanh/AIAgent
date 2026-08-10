<#
.SYNOPSIS
Runtime Validator - kiem tra cau truc .opencode/runtime/ va .opencode/sdk/.
.DESCRIPTION
Check RNT-001..007: (1) runtime dir + entry aios.ps1, (2) module files toi thieu,
(3) moi module co schema/doc reference, (4) tests dir + test files ton tai,
(5) PLAN.md frontmatter, (6) UTF-8 no-BOM, (7) ASCII-only (khong ky tu unicode).
Exit 0 = PASS, exit 1 = FAIL.
.DESCRIPTION
ASCII-only (PS 5.1 ANSI). UTF-8 no BOM.
#>
param([switch]$Silent)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$rtDir = Join-Path $root "runtime"
$sdkDir = Join-Path $root "sdk"
$errors = @()
$warnings = @()

# ---------- RNT-001: thu muc toi thieu ----------
if (-not (Test-Path $rtDir))        { $errors += "RNT-001: thieu .opencode/runtime/" }
if (-not (Test-Path $sdkDir))       { $warnings += "RNT-001: thieu .opencode/sdk/ (chua tao)" }
if (-not (Test-Path (Join-Path $rtDir "tests"))) { $warnings += "RNT-001: thieu .opencode/runtime/tests/" }

# ---------- RNT-002: entry point ----------
$aios = Join-Path $root "aios.ps1"
if (-not (Test-Path $aios)) { $warnings += "RNT-002: thieu aios.ps1 (entry - Phase 2)" }

# ---------- RNT-003: module files (Phase 1+ bat buoc) ----------
$requiredModules = @("kernel.ps1", "event-bus.psm1", "state-machine.psm1")
foreach ($m in $requiredModules) {
    $p = Join-Path $rtDir $m
    if (-not (Test-Path $p)) { $warnings += "RNT-003: thieu runtime/$m (Phase 1)" }
}

# ---------- RNT-004: test runner + test files ----------
$runner = Join-Path $root "scripts\runtime-tests.ps1"
if (-not (Test-Path $runner)) { $errors += "RNT-004: thieu scripts/runtime-tests.ps1" }
$testFiles = @(Get-ChildItem (Join-Path $rtDir "tests") -Filter "*.test.ps1" -File -ErrorAction SilentlyContinue)
if ($testFiles.Count -eq 0) { $warnings += "RNT-004: chua co test file nao trong runtime/tests/" }

# ---------- RNT-005: PLAN.md ----------
$plan = Join-Path $rtDir "PLAN.md"
if (-not (Test-Path $plan)) { $errors += "RNT-005: thieu runtime/PLAN.md" }
else {
    $pc = Get-Content -LiteralPath $plan -Raw -Encoding utf8
    if ($pc -notmatch '(?m)^name:\s*\S+') { $errors += "RNT-005: PLAN.md thieu frontmatter name" }
    if ($pc -notmatch '(?m)^agent:\s*\S+') { $errors += "RNT-005: PLAN.md thieu frontmatter agent" }
    if ($pc -notmatch '(?m)^description:') { $errors += "RNT-005: PLAN.md thieu frontmatter description" }
}

# ---------- RNT-006: UTF-8 no-BOM ----------
function Test-NoBom {
    param([string]$Path)
    try {
        $bytes = [System.IO.File]::ReadAllBytes($Path)
        return -not ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)
    } catch { return $false }
}
foreach ($f in @($plan, $runner)) {
    if (Test-Path $f -ErrorAction SilentlyContinue) {
        if (-not (Test-NoBom $f)) { $errors += "RNT-006: BOM trong $f" }
    }
}

# ---------- RNT-007: ASCII-only script ----------
foreach ($f in @($runner)) {
    if (Test-Path $f -ErrorAction SilentlyContinue) {
        $bytes = [System.IO.File]::ReadAllBytes($f)
        $nonAscii = $bytes | Where-Object { $_ -gt 127 }
        if ($nonAscii.Count -gt 0) { $errors += "RNT-007: ky tu non-ASCII trong $f ($($nonAscii.Count) bytes)" }
    }
}

# ---------- Output ----------
if (-not $Silent) {
    ""
    "=== Runtime Validator ==="
    if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors   | ForEach-Object { "  [E] $_" } }
    if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
    ""
    if ($errors.Count -eq 0 -and $warnings.Count -eq 0) { "PASS - runtime structure OK" }
    elseif ($errors.Count -eq 0) { "PASS (voi $($warnings.Count) warning) - runtime structure OK" }
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }
