param(
    [switch]$dryRun,
    [switch]$force,
    [switch]$evolve,              # Run full System Evolution Engine
    [switch]$semanticDiff,        # Run only Semantic Diff Engine
    [switch]$compatibility,       # Run only Compatibility Checker
    [switch]$migration,           # Run only Migration System
    [switch]$selfHeal,            # Run only Self Healing Engine
    [switch]$knowledgeMigrate,    # Run only Knowledge Migration
    [switch]$healthScore,         # Run only Health Score
    [switch]$report,              # Run only Evolution Report
    [string]$evolutionMode = "full"  # full | scan | heal | report
)

$ErrorActionPreference = "Stop"
$root = ".opencode"
$report = @{
    scanned_at = (Get-Date -Format "o")
    agents = @{}
    commands = @{}
    skills = @{}
    scripts = @{}
    knowledge = @{}
    issues = @()
    cross_refs = @{}
}

function Parse-Frontmatter {
    param([string]$Path)
    $content = Get-Content -LiteralPath $Path -Raw -Encoding utf8
    if ($content -match '(?s)^---\s*\r?\n(.+?)\r?\n---') {
        $yaml = $Matches[1]
        $result = @{}
        foreach ($line in $yaml -split '\r?\n') {
            if ($line -match '^(\w[\w_-]*)\s*:\s*(.+)$') {
                $key = $Matches[1].Trim()
                $val = $Matches[2].Trim().Trim('"', "'")
                $result[$key] = $val
            }
        }
        return $result, $content
    }
    return $null, $content
}

Write-Host "Scanning agents..." -ForegroundColor Cyan
Get-ChildItem -Path "$root\agents\*.md" | ForEach-Object {
    $fm, $raw = Parse-Frontmatter -Path $_.FullName
    if ($fm) {
        $report.agents[$_.BaseName] = @{
            file = "agents/$($_.Name)"
            description = $fm.description
            mode = $fm.mode
            model = $fm.model
            permissions = @{
                read = if ($fm.read) { $fm.read } else { "deny" }
                grep = if ($fm.grep) { $fm.grep } else { "deny" }
                glob = if ($fm.glob) { $fm.glob } else { "deny" }
                edit = if ($fm.edit) { $fm.edit } else { "deny" }
                bash = if ($fm.bash) { $fm.bash } else { "deny" }
            }
        }
    }
}

Write-Host "Scanning commands..." -ForegroundColor Cyan
Get-ChildItem -Path "$root\commands\*.md" | ForEach-Object {
    $fm, $raw = Parse-Frontmatter -Path $_.FullName
    if ($fm) {
        $report.commands[$_.BaseName] = @{
            file = "commands/$($_.Name)"
            description = $fm.description
            agent = $fm.agent
            deprecated = ($fm.deprecated -eq "true")
        }
    }
}

Write-Host "Scanning skills..." -ForegroundColor Cyan
Get-ChildItem -Path "$root\skills\*\SKILL.md" | ForEach-Object {
    $fm, $raw = Parse-Frontmatter -Path $_.FullName
    if ($fm) {
        $skillDir = $_.Directory.Name
        $report.skills[$skillDir] = @{
            name = $fm.name
            description = $fm.description
            schema_version = $fm.schema_version
            file = "skills/$skillDir/SKILL.md"
        }
    }
}

Write-Host "Scanning scripts..." -ForegroundColor Cyan
Get-ChildItem -Path "$root\scripts\*.ps1" | ForEach-Object {
    $content = Get-Content -LiteralPath $_.FullName -Raw -Encoding utf8
    $summary = ""
    if ($content -match '<#\s*\n\.SYNOPSIS\s*\n(.+?)(?:\n\.|\n#>|`)') {
        $summary = $Matches[1].Trim()
    }
    $report.scripts[$_.BaseName] = @{
        file = "scripts/$($_.Name)"
        summary = if ($summary) { $summary } else { "Utility script" }
        size = (Get-Item $_).Length
    }
}

Write-Host "Scanning knowledge..." -ForegroundColor Cyan
if (Test-Path "$root\knowledge") {
    Get-ChildItem -Path "$root\knowledge\*" -Recurse -File | ForEach-Object {
        $base = (Get-Item "$root\knowledge").FullName
        $rel = $_.FullName.Substring($base.Length + 1)
        $report.knowledge["knowledge/$rel"] = @{
            file = "knowledge/$rel"
            size = $_.Length
        }
    }
}

Write-Host "Cross-referencing..." -ForegroundColor Cyan
$report.cross_refs = @{
    command_to_agent = @{}
    agent_to_commands = @{}
    skill_to_commands = @{}
    orphans = @()
    missing = @()
}

foreach ($cmdName in $report.commands.Keys) {
    $cmd = $report.commands[$cmdName]
    $agentName = $cmd.agent
    if ($agentName) {
        $report.cross_refs.command_to_agent[$cmdName] = $agentName
        if (-not $report.cross_refs.agent_to_commands.ContainsKey($agentName)) {
            $report.cross_refs.agent_to_commands[$agentName] = @()
        }
        $list = $report.cross_refs.agent_to_commands[$agentName]
        $list += $cmdName
        $report.cross_refs.agent_to_commands[$agentName] = $list
        if (-not $report.agents.ContainsKey($agentName)) {
            $report.cross_refs.missing += "Command '$cmdName' references agent '$agentName' which does not exist"
            $report.issues += "MISSING_AGENT: command=$cmdName, agent=$agentName"
        }
    }
}

foreach ($agentName in $report.agents.Keys) {
    $cmds = $report.cross_refs.agent_to_commands[$agentName]
    if (-not $cmds -or $cmds.Count -eq 0) {
        if ($agentName -ne "general") {
            $report.cross_refs.orphans += "Agent '$agentName' is not referenced by any command"
            $report.issues += "ORPHAN_AGENT: agent=$agentName"
        }
    }
}

foreach ($skillName in $report.skills.Keys) {
    $report.cross_refs.skill_to_commands[$skillName] = @()
}
foreach ($cmdName in $report.commands.Keys) {
    $cmdFile = "$root/$($report.commands[$cmdName].file)"
    if (Test-Path $cmdFile) {
        $content = Get-Content -LiteralPath $cmdFile -Raw -Encoding utf8
        foreach ($skillName in $report.skills.Keys) {
            if ($content -match [regex]::Escape($skillName)) {
                $list = $report.cross_refs.skill_to_commands[$skillName]
                $list += @{command = $cmdName; file = $cmdFile}
                $report.cross_refs.skill_to_commands[$skillName] = $list
            }
        }
    }
}

# === BUILD SYSTEM MAP ===
Write-Host "Generating SYSTEM_MAP.md..." -ForegroundColor Cyan

$nAgents = ($report.agents.Keys | Measure-Object).Count
$nCmds = ($report.commands.Keys | Measure-Object).Count
$nSkills = ($report.skills.Keys | Measure-Object).Count
$nScripts = ($report.scripts.Keys | Measure-Object).Count
$nKnowledge = ($report.knowledge.Keys | Measure-Object).Count
$now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$lines = New-Object System.Collections.ArrayList
$nl = "`r`n"

$null = $lines.Add("# He Thong .opencode - So Do Tong The")
$null = $lines.Add("")
$null = $lines.Add("> **Tu dong tao luc:** $now")
$null = $lines.Add("> **Workflow ID:** WF-$(Get-Date -Format 'yyyyMMdd')-SYNC")
$null = $lines.Add("> **Cap nhat:** Toan bo agents, commands, skills, scripts, knowledge")
$null = $lines.Add("")
$null = $lines.Add("---")
$null = $lines.Add("")
$null = $lines.Add("## Muc luc")
$null = $lines.Add("")
$null = $lines.Add("- [Cau truc thu muc](#cau-truc-thu-muc)")
$null = $lines.Add("- [Agents](#agents)")
$null = $lines.Add("- [Commands](#commands)")
$null = $lines.Add("- [Skills](#skills)")
$null = $lines.Add("- [Scripts](#scripts)")
$null = $lines.Add("- [Knowledge Base](#knowledge-base)")
$null = $lines.Add("- [Ma tran Cross-Reference](#ma-tran-cross-reference)")
$null = $lines.Add("- [Workflow Overview](#workflow-overview)")
$null = $lines.Add("- [Phat hien van de](#phat-hien-van-de)")
$null = $lines.Add("")
$null = $lines.Add("---")
$null = $lines.Add("")
$null = $lines.Add("## Cau truc thu muc")
$null = $lines.Add("")
$null = $lines.Add('```')
$null = $lines.Add(".opencode/")
$null = $lines.Add("|-- agents/           # $nAgents agent definitions")
$null = $lines.Add("|-- commands/         # $nCmds command templates")
$null = $lines.Add("|-- skills/           # $nSkills skill packages")
$null = $lines.Add("|-- scripts/          # $nScripts utility scripts")
$null = $lines.Add("|-- knowledge/        # Knowledge base")
$null = $lines.Add("|-- backup/           # Backup artifacts")
$null = $lines.Add("|-- workflow/         # Workflow artifacts")
$null = $lines.Add("'-- workflows/        # Workflow snapshots")
$null = $lines.Add('```')
$null = $lines.Add("")
$null = $lines.Add("---")
$null = $lines.Add("")
$null = $lines.Add("## Agents")
$null = $lines.Add("")
$null = $lines.Add("| Agent | Description | Model | Permissions | Commands |")
$null = $lines.Add("|-------|-------------|-------|-------------|----------|")

$sortedAgents = $report.agents.Keys | Sort-Object
foreach ($agentName in $sortedAgents) {
    $a = $report.agents[$agentName]
    $perms = @()
    if ($a.permissions.read -eq 'allow') { $perms += 'read' }
    if ($a.permissions.grep -eq 'allow') { $perms += 'grep' }
    if ($a.permissions.glob -eq 'allow') { $perms += 'glob' }
    if ($a.permissions.edit -eq 'allow') { $perms += 'edit' }
    if ($a.permissions.bash -eq 'allow') { $perms += 'bash' }
    $cmdsList = $report.cross_refs.agent_to_commands[$agentName]
    $cmds = if ($cmdsList) { $cmdsList -join ', ' } else { "---" }
    $desc = $a.description -replace '\|', '/'
    $model = if ($a.model) { $a.model } else { "default" }
    $null = $lines.Add("| $agentName | $desc | $model | $($perms -join ', ') | $cmds |")
}

$null = $lines.Add("")
$null = $lines.Add("---")
$null = $lines.Add("")
$null = $lines.Add("## Commands")
$null = $lines.Add("")
$null = $lines.Add("| Command | Description | Agent | Deprecated |")
$null = $lines.Add("|---------|-------------|-------|------------|")

$sortedCmds = $report.commands.Keys | Sort-Object
foreach ($cmdName in $sortedCmds) {
    $c = $report.commands[$cmdName]
    $dep = if ($c.deprecated) { "Yes" } else { "" }
    $desc = $c.description -replace '\|', '/'
    $agent = if ($c.agent) { $c.agent } else { "---" }
    $null = $lines.Add("| /$cmdName | $desc | $agent | $dep |")
}

$null = $lines.Add("")
$null = $lines.Add("---")
$null = $lines.Add("")
$null = $lines.Add("## Skills")
$null = $lines.Add("")
$null = $lines.Add("| Skill | Name | Description | Schema Version |")
$null = $lines.Add("|-------|------|-------------|----------------|")

$sortedSkills = $report.skills.Keys | Sort-Object
foreach ($skillName in $sortedSkills) {
    $s = $report.skills[$skillName]
    $desc = $s.description -replace '\|', '/'
    $null = $lines.Add("| $skillName | $($s.name) | $desc | $($s.schema_version) |")
}

$null = $lines.Add("")
$null = $lines.Add("---")
$null = $lines.Add("")
$null = $lines.Add("## Scripts")
$null = $lines.Add("")
$null = $lines.Add("| Script | Summary | Size |")
$null = $lines.Add("|--------|---------|------|")

$sortedScripts = $report.scripts.Keys | Sort-Object
foreach ($scriptName in $sortedScripts) {
    $s = $report.scripts[$scriptName]
    if ($s.size -gt 1MB) { $sz = "{0:N1} MB" -f ($s.size / 1MB) }
    else { $sz = "{0:N0} KB" -f ($s.size / 1KB) }
    $summary = $s.summary -replace '\|', '/' -replace "`n", ' '
    $null = $lines.Add("| $scriptName | $summary | $sz |")
}

$null = $lines.Add("")
$null = $lines.Add("---")
$null = $lines.Add("")
$null = $lines.Add("## Knowledge Base")
$null = $lines.Add("")
$null = $lines.Add("| File | Size |")
$null = $lines.Add("|------|------|")

$sortedKnowledge = $report.knowledge.Keys | Sort-Object
foreach ($kf in $sortedKnowledge) {
    $k = $report.knowledge[$kf]
    if ($k.size -gt 1MB) { $sz = "{0:N1} MB" -f ($k.size / 1MB) }
    else { $sz = "{0:N0} KB" -f ($k.size / 1KB) }
    $null = $lines.Add("| $kf | $sz |")
}

$null = $lines.Add("")
$null = $lines.Add("---")
$null = $lines.Add("")
$null = $lines.Add("## Ma tran Cross-Reference")
$null = $lines.Add("")
$null = $lines.Add("### Command -> Agent Mapping")
$null = $lines.Add("")
$null = $lines.Add("| Command | Agent | Agent File |")
$null = $lines.Add("|---------|-------|------------|")

# Add all commands (even ones not in report for the static table)
$staticCmdMap = @(
    @{cmd="team"; agent="general"; file="commands/team.md"},
    @{cmd="team-syncdocs"; agent="general"; file="commands/team-syncdocs.md"},
    @{cmd="team-analyze"; agent="analyst"; file="agents/analyst.md"},
    @{cmd="team-plan"; agent="planner"; file="agents/planner.md"},
    @{cmd="team-review"; agent="reviewer"; file="agents/reviewer.md"},
    @{cmd="team-build"; agent="builder"; file="agents/builder.md"},
    @{cmd="team-ui-audit"; agent="ui-beautifier"; file="agents/ui-beautifier.md"},
    @{cmd="team-testplan"; agent="test-planner"; file="agents/test-planner.md"},
    @{cmd="team-test"; agent="tester"; file="agents/tester.md"},
    @{cmd="team-selfimprove"; agent="self-improver"; file="agents/self-improver.md"},
    @{cmd="team-gitguard"; agent="guardian"; file="agents/guardian.md"},
    @{cmd="team-gitpush"; agent="pusher"; file="agents/pusher.md"},
    @{cmd="team-cleanup"; agent="cleaner"; file="agents/cleaner.md"},
    # @{cmd="team-explore"; agent="codebase-explorer"; file="agents/codebase-explorer.md"},  # DEPRECATED — merged into analyst
    @{cmd="backup"; agent="backup-agent"; file="commands/backup.md"}
)
foreach ($entry in $staticCmdMap) {
    $null = $lines.Add("| /$($entry.cmd) | $($entry.agent) | $($entry.file) |")
}

$null = $lines.Add("")
$null = $lines.Add("### Agent -> Commands")
$null = $lines.Add("")
$null = $lines.Add("| Agent | Commands |")
$null = $lines.Add("|-------|----------|")

foreach ($agentName in $sortedAgents) {
    $cmdsList = $report.cross_refs.agent_to_commands[$agentName]
    if (-not $cmdsList) { $cmdsList = @("Orphaned") }
    $null = $lines.Add("| $agentName | $($cmdsList -join ', ') |")
}

$null = $lines.Add("")
$null = $lines.Add("---")
$null = $lines.Add("")
$null = $lines.Add("## Workflow Overview")
$null = $lines.Add("")
$null = $lines.Add('```')
@(
    "                    +---------+",
    "                    |  START  |",
    "                    +----+----+",
    "                         |",
    "                         v",
    "                    +---------+",
    "                    |ANALYZE  |",
    "                    +----+----+",
    "                         |",
    "                         v",
    "                    +---------+",
    "                    | DESIGN  |",
    "                    +----+----+",
    "                         |",
    "                         v",
    "                    +---------+",
    "                    |  PLAN   |",
    "                    +----+----+",
    "                         |",
    "                         v",
    "                    +---------+",
    "                    | REVIEW  |",
    "                    +----+----+",
    "                    +----+----+",
    "                    |         |",
    "                    v         v",
    "             +---------+  +--------------+",
    "             |APPROVED |  |CHANGES_REQ   |",
    "             +----+----+  +------+-------+",
    "                  |              |",
    "                  v              v",
    "             +---------+   +---------+",
    "             | BACKUP  |   |  PLAN   |",
    "             +----+----+   +---------+",
    "                  |",
    "                  v",
    "             +---------+",
    "             |  BUILD  |",
    "             +----+----+",
    "                  |",
    "                  v",
    "             +-------+----+",
    "             | STATIC ANALYSIS |",
    "             +-----+------+",
    "                   |",
    "                   v",
    "             +-------+----+",
    "             |  UI AUDIT  |",
    "             +-----+------+",
    "                   |",
    "                   v",
    "             +---------+",
    "             | TESTPLAN|",
    "             +----+----+",
    "                   |",
    "                   v",
    "             +---------+",
    "             |  TEST   |",
    "             +----+----+",
    "              +---+---+",
    "              |       |",
    "              v       v",
    "          +--------+ +--------+",
    "          | PASS   | | FAIL   |",
    "          +---+----+ +--------+",
    "              |",
    "         +-----------+",
    "         |SELF_IMPRV.|",
    "         +-----+-----+",
    "               |",
    "         +----------+",
    "         | APPROVAL |",
    "         +----+-----+",
    "              |",
    "       +------+------+",
    "       |             |",
    "       v             v",
    "  +---------+  +---------+",
    "  |COMPLETE |  |COMPLETE |",
    "  +---------+  +---------+"
) | ForEach-Object { $null = $lines.Add($_) }
$null = $lines.Add('```')
$null = $lines.Add("")
$null = $lines.Add("### Buoc theo Command")
$null = $lines.Add("")
$null = $lines.Add("| Buoc | Command | Agent | File |")
$null = $lines.Add("|------|---------|-------|------|")
$null = $lines.Add("| 1 | /team-analyze | analyst | commands/team-analyze.md |")
$null = $lines.Add("| 2-3 | /team-plan | planner (m rong) | commands/team-plan.md |")
$null = $lines.Add("| 4 | /team-review | reviewer | commands/team-review.md |")
$null = $lines.Add("| 5 | Backup (utility) | --- | scripts/backup-utility.ps1 |")
$null = $lines.Add("| 6 | /team-build | builder | commands/team-build.md |")
$null = $lines.Add("| 7 | Static Analysis | --- | skills/dev-team/SKILL.md |")
$null = $lines.Add("| 8 | /team-ui-audit | ui-beautifier | commands/team-ui-audit.md |")
$null = $lines.Add("| 9 | /team-testplan | test-planner | commands/team-testplan.md |")
$null = $lines.Add("| 10 | /team-test | tester | commands/team-test.md |")
$null = $lines.Add("| 11 | /team-selfimprove | self-improver | commands/team-selfimprove.md |")
$null = $lines.Add("| 12 | /team-gitpush | pusher | commands/team-gitpush.md |")
$null = $lines.Add("")
$null = $lines.Add("### Pre/Post Steps")
$null = $lines.Add("")
$null = $lines.Add("| Step | Command | Agent | File |")
$null = $lines.Add("|------|---------|-------|------|")
$null = $lines.Add("| Pre-push | /team-gitguard | guardian | commands/team-gitguard.md |")
$null = $lines.Add("| Cleanup | /team-cleanup | cleaner | skills/workspace-cleaner/SKILL.md |")
# $null = $lines.Add("| Explore | /team-explore (DEPR.) | codebase-explorer | commands/team-explore.md |")  # DEPRECATED
$null = $lines.Add("| Backup | /backup | backup-agent | commands/backup.md |")
$null = $lines.Add("")
$null = $lines.Add("---")
$null = $lines.Add("")
$null = $lines.Add("## Phat hien van de")
$null = $lines.Add("")
$null = $lines.Add("| # | Loai | Chi tiet |")
$null = $lines.Add("|---|------|----------|")

if ($report.issues.Count -eq 0) {
    $null = $lines.Add("| --- | OK | Khong phat hien van de. He thong dong bo hoan chinh. |")
} else {
    $i = 1
    foreach ($issue in $report.issues) {
        $parts = $issue -split ': ', 2
        $type = if ($parts.Count -gt 1) { $parts[0] } else { "ISSUE" }
        $detail = if ($parts.Count -gt 1) { $parts[1] } else { $issue }
        $null = $lines.Add("| $i | $type | $detail |")
        $i++
    }
}

$null = $lines.Add("")
$null = $lines.Add("---")
$null = $lines.Add("")
$null = $lines.Add("> **Tong so:** $nAgents agents . $nCmds commands . $nSkills skills . $nScripts scripts . $nKnowledge knowledge files")
$null = $lines.Add("> **Sinh boi:** sync-system-docs.ps1")

$mapContent = $lines -join "`r`n"
$mapPath = "$root\SYSTEM_MAP.md"

if (-not $dryRun) {
    $mapContent | Out-File -FilePath $mapPath -Encoding utf8
    Write-Host "OK SYSTEM_MAP.md generated at $mapPath" -ForegroundColor Green
} else {
    Write-Host "DRY-RUN: Would generate SYSTEM_MAP.md" -ForegroundColor Yellow
}

# === UPDATE team.md ===
Write-Host "Updating team.md command table..." -ForegroundColor Cyan
$teamFilePath = "$root\commands\team.md"
$teamContent = Get-Content -LiteralPath $teamFilePath -Raw -Encoding utf8

$cmdTable = @()
$cmdTable += "| Buoc | Command | Agent | File command |"
$cmdTable += "|------|---------|-------|-------------|"
$cmdTable += "| 0 | /team-syncdocs | general | team-syncdocs.md |"
$cmdTable += "| 0 | /team-cleanup | cleaner | team-cleanup.md |"
$cmdTable += "| 0 | /team | general | team.md |"
$cmdTable += "| 1 | /team-analyze | analyst | team-analyze.md |"
$cmdTable += "| 2-3 | /team-plan | planner (mo rong) | team-plan.md |"
$cmdTable += "| 4 | /team-review | reviewer | team-review.md |"
$cmdTable += "| 4.5 | /team-gitguard | guardian | team-gitguard.md |"
$cmdTable += "| 6 | /team-build | builder | team-build.md |"
$cmdTable += "| 8 | /team-ui-audit | ui-beautifier | team-ui-audit.md |"
$cmdTable += "| 9 | /team-testplan | test-planner | team-testplan.md |"
$cmdTable += "| 10 | /team-test | tester | team-test.md |"
$cmdTable += "| 11 | team (goi tu) | self-improver | team-selfimprove.md |"
$cmdTable += "| 12 | /team-gitpush | pusher | team-gitpush.md |"

$newTable = $cmdTable -join "`r`n"

    if ($teamContent -match '(?s)(\| Buoc \| Command \| Agent \| File command \|[\r\n]+\|------\|---------\|-------\|-------------[\|]*[\r\n]+)((?:\|[^\n]*\|[^\n]*\|[^\n]*\|[^\n]*\|[\r\n]*)+)') {
    $fullMatch = $Matches[0]
    $newSection = $newTable + "`r`n"
    $newTeamContent = $teamContent -replace [regex]::Escape($fullMatch), $newSection
    if (-not $dryRun) {
        $newTeamContent | Out-File -LiteralPath $teamFilePath -Encoding utf8
        Write-Host "OK team.md table updated" -ForegroundColor Green
    } else {
        Write-Host "DRY-RUN: Would update team.md table" -ForegroundColor Yellow
    }
} else {
    Write-Host "WARNING: Could not find table in team.md" -ForegroundColor Yellow
    $report.issues += "UPDATE_FAILED: Cannot locate table in team.md"
}

# === UPDATE SKILL.md ===
$skillPath = "$root\skills\dev-team\SKILL.md"
if (Test-Path $skillPath) {
    Write-Host "Updating SKILL.md integration table..." -ForegroundColor Cyan
    $skillContent = Get-Content -LiteralPath $skillPath -Raw -Encoding utf8

    $skillTable = @()
    $skillTable += "| Buoc | Command | Agent | File command |"
    $skillTable += "|------|---------|-------|-------------|"
    $skillTable += "| 0 | /team-syncdocs | general | team-syncdocs.md |"
    $skillTable += "| 0 | /team-cleanup | cleaner | team-cleanup.md |"
    $skillTable += "| 0 | /team | general | team.md |"
    $skillTable += "| 1 | /team-analyze | analyst | team-analyze.md |"
    $skillTable += "| 2-3 | /team-plan | planner (mo rong) | team-plan.md |"
    $skillTable += "| 4 | /team-review | reviewer | team-review.md |"
    $skillTable += "| 6 | /team-build | builder | team-build.md |"
    $skillTable += "| 8 | /team-ui-audit | ui-beautifier | team-ui-audit.md |"
    $skillTable += "| 9 | /team-testplan | test-planner | team-testplan.md |"
    $skillTable += "| 10 | /team-test | tester | team-test.md |"
    $skillTable += "| 11 | team (goi tu) | self-improver | team-selfimprove.md |"
    $skillTable += "| 12 | /team-gitpush | pusher | team-gitpush.md |"

    $newSkillTable = $skillTable -join "`r`n"

    if ($skillContent -match '(?s)(\| Buoc \| Command \| Agent \| File command \|[\r\n]+\|------\|---------\|-------\|-------------[\|]*[\r\n]+)((?:\|[^\n]*\|[^\n]*\|[^\n]*\|[^\n]*\|[\r\n]*)+)') {
        $fullMatch = $Matches[0]
        $newSection = $newSkillTable + "`r`n"
        $newSkillContent = $skillContent -replace [regex]::Escape($fullMatch), $newSection
        if (-not $dryRun) {
            $newSkillContent | Out-File -LiteralPath $skillPath -Encoding utf8
            Write-Host "OK SKILL.md table updated" -ForegroundColor Green
        } else {
            Write-Host "DRY-RUN: Would update SKILL.md table" -ForegroundColor Yellow
        }
    } else {
        Write-Host "WARNING: Could not find table in SKILL.md" -ForegroundColor Yellow
        $report.issues += "UPDATE_FAILED: Cannot locate table in SKILL.md"
    }
}

# === EVOLUTION ENGINE ORCHESTRATION ===
$runEvolution = $evolve -or $semanticDiff -or $compatibility -or $migration -or $selfHeal -or $knowledgeMigrate -or $healthScore -or $report -or ($evolutionMode -ne "none")
$evolutionResults = @{}
$evolutionDir = "$root\scripts\evolution"
$reportsDir = "$evolutionDir\reports"

if ($runEvolution -and -not $dryRun) {
    if (-not (Test-Path $reportsDir)) { New-Item -ItemType Directory -Path $reportsDir -Force | Out-Null }
    
    Write-Host "" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Magenta
    Write-Host "  SYSTEM EVOLUTION ENGINE" -ForegroundColor Magenta
    Write-Host "========================================" -ForegroundColor Magenta
    
    $runSemantic = $semanticDiff -or ($evolutionMode -in @('full', 'scan')) -or $evolve
    $runCompat = $compatibility -or ($evolutionMode -in @('full', 'scan')) -or $evolve
    $runMigration = $migration -or ($evolutionMode -in @('full', 'scan')) -or $evolve
    $runHeal = $selfHeal -or ($evolutionMode -in @('full', 'heal')) -or $evolve
    $runKnowledge = $knowledgeMigrate -or ($evolutionMode -in @('full', 'scan')) -or $evolve
    $runHealth = $healthScore -or ($evolutionMode -in @('full')) -or $evolve
    $runReport = $report -or ($evolutionMode -in @('full')) -or $evolve
    
    $evolutionSteps = @()
    $evolutionIssues = @()
    
    # 1. Semantic Diff Engine
    if ($runSemantic) {
        Write-Host "`n[1/7] Semantic Diff Engine..." -ForegroundColor Cyan
        $sdScript = "$evolutionDir\semantic-diff.ps1"
        if (Test-Path $sdScript) {
            $agentContracts = Get-ChildItem -Path "$root\system\contracts\*.yaml" -ErrorAction SilentlyContinue
            foreach ($ac in $agentContracts) {
                $agentName = $ac.BaseName
                try {
                    $sdResult = & $sdScript -agentName $agentName -outputDir $reportsDir
                    $evolutionResults["semantic_diff_$agentName"] = $sdResult
                    $evolutionSteps += "Semantic Diff: $agentName — $($sdResult.summary)"
                } catch {
                    $evolutionIssues += "SEMANTIC_DIFF_FAILED: agent=$agentName error=$($_.Exception.Message)"
                }
            }
        } else {
            $evolutionIssues += "SKIPPED: semantic-diff.ps1 not found"
        }
    }
    
    # 2. Compatibility Checker
    if ($runCompat) {
        Write-Host "[2/7] Compatibility Checker..." -ForegroundColor Cyan
        $ccScript = "$evolutionDir\compatibility-checker.ps1"
        if (Test-Path $ccScript) {
            try {
                $ccResult = & $ccScript -contractDir "$root\system\contracts" -agentsDir "$root\agents" -outputDir $reportsDir
                $evolutionResults["compatibility"] = $ccResult
                $evolutionSteps += "Compatibility: score=$($ccResult.compatibility_score)/100 issues=$($ccResult.issues.Count)"
            } catch {
                $evolutionIssues += "COMPATIBILITY_FAILED: $($_.Exception.Message)"
            }
        } else {
            $evolutionIssues += "SKIPPED: compatibility-checker.ps1 not found"
        }
    }
    
    # 3. Migration System
    if ($runMigration) {
        Write-Host "[3/7] Migration System..." -ForegroundColor Cyan
        $msScript = "$evolutionDir\migration-system.ps1"
        if (Test-Path $msScript) {
            try {
                $msResult = & $msScript -contractDir "$root\system\contracts" -outputDir $reportsDir
                $evolutionResults["migration"] = $msResult
                $evolutionSteps += "Migration: $($msResult.tasks.Count) tasks, $($msResult.affected_agents.Count) affected"
            } catch {
                $evolutionIssues += "MIGRATION_FAILED: $($_.Exception.Message)"
            }
        } else {
            $evolutionIssues += "SKIPPED: migration-system.ps1 not found"
        }
    }
    
    # 4. Self Healing Engine
    if ($runHeal) {
        Write-Host "[4/7] Self Healing Engine..." -ForegroundColor Cyan
        $shScript = "$evolutionDir\self-healing.ps1"
        if (Test-Path $shScript) {
            try {
                $shResult = & $shScript -contractDir "$root\system\contracts" -agentsDir "$root\agents" -commandsDir "$root\commands" -outputDir $reportsDir $(if ($force) { "-apply" } else { "" })
                $evolutionResults["self_healing"] = $shResult
                $evolutionSteps += "Self-healing: $($shResult.auto_fixed_count) fixed, $($shResult.pending_count) pending"
            } catch {
                $evolutionIssues += "SELF_HEALING_FAILED: $($_.Exception.Message)"
            }
        } else {
            $evolutionIssues += "SKIPPED: self-healing.ps1 not found"
        }
    }
    
    # 5. Knowledge Migration
    if ($runKnowledge) {
        Write-Host "[5/7] Knowledge Migration..." -ForegroundColor Cyan
        $kmScript = "$evolutionDir\knowledge-migration.ps1"
        if (Test-Path $kmScript) {
            try {
                $kmResult = & $kmScript -knowledgeDir "$root\knowledge" -agentsDir "$root\agents" -outputDir $reportsDir
                $evolutionResults["knowledge"] = $kmResult
                $evolutionSteps += "Knowledge: $($kmResult.deprecated_knowledge.Count) deprecated, $($kmResult.missing_knowledge.Count) missing"
            } catch {
                $evolutionIssues += "KNOWLEDGE_MIGRATION_FAILED: $($_.Exception.Message)"
            }
        } else {
            $evolutionIssues += "SKIPPED: knowledge-migration.ps1 not found"
        }
    }
    
    # 6. Health Score
    if ($runHealth) {
        Write-Host "[6/7] Health Score..." -ForegroundColor Cyan
        $hsScript = "$evolutionDir\health-score.ps1"
        if (Test-Path $hsScript) {
            try {
                $lastCompat = Get-ChildItem -Path "$reportsDir\compatibility-checker-*.json" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
                $lastKnowledge = Get-ChildItem -Path "$reportsDir\knowledge-migration-*.json" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
                $lastMigration = Get-ChildItem -Path "$reportsDir\migration-system-*.json" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
                
                $hsResult = & $hsScript `
                    -contractDir "$root\system\contracts" `
                    -agentsDir "$root\agents" `
                    -commandsDir "$root\commands" `
                    -skillsDir "$root\skills" `
                    -scriptsDir "$root\scripts" `
                    -outputDir $reportsDir `
                    $(if ($lastCompat) { "-compatibilityReport", "`"$($lastCompat.FullName)`"" } else { "" }) `
                    $(if ($lastKnowledge) { "-knowledgeReport", "`"$($lastKnowledge.FullName)`"" } else { "" }) `
                    $(if ($lastMigration) { "-migrationReport", "`"$($lastMigration.FullName)`"" } else { "" })
                $evolutionResults["health"] = $hsResult
                $evolutionSteps += "Health: $($hsResult.overall)/100"
            } catch {
                $evolutionIssues += "HEALTH_SCORE_FAILED: $($_.Exception.Message)"
            }
        } else {
            $evolutionIssues += "SKIPPED: health-score.ps1 not found"
        }
    }
    
    # 7. Evolution Report
    if ($runReport) {
        Write-Host "[7/7] Evolution Report..." -ForegroundColor Cyan
        $erScript = "$evolutionDir\evolution-report.ps1"
        if (Test-Path $erScript) {
            try {
                $lastSD = Get-ChildItem -Path "$reportsDir\semantic-diff-*.json" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
                $lastCC = Get-ChildItem -Path "$reportsDir\compatibility-checker-*.json" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
                $lastMS = Get-ChildItem -Path "$reportsDir\migration-system-*.json" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
                $lastSH = Get-ChildItem -Path "$reportsDir\self-healing-*.json" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
                $lastKM = Get-ChildItem -Path "$reportsDir\knowledge-migration-*.json" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
                $lastHS = Get-ChildItem -Path "$reportsDir\health-score-*.json" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
                
                $reportPath = "$root\SYSTEM_EVOLUTION_REPORT.md"
                $null = & $erScript `
                    $(if ($lastSD) { "-semanticDiffReport", "`"$($lastSD.FullName)`"" } else { "" }) `
                    $(if ($lastCC) { "-compatibilityReport", "`"$($lastCC.FullName)`"" } else { "" }) `
                    $(if ($lastMS) { "-migrationReport", "`"$($lastMS.FullName)`"" } else { "" }) `
                    $(if ($lastSH) { "-selfHealingReport", "`"$($lastSH.FullName)`"" } else { "" }) `
                    $(if ($lastKM) { "-knowledgeReport", "`"$($lastKM.FullName)`"" } else { "" }) `
                    $(if ($lastHS) { "-healthReport", "`"$($lastHS.FullName)`"" } else { "" }) `
                    -outputFile $reportPath
                $evolutionResults["report"] = "Generated: $reportPath"
                $evolutionSteps += "Evolution Report: $reportPath"
            } catch {
                $evolutionIssues += "EVOLUTION_REPORT_FAILED: $($_.Exception.Message)"
            }
        } else {
            $evolutionIssues += "SKIPPED: evolution-report.ps1 not found"
        }
    }
    
    # Add evolution issues to main report
    foreach ($ei in $evolutionIssues) {
        $report.issues += "EVOLUTION: $ei"
    }
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Magenta
    Write-Host "  EVOLUTION ENGINE COMPLETE" -ForegroundColor Magenta
    $healthScoreVal = if ($evolutionResults.health) { $evolutionResults.health.overall } else { "N/A" }
    Write-Host "  Health Score: $healthScoreVal/100" -ForegroundColor $(if ($healthScoreVal -ge 80) { "Green" } elseif ($healthScoreVal -ge 50) { "Yellow" } else { "Red" })
    Write-Host "========================================" -ForegroundColor Magenta
}

# === REPORT ===
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  SYSTEM DOCS SYNC REPORT" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Agents:     $($report.agents.Keys.Count)" -ForegroundColor White
Write-Host "  Commands:   $($report.commands.Keys.Count)" -ForegroundColor White
Write-Host "  Skills:     $($report.skills.Keys.Count)" -ForegroundColor White
Write-Host "  Scripts:    $($report.scripts.Keys.Count)" -ForegroundColor White
$kc = if ($report.knowledge.Keys) { $report.knowledge.Keys.Count } else { 0 }
Write-Host "  Knowledge:  $kc" -ForegroundColor White
if ($runEvolution) {
    Write-Host "  Evolution:  Executed" -ForegroundColor Magenta
}

$issueColor = if ($report.issues.Count -gt 0) { "Red" } else { "Green" }
Write-Host "  Issues:     $($report.issues.Count)" -ForegroundColor $issueColor
if ($report.issues.Count -gt 0) {
    Write-Host "  ---------- Issues ----------" -ForegroundColor Yellow
    foreach ($issue in $report.issues) {
        Write-Host "    ! $issue" -ForegroundColor Yellow
    }
}
Write-Host "========================================" -ForegroundColor Cyan

if ($runEvolution -and $evolutionResults.health) {
    Write-Host "  System Health: $($evolutionResults.health.overall)/100" -ForegroundColor $(if ($evolutionResults.health.overall -ge 80) { "Green" } elseif ($evolutionResults.health.overall -ge 50) { "Yellow" } else { "Red" })
    Write-Host "========================================" -ForegroundColor Cyan
}

$report | ConvertTo-Json -Depth 5 | Out-File -FilePath "$root\scripts\sync-last-report.json" -Encoding utf8
Write-Host "Done!" -ForegroundColor Green

# Return evolution report path if generated
if ($runReport -and $evolutionResults.report) {
    Write-Host "Evolution Report: $($evolutionResults.report)" -ForegroundColor Magenta
}


