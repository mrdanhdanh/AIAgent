<#
.SYNOPSIS
Workflow Validator v4 — validate 5 workflow definitions (.opencode/workflow/definitions/*.yaml).
.DESCRIPTION
Parser YAML SUBSET tu viet (KHONG dung ConvertFrom-Yaml — khong available trong PS 5.1).
Chi parse cac key can thiet: top-level (id, name, version, description, phases) va
moi phase block (id, title, agent, command, depends_on). Bo qua nested objects
(inputs/outputs/description folded) — chung khong can cho validation.

Cach mo rong: them key can kiem tra vao $phaseKeys / $topKeys, hoac them ham
Test-<muc> vao phan validation. Gi\u1eef parser don gian de bao tri.

Validate moi file *.yaml:
  1. no-tab: khong chua [char]9.
  2. no-BOM: 3 byte dau khong phai EF BB BF.
  3. required keys top-level: id, name, version, description, phases (thieu -> WF-ERR-003).
  4. moi phase: required id, title, it nhat 1 trong agent|command (thieu -> WF-ERR-003).
  5. duplicate phase id -> WF-ERR-004.
  6. depends_on tro phase id ton tai -> WF-ERR-005.
  7. cycle detect (DFS) -> WF-ERR-006.
  8. agent thuoc .opencode/agents/*.md (BaseName, khong hardcode) -> WF-ERR-007.
  9. command thuoc .opencode/commands/*.md (BaseName, bo dau '/') -> WF-ERR-008.

Output: JSON report ra console + .opencode/scripts/workflow-validator-report.json.
Exit 0 khi tat ca PASS, exit 1 khi co FAIL. READ-ONLY — khong sua file nao.
#>
param(
    [string]$DefinitionsDir = ".opencode/workflow/definitions",
    [string]$AgentsDir      = ".opencode/agents",
    [string]$CommandsDir    = ".opencode/commands",
    [string]$SchemaPath     = ".opencode/workflow/schemas/workflow.schema.yaml"
)

$ErrorActionPreference = "Stop"

# ─── Helper: doc file theo UTF-8 (khong them BOM khi doc) ───────────
function Read-FileUtf8NoBom {
    param([string]$Path)
    $bytes = [System.IO.File]::ReadAllBytes($Path)
    $text = [System.Text.Encoding]::UTF8.GetString($bytes)
    return $text
}

# ─── Helper: kiem tra BOM ───────────────────────────────────────────
function Test-Bom {
    param([string]$Path)
    $bytes = [System.IO.File]::ReadAllBytes($Path)
    if ($bytes.Length -lt 3) { return $false }
    return ($bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)
}

# ─── Helper: kiem tra tab ──────────────────────────────────────────────
function Test-Tab {
    param([string]$Content)
    return ($Content.IndexOf([char]9) -ge 0)
}

# ─── Helper: ghi file UTF-8 no-BOM (PS 5.1 Out-File -Encoding utf8 se them BOM) ──
function Write-FileUtf8NoBom {
    param([string]$Path, [string]$Content)
    [System.IO.File]::WriteAllText($Path, $Content, (New-Object System.Text.UTF8Encoding($false)))
}

# ─── Parser YAML subset ─────────────────────────────────────────────
function ConvertFrom-WorkflowYaml {
    param([string]$Path)
    $content = Read-FileUtf8NoBom -Path $Path
    $lines = $content -split "\r?\n"

    $topKeys = @{}
    $phaseList = @()
    $currentPhase = $null
    $pendingListKey = $null      # dang cho collection cua key (depends_on multiline)
    $pendingListIndent = -1
    $seenPhaseStart = $false

    foreach ($line in $lines) {
        $trimmed = $line.Trim()
        if ($trimmed -eq "") { continue }
        if ($trimmed -match "^#") { continue }

        $indent = $line.Length - $line.TrimStart(" ").Length

        # List item: "- id: analyze" (indent 2 = phase moi) hoac "- string" (nested, skip)
        if ($trimmed -match "^- ") {
            if ($indent -eq 2) {
                # Phase moi
                $currentPhase = @{ id = ""; title = ""; agent = ""; command = ""; depends_on = @(); _line = 0 }
                $phaseList += $currentPhase
                $seenPhaseStart = $true
                $pendingListKey = $null
                if ($trimmed -match "^- (\w[\w-]*)\s*:\s*(.*)$") {
                    $currentPhase[$Matches[1]] = $Matches[2].Trim()
                    $currentPhase._line = $lines.IndexOf($line) + 1
                }
            }
            else {
                # Nested list item: gom vao pendingListKey neu dang thu thap
                if ($pendingListKey -and $indent -gt $pendingListIndent) {
                    $item = $trimmed -replace "^- ", ""
                    $currentPhase[$pendingListKey] += $item
                }
            }
            continue
        }

        # Key: value line
        if ($trimmed -match "^([\w-]+)\s*:\s*(.*)$") {
            $key = $Matches[1]
            $val = $Matches[2].Trim()
            $pendingListKey = $null

            if ($indent -eq 0) {
                # Top-level
                $topKeys[$key] = $val
                $currentPhase = $null
                $seenPhaseStart = $false
                continue
            }

            if ($seenPhaseStart -and $currentPhase) {
                if ($key -eq "depends_on") {
                    if ($val -match "^\[(.*)\]$") {
                        $inner = $Matches[1].Trim()
                        if ($inner -eq "") {
                            $currentPhase["depends_on"] = @()
                        }
                        else {
                            $currentPhase["depends_on"] = @($inner -split "," | ForEach-Object { $_.Trim() })
                        }
                    }
                    elseif ($val -eq "") {
                        # Multiline depends_on dang cho
                        $currentPhase["depends_on"] = @()
                        $pendingListKey = "depends_on"
                        $pendingListIndent = $indent + 2
                    }
                }
                else {
                    $currentPhase[$key] = $val
                }
            }
            continue
        }

        # Dong khac (noi dung folded description v.v.) — bo qua
    }

    return @{ top = $topKeys; phases = $phaseList }
}

# ─── DFS cycle detection ────────────────────────────────────────────
function Test-Cycle {
    param(
        [System.Collections.Generic.Dictionary[string,string[]]]$Graph,
        [string]$Node,
        [System.Collections.Generic.Dictionary[string,int]]$Color,
        [System.Collections.Generic.List[string]]$Stack,
        [ref]$CycleFound
    )
    if (-not $Color.ContainsKey($Node)) { return }
    if ($Color[$Node] -eq 2) { return }        # done
    if ($Color[$Node] -eq 1) {
        # Back edge -> cycle
        $idx = $Stack.IndexOf($Node)
        if ($idx -ge 0) {
            $cycleNodes = @()
            for ($i = $idx; $i -lt $Stack.Count; $i++) { $cycleNodes += $Stack[$i] }
            $cycleNodes += $Node
            $script:CyclePath = ($cycleNodes -join " -> ")
            $CycleFound.Value = $true
        }
        return
    }
    $Color[$Node] = 1
    $Stack.Add($Node) | Out-Null
    if ($Graph.ContainsKey($Node)) {
        foreach ($dep in $Graph[$Node]) {
            if ($CycleFound.Value) { break }
            Test-Cycle -Graph $Graph -Node $dep -Color $Color -Stack $Stack -CycleFound $CycleFound
        }
    }
    $Stack.RemoveAt($Stack.Count - 1)
    $Color[$Node] = 2
}

# ─── Scan dir -> tap hop BaseName ───────────────────────────────────
function Get-BaseNames {
    param([string]$Dir, [string]$Pattern)
    $names = @{}
    if (-not (Test-Path -LiteralPath $Dir)) { return $names }
    Get-ChildItem -LiteralPath $Dir -Filter $Pattern -File -ErrorAction SilentlyContinue | ForEach-Object {
        $names[$_.BaseName] = $true
    }
    return $names
}

# ─── Main ───────────────────────────────────────────────────────────
$agentNames = Get-BaseNames -Dir $AgentsDir -Pattern "*.md"
$commandNames = Get-BaseNames -Dir $CommandsDir -Pattern "*.md"

$report = @{
    validator = "workflow-validator.ps1"
    schema    = $SchemaPath
    scanned_at = (Get-Date -Format "o")
    files     = @()
    status    = "PASS"
}

if (-not (Test-Path -LiteralPath $DefinitionsDir)) {
    $report.status = "FAIL"
    $report.files += @{
        file      = $DefinitionsDir
        status    = "FAIL"
        errors    = @(@{ code = "WF-ERR-001"; description = "Definitions dir missing"; line = $null })
    }
    $jsonOut = $report | ConvertTo-Json -Depth 8
    Write-Output $jsonOut
    Write-FileUtf8NoBom -Path ".opencode/scripts/workflow-validator-report.json" -Content $jsonOut
    exit 1
}

$yamlFiles = Get-ChildItem -LiteralPath $DefinitionsDir -Filter "*.yaml" -File | Sort-Object Name

if ($yamlFiles.Count -eq 0) {
    Write-Output (@{ validator = "workflow-validator.ps1"; status = "FAIL"; error = "No *.yaml found in $DefinitionsDir" } | ConvertTo-Json -Depth 5)
    exit 1
}

foreach ($file in $yamlFiles) {
    $fileErrors = @()
    $path = $file.FullName

    # 1. no-tab
    $content = Read-FileUtf8NoBom -Path $path
    if (Test-Tab -Content $content) {
        $fileErrors += @{ code = "WF-ERR-002"; description = "YAML chua tab (dung 2-space indent)"; file = $path; line = $null; suggestion = "Thay tab bang spaces (2-space indent)" }
    }

    # 2. no-BOM
    if (Test-Bom -Path $path) {
        $fileErrors += @{ code = "WF-ERR-002"; description = "YAML co BOM (phai UTF-8 no-BOM)"; file = $path; line = $null; suggestion = "Luu lai voi UTF8Encoding(false)" }
    }

    # Parse
    $parsed = ConvertFrom-WorkflowYaml -Path $path
    $top = $parsed.top
    $phases = $parsed.phases

    # 3. Required top-level keys
    foreach ($reqKey in @("id", "name", "version", "description", "phases")) {
        if (-not $top.ContainsKey($reqKey)) {
            $fileErrors += @{ code = "WF-ERR-003"; description = "Thieu required top-level key: $reqKey"; file = $path; line = $null; suggestion = "Them '$reqKey' vao top-level" }
        }
    }

    # 4. Phase required keys + at least 1 agent|command
    foreach ($p in $phases) {
        if (-not $p["id"]) {
            $fileErrors += @{ code = "WF-ERR-003"; description = "Phase thieu required key: id"; file = $path; line = $p._line; suggestion = "Them 'id' cho phase" }
        }
        if (-not $p["title"]) {
            $fileErrors += @{ code = "WF-ERR-003"; description = "Phase '$($p["id"])' thieu required key: title"; file = $path; line = $p._line; suggestion = "Them 'title' cho phase" }
        }
        $hasAgent = [bool]$p["agent"]
        $hasCommand = [bool]$p["command"]
        if (-not $hasAgent -and -not $hasCommand) {
            $fileErrors += @{ code = "WF-ERR-003"; description = "Phase '$($p["id"])' phai co it nhat 1 trong agent|command"; file = $path; line = $p._line; suggestion = "Them agent hoac command" }
        }
    }

    # 5. Duplicate phase id
    $idCount = @{}
    foreach ($p in $phases) {
        $phaseId = $p["id"]
        if ($phaseId -and $idCount.ContainsKey($phaseId)) {
            $fileErrors += @{ code = "WF-ERR-004"; description = "Duplicate phase id: $phaseId"; file = $path; line = $p._line; suggestion = "Doi ten phase id cho duy nhat" }
        }
        else { $idCount[$phaseId] = $true }
    }

    # 6. depends_on ton tai + 7. cycle
    $phaseIds = @{}
    foreach ($p in $phases) { if ($p["id"]) { $phaseIds[$p["id"]] = $true } }
    $graph = New-Object 'System.Collections.Generic.Dictionary[string,string[]]'
    foreach ($p in $phases) {
        $deps = @()
        foreach ($d in $p["depends_on"]) {
            if ($d -and -not $phaseIds.ContainsKey($d)) {
                $fileErrors += @{ code = "WF-ERR-005"; description = "depends_on tro phase id khong ton tai: $d (phase '$($p["id"])')"; file = $path; line = $p._line; suggestion = "Sua depends_on ve dung phase id" }
            }
            else { $deps += $d }
        }
        if ($p["id"]) { $graph[$p["id"]] = $deps }
    }
    # DFS cycle
    $color = New-Object 'System.Collections.Generic.Dictionary[string,int]'
    $script:CyclePath = ""
    $cycleFound = [ref]$false
    foreach ($node in $phaseIds.Keys) {
        if ($cycleFound.Value) { break }
        $stack = New-Object 'System.Collections.Generic.List[string]'
        Test-Cycle -Graph $graph -Node $node -Color $color -Stack $stack -CycleFound $cycleFound
    }
    if ($cycleFound.Value) {
        $fileErrors += @{ code = "WF-ERR-006"; description = "Cycle detected: $script:CyclePath"; file = $path; line = $null; suggestion = "Xoa vong lap trong depends_on" }
    }

    # 8. agent ton tai
    foreach ($p in $phases) {
        if ($p["agent"]) {
            $agentKey = $p["agent"]
            if (-not $agentNames.ContainsKey($agentKey)) {
                $fileErrors += @{ code = "WF-ERR-007"; description = "Agent khong ton tai: $agentKey (phase '$($p["id"])')"; file = $path; line = $p._line; suggestion = "Kiem tra .opencode/agents/<name>.md" }
            }
        }
    }

    # 9. command ton tai
    foreach ($p in $phases) {
        if ($p["command"]) {
            $cmd = $p["command"]
            $cmdKey = $cmd -replace "^/", ""   # normalize strip '/'
            if (-not $commandNames.ContainsKey($cmdKey)) {
                $fileErrors += @{ code = "WF-ERR-008"; description = "Command khong ton tai: $cmd (phase '$($p["id"])')"; file = $path; line = $p._line; suggestion = "Kiem tra .opencode/commands/<name>.md" }
            }
        }
    }

    $fileStatus = if ($fileErrors.Count -eq 0) { "PASS" } else { "FAIL" }
    $report.files += @{
        file      = $file.Name
        path      = $path
        status    = $fileStatus
        errors    = $fileErrors
    }
    if ($fileStatus -eq "FAIL") { $report.status = "FAIL" }
}

# ─── Output ─────────────────────────────────────────────────────────
$json = $report | ConvertTo-Json -Depth 8
Write-Output $json
Write-FileUtf8NoBom -Path ".opencode/scripts/workflow-validator-report.json" -Content $json

if ($report.status -eq "PASS") { exit 0 } else { exit 1 }
