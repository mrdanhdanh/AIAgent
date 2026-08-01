<#
.SYNOPSIS
Build/Update Knowledge Index - scan source code + docs to generate 7 index JSON files.
.DESCRIPTION
Scans JapaneseLearner/ (.cs, .razor, .csproj) + .opencode/knowledge/ (.md) to generate:
code-index, symbol-index, api-index, database-index, dependency-graph,
document-index, business-rule-index into .opencode/knowledge-index/.
.PARAMETER Update
Update index (default mode).
.PARAMETER Rebuild
Clean old index then rebuild everything.
.PARAMETER Status
Only show current index status.
#>
param(
    [switch]$Update,
    [switch]$Rebuild,
    [switch]$Status
)

$ErrorActionPreference = "Stop"
$projectRoot = (Resolve-Path ".").Path
$sourceDir = Join-Path $projectRoot "JapaneseLearner"
$knowledgeDir = Join-Path $projectRoot ".opencode\knowledge"
$indexDir = Join-Path $projectRoot ".opencode\knowledge-index"
$timestamp = Get-Date -Format "o"

# --- Helpers ---------------------------------------------------
function Write-Log { param([string]$Msg) Write-Host "[INDEX] $Msg" }

function Get-Files {
    param([string]$Dir, [string[]]$Patterns)
    $files = @()
    foreach ($p in $Patterns) {
        if (Test-Path $Dir) {
            $files += Get-ChildItem -Path $Dir -Recurse -Filter $p -ErrorAction SilentlyContinue |
                Where-Object { $_.FullName -notmatch '\\(bin|obj|node_modules)\\' }
        }
    }
    return $files
}

function Get-ApiMethodsFromCode {
    param([string]$Content)
    $apis = @()
    $matches = [regex]::Matches($Content, '(?m)^\s*public\s+(async\s+)?(static\s+)?([A-Za-z0-9_<>\[\],?]+)\s+([A-Za-z_][A-Za-z0-9_]*)\s*\(([^)]*)\)')
    foreach ($m in $matches) {
        $apis += @{
            name       = $m.Groups[4].Value
            returnType = $m.Groups[3].Value
            signature  = $m.Groups[0].Value.Trim()
        }
    }
    return $apis
}

function Get-StorageKeysFromCode {
    param([string]$Content)
    $keys = @()
    $matches = [regex]::Matches($Content, 'StorageKey\s*=\s*"([^"]+)"')
    foreach ($m in $matches) { $keys += $m.Groups[1].Value }
    $matches2 = [regex]::Matches($Content, 'GetItemAsync<[^>]+>\("([^"]+)"\)')
    foreach ($m in $matches2) { $keys += $m.Groups[1].Value }
    $matches3 = [regex]::Matches($Content, 'SetItemAsync\("([^"]+)"')
    foreach ($m in $matches3) { $keys += $m.Groups[1].Value }
    return ($keys | Select-Object -Unique)
}

# --- Status mode -----------------------------------------------
if ($Status) {
    Write-Log "Knowledge Index status:"
    if (Test-Path $indexDir) {
        $jsonFiles = Get-ChildItem $indexDir -Filter *.json -ErrorAction SilentlyContinue
        if ($jsonFiles.Count -eq 0) {
            Write-Log "  (empty - run /knowledge-index to build)"
            exit 0
        }
        foreach ($f in $jsonFiles) {
            $size = [math]::Round($f.Length / 1KB, 1)
            Write-Log "  [OK] $($f.Name) ($size KB)"
        }
    } else {
        Write-Log "  (folder not found - run /knowledge-index to build)"
    }
    exit 0
}

# --- Rebuild mode ----------------------------------------------
if ($Rebuild -and (Test-Path $indexDir)) {
    Write-Log "Rebuild mode - cleaning old index..."
    Remove-Item (Join-Path $indexDir "*") -Recurse -Force -ErrorAction SilentlyContinue
}

if (-not (Test-Path $indexDir)) { New-Item -ItemType Directory -Path $indexDir | Out-Null }

# --- Collect files ---------------------------------------------
Write-Log "Scanning source..."
$csFiles = @(Get-Files $sourceDir @("*.cs", "*.razor", "*.csproj"))
$docFiles = @(Get-Files $knowledgeDir @("*.md"))
Write-Log "  $($csFiles.Count) source files, $($docFiles.Count) doc files"

# --- Build indexes ---------------------------------------------
$codeIndex = @()
$symbolIndex = @{}
$apiIndex = @()
$dbIndex = @()
$depGraph = @{ nodes = @(); edges = @() }
$docIndex = @()
$businessRules = @()

$symbolPatterns = @(
    '(?m)^\s*(?:public|internal|private|protected)\s+(?:abstract\s+|sealed\s+|static\s+|partial\s+)*(?:class|interface|record)\s+([A-Za-z_][A-Za-z0-9_]*)',
    '(?m)^\s*public\s+(?:async\s+)?(?:static\s+)?[A-Za-z0-9_<>\[\],?]+\s+([A-Za-z_][A-Za-z0-9_]*)\s*\(',
    '(?m)^\s*public\s+[A-Za-z0-9_<>\[\],?]+\s+([A-Za-z_][A-Za-z0-9_]*)\s*\{'
)

foreach ($file in $csFiles) {
    $rel = $file.FullName.Substring($projectRoot.Length + 1).Replace('\', '/')
    $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }

    $codeIndex += @{ file = $rel; size = $file.Length }

    foreach ($pat in $symbolPatterns) {
        $ms = [regex]::Matches($content, $pat)
        foreach ($m in $ms) {
            $sym = $m.Groups[1].Value
            if (-not $symbolIndex.ContainsKey($sym)) { $symbolIndex[$sym] = @() }
            $symbolIndex[$sym] += @{ file = $rel; line = 1 }
        }
    }

    $apis = Get-ApiMethodsFromCode $content
    foreach ($a in $apis) {
        $apiIndex += @{ name = $a.name; returnType = $a.returnType; signature = $a.signature; file = $rel }
    }

    $keys = Get-StorageKeysFromCode $content
    foreach ($k in $keys) {
        $dbIndex += @{ key = $k; file = $rel }
    }

    $depGraph.nodes += @{ name = $rel; type = "FILE" }

    if ($rel -like "*Program.cs*") {
        $diMatches = [regex]::Matches($content, 'AddScoped<([A-Za-z0-9_]+),\s*([A-Za-z0-9_]+)>')
        foreach ($dm in $diMatches) {
            $depGraph.edges += @{
                from = $dm.Groups[1].Value
                to   = $dm.Groups[2].Value
                type = "DI_REGISTRATION"
            }
        }
    }
}

foreach ($doc in $docFiles) {
    $rel = $doc.FullName.Substring($projectRoot.Length + 1).Replace('\', '/')
    $content = Get-Content $doc.FullName -Raw -ErrorAction SilentlyContinue
    $headings = @()
    if ($content) {
        $hm = [regex]::Matches($content, '(?m)^#{1,3}\s+(.+)$')
        foreach ($h in $hm) { $headings += $h.Groups[1].Value.Trim() }
    }
    $docIndex += @{ file = $rel; headings = $headings; size = $doc.Length }
    if ($content) {
        $bm = [regex]::Matches($content, '(?m)^\s*[-*]\s*(.+?(?:phai|bat buoc|luon|khong duoc).+)$')
        foreach ($b in $bm) {
            $businessRules += @{ rule = $b.Groups[1].Value.Trim(); source = $rel }
        }
    }
}

# --- Write JSON ------------------------------------------------
function Write-JsonFile { param([string]$Name, $Data)
    $path = Join-Path $indexDir $Name
    $Data | ConvertTo-Json -Depth 6 | Set-Content -Path $path -Encoding UTF8
    Write-Log "  [OK] $Name"
}

Write-Log "Writing indexes..."
Write-JsonFile "code-index.json" @{ generated_at = $timestamp; files = $codeIndex }
Write-JsonFile "symbol-index.json" @{ generated_at = $timestamp; symbols = $symbolIndex }
Write-JsonFile "api-index.json" @{ generated_at = $timestamp; apis = $apiIndex }
Write-JsonFile "database-index.json" @{ generated_at = $timestamp; storage_keys = $dbIndex; note = "JapaneseLearner uses Blazored.LocalStorage - no DB server" }
Write-JsonFile "dependency-graph.json" @{ generated_at = $timestamp; nodes = $depGraph.nodes; edges = $depGraph.edges }
Write-JsonFile "document-index.json" @{ generated_at = $timestamp; documents = $docIndex }
Write-JsonFile "business-rule-index.json" @{ generated_at = $timestamp; rules = $businessRules }

# --- Summary ---------------------------------------------------
$summary = @{
    status       = "SUCCESS"
    generated_at = $timestamp
    source_files = $csFiles.Count
    doc_files    = $docFiles.Count
    symbols      = $symbolIndex.Count
    apis         = $apiIndex.Count
    docs_indexed = $docIndex.Count
    rules_found  = $businessRules.Count
    output_dir   = $indexDir
}
Write-Log "DONE - $($csFiles.Count) source files, $($symbolIndex.Count) symbols, $($apiIndex.Count) APIs, $($docIndex.Count) docs"
$summary | ConvertTo-Json -Depth 3
