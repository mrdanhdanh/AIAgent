# glossary-validator.ps1
# Validator cho Glossary (Sprint 0)
# Checks GLS-001..003 (per-term files, Owns/Does not own)
# ASCII-only (PS 5.1 ANSI).
# Exit 0 = PASS.
<#
.SYNOPSIS
  Validate AIOS Glossary.
.DESCRIPTION
  Kiem tra .opencode/glossary/ co du cac thu ngu co ban + format.
  Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$glossaryDir = Join-Path $root 'glossary'

if (-not (Test-Path $glossaryDir)) { Write-Error "glossary/ not found"; exit 1 }

$errors   = @()
$warnings = @()
$infos    = @()

# ---------- GLS-001: files co ban ----------
$terms = @('agent','capability','workflow','artifact','context','runtime',
  'event','phase-task','knowledge-memory','command-skill-plugin')
foreach ($t in $terms) {
  if (-not (Test-Path (Join-Path $glossaryDir "$t.md"))) {
    $errors += "GLS-001: missing term file $t.md"
  }
}

# ---------- GLS-002: format per file ----------
$termFiles = @(Get-ChildItem (Join-Path $glossaryDir '*.md'))
foreach ($f in $termFiles) {
  if ($f.Name -eq 'README.md') { continue }
  $text = Get-Content -LiteralPath $f.FullName -Raw -Encoding utf8
  if ($text -notmatch 'Owns') { $warnings += "GLS-002: $($f.Name) thieu Owns" }
  if ($text -notmatch 'Does not own') { $warnings += "GLS-002: $($f.Name) thieu Does not own" }
}

# ---------- GLS-003: mot nghia (khong rong) ----------
if (-not (Test-Path (Join-Path $glossaryDir 'README.md'))) {
  $errors += "GLS-003: missing README.md"
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== Glossary Validation (Sprint 0) ==="
  "term files: $($termFiles.Count)"
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }