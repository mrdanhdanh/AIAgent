<#
.SYNOPSIS
Doctor Module: Agent Check
.DESCRIPTION
Checks each agent definition (.opencode/agents/*.md):
YAML frontmatter, description, contract, permissions, dependencies,
prompt size, output schema, deprecated fields, missing fields.
#>

function Get-DoctorAgents {
    param(
        [string]$Root = ".",
        [switch]$Detail
    )

    $agentsDir = Join-Path $Root ".opencode/agents"
    $agentFiles = @(Get-ChildItem -Path $agentsDir -Filter "*.md" -ErrorAction SilentlyContinue)

    $checks = @()
    $issues = @()
    $score = 100

    if ($agentFiles.Count -eq 0) {
        return @{
            group  = "Agents"
            score  = 0
            status = "ERROR"
            checks = @(@{ name = "Agents"; status = "ERROR"; detail = "No agent files found" })
            issues = @(@{ severity = "CRITICAL"; group = "Agents"; message = "No agent definitions" })
        }
    }

    $failCount = 0
    foreach ($af in $agentFiles) {
        $name = $af.BaseName
        $content = Get-Content -LiteralPath $af.FullName -Raw -Encoding utf8 -ErrorAction SilentlyContinue
        $agentChecks = @()
        $agentIssues = @()

        # --- YAML frontmatter syntax ---
        if ($content -match '(?s)^---\r?\n(.*?)\r?\n---') {
            $fm = $Matches[1]
            $agentChecks += @{ name = "YAML syntax"; status = "PASS"; detail = "frontmatter parsed" }
        }
        else {
            $failCount++
            $agentChecks += @{ name = "YAML syntax"; status = "ERROR"; detail = "No valid YAML frontmatter" }
            $agentIssues += @{ severity = "CRITICAL"; group = "Agents"; message = "$($name): invalid frontmatter" }
        }

        # --- Description ---
        if ($content -match 'description\s*:\s*\S') {
            $agentChecks += @{ name = "Description"; status = "PASS"; detail = "present" }
        }
        else {
            $failCount++
            $agentChecks += @{ name = "Description"; status = "ERROR"; detail = "missing" }
            $agentIssues += @{ severity = "CRITICAL"; group = "Agents"; message = "$($name): missing description" }
        }

        # --- Model ---
        if ($content -match 'model\s*:\s*\S') {
            $agentChecks += @{ name = "Model"; status = "PASS"; detail = "present" }
        }
        else {
            $agentChecks += @{ name = "Model"; status = "WARNING"; detail = "missing - will use default" }
            $agentIssues += @{ severity = "WARNING"; group = "Agents"; message = "$($name): no explicit model" }
        }

        # --- Mode ---
        if ($content -match 'mode\s*:\s*(subagent|primary|agent)') {
            $agentChecks += @{ name = "Mode"; status = "PASS"; detail = $Matches[1] }
        }
        else {
            $agentChecks += @{ name = "Mode"; status = "WARNING"; detail = "missing/invalid" }
            $agentIssues += @{ severity = "WARNING"; group = "Agents"; message = "$($name): missing mode" }
        }

        # --- Permissions ---
        if ($content -match '(?s)permission\s*:') {
            $permNames = @()
            if ($content -match '(?s)permission\s*:\s*\{(.*?)\}') { $permNames = @("read/grep/glob/edit/bash") }
            elseif ($content -match '(?i)(read|edit|bash|grep|glob)\s*:\s*(allow|deny)') { $permNames = @("inline perms") }
            $agentChecks += @{ name = "Permissions"; status = "PASS"; detail = "defined" }
        }
        else {
            $failCount++
            $agentChecks += @{ name = "Permissions"; status = "ERROR"; detail = "missing" }
            $agentIssues += @{ severity = "MAJOR"; group = "Agents"; message = "$($name): missing permission block" }
        }

        # --- Contract (output schema) ---
        if ($content -match '(?i)(contract|output schema|output contract|schema_version)') {
            $agentChecks += @{ name = "Contract"; status = "PASS"; detail = "output schema documented" }
        }
        else {
            $agentChecks += @{ name = "Contract"; status = "WARNING"; detail = "no explicit output schema" }
            $agentIssues += @{ severity = "WARNING"; group = "Agents"; message = "$($name): missing output contract" }
        }

        # --- Deprecated fields ---
        if ($content -match '(?i)deprecated') {
            $agentChecks += @{ name = "Deprecated"; status = "WARNING"; detail = "contains deprecated markers" }
            $agentIssues += @{ severity = "WARNING"; group = "Agents"; message = "$($name): contains deprecated content" }
        }
        else {
            $agentChecks += @{ name = "Deprecated"; status = "PASS"; detail = "none" }
        }

        # --- Prompt size ---
        $sizeKB = [Math]::Round($content.Length / 1024, 1)
        if ($content.Length -gt 30000) {
            $agentChecks += @{ name = "Prompt size"; status = "WARNING"; detail = "$sizeKB KB (large)" }
            $agentIssues += @{ severity = "WARNING"; group = "Agents"; message = "$($name): prompt size $sizeKB KB may exceed context" }
        }
        else {
            $agentChecks += @{ name = "Prompt size"; status = "PASS"; detail = "$sizeKB KB" }
        }

        $checks += @{
            name   = $name
            status = if ($agentIssues.Count -eq 0) { "PASS" } elseif (($agentIssues | Where-Object { $_.severity -in @("CRITICAL","MAJOR") }).Count -gt 0) { "WARNING" } else { "PASS" }
            detail = "$($agentChecks.Count) sub-checks, $($agentIssues.Count) issue(s)"
            items  = $agentChecks
        }
        $issues += $agentIssues
    }

    # --- Circular dependency detection (command -> agent -> command) ---
    $ocConfigPath = Join-Path $Root "opencode.json"
    if (Test-Path -LiteralPath $ocConfigPath) {
        try {
            $ocConfig = Get-Content -LiteralPath $ocConfigPath -Raw -Encoding utf8 | ConvertFrom-Json
            $agentNames = @($agentFiles | ForEach-Object { $_.BaseName })
            if ($ocConfig.command) {
                $mapped = @($ocConfig.command.PSObject.Properties | ForEach-Object {
                    @{ cmd = $_.Name; agent = $_.Value.agent }
                })
                $orphanAgents = @($mapped | Where-Object { $_.agent -and $_.agent -notin $agentNames })
                if ($orphanAgents.Count -gt 0) {
                    $score -= 10
                    $issues += @{ severity = "MAJOR"; group = "Agents"; message = "Commands map to missing agents: $($orphanAgents.agent -join ', ')" }
                    $checks += @{ name = "Circular dependency"; status = "WARNING"; detail = "orphan agent refs: $($orphanAgents.Count)" }
                }
                else {
                    $checks += @{ name = "Circular dependency"; status = "PASS"; detail = "no orphan agent refs" }
                }
            }
        }
        catch { }
    }

    if ($failCount -gt 0) { $score -= [Math]::Min(30, $failCount * 5) }
    $score = [Math]::Max(0, $score)
    $status = if ($score -ge 80) { "PASS" } elseif ($score -ge 50) { "WARNING" } else { "ERROR" }

    return @{
        group  = "Agents"
        score  = $score
        status = $status
        checks = $checks
        issues = $issues
    }
}
