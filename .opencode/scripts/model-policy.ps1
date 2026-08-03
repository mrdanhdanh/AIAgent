<#
.SYNOPSIS
    Model Policy Manager - bật/tắt free model cho toàn bộ agent/skill/command.

.DESCRIPTION
    Đọc .opencode/model-policy/settings.json:
      free_model_enabled: true  -> mọi agent dùng free_model (opencode-go/deepseek-v4-flash)
      free_model_enabled: false -> khôi phục model mặc định từ models.default.json

    Script ghi đè model trong 2 nguồn:
      1. opencode.json  (agent.<name>.model)
      2. .opencode/agents/*.md  (frontmatter model:)

    Modes:
      status  - báo cáo trạng thái hiện tại (read-only, không ghi file)
      apply   - áp dụng cài đặt theo settings.json (không đổi settings)
      enable  - set free_model_enabled = true, rồi apply
      disable - set free_model_enabled = false, rồi apply (restore defaults)

    Flags:
      -ProjectRoot <path> - project root (default: workspace root)
      -DryRun            - chỉ báo cáo, không ghi file
      -Verbose           - chi tiết

.EXAMPLE
    .opencode/scripts/model-policy.ps1 -Mode status
    .opencode/scripts/model-policy.ps1 -Mode enable
    .opencode/scripts/model-policy.ps1 -Mode disable
    .opencode/scripts/model-policy.ps1 -Mode apply -DryRun
#>

param(
    [ValidateSet("status", "apply", "enable", "disable")]
    [string]$Mode = "status",
    [string]$ProjectRoot = "",
    [switch]$DryRun,
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"

# ---- 0. UTF-8 helpers (PS 5.1 Get-Content defaults to ANSI -> corrupt) --
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Read-Utf8([string]$path) {
    return [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
}
function Write-Utf8([string]$path, [string]$text) {
    [System.IO.File]::WriteAllText($path, $text, $Utf8NoBom)
}

# ---- 1. Locate directories -------------------------------------------
if ([string]::IsNullOrWhiteSpace($ProjectRoot)) {
    $ProjectRoot = (Get-Location).Path
}
if (-not (Test-Path -LiteralPath $ProjectRoot)) {
    Write-Error "ProjectRoot does not exist: $ProjectRoot"
    exit 1
}

$policyDir    = Join-Path $ProjectRoot ".opencode\model-policy"
$settingsPath = Join-Path $policyDir "settings.json"
$defaultsPath = Join-Path $policyDir "models.default.json"
$configPath   = Join-Path $ProjectRoot "opencode.json"
$agentsDir    = Join-Path $ProjectRoot ".opencode\agents"
$backupDir    = Join-Path $policyDir "backup"

$FREE_MODEL_DEFAULT = "opencode-go/deepseek-v4-flash"

function Write-Log($msg) {
    if ($Verbose) { Write-Host "[verbose] $msg" -ForegroundColor DarkGray }
}
function Write-Step($msg) {
    Write-Host "== $msg" -ForegroundColor Cyan
}
function Write-Ok($msg) {
    Write-Host "  [OK] $msg" -ForegroundColor Green
}
function Write-Info($msg) {
    Write-Host "  [..] $msg" -ForegroundColor Gray
}
function Write-Warn($msg) {
    Write-Host "  [!] $msg" -ForegroundColor Yellow
}

# ---- 2. Load settings -------------------------------------------------
if (-not (Test-Path -LiteralPath $settingsPath)) {
    Write-Error "settings.json not found: $settingsPath"
    exit 1
}
$settings = Read-Utf8 $settingsPath | ConvertFrom-Json

if (-not $settings.PSObject.Properties['free_model_enabled']) {
    Write-Error "settings.json missing 'free_model_enabled'"
    exit 1
}
$enabled = [bool]$settings.free_model_enabled
$freeModel = if ($settings.PSObject.Properties['free_model']) { [string]$settings.free_model } else { $FREE_MODEL_DEFAULT }
if ([string]::IsNullOrWhiteSpace($freeModel)) { $freeModel = $FREE_MODEL_DEFAULT }

# effective state for this run (enable/disable override settings value)
if ($Mode -eq "enable") { $enabled = $true }
if ($Mode -eq "disable") { $enabled = $false }

# ---- 3. Load default registry ----------------------------------------
$defaultMap = @{}
if (Test-Path -LiteralPath $defaultsPath) {
    $defaults = Read-Utf8 $defaultsPath | ConvertFrom-Json
    foreach ($p in $defaults.agents.PSObject.Properties) {
        $defaultMap[$p.Name] = [string]$p.Value
    }
}

# ---- 4. Collect agents from opencode.json ----------------------------
if (-not (Test-Path -LiteralPath $configPath)) {
    Write-Error "opencode.json not found: $configPath"
    exit 1
}
$configRaw = Read-Utf8 $configPath
$config = $configRaw | ConvertFrom-Json

$agentNames = @()
if ($config.agent) {
    foreach ($p in $config.agent.PSObject.Properties) {
        $agentNames += $p.Name
    }
}
$agentNames = $agentNames | Sort-Object -Unique

if ($agentNames.Count -eq 0) {
    Write-Error "No agents found in opencode.json"
    exit 1
}

# ---- 5. Determine target model per agent -----------------------------
$targetMap = @{}
foreach ($name in $agentNames) {
    if ($enabled) {
        $targetMap[$name] = $freeModel
    }
    else {
        if ($defaultMap.ContainsKey($name)) {
            $targetMap[$name] = $defaultMap[$name]
        }
        else {
            Write-Warn "no default for '$name' - keeping current model"
            $targetMap[$name] = $null
        }
    }
}

# ---- 6. Helpers: replace model values ---------------------------------
function Set-OpenCodeJsonModel {
    param(
        [string]$Text,
        [string]$AgentName,
        [string]$NewModel
    )
    $escaped = [regex]::Escape($AgentName)
    $pattern = '"' + $escaped + '"\s*:\s*\{[^}]*?"model":\s*"[^"]*"'
    if ($Text -notmatch $pattern) {
        return @{ ok = $false; text = $Text }
    }
    $callback = {
        param($m)
        $block = $m.Value
        return $block -replace '"model":\s*"[^"]*"', ('"model": "' + $NewModel + '"')
    }
    $newText = [regex]::Replace($Text, $pattern, $callback)
    return @{ ok = $true; text = $newText }
}

function Set-AgentMdModel {
    param(
        [string]$Text,
        [string]$NewModel
    )
    if ($Text -match '(?m)^model:[^\r\n]*') {
        # Preserve CRLF: don't consume trailing \r\n (use [^\r\n]* without $)
        return $Text -replace '(?m)^model:[^\r\n]*', ('model: ' + $NewModel)
    }
    return $null
}

# ---- 7. Read-only status ----------------------------------------------
Write-Step "MODEL-POLICY $($Mode.ToUpper()) - free_model_enabled=$enabled"
if ($enabled) {
    Write-Info "Free model: $freeModel (mode=$Mode, dry-run=$DryRun)"
}
else {
    Write-Info "Defaults active (mode=$Mode, dry-run=$DryRun)"
}

if ($Mode -eq "status") {
    # Read-only: chỉ báo cáo trạng thái hiện tại của từng agent
    $report = @()
    foreach ($name in $agentNames) {
        $current = $null
        if ($config.agent.$name.PSObject.Properties['model']) {
            $current = [string]$config.agent.$name.model
        }
        $target = $targetMap[$name]
        $statusTxt = if ($current -eq $target) { "OK" } else { "DIFF" }
        $report += [PSCustomObject]@{
            agent   = $name
            current = $current
            target  = $target
            status  = $statusTxt
        }
    }
    Write-Step "STATUS REPORT"
    foreach ($r in $report) {
        $mark = if ($r.status -eq "OK") { "OK " } else { "DIFF" }
        Write-Info ("{0}  {1,-22} {2}  ->  {3}" -f $mark, $r.agent, $r.current, $r.target)
    }
    $diffCount = @($report | Where-Object { $_.status -eq "DIFF" }).Count
    Write-Info "total=$($report.Count)  diff=$diffCount"
    Write-Info "NEXT: run /model-policy enable (hoặc apply) để áp dụng"
    exit 0
}

# ---- 8. Backup before write -------------------------------------------
if (-not $DryRun) {
    if (-not (Test-Path -LiteralPath $backupDir)) {
        New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    }
    $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $backupFile = Join-Path $backupDir ("opencode.{0}.json.bak" -f $stamp)
    Copy-Item -LiteralPath $configPath -Destination $backupFile -Force
    Write-Log "backup opencode.json -> $backupFile"
}

# ---- 9. Apply to opencode.json ----------------------------------------
$changed = @()
$newConfigText = $configRaw
foreach ($name in $agentNames) {
    $newModel = $targetMap[$name]
    if ([string]::IsNullOrWhiteSpace($newModel)) { continue }
    $res = Set-OpenCodeJsonModel -Text $newConfigText -AgentName $name -NewModel $newModel
    if ($res.ok -and $res.text -ne $newConfigText) {
        $newConfigText = $res.text
        $changed += $name
        Write-Ok "opencode.json: $name -> $newModel"
    }
    else {
        Write-Log "no change for $name in opencode.json"
    }
}

if (-not $DryRun -and $changed.Count -gt 0) {
    Write-Utf8 $configPath $newConfigText
    Write-Ok "wrote opencode.json"
}

# ---- 10. Apply to .opencode/agents/*.md --------------------------------
$mdChanged = @()
if (Test-Path -LiteralPath $agentsDir) {
    foreach ($name in $agentNames) {
        $mdFile = Join-Path $agentsDir ($name + ".md")
        if (-not (Test-Path -LiteralPath $mdFile)) { continue }
        $newModel = $targetMap[$name]
        if ([string]::IsNullOrWhiteSpace($newModel)) { continue }
        $mdText = Read-Utf8 $mdFile
        $mdResult = Set-AgentMdModel -Text $mdText -NewModel $newModel
        if ($mdResult -ne $null -and $mdResult -ne $mdText) {
            if (-not $DryRun) {
                Write-Utf8 $mdFile $mdResult
            }
            $mdChanged += $name
            Write-Ok "agents/$name.md -> $newModel"
        }
        else {
            Write-Log "no change for $name.md"
        }
    }
}
else {
    Write-Warn "agents dir not found: $agentsDir"
}

# ---- 11. enable/disable persist setting -------------------------------
if ($Mode -eq "enable" -and -not $settings.free_model_enabled) {
    $settings.free_model_enabled = $true
    if (-not $DryRun) {
        Write-Utf8 $settingsPath ($settings | ConvertTo-Json -Depth 5)
    }
    Write-Ok "settings.json: free_model_enabled -> true"
}
if ($Mode -eq "disable" -and $settings.free_model_enabled) {
    $settings.free_model_enabled = $false
    if (-not $DryRun) {
        Write-Utf8 $settingsPath ($settings | ConvertTo-Json -Depth 5)
    }
    Write-Ok "settings.json: free_model_enabled -> false"
}

# ---- 12. Report --------------------------------------------------------
Write-Step "REPORT"
Write-Info "agents total   : $($agentNames.Count)"
Write-Info "changed json   : $($changed.Count)"
Write-Info "changed md     : $($mdChanged.Count)"
Write-Info "free model     : $freeModel"
Write-Info "mode           : $Mode (dry-run=$DryRun)"
Write-Info "NEXT STEP      : restart opencode session để config mới có hiệu lực"
