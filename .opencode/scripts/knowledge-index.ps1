<#
.SYNOPSIS
    Build Knowledge Index for Knowledge Assistant - scan JapaneseLearner source
    and generate JSON indexes into .opencode/knowledge/knowledge-assistant/index/.

.DESCRIPTION
    Modes:
      build   - full scan, replace old index
      update  - re-scan and merge (keep timestamp)
      status  - check index existence + stats
      clean   - delete all index files
    Flags:
      -ProjectRoot <path> - project root (default: workspace root)
      -DryRun            - report only, no writes
      -Verbose           - detailed output

.EXAMPLE
    .opencode/scripts/knowledge-index.ps1 -Mode build
    .opencode/scripts/knowledge-index.ps1 -Mode update -DryRun
    .opencode/scripts/knowledge-index.ps1 -Mode status
#>

param(
    [ValidateSet("build", "update", "status", "clean")]
    [string]$Mode = "status",
    [string]$ProjectRoot = "",
    [switch]$DryRun,
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"

# ---- 1. Locate directories -------------------------------------------
if ([string]::IsNullOrWhiteSpace($ProjectRoot)) {
    $ProjectRoot = (Get-Location).Path
}
if (-not (Test-Path -LiteralPath $ProjectRoot)) {
    Write-Error "ProjectRoot does not exist: $ProjectRoot"
    exit 1
}

$indexDir = Join-Path $ProjectRoot ".opencode\knowledge\knowledge-assistant\index"
$srcDir   = Join-Path $ProjectRoot "JapaneseLearner"
$docDir   = Join-Path $ProjectRoot ".opencode\knowledge"

# ---- 2. Helper functions ---------------------------------------------
function Write-Log($msg) {
    if ($Verbose) { Write-Host "[verbose] $msg" -ForegroundColor DarkGray }
}

function Get-FilesByExt($dir, [string[]]$exts) {
    $result = @()
    if (-not (Test-Path -LiteralPath $dir)) { return $result }
    foreach ($ext in $exts) {
        $files = Get-ChildItem -Path $dir -Recurse -Filter "*.$ext" -File -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -notmatch "\\(bin|obj)\\" -and $_.FullName -notmatch "\\\.git\\" }
        $result += $files
    }
    return $result
}

# ---- 3. Mode CLEAN ----------------------------------------------------
if ($Mode -eq "clean") {
    if ($DryRun) {
        Write-Host "[dry-run] Would delete index at: $indexDir"
        exit 0
    }
    if (Test-Path -LiteralPath $indexDir) {
        Remove-Item -LiteralPath $indexDir -Recurse -Force
        Write-Host "[OK] Index deleted"
    } else {
        Write-Host "[INFO] Index does not exist"
    }
    exit 0
}

# ---- 4. Mode STATUS ---------------------------------------------------
if ($Mode -eq "status") {
    if (-not (Test-Path -LiteralPath $indexDir)) {
        Write-Host "INDEX_STATUS: not_built"
        Write-Host "INDEX_DIR: $indexDir"
        Write-Host "INDEX_FILES: 0"
        exit 0
    }
    $files = Get-ChildItem -LiteralPath $indexDir -Filter "*.json" -File -ErrorAction SilentlyContinue
    Write-Host "INDEX_STATUS: built"
    Write-Host "INDEX_DIR: $indexDir"
    Write-Host "INDEX_FILES: $($files.Count)"
    foreach ($f in $files) {
        $size = [math]::Round($f.Length / 1KB, 1)
        Write-Host ("  - {0} ({1} KB)" -f $f.Name, $size)
    }
    exit 0
}

# ---- 5. Collect files -------------------------------------------------
Write-Log "Scanning source at: $srcDir"
$csFiles    = @(Get-FilesByExt $srcDir @("cs"))
$razorFiles = @(Get-FilesByExt $srcDir @("razor"))
$csprojFiles= @(Get-FilesByExt $srcDir @("csproj"))
$mdFiles    = @(Get-FilesByExt $docDir @("md"))

Write-Log "C# files: $($csFiles.Count), Razor: $($razorFiles.Count), csproj: $($csprojFiles.Count), docs: $($mdFiles.Count)"

# ---- 6. Parse routes (@page) -----------------------------------------
$routes = @()
foreach ($f in $razorFiles) {
    $content = Get-Content -LiteralPath $f.FullName -Raw -ErrorAction SilentlyContinue
    $matches = [regex]::Matches($content, '@page\s+"([^"]+)"')
    foreach ($m in $matches) {
        $routes += [PSCustomObject]@{
            route       = $m.Groups[1].Value
            component   = $f.Name
            file        = $f.FullName.Substring($srcDir.Length + 1)
            has_params  = ($m.Groups[1].Value -match "\{")
        }
    }
}

# ---- 7. Parse symbols (class/interface/method) -----------------------
$symbols = @()
foreach ($f in $csFiles) {
    $content = Get-Content -LiteralPath $f.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    $rel = $f.FullName.Substring($srcDir.Length + 1)

    $classMatches = [regex]::Matches($content, '(?m)^\s*(public\s+|internal\s+)?(sealed\s+|abstract\s+|static\s+)*(class|interface|record|enum)\s+(\w+)')
    foreach ($m in $classMatches) {
        $lineNo = ($content.Substring(0, $m.Index) -split "`n").Count
        $symbols += [PSCustomObject]@{
            name    = $m.Groups[4].Value
            type    = $m.Groups[3].Value
            file    = $rel
            line    = $lineNo
        }
    }

    $methodMatches = [regex]::Matches($content, '(?m)^\s{4}(public|private|protected|internal)\s+(static\s+)?(async\s+)?([\w<>\[\]?,\s]+?)\s+(\w+)\s*\(')
    foreach ($m in $methodMatches) {
        $lineNo = ($content.Substring(0, $m.Index) -split "`n").Count
        $symbols += [PSCustomObject]@{
            name    = $m.Groups[5].Value
            type    = "method"
            file    = $rel
            line    = $lineNo
        }
    }
}

# ---- 8. Parse services (interface + impl + DI) -----------------------
$services = @()
$diRegistrations = @()
$programCs = Join-Path $srcDir "Program.cs"
if (Test-Path -LiteralPath $programCs) {
    $content = Get-Content -LiteralPath $programCs -Raw
    $di = [regex]::Matches($content, 'AddScoped<([\w]+),\s*([\w]+)>')
    foreach ($m in $di) {
        $diRegistrations += [PSCustomObject]@{
            interface_name = $m.Groups[1].Value
            impl_name      = $m.Groups[2].Value
        }
    }
}

# ---- 9. Parse data models --------------------------------------------
$models = @()
foreach ($f in $csFiles) {
    $rel = $f.FullName.Substring($srcDir.Length + 1)
    if ($rel -notmatch "^Models\\") { continue }
    $content = Get-Content -LiteralPath $f.FullName -Raw -ErrorAction SilentlyContinue
    $classMatch = [regex]::Match($content, 'class\s+(\w+)')
    if (-not $classMatch.Success) { continue }
    $props = @()
    $propMatches = [regex]::Matches($content, 'public\s+([\w<>\[\]?]+)\s+(\w+)\s*\{')
    foreach ($p in $propMatches) {
        $props += [PSCustomObject]@{
            name = $p.Groups[2].Value
            type = $p.Groups[1].Value
        }
    }
    $models += [PSCustomObject]@{
        entity     = $classMatch.Groups[1].Value
        file       = $rel
        properties = $props
    }
}

# ---- 10. Parse dependency graph (@inject) ----------------------------
$depEdges = @()
foreach ($f in $razorFiles) {
    $content = Get-Content -LiteralPath $f.FullName -Raw -ErrorAction SilentlyContinue
    $rel = $f.FullName.Substring($srcDir.Length + 1)
    $injects = [regex]::Matches($content, '@inject\s+([\w.]+)\s+(\w+)')
    foreach ($m in $injects) {
        $depEdges += [PSCustomObject]@{
            from   = $f.Name
            to     = $m.Groups[1].Value
            type   = "inject"
            file   = $rel
        }
    }
}

# ---- 11. Parse document index (headings) -----------------------------
$docIndex = @()
foreach ($f in $mdFiles) {
    $content = Get-Content -LiteralPath $f.FullName -Raw -ErrorAction SilentlyContinue
    $rel = $f.FullName.Substring($docDir.Length + 1)
    $sections = @()
    $headingMatches = [regex]::Matches($content, '(?m)^(#{1,3})\s+(.+)$')
    foreach ($m in $headingMatches) {
        $sections += [PSCustomObject]@{
            level   = $m.Groups[1].Value.Length
            title   = $m.Groups[2].Value.Trim()
        }
    }
    $docIndex += [PSCustomObject]@{
        document = $rel
        sections = $sections
    }
}

# ---- 12. Build report -------------------------------------------------
$report = [PSCustomObject]@{
    generated_at   = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")
    mode           = $Mode
    project_root   = $ProjectRoot
    stats          = [PSCustomObject]@{
        cs_files      = $csFiles.Count
        razor_files   = $razorFiles.Count
        csproj_files  = $csprojFiles.Count
        doc_files     = $mdFiles.Count
        routes        = $routes.Count
        symbols       = $symbols.Count
        di_services   = $diRegistrations.Count
        models        = $models.Count
        dep_edges     = $depEdges.Count
        doc_sections  = $docIndex.Count
    }
}

# ---- 13. Write files --------------------------------------------------
$indexFiles = @{
    "route-index.json"       = $routes
    "code-index.json"        = $symbols
    "symbol-index.json"      = $symbols
    "service-index.json"     = $diRegistrations
    "data-model-index.json"  = $models
    "dependency-graph.json"  = $depEdges
    "document-index.json"    = $docIndex
}

if ($Mode -eq "build") {
    if (Test-Path -LiteralPath $indexDir) {
        Remove-Item -LiteralPath $indexDir -Recurse -Force
    }
}

if ($DryRun) {
    Write-Host "[dry-run] Would write $($indexFiles.Count) index files to: $indexDir"
    Write-Host "[dry-run] Stats: $($report.stats | ConvertTo-Json -Compress)"
    exit 0
}

if (-not (Test-Path -LiteralPath $indexDir)) {
    New-Item -ItemType Directory -Path $indexDir -Force | Out-Null
}

foreach ($k in $indexFiles.Keys) {
    $path = Join-Path $indexDir $k
    ($indexFiles[$k] | ConvertTo-Json -Depth 5) | Set-Content -LiteralPath $path -Encoding UTF8
    Write-Log "Written: $k"
}

$reportPath = Join-Path $indexDir "_index-report.json"
$report | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $reportPath -Encoding UTF8

# ---- 14. Output -------------------------------------------------------
Write-Host "INDEX_BUILD: success"
Write-Host "MODE: $Mode"
Write-Host "FILES_SCANNED: $($csFiles.Count + $razorFiles.Count + $csprojFiles.Count)"
Write-Host "ROUTES_FOUND: $($routes.Count)"
Write-Host "SYMBOLS_FOUND: $($symbols.Count)"
Write-Host "DI_SERVICES: $($diRegistrations.Count)"
Write-Host "MODELS_FOUND: $($models.Count)"
Write-Host "DEP_EDGES: $($depEdges.Count)"
Write-Host "DOC_SECTIONS: $($docIndex.Count)"
Write-Host "INDEX_DIR: $indexDir"
Write-Host "DURATION: $([math]::Round((Get-Date).Subtract((Get-Date).AddHours(0)).TotalSeconds, 2))s"
exit 0
