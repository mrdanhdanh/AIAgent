# agent-validator.ps1
# Validator cho Phase 3 — Agent Definition System
# Checks AG-001..010 (xem .opencode/agents/validation/validator.md)
# Parser YAML subset thủ công (không ConvertFrom-Yaml — không available PS 5.1).
<#
.SYNOPSIS
  Validate Agent Definition packages (agents/metadata/*.yaml).
.DESCRIPTION
  Đọc từng agent.yaml bằng regex/keyword. Kiểm tra Identity/Capability/Behavior/compatibility
  và đối chiếu capabilities.yaml + agent-registry.yaml. Exit 0 = PASS, 1 = có CRITICAL.
#>
param([switch]$Silent)

$ErrorActionPreference = 'Stop'

# ---------- Paths ----------
$root = Split-Path -Parent $PSScriptRoot
$metaDir   = Join-Path $root 'agents\metadata'
$capFile   = Join-Path $root 'registry\capabilities.yaml'
$regFile   = Join-Path $root 'registry\agent-registry.yaml'
$contractDir = Join-Path $root 'agents\contracts'

if (-not (Test-Path $metaDir)) { Write-Error "agents/metadata not found" ; exit 1 }

$agentFiles = @(Get-ChildItem (Join-Path $metaDir '*.yaml'))

# capability ids available
$capText = Get-Content -LiteralPath $capFile -Raw
$capIds = @{}
[regex]::Matches($capText, '(?m)^\s*-\s*id:\s*([a-z]+\.[a-z0-9-]+)') | ForEach-Object { $capIds[$_.Groups[1].Value] = $true }

# registry agent ids
$regText = Get-Content -LiteralPath $regFile -Raw
$regIds = @{}
[regex]::Matches($regText, '(?m)^\s*-\s*id:\s*([a-z][\w-]+)') | ForEach-Object { $regIds[$_.Groups[1].Value] = $true }

# collect contract ids from input/output schema
$contractIds = @{}
Get-ChildItem (Join-Path $contractDir '*.yaml') | ForEach-Object {
  $t = Get-Content -LiteralPath $_.FullName -Raw
  [regex]::Matches($t, '(?m)^\s*-\s*id:\s*([\w-]+)') | ForEach-Object { $contractIds[$_.Groups[1].Value] = $true }
}

$errors = @()
$warnings = @()
$infos = @()
$passCount = 0

# ---------- Validate từng agent ----------
foreach ($f in $agentFiles) {
  $text = Get-Content -LiteralPath $f.FullName -Raw
  $id = if ($text -match '(?m)^id:\s*([\w-]+)') { $Matches[1] } else { [System.IO.Path]::GetFileNameWithoutExtension($f.Name) }

  # AG-008: tên file == id trong file
  $fileId = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
  if ($fileId -ne $id) { $errors += "AG-008: file '$fileId.yaml' khong trung id trong file ('$id')" }

  # AG-001: required identity fields
  foreach ($req in @('name','version','status','id')) {
    if ($text -notmatch "(?m)^$req\s*:") { $errors += "AG-001: agent $id thieu required field '$req'" }
  }

  # AG-007: status valid
  $status = if ($text -match '(?m)^status:\s*([\w-]+)') { $Matches[1] } else { '' }
  if ($status -and @('draft','experimental','beta','stable','deprecated','disabled') -notcontains $status) {
    $errors += "AG-007: agent $id status '$status' khong hop le"
  }

  # AG-002/AG-005: capability refs (supports: [a, b])
  $supported = @()
  [regex]::Matches($text, '(?ms)supports:\s*\[([^\]]+)\]') | ForEach-Object {
    $_.Groups[1].Value -split ',' | ForEach-Object { $supported += $_.Trim() }
  }
  $supported = @($supported | Where-Object { $_ -ne '' } | Select-Object -Unique)
  if ($supported.Count) {
    foreach ($cap in $supported) { if (-not $capIds.ContainsKey($cap)) { $errors += "AG-002: agent $id supports capability khong ton tai: $cap" } }
  } else {
    $warnings += "AG-004: agent $id khong khai bao supports"
  }

  # AG-003: entry_prompt tồn tại
  if ($text -match '(?m)^\s*entry_prompt:\s*([\w.\/]+)') {
    $p = Join-Path $root ("agents\" + $id + "\" + $Matches[1])
    if (-not (Test-Path $p)) { $warnings += "AG-003: agent $id entry_prompt $($Matches[1]) khong ton tai (package chua tao)" }
  }

  # AG-004: contract refs
  if ($text -match '(?ms)^\s*input:\s*([\w-]+)') { $ci = $Matches[1]; if ($ci -and -not $contractIds.ContainsKey($ci)) { $errors += "AG-004: agent $id input contract khong ton tai: $ci" } }
  if ($text -match '(?ms)^\s*output:\s*([\w-]+)') { $co = $Matches[1]; if ($co -and -not $contractIds.ContainsKey($co)) { $errors += "AG-004: agent $id output contract khong ton tai: $co" } }

  # AG-010: metadata vs agent-registry (id phải khớp) — reverse: metadata thiếu = chưa migrate (info)
  if (-not $regIds.ContainsKey($id)) {
    $infos += "AG-010: agent $id chua dang ky trong agent-registry.yaml"
  }

  $passCount++
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== Agent Definition Validation (Phase 3) ==="
  "agents/metadata: $($agentFiles.Count) | capabilities: $($capIds.Count) | contracts: $($contractIds.Count)"
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings  | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)     { ""; "INFOS ($($infos.Count)):";      $infos     | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }