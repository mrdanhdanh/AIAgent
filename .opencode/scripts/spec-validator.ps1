# spec-validator.ps1
# Validator cho AIOS_IMPLEMENTATION.md — Implementation Control
# Checks IMP-001..005 (SPEC index day du, 4 giai doan, core spec)
# ASCII-only (PS 5.1 ANSI) — khong dung ky tu Unicode.
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate AIOS Implementation control file.
.DESCRIPTION
  Kiem tra AIOS_IMPLEMENTATION.md du SPEC index (001-020), 4 giai doan,
  core spec, priority. Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$implFile = Join-Path $root 'AIOS_IMPLEMENTATION.md'

if (-not (Test-Path $implFile)) { Write-Error "AIOS_IMPLEMENTATION.md not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

$text = Get-Content -LiteralPath $implFile -Raw -Encoding utf8

# ---------- IMP-001: 4 giai doan (regex voi `.` cho ky tu dia danh) ----------
$stages = @('Giai .o.n 1','Giai .o.n 2','Giai .o.n 3','Giai .o.n 4')
foreach ($s in $stages) {
  if ($text -notmatch $s) { $errors += "IMP-001: thieu giai doan '$s'" }
}

# ---------- IMP-002: SPEC index 001-020 ----------
for ($i = 1; $i -le 20; $i++) {
  $spec = "SPEC-{0:D3}" -f $i
  if ($text -notmatch [regex]::Escape($spec)) { $errors += "IMP-002: thieu $spec" }
}

# ---------- IMP-003: 7 core spec ----------
$core = @('SPEC-004','SPEC-005','SPEC-011','SPEC-012','SPEC-013','SPEC-014','SPEC-015')
foreach ($c in $core) {
  if ($text -notmatch [regex]::Escape($c)) { $warnings += "IMP-003: core spec $c thieu trong index" }
}

# ---------- IMP-004: pipeline ----------
$pipeline = @('Roadmap','Specification','Architecture Validation','Code Generation','Tests','Doctor')
foreach ($p in $pipeline) {
  if ($text -notmatch [regex]::Escape($p)) { $warnings += "IMP-004: thieu pipeline step '$p'" }
}

# ---------- IMP-005: priority bang ----------
if ($text -notmatch '40%') { $warnings += "IMP-005: thieu priority 40% (Specification)" }
if ($text -notmatch '30%') { $warnings += "IMP-005: thieu priority 30% (Runtime Kernel)" }

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== AIOS Implementation Control Validation ==="
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)     { ""; "INFOS ($($infos.Count)):";      $infos     | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }