# capability-validator.ps1
# Validator cho Capability Registry v4.0
# Checks CR-001..009 (xem .opencode/registry/validator.md)
# Không dùng ConvertFrom-Yaml (không available PS 5.1) — parser YAML subset thủ công.
<#
.SYNOPSIS
  Validate Capability Registry (registry/) cho tính nhất quán + sinh coverage report.
.DESCRIPTION
  Đọc capabilities.yaml, agent-registry.yaml, skill-registry.yaml, command-registry.yaml
  bằng parser YAML subset (list-of-maps). Báo CR-00x, exit 0 = PASS.
.PARAMETER Silent
  Chỉ matrix kết quả tối thiểu.
.PARAMETER Report
  Xuất .opencode/reports/CAPABILITY_COVERAGE.md.
#>
param(
  [switch]$Silent,
  [switch]$Report
)

$ErrorActionPreference = 'Stop'

# ---------- Helpers ----------
function Write-NoBom {
  param([string]$Path, [string]$Content)
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($Path, $Content, $utf8NoBom)
}

# Parser YAML subset: một list `  - key: value` thành mảng hashtable.
# value đơn hoặc inline list [a, b, c].
# Parser YAML subset: danh sach `  - key: value` thanh mang hashtable.
# Chi xu ly entities (list item `- ...`), bo qua root keys (version, agents, ...).
function Read-EntityList {
  param([string]$Path)
  $lines = Get-Content -LiteralPath $Path -Encoding utf8
  $entities = @()
  $cur = $null

  foreach ($line in $lines) {
    # bo comment
    if ($line -match '^\s*#') { continue }
    # item moi (dash prefix) -> tao entity moi
    if ($line -match '^\s*-\s+') {
      if ($cur) { $entities += $cur }
      $cur = @{}
      $rest = ($line -replace '^\s*-\s+', '').Trim()
      if ($rest -match '^\s*([\w.-]+)\s*:\s*(.*)$') {
        $k = $Matches[1]
        $v = $Matches[2].Trim()
        if ($v -eq '') { $cur[$k] = @() }
        elseif ($v -match '^\[(.*)\]$') { $cur[$k] = @($Matches[1] -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }) }
        elseif ($v -match '^true$') { $cur[$k] = $true }
        elseif ($v -match '^false$') { $cur[$k] = $false }
        else { $cur[$k] = ($v -replace '^"|"$', '').Trim("'") }
      }
      continue
    }
    # field thuoc entity hien tai (indent >= 2)
    if ($cur) {
      if ($line -match '^\s{2,}([\w.-]+)\s*:\s*(.*)$') {
        $k = $Matches[1]
        $v = $Matches[2].Trim()
        if ($v -eq '') { $cur[$k] = @() }
        elseif ($v -match '^\[(.*)\]$') { $cur[$k] = @($Matches[1] -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }) }
        elseif ($v -match '^true$') { $cur[$k] = $true }
        elseif ($v -match '^false$') { $cur[$k] = $false }
        else { $cur[$k] = ($v -replace '^"|"$', '').Trim("'") }
      }
      elseif ($line -match '\s*-\s+(.+)$') {
        $item = $Matches[1].Trim().Trim("'")
        if (-not $cur['_list_']) { $cur['_list_'] = @() }
        $cur['_list_'] += $item
        $curField = '_list_'
      }
    }
  }
  # map _list_ -> lưu cho các field được khai báo dạng block list
  if ($cur) { $entities += $cur }
  return $entities
}

# ---------- Paths ----------
$root = Split-Path -Parent $PSScriptRoot
$reg  = Join-Path $root 'registry'
$capFile   = Join-Path $reg 'capabilities.yaml'
$agentFile = Join-Path $reg 'agent-registry.yaml'
$skillFile = Join-Path $reg 'skill-registry.yaml'
$cmdFile   = Join-Path $reg 'command-registry.yaml'
$reportDir = Join-Path $root 'reports'
$reportFile = Join-Path $reportDir 'CAPABILITY_COVERAGE.md'

if (-not (Test-Path $capFile)) { Write-Error "capabilities.yaml not found" ; exit 1 }

$capabilities = @(Read-EntityList -Path $capFile)
$agents   = @(Read-EntityList -Path $agentFile)
$skills   = @(Read-EntityList -Path $skillFile)
$commands = @(Read-EntityList -Path $cmdFile)

$errors = @()
$warnings = @()
$infos = @()

# ---------- CR-001 duplicate capability id ----------
$seen = @{}
foreach ($c in $capabilities) {
  $id = $c.id
  if ($seen.ContainsKey($id)) { $errors += "CR-001: duplicate capability id '$id'" }
  $seen[$id] = $true
}

# ---------- CR-008: category trong taxonomy ----------
$taxonomy = @('analysis','architecture','planning','implementation','review','testing',
  'knowledge','memory','deployment','workspace','ui','security','documentation','orchestration')
foreach ($c in $capabilities) {
  if ($c.category -and $taxonomy -notcontains $c.category) {
    $errors += "CR-008: category $($c.category) cua capability $($c.id) khong trong taxonomy"
  }
}

# ---------- CR-006: duplicate agent/skill/command id ----------
foreach ($pair in @(@($agents,'agent'),@($skills,'skill'),@($commands,'command'))) {
  $list = $pair[0]; $kind = $pair[1]; $s = @{}
  foreach ($e in $list) {
    if ($s.ContainsKey($e.id)) { $errors += "CR-006: duplicate ${kind} id '$($e.id)'" }
    $s[$e.id] = $true
  }
}

# ---------- CR-002: refs khớp capability ----------
foreach ($a in $agents) {
  foreach ($cap in @($a.capabilities)) { if ($cap -and -not $seen.ContainsKey($cap)) { $errors += "CR-002: agent $($a.id) refs capability khong ton tai: $cap" } }
}
$skillIds = @{}
foreach ($s in $skills) {
  $skillIds[$s.id] = $true
  foreach ($cp in @($s.supports)) { if ($cp -and -not $seen.ContainsKey($cp)) { $errors += "CR-002: skill $($s.id) supports capability khong ton tai: $cp" } }
}
foreach ($cmd in $commands) {
  foreach ($cp in @($cmd.supports)) { if ($cp -and -not $seen.ContainsKey($cp)) { $errors += "CR-002: command $($cmd.id) supports capability khong ton tai: $cp" } }
}

# ---------- CR-004 / CR-005: empty ----------
foreach ($a in $agents) { if (-not @($a.capabilities).Count) { $warnings += "CR-004: agent $($a.id) khong co capability" } }
foreach ($s in $skills)   { if (-not @($s.supports).Count)   { $warnings += "CR-005: skill $($s.id) supports rong" } }
foreach ($c in $commands) { if (-not @($c.supports).Count)   { $warnings += "CR-005: command $($c.id) supports rong" } }

# ---------- CR-003: orphan capability (no agent) ----------
$coveredByAgent = @{}
foreach ($a in $agents) { foreach ($c in @($a.capabilities)) { $coveredByAgent[$c] = $true } }
foreach ($c in $capabilities) {
  if (-not $coveredByAgent.ContainsKey($c.id)) { $warnings += "CR-003: orphan capability $($c.id) khong co agent" }
}

# ---------- CR-009: registry vs thực tế ----------
$realAgents = (Get-ChildItem (Join-Path $root 'agents/*.md') -ErrorAction SilentlyContinue).Count
$realSkills = (Get-ChildItem (Join-Path $root 'skills/*/SKILL.md') -ErrorAction SilentlyContinue).Count
$realCmds   = (Get-ChildItem (Join-Path $root 'commands/*.md') -ErrorAction SilentlyContinue).Count
if ($realAgents -and $agents.Count -ne $realAgents) { $infos += "CR-009: registry agents=$($agents.Count) vs thuc te=$realAgents" }
if ($realSkills -and $skills.Count -ne $realSkills) { $infos += "CR-009: registry skills=$($skills.Count) vs thuc te=$realSkills" }
if ($realCmds   -and $commands.Count -ne $realCmds) { $infos += "CR-009: registry commands=$($commands.Count) vs thuc te=$realCmds" }

# ---------- CR-007: dependency cycle (optional) ----------
$hasDep = $false
foreach ($a in $agents) { if (@($a.dependencies).Count) { $hasDep = $true } }
if (-not $hasDep) {
  $infos += "CR-007: skip (khong agent khai bao dependencies)"
}

# ---------- Coverage report ----------
if ($Report -or (-not $Silent)) {
  $lines = @()
  $lines += "# CAPABILITY_COVERAGE.md - Capability Registry v4.0"
  $lines += ""
  $lines += "Generated by capability-validator.ps1"
  $lines += ""
  $lines += "| Capability | Agent | Skill | Command | Status |"
  $lines += "|------------|-------|-------|---------|--------|"
  foreach ($c in $capabilities) {
    $id = $c.id
    $a = @($agents | Where-Object { @($_.capabilities) -contains $id }).Count
    $s = @($skills | Where-Object { @($_.supports) -contains $id }).Count
    $cm = @($commands | Where-Object { @($_.supports) -contains $id }).Count
    $status = if ($a -gt 0) { 'OK' } elseif ($s -gt 0 -or $cm -gt 0) { 'Partial' } else { 'Missing' }
    $lines += "| $id | $(if($a){'x'}else{'-'}) | $(if($s){'x'}else{'-'}) | $(if($cm){'x'}else{'-'}) | $status |"
  }
  if ($Report) {
    if (-not (Test-Path $reportDir)) { New-Item -ItemType Directory -Path $reportDir | Out-Null }
    Write-NoBom -Path $reportFile -Content ($lines -join "`n")
  }
}

# ---------- Output ----------
if (-not $Silent) {
  ""
  "=== Capability Registry Validation ==="
  "capabilities: $($capabilities.Count) | agents: $($agents.Count) | skills: $($skills.Count) | commands: $($commands.Count)"
  if ($errors.Count)    { ""; "ERRORS ($($errors.Count)):";    $errors    | ForEach-Object { "  [E] $_" } }
  if ($warnings.Count)  { ""; "WARNINGS ($($warnings.Count)):"; $warnings  | ForEach-Object { "  [W] $_" } }
  if ($infos.Count)     { ""; "INFOS ($($infos.Count)):";      $infos     | ForEach-Object { "  [I] $_" } }
  ""
}

if ($errors.Count -gt 0) { exit 1 } else { exit 0 }