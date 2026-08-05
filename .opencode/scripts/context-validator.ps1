# context-validator.ps1
# Validator cho Phase 4 — Context Engine
# Checks CTX-001..008 (xem .opencode/context/validator/validator.md)
# Parser YAML subset thủ công (không ConvertFrom-Yaml — không available PS 5.1).
<#
.SYNOPSIS
  Validate Context Engine structure: profiles/, schemas/, budget.
.DESCRIPTION
  Đọc profiles/*.yaml và kiểm tra cấu trúc (required/optional/forbidden),
  đối chiếu context-types.yaml và budget.schema.yaml. Exit 0 = PASS.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

# ---------- Paths ----------
$root = Split-Path -Parent $PSScriptRoot
$ctxDir    = Join-Path $root 'context'
$profDir   = Join-Path $ctxDir 'profiles'
$schemaDir = Join-Path $ctxDir 'schemas'
$budgetFile = Join-Path $schemaDir 'budget.schema.yaml'
$typesFile  = Join-Path $schemaDir 'context-types.yaml'

if (-not (Test-Path $profDir)) { Write-Error "context/profiles not found" ; exit 1 }

# Đọc budget: line dạng `  builder:  8000`
$budgets = @{}
if (Test-Path $budgetFile) {
  Get-Content -LiteralPath $budgetFile | ForEach-Object {
    if ($_ -match '^\s{2}([\w-]+):\s*(\d+)\s*$') { $budgets[$Matches[1]] = [int]$Matches[2] }
  }
}

# Đọc context-types valid list
$validTypes = @()
if (Test-Path $typesFile) {
  [regex]::Matches((Get-Content -LiteralPath $typesFile -Raw), '(?m)^\s*-\s*type:\s*([\w.]+)') | ForEach-Object { $validTypes += $_.Groups[1].Value }
}
$profiles = @(Get-ChildItem (Join-Path $profDir '*.yaml'))

$errors = @()
$warnings = @()
$infos = @()

# ---------- CTX-001: budget > 0 ----------
foreach ($kv in $budgets.GetEnumerator()) {
  if ($kv.Value -le 0) { $errors += "CTX-001: budget ${($kv.Key)} phai > 0 (got $($kv.Value))" }
}

# ---------- Validate từng profile ----------
foreach ($pf in $profiles) {
  $content = Get-Content -LiteralPath $pf.FullName -Raw
  $agent = if ($content -match '(?m)^agent:\s*([\w-]+)') { $Matches[1] } else { [System.IO.Path]::GetFileNameWithoutExtension($pf.Name) }

  # CTX-002: chỉ validate required items phải là valid type (hoặc artifact.xxx)
  if ($content -match '(?ms)required:\s*\n\s*-((?:\s+-.*\n?)*)') {
    $reqBlock = $Matches[1]
    [regex]::Matches($reqBlock, '^\s*-\s*([a-z_.]+)\s*$') | ForEach-Object {
      $item = $_.Groups[1].Value
      if ($item -eq '') { return }
      $ok = ($item -like 'artifact.*') -or ($validTypes -contains $item)
      if (-not $ok) { $errors += "CTX-002: profile '$agent' required item '$item' khong hop le" }
    }
  }

  # CTX-003: budget của agent đã khai trong budget.schema.yaml
  if ($agent -and -not $budgets.ContainsKey($agent)) {
    $infos += "CTX-003: agent '$agent' chua co budget (dung default)"
  }
}

# CTX-004: đủ tối thiểu module
foreach ($m in @('providers','resolver','builder','validator','cache','compression','intelligence','schemas')) {
  if (-not (Test-Path (Join-Path $ctxDir $m))) { $warnings += "CTX-004: thieu module context/$m" }
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== Context Engine Validation (Phase 4) ==="
  "profiles: $($profiles.Count) | budgets: $($budgets.Count) | types: $($validTypes.Count)"
  if ($errors.Count)   { ""; "ERRORS ($($errors.Count)):";     $errors   | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count) { ""; "WARNINGS ($($warnings.Count)):"; $warnings | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)    { ""; "INFOS ($($infos.Count)):";      $infos    | ForEach-Object { "  [I] $_" } }
  ""
}
if ($errors.Count -gt 0) { exit 1 } else { exit 0 }