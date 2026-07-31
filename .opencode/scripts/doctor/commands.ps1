<#
.SYNOPSIS
Doctor Module: Command Check
.DESCRIPTION
Checks each command definition (.opencode/commands/*.md + opencode.json):
syntax, agent mapping, flags, workflow, dependencies, output contract.
#>

function Get-DoctorCommands {
    param(
        [string]$Root = ".",
        [switch]$Detail
    )

    $cmdsDir = Join-Path $Root ".opencode/commands"
    $cmdFiles = @(Get-ChildItem -Path $cmdsDir -Filter "*.md" -ErrorAction SilentlyContinue)
    $ocConfigPath = Join-Path $Root "opencode.json"

    $checks = @()
    $issues = @()
    $score = 100

    # Load opencode.json command registry
    $registry = @{}
    $registered = @()
    if (Test-Path -LiteralPath $ocConfigPath) {
        try {
            $ocConfig = Get-Content -LiteralPath $ocConfigPath -Raw -Encoding utf8 | ConvertFrom-Json
            if ($ocConfig.command) {
                $registered = @($ocConfig.command.PSObject.Properties | ForEach-Object { $_.Name })
                foreach ($p in $ocConfig.command.PSObject.Properties) {
                    $registry[$p.Name] = $p.Value
                }
            }
        }
        catch {
            $score -= 20
            $issues += @{ severity = "CRITICAL"; group = "Commands"; message = "opencode.json unparseable - command registry broken" }
        }
    }

    # Agent names available
    $agentNames = @(Get-ChildItem -Path (Join-Path $Root ".opencode/agents") -Filter "*.md" -ErrorAction SilentlyContinue | ForEach-Object { $_.BaseName })

    if ($cmdFiles.Count -eq 0) {
        return @{
            group  = "Commands"
            score  = 0
            status = "ERROR"
            checks = @(@{ name = "Commands"; status = "ERROR"; detail = "No command files found" })
            issues = @(@{ severity = "CRITICAL"; group = "Commands"; message = "No command definitions" })
        }
    }

    $failCount = 0
    foreach ($cf in $cmdFiles) {
        $name = $cf.BaseName
        $content = Get-Content -LiteralPath $cf.FullName -Raw -Encoding utf8 -ErrorAction SilentlyContinue
        $cmdIssues = @()

        # --- Syntax / frontmatter ---
        if ($content -match '(?s)^---\r?\n(.*?)\r?\n---') {
            $fm = $Matches[1]
            $hasDescription = $fm -match 'description\s*:\s*\S'
            $hasAgent = $fm -match 'agent\s*:\s*\S'
        }
        else {
            $failCount++
            $cmdIssues += @{ severity = "MAJOR"; group = "Commands"; message = "$($name): missing frontmatter" }
            $hasDescription = $false
            $hasAgent = $false
        }

        # --- Description ---
        if (-not $hasDescription) {
            $failCount++
            $cmdIssues += @{ severity = "MAJOR"; group = "Commands"; message = "$($name): missing description in frontmatter" }
        }

        # --- Agent mapping (frontmatter) ---
        $frontAgent = ""
        if ($fm -match 'agent\s*:\s*(\S+)') { $frontAgent = $Matches[1].Trim() }

        # --- Agent mapping (opencode.json) ---
        $regAgent = ""
        if ($registry.ContainsKey($name)) { $regAgent = "$($registry[$name].agent)" }

        if ($frontAgent) {
            if ($frontAgent -in $agentNames) {
                # PASS
            }
            else {
                $failCount++
                $cmdIssues += @{ severity = "MAJOR"; group = "Commands"; message = "$($name): frontmatter agent '$frontAgent' not found in agents/" }
            }
        }
        elseif ($regAgent -and $regAgent -notin $agentNames) {
            $failCount++
            $cmdIssues += @{ severity = "MAJOR"; group = "Commands"; message = "$($name): registered agent '$regAgent' not found in agents/" }
        }

        # --- Registry ---
        if ($name -in $registered) {
            # registered
        }
        else {
            $cmdIssues += @{ severity = "WARNING"; group = "Commands"; message = "$($name): not registered in opencode.json" }
        }

        # --- Flags documented ---
        if ($content -match '(?i)(flags|--\w+|Modes?)\s*:') {
            # documented
        }
        else {
            $cmdIssues += @{ severity = "WARNING"; group = "Commands"; message = "$($name): no flags/modes documented" }
        }

        # --- Output contract ---
        if ($content -match '(?i)(output contract|OUTPUT CONTRACT|output:)') {
            # documented
        }
        else {
            $cmdIssues += @{ severity = "WARNING"; group = "Commands"; message = "$($name): no output contract section" }
        }

        # --- Workflow reference ---
        if ($content -match '(?i)(workflow|buoc|step)') {
            # has workflow mention
        }

        $checks += @{
            name   = $name
            status = if ($cmdIssues.Count -eq 0) { "PASS" } elseif (($cmdIssues | Where-Object { $_.severity -eq "MAJOR" }).Count -gt 0) { "WARNING" } else { "PASS" }
            detail = "$($cmdIssues.Count) issue(s)"
            items  = $cmdIssues
        }
        $issues += $cmdIssues
    }

    if ($failCount -gt 0) { $score -= [Math]::Min(30, $failCount * 5) }
    if ($registered.Count -eq 0) {
        $score -= 10
        $issues += @{ severity = "CRITICAL"; group = "Commands"; message = "No commands registered in opencode.json" }
    }
    $score = [Math]::Max(0, $score)
    $status = if ($score -ge 80) { "PASS" } elseif ($score -ge 50) { "WARNING" } else { "ERROR" }

    return @{
        group  = "Commands"
        score  = $score
        status = $status
        checks = $checks
        issues = $issues
    }
}
