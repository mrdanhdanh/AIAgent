<#
.SYNOPSIS
Doctor Module: Environment Check
.DESCRIPTION
Checks the OpenCode environment and AI Agent Framework:
OpenCode version, agent/command/skill folders, scripts, PowerShell, Python, Git,
model config, API config, permissions, knowledge folders, contract registry.
#>

# --- Helper: safe get version ------------------------------------
function Get-ToolVersion {
    param([string]$Command, [string[]]$Arguments)
    try {
        $output = & $Command @Arguments 2>&1 | Out-String
        return ($output.Trim() -split "`n")[0].Trim()
    }
    catch { return $null }
}

# --- Main: Environment Check -------------------------------------
function Get-DoctorEnvironment {
    param(
        [string]$Root = ".",
        [switch]$Detail
    )

    $checks = @()
    $issues = @()
    $score = 100

    # 1. OpenCode version
    $ocVersion = Get-ToolVersion -Command "opencode" -Arguments @("--version")
    if ($ocVersion) {
        $checks += @{ name = "OpenCode"; status = "PASS"; detail = $ocVersion }
    }
    else {
        $score -= 10
        $checks += @{ name = "OpenCode"; status = "WARNING"; detail = "opencode CLI not detected (might be installed as extension)" }
        $issues += @{ severity = "WARNING"; group = "Environment"; message = "OpenCode version not detectable" }
    }

    # 2. Agent folders
    $agentsDir = Join-Path $Root ".opencode/agents"
    $agentFiles = @(Get-ChildItem -Path $agentsDir -Filter "*.md" -ErrorAction SilentlyContinue)
    if ($agentFiles.Count -gt 0) {
        $checks += @{ name = "Agent folders"; status = "PASS"; detail = "$($agentFiles.Count) agent files" }
    }
    else {
        $score -= 15
        $checks += @{ name = "Agent folders"; status = "ERROR"; detail = "No agent files found in $agentsDir" }
        $issues += @{ severity = "CRITICAL"; group = "Environment"; message = "Missing agent definitions" }
    }

    # 3. Command folders
    $cmdsDir = Join-Path $Root ".opencode/commands"
    $cmdFiles = @(Get-ChildItem -Path $cmdsDir -Filter "*.md" -ErrorAction SilentlyContinue)
    if ($cmdFiles.Count -gt 0) {
        $checks += @{ name = "Command folders"; status = "PASS"; detail = "$($cmdFiles.Count) command files" }
    }
    else {
        $score -= 15
        $checks += @{ name = "Command folders"; status = "ERROR"; detail = "No command files found in $cmdsDir" }
        $issues += @{ severity = "CRITICAL"; group = "Environment"; message = "Missing command definitions" }
    }

    # 4. Skill folders
    $skillsDir = Join-Path $Root ".opencode/skills"
    $skillDirs = @(Get-ChildItem -Path $skillsDir -Directory -ErrorAction SilentlyContinue)
    if ($skillDirs.Count -gt 0) {
        $checks += @{ name = "Skill folders"; status = "PASS"; detail = "$($skillDirs.Count) skill packages" }
    }
    else {
        $score -= 10
        $checks += @{ name = "Skill folders"; status = "WARNING"; detail = "No skills found in $skillsDir" }
        $issues += @{ severity = "WARNING"; group = "Environment"; message = "Missing skill packages" }
    }

    # 5. Scripts
    $scriptsDir = Join-Path $Root ".opencode/scripts"
    $scriptFiles = @(Get-ChildItem -Path $scriptsDir -Filter "*.ps1" -ErrorAction SilentlyContinue)
    $scriptCount = $scriptFiles.Count + @(Get-ChildItem -Path (Join-Path $scriptsDir "evolution") -Filter "*.ps1" -ErrorAction SilentlyContinue).Count
    $checks += @{ name = "Scripts"; status = "PASS"; detail = "$scriptCount PowerShell scripts" }

    # 6. PowerShell version
    $psVer = "$($PSVersionTable.PSVersion)"
    $checks += @{ name = "PowerShell"; status = "PASS"; detail = $psVer }

    # 7. Python version
    $pyVer = Get-ToolVersion -Command "python" -Arguments @("--version")
    if ($pyVer) { $checks += @{ name = "Python"; status = "PASS"; detail = $pyVer } }
    else {
        $score -= 5
        $checks += @{ name = "Python"; status = "WARNING"; detail = "Python not detected (optional)" }
        $issues += @{ severity = "WARNING"; group = "Environment"; message = "Python not installed - some skills may require it" }
    }

    # 8. Git version
    $gitVer = Get-ToolVersion -Command "git" -Arguments @("--version")
    if ($gitVer) { $checks += @{ name = "Git"; status = "PASS"; detail = $gitVer } }
    else {
        $score -= 10
        $checks += @{ name = "Git"; status = "ERROR"; detail = "Git not detected" }
        $issues += @{ severity = "CRITICAL"; group = "Environment"; message = "Git required for gitguard/gitpush commands" }
    }

    # 9. Model configuration (opencode.json)
    $ocConfigPath = Join-Path $Root "opencode.json"
    $modelsFound = 0
    if (Test-Path -LiteralPath $ocConfigPath) {
        try {
            $ocConfig = Get-Content -LiteralPath $ocConfigPath -Raw -Encoding utf8 | ConvertFrom-Json
            if ($ocConfig.agent) {
                $models = @($ocConfig.agent.PSObject.Properties | ForEach-Object { $_.Value.model } | Where-Object { $_ })
                $modelsFound = @($models | Select-Object -Unique).Count
            }
            $checks += @{ name = "Model configuration"; status = "PASS"; detail = "$modelsFound unique model(s) in opencode.json" }
        }
        catch {
            $score -= 10
            $checks += @{ name = "Model configuration"; status = "ERROR"; detail = "opencode.json parse failed: $($_.Exception.Message)" }
            $issues += @{ severity = "CRITICAL"; group = "Environment"; message = "opencode.json is not valid JSON" }
        }
    }
    else {
        $score -= 10
        $checks += @{ name = "Model configuration"; status = "WARNING"; detail = "opencode.json not found at root" }
        $issues += @{ severity = "WARNING"; group = "Environment"; message = "opencode.json missing" }
    }

    # 10. API configuration (env vars presence only - never print values)
    $apiKeys = @("OPENAI_API_KEY", "ANTHROPIC_API_KEY", "OPENCODE_API_KEY")
    $configured = @($apiKeys | Where-Object { [Environment]::GetEnvironmentVariable($_) }).Count
    if ($configured -gt 0) {
        $checks += @{ name = "API configuration"; status = "PASS"; detail = "$configured provider key(s) configured (names only)" }
    }
    else {
        $checks += @{ name = "API configuration"; status = "WARNING"; detail = "No provider API keys found in env (may use other auth)" }
        $issues += @{ severity = "WARNING"; group = "Environment"; message = "No API keys in environment - check OpenCode auth" }
    }

    # 11. Permissions
    $permOk = 0
    foreach ($af in $agentFiles) {
        $content = Get-Content -LiteralPath $af.FullName -Raw -Encoding utf8 -ErrorAction SilentlyContinue
        if ($content -match '(?i)permission\s*:') { $permOk++ }
    }
    if ($agentFiles.Count -gt 0) {
        $ratio = [Math]::Round(($permOk / $agentFiles.Count) * 100)
        if ($ratio -ge 80) { $checks += @{ name = "Permissions"; status = "PASS"; detail = "$permOk/$($agentFiles.Count) agents define permissions" } }
        else {
            $score -= 5
            $checks += @{ name = "Permissions"; status = "WARNING"; detail = "$permOk/$($agentFiles.Count) agents define permissions" }
            $issues += @{ severity = "WARNING"; group = "Environment"; message = "Some agents missing permission blocks" }
        }
    }

    # 12. Knowledge folders
    $knowledgeDir = Join-Path $Root ".opencode/knowledge"
    if (Test-Path -LiteralPath $knowledgeDir) {
        $checks += @{ name = "Knowledge folders"; status = "PASS"; detail = "Knowledge base present" }
    }
    else {
        $score -= 10
        $checks += @{ name = "Knowledge folders"; status = "ERROR"; detail = "Knowledge base missing at $knowledgeDir" }
        $issues += @{ severity = "CRITICAL"; group = "Environment"; message = "Knowledge base missing" }
    }

    # 13. Contract registry
    $contractsDir = Join-Path $Root ".opencode/system/contracts"
    $contractFiles = @(Get-ChildItem -Path $contractsDir -Filter "*.yaml" -ErrorAction SilentlyContinue)
    if ($contractFiles.Count -gt 0) {
        $checks += @{ name = "Contract registry"; status = "PASS"; detail = "$($contractFiles.Count) contract file(s)" }
    }
    else {
        $score -= 5
        $checks += @{ name = "Contract registry"; status = "WARNING"; detail = "No contracts found in $contractsDir" }
        $issues += @{ severity = "WARNING"; group = "Environment"; message = "Contract registry empty" }
    }

    $score = [Math]::Max(0, $score)
    $status = if ($score -ge 80) { "PASS" } elseif ($score -ge 50) { "WARNING" } else { "ERROR" }

    return @{
        group  = "Environment"
        score  = $score
        status = $status
        checks = $checks
        issues = $issues
    }
}
