param(
    [Parameter(Mandatory = $false)]
    [string]$opencodeDir = ".opencode"
)

$toolVersion = "1.0.0"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$allPass = $true
$checks = @()

function Get-AgentNames {
    $agents = Get-ChildItem -Path "$opencodeDir/agents" -Filter "*.md"
    return $agents | ForEach-Object { $_.BaseName }
}

function Get-CommandNames {
    $cmds = Get-ChildItem -Path "$opencodeDir/commands" -Filter "*.md"
    return $cmds | ForEach-Object { $_.BaseName }
}

function Get-SkillNames {
    $skills = Get-ChildItem -Path "$opencodeDir/skills" -Filter "*.md" -Recurse
    return $skills | ForEach-Object { $_.BaseName }
}

$agentNames = Get-AgentNames
$commandNames = Get-CommandNames
$skillNames = Get-SkillNames

Write-Host "=== Cross-Reference Validator ===`n" -ForegroundColor Cyan

# 1. Agent → Command references
foreach ($agent in $agentNames) {
    $content = Get-Content -LiteralPath "$opencodeDir/agents/$agent.md" -Raw
    foreach ($cmd in $commandNames) {
        if ($content -match "team-$cmd" -and -not (Test-Path "$opencodeDir/commands/team-$cmd.md")) {
            $checks += [PSCustomObject]@{ Check = "agent→command"; From = "$agent.md"; Target = "team-$cmd.md"; Status = "FAIL"; Message = "References non-existent command" }
            $allPass = $false
        }
    }
}

# 2. Command → Agent references
foreach ($cmd in $commandNames) {
    $content = Get-Content -LiteralPath "$opencodeDir/commands/team-$cmd.md" -Raw
    $agentRef = [regex]::Match($content, "agent:\s*(\w+)")
    if ($agentRef.Success) {
        $agentFile = "$($agentRef.Groups[1].Value).md"
        if (-not (Test-Path "$opencodeDir/agents/$agentFile")) {
            $checks += [PSCustomObject]@{ Check = "command→agent"; From = "team-$cmd.md"; Target = $agentFile; Status = "FAIL"; Message = "References non-existent agent" }
            $allPass = $false
        }
    }
}

# 3. SKILL.md → Agent references
$skillContent = Get-Content -LiteralPath "$opencodeDir/skills/dev-team/SKILL.md" -Raw
foreach ($agent in $agentNames) {
    if ($skillContent -match $agent -and -not (Test-Path "$opencodeDir/agents/$agent.md")) {
        $checks += [PSCustomObject]@{ Check = "SKILL.md→agent"; From = "SKILL.md"; Target = "$agent.md"; Status = "FAIL"; Message = "References non-existent agent" }
        $allPass = $false
    }
}

# 4. Agent → Agent references (subagent calls)
foreach ($agent in $agentNames) {
    $content = Get-Content -LiteralPath "$opencodeDir/agents/$agent.md" -Raw
    $calls = [regex]::Matches($content, 'subagent_type["\s:]+(\w+)')
    foreach ($call in $calls) {
        $targetAgent = "$($call.Groups[1].Value).md"
        if (-not (Test-Path "$opencodeDir/agents/$targetAgent")) {
            $checks += [PSCustomObject]@{ Check = "agent→subagent"; From = "$agent.md"; Target = $targetAgent; Status = "FAIL"; Message = "References non-existent subagent" }
            $allPass = $false
        }
    }
}

# 5. Script references in agents/commands
$allMd = Get-ChildItem -Path "$opencodeDir" -Filter "*.md" -Recurse
foreach ($md in $allMd) {
    $content = Get-Content -LiteralPath $md.FullName -Raw
    $scriptRefs = [regex]::Matches($content, '(?:backup-utility|rollback-utility|gitpush-utility|schema-validator|cross-ref-validator)\.ps1')
    foreach ($ref in $scriptRefs) {
        if (-not (Test-Path "$opencodeDir/scripts/$($ref.Value)")) {
            $checks += [PSCustomObject]@{ Check = "md→script"; From = $md.Name; Target = $ref.Value; Status = "FAIL"; Message = "References non-existent script" }
            $allPass = $false
        }
    }
}

# 6. SKILL section headers → actual section anchors
$skillFiles = Get-ChildItem -Path "$opencodeDir/skills" -Filter "*.md" -Recurse
foreach ($sf in $skillFiles) {
    $content = Get-Content -LiteralPath $sf.FullName -Raw
    $links = [regex]::Matches($content, '#(\w+(?:-\w+)*)')
    foreach ($link in $links) {
        $target = $link.Groups[1].Value
        if ($content -notmatch "(?i)^##+\s+.*\b$target") {
            $checks += [PSCustomObject]@{ Check = "skill→anchor"; From = $sf.Name; Target = "#$target"; Status = "WARN"; Message = "Possible broken internal link" }
        }
    }
}

# Output
foreach ($c in $checks) {
    $color = switch ($c.Status) {
        "FAIL" { "Red" }
        "WARN" { "Yellow" }
        default { "Green" }
    }
    Write-Host "[$($c.Status)] $($c.Check): $($c.From) → $($c.Target)" -ForegroundColor $color
    Write-Host "       $($c.Message)" -ForegroundColor $color
}

$summary = [PSCustomObject]@{
    tool      = "cross-ref-validator.ps1"
    version   = $toolVersion
    timestamp = $timestamp
    checks_total = $checks.Count
    checks_fail  = ($checks | Where-Object { $_.Status -eq "FAIL" }).Count
    checks_warn  = ($checks | Where-Object { $_.Status -eq "WARN" }).Count
    all_pass   = $allPass
    checks     = $checks
}

$summary | ConvertTo-Json -Depth 3 | Set-Content -LiteralPath "$opencodeDir/scripts/cross-ref-validator-report.json"
Write-Host "`nReport: $opencodeDir/scripts/cross-ref-validator-report.json" -ForegroundColor Cyan
exit $(if ($allPass) { 0 } else { 1 })
