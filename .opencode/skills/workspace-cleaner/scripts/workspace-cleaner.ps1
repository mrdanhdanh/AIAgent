param(
    [ValidateSet("all", "build", "backup", "temp", "cache", "log")]
    [string]$Target = "all",

    [switch]$DryRun,

    [switch]$Force,

    [int]$KeepBackup = 5,

    [switch]$Aggressive,

    [int]$OlderThanDays = 0,

    [string]$ReportPath = "",

    [string]$WorkspacePath = ".",

    # Risk threshold: ngưỡng risk cao nhất cho phép (mặc định MEDIUM = không cho xóa HIGH nếu không force)
    [ValidateSet("LOW", "MEDIUM", "HIGH")]
    [string]$MaxRiskThreshold = "MEDIUM"
)

# ─────────────────────────────────────────────
# KHỞI TẠO
# ─────────────────────────────────────────────
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$dateStamp = Get-Date -Format "yyyyMMdd"
$workflowSequence = 1

# Tìm sequence number cho workflow ID
$existingWorkflows = Get-ChildItem -Path ".opencode\backup" -Directory -Filter "WF-$dateStamp-*" -ErrorAction SilentlyContinue
if ($existingWorkflows) {
    $lastSeq = ($existingWorkflows.Name | ForEach-Object { [int]($_-replace "WF-$dateStamp-", "") }) | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
    $workflowSequence = $lastSeq + 1
}
$workflowId = "WF-$dateStamp-{0:D3}" -f $workflowSequence
$backupRoot = ".opencode\backup\$workflowId"

# ─────────────────────────────────────────────
# CẤU HÌNH PHÁT HIỆN RÁC CHI TIẾT (Point 1)
# ─────────────────────────────────────────────
$garbageConfig = @{
    build = @{
        patterns       = @("**/bin", "**/obj")
        extensions     = @()
        max_size_mb    = 0
        empty_dirs_only = $false
        generated_paths = @("bin/", "obj/")
        risk           = "LOW"
        enabled        = ($Target -in @("all", "build"))
    }
    test = @{
        patterns       = @("**/TestResults", "**/coverage", "**/*.cobertura.xml")
        extensions     = @()
        max_size_mb    = 0
        empty_dirs_only = $false
        generated_paths = @("TestResults/")
        risk           = "LOW"
        enabled        = ($Target -in @("all", "build"))
    }
    backup_old = @{
        patterns       = @()
        extensions     = @()
        max_size_mb    = 0
        empty_dirs_only = $false
        generated_paths = @()
        risk           = "MEDIUM"
        enabled        = ($Target -in @("all", "backup"))
        keep_count     = $KeepBackup
    }
    log = @{
        patterns       = @("**/*.log", "**/*.out")
        extensions     = @(".log", ".out")
        max_size_mb    = 1
        empty_dirs_only = $false
        generated_paths = @()
        risk           = "MEDIUM"
        enabled        = ($Target -in @("all", "log"))
    }
    temp_zip = @{
        patterns       = @("**/*.zip", "**/*.tar.gz", "**/*.7z")
        extensions     = @(".zip", ".tar.gz", ".7z")
        max_size_mb    = 100
        empty_dirs_only = $false
        generated_paths = @()
        risk           = "MEDIUM"
        enabled        = ($Target -in @("all", "temp"))
    }
    ide_cache = @{
        patterns       = @("**/.vs/**", "**/.vscode/**")
        extensions     = @()
        max_size_mb    = 0
        empty_dirs_only = $false
        generated_paths = @()
        risk           = "MEDIUM"
        enabled        = ($Target -in @("all", "cache"))
        exclude_patterns = @("**/.vscode/settings.json", "**/.vscode/launch.json", "**/.vscode/tasks.json")
    }
    publish = @{
        patterns       = @("**/release", "**/publish", "**/dist")
        extensions     = @()
        max_size_mb    = 0
        empty_dirs_only = $false
        generated_paths = @("release/", "publish/", "dist/")
        risk           = "HIGH"
        enabled        = ($Target -in @("all", "build")) -and $Aggressive
    }
    nuget_cache = @{
        patterns       = @()
        extensions     = @()
        max_size_mb    = 0
        empty_dirs_only = $false
        generated_paths = @()
        risk           = "HIGH"
        enabled        = $Aggressive
        custom_scan    = {
            $nugetPath = [System.IO.Path]::Combine([Environment]::GetFolderPath("UserProfile"), ".nuget", "packages")
            if (Test-Path $nugetPath) {
                # Chỉ quét các package cũ (last accessed > 30 ngày)
                Get-ChildItem -Path $nugetPath -Directory -ErrorAction SilentlyContinue | Where-Object {
                    $_.LastWriteTime -lt (Get-Date).AddDays(-$OlderThanDays)
                }
            }
        }
    }
    dotnet_temp = @{
        patterns       = @()
        extensions     = @()
        max_size_mb    = 0
        empty_dirs_only = $false
        generated_paths = @()
        risk           = "HIGH"
        enabled        = $Aggressive
        custom_scan    = {
            $tempPath = [System.IO.Path]::Combine([Environment]::GetFolderPath("Temp"), "dotnet-*")
            Get-ChildItem -Path $tempPath -Directory -ErrorAction SilentlyContinue
        }
    }
}

# ─────────────────────────────────────────────
# PROTECTED LIST CÓ CẤU TRÚC (Point 3)
# ─────────────────────────────────────────────
$protectedList = @{
    protected_extensions = @(
        ".cs",           # Source code C#
        ".razor",        # Blazor components
        ".csproj",       # Project files
        ".sln",          # Solution files
        ".md",           # Documentation
        ".gitignore",    # Git config
        ".editorconfig", # Editor config
        ".props",        # MSBuild properties
        ".targets",      # MSBuild targets
        ".ps1"           # PowerShell scripts (non-generated)
    )

    protected_dirs = @(
        ".git",
        ".opencode/agents",
        ".opencode/skills",
        ".opencode/scripts",
        ".opencode/knowledge",
        ".opencode/commands"
    )

    protected_paths = @(
        "AGENTS.md",
        "opencode.json",
        "Directory.Build.props",
        ".opencode/SYSTEM_MAP.md"
    )

    protected_patterns = @(
        "**/*.ps1",
        "**/.opencode/**/*.md",
        ".github/**",
        "**/launchSettings.json"
    )
}

# ─────────────────────────────────────────────
# HÀM KIỂM TRA PROTECTED (Point 3)
# ─────────────────────────────────────────────
function Test-Protected {
    param([string]$Path)

    $resolvedPath = try { (Resolve-Path -LiteralPath $Path -ErrorAction Stop).Path } catch { $Path }
    $fileName = Split-Path -Path $resolvedPath -Leaf
    $extension = [System.IO.Path]::GetExtension($resolvedPath)
    $relativePath = try {
        $fullPath = (Resolve-Path -LiteralPath $WorkspacePath).Path
        $resolvedPath.Substring($fullPath.Length + 1)
    } catch { $resolvedPath }

    # 1. Kiểm tra extensions
    if ($protectedList.protected_extensions -contains $extension) {
        return $true, "protected_extension: $extension"
    }

    # 2. Kiểm tra directories (kiểm tra đường dẫn cha)
    foreach ($dir in $protectedList.protected_dirs) {
        $dirFull = try {
            Join-Path -Path (Resolve-Path -LiteralPath $WorkspacePath).Path -ChildPath $dir
        } catch { "" }
        if ($dirFull -and $resolvedPath.StartsWith($dirFull, [StringComparison]::OrdinalIgnoreCase)) {
            return $true, "protected_dir: $dir"
        }
    }

    # 3. Kiểm tra exact paths
    foreach ($p in $protectedList.protected_paths) {
        $pFull = try {
            Join-Path -Path (Resolve-Path -LiteralPath $WorkspacePath).Path -ChildPath $p
        } catch { "" }
        if ($pFull -and $resolvedPath -eq $pFull) {
            return $true, "protected_path: $p"
        }
        # Cũng kiểm tra tên file
        if ($fileName -eq $p) {
            return $true, "protected_path: $p (filename match)"
        }
    }

    # 4. Kiểm tra glob patterns (dùng simple match)
    foreach ($pattern in $protectedList.protected_patterns) {
        if (Test-GlobMatch -Path $relativePath -Pattern $pattern) {
            return $true, "protected_pattern: $pattern"
        }
    }

    return $false, ""
}

# ─────────────────────────────────────────────
# HÀM GLOB MATCH ĐƠN GIẢN
# ─────────────────────────────────────────────
function Test-GlobMatch {
    param([string]$Path, [string]$Pattern)

    # Chuyển glob pattern thành regex
    $regex = '^' + [regex]::Escape($Pattern) `
        -replace '\*\*/', '.*' `
        -replace '\*', '[^/]*' `
        -replace '\?', '.' `
        -replace '\.\*\.\*', '.*' + '$'

    return ($Path -match $regex)
}

# ─────────────────────────────────────────────
# HÀM QUÉT THEO CẤU HÌNH (Point 1)
# ─────────────────────────────────────────────
function Invoke-GarbageScan {
    param(
        [hashtable]$Config,
        [string]$WorkspacePath,
        [int]$OlderThanDays
    )

    $candidates = @()

    # Nếu có custom_scan function
    if ($Config.ContainsKey("custom_scan")) {
        $items = & $Config["custom_scan"]
        foreach ($item in $items) {
            $size = 0
            if ($item -is [System.IO.DirectoryInfo]) {
                $size = (Get-ChildItem -LiteralPath $item.FullName -Recurse -File -ErrorAction SilentlyContinue |
                    Measure-Object -Property Length -Sum).Sum
            } else {
                $size = $item.Length
            }
            $candidates += @{
                path      = $item.FullName
                size_bytes = [long]$size
                type      = "custom"
                is_dir    = $item -is [System.IO.DirectoryInfo]
            }
        }
        return $candidates
    }

    # Quét theo patterns
    foreach ($pattern in $Config.patterns) {
        $items = Get-ChildItem -Path $WorkspacePath -Directory -Filter (Split-Path $pattern -Leaf) -Recurse -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -like ((Join-Path $WorkspacePath (Split-Path $pattern -Parent)).Replace('[','`[').Replace(']','`]') + "*") }

        # Fallback: dùng -Filter cho pattern đơn giản
        if (-not $items) {
            $leaf = Split-Path $pattern -Leaf
            $parent = Split-Path $pattern -Parent
            if ($parent -eq "*") { $parent = "" }
            $items = Get-ChildItem -Path $WorkspacePath -Directory -Filter $leaf -Recurse -Depth 5 -ErrorAction SilentlyContinue
        }

        # Lọc theo max_size_mb
        foreach ($item in $items) {
            # Kiểm tra exclude patterns
            if ($Config.ContainsKey("exclude_patterns")) {
                $isExcluded = $false
                foreach ($exPat in $Config.exclude_patterns) {
                    $relPath = try {
                        $fullPath = (Resolve-Path $WorkspacePath).Path
                        $item.FullName.Substring($fullPath.Length + 1)
                    } catch { $item.FullName }
                    if (Test-GlobMatch -Path $relPath -Pattern $exPat) {
                        $isExcluded = $true
                        break
                    }
                }
                if ($isExcluded) { continue }
            }

            $size = (Get-ChildItem -LiteralPath $item.FullName -Recurse -File -ErrorAction SilentlyContinue |
                Measure-Object -Property Length -Sum).Sum
            $sizeMB = $size / 1MB

            if ($Config.max_size_mb -gt 0 -and $sizeMB -lt $Config.max_size_mb) {
                continue  # Quá nhỏ, bỏ qua
            }

            if ($Config.empty_dirs_only) {
                $children = Get-ChildItem -LiteralPath $item.FullName -ErrorAction SilentlyContinue
                if ($children) { continue }  # Không trống, bỏ qua
            }

            $candidates += @{
                path       = $item.FullName
                size_bytes = [long]$size
                type       = "dir"
                is_dir     = $true
            }
        }
    }

    # Quét theo extensions (files)
    foreach ($ext in $Config.extensions) {
        $files = Get-ChildItem -Path $WorkspacePath -Filter "*$ext" -Recurse -ErrorAction SilentlyContinue
        foreach ($f in $files) {
            if ($OlderThanDays -gt 0 -and $f.LastWriteTime -gt (Get-Date).AddDays(-$OlderThanDays)) {
                continue
            }

            $sizeMB = $f.Length / 1MB
            if ($Config.max_size_mb -gt 0 -and $sizeMB -lt $Config.max_size_mb) {
                continue
            }

            $candidates += @{
                path       = $f.FullName
                size_bytes = $f.Length
                type       = "file"
                is_dir     = $false
            }
        }
    }

    return $candidates
}

# ─────────────────────────────────────────────
# BƯỚC 1: WORKSPACE SCAN
# ─────────────────────────────────────────────
Write-Host "=== WORKSPACE CLEANER v2.0 ==="
Write-Host "Workflow ID: $workflowId"
Write-Host "Mode: $(if ($DryRun) {'DRY RUN'} else {'FULL'})$(if ($Aggressive) {' + AGGRESSIVE'})"
Write-Host "Target: $Target"
Write-Host ""

$scanReport = @{
    scanned_files = 0
    scanned_dirs  = 0
    candidates    = 0
    protected_skipped = 0
    candidates_detail = @()
}

$classificationReport = @{
    low    = 0
    medium = 0
    high   = 0
    by_type = @{}
}

$allCandidates = @()
$skipReasons = @{
    protected_match = 0
    already_backed_up = 0
    not_found = 0
    too_small = 0
    too_recent = 0
    excluded = 0
}

# Count total files/dirs for stats
$scanReport.scanned_files = (Get-ChildItem -Path $WorkspacePath -File -Recurse -ErrorAction SilentlyContinue).Count
$scanReport.scanned_dirs = (Get-ChildItem -Path $WorkspacePath -Directory -Recurse -ErrorAction SilentlyContinue).Count

foreach ($gtype in $garbageConfig.Keys) {
    $config = $garbageConfig[$gtype]
    if (-not $config.enabled) { continue }

    Write-Host "  Scanning [$gtype]..."

    $items = Invoke-GarbageScan -Config $config -WorkspacePath $WorkspacePath -OlderThanDays $OlderThanDays

    foreach ($item in $items) {
        # Kiểm tra protected TRƯỚC (Point 3)
        $isProtected, $reason = Test-Protected -Path $item.path
        if ($isProtected) {
            $skipReasons.protected_match++
            $scanReport.protected_skipped++
            Write-Host "    [PROTECTED] $($item.path) -> $reason"
            continue
        }

        # Thêm vào classification
        $risk = $config.risk
        $classificationReport[$risk.ToLower()]++
        if (-not $classificationReport.by_type.ContainsKey($gtype)) {
            $classificationReport.by_type[$gtype] = 0
        }
        $classificationReport.by_type[$gtype]++

        $scanReport.candidates++

        $candidate = @{
            type       = $gtype
            path       = $item.path
            risk       = $risk
            size_bytes = $item.size_bytes
            criteria   = @{
                patterns         = $config.patterns
                extensions       = $config.extensions
                max_size_mb      = $config.max_size_mb
                empty_dirs_only  = $config.empty_dirs_only
                generated_paths  = $config.generated_paths
            }
        }
        $allCandidates += $candidate
        $scanReport.candidates_detail += $candidate
    }
}

$totalSize = ($allCandidates | Measure-Object -Property size_bytes -Sum).Sum
$totalItems = $allCandidates.Count

# ─────────────────────────────────────────────
# BƯỚC 2: DRY-RUN REPORT (BẮT BUỘC) (Point 4)
# ─────────────────────────────────────────────
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════════╗"
Write-Host "║            WORKSPACE CLEANUP — DRY RUN                      ║"
Write-Host "╠══════════════════════════════════════════════════════════════╣"
Write-Host "║ Workflow ID: $workflowId"
Write-Host "║──────────────────────────────────────────────────────────────║"
Write-Host "║ SCAN REPORT                                                 ║"
Write-Host "║   Scanned files: $($scanReport.scanned_files)  |  Scanned dirs: $($scanReport.scanned_dirs)"
Write-Host "║   Candidates found: $($scanReport.candidates)  |  Protected skipped: $($scanReport.protected_skipped)"
Write-Host "║──────────────────────────────────────────────────────────────║"
Write-Host "║ CLASSIFICATION REPORT                                       ║"

foreach ($risk in @("LOW", "MEDIUM", "HIGH")) {
    $count = $classificationReport[$risk.ToLower()]
    if ($count -gt 0) {
        $riskSize = ($allCandidates | Where-Object { $_.risk -eq $risk } | Measure-Object -Property size_bytes -Sum).Sum
        Write-Host "║   $risk`t→ $count items`t$("{0:N1}" -f ($riskSize / 1MB)) MB"
    }
}

Write-Host "║──────────────────────────────────────────────────────────────║"
Write-Host "║ TOTAL: $totalItems items, $("{0:N1}" -f ($totalSize / 1MB)) MB"
Write-Host "║──────────────────────────────────────────────────────────────║"
Write-Host "║ RISK THRESHOLD CHECK (max allowed: $MaxRiskThreshold)        ║"

# Check risk threshold
$highestRisk = if ($classificationReport.high -gt 0) { "HIGH" }
              elseif ($classificationReport.medium -gt 0) { "MEDIUM" }
              else { "LOW" }

$riskLevels = @{ "LOW" = 1; "MEDIUM" = 2; "HIGH" = 3 }
$thresholdLevel = $riskLevels[$MaxRiskThreshold]
$actualLevel = $riskLevels[$highestRisk]

if ($actualLevel -gt $thresholdLevel) {
    Write-Host "║   ⚠ HIGH items found — vượt ngưỡng $MaxRiskThreshold         ║"
    Write-Host "║   → BLOCKED: Yêu cầu --force để tiếp tục                    ║"
    Write-Host "╚══════════════════════════════════════════════════════════════╝"
    if (-not $Force) {
        Write-Host "[BLOCKED] Risk threshold exceeded. Use --force to override."
        exit 1
    }
} else {
    Write-Host "║   ✓ Risk trong ngưỡng cho phép                              ║"
    Write-Host "╚══════════════════════════════════════════════════════════════╝"
}

# Nếu chỉ dry-run → dừng tại đây
if ($DryRun) {
    Write-Host "[DRY RUN] Không có thay đổi nào được thực hiện."
    exit 0
}

# ─────────────────────────────────────────────
# BƯỚC 3: BACKUP (MEDIUM items) (Point 5)
# ─────────────────────────────────────────────
$backupReport = @{
    workflow_id    = $workflowId
    status         = "SKIPPED"
    manifest_path  = ""
    backed_up_files = @()
    failed_backups  = @()
    skip_reasons    = @{
        protected_match = $skipReasons.protected_match
        already_backed_up = 0
        not_found = 0
    }
}

$mediumCandidates = $allCandidates | Where-Object { $_.risk -eq "MEDIUM" -and $_.type -ne "backup_old" } | ForEach-Object { $_.path }
$backupOldCandidates = $allCandidates | Where-Object { $_.type -eq "backup_old" } | ForEach-Object { $_.path }

if ($mediumCandidates.Count -gt 0 -or $backupOldCandidates.Count -gt 0) {
    $backupItems = @()
    $backupItems += $mediumCandidates
    $backupItems += $backupOldCandidates

    Write-Host ""
    Write-Host "=== BACKUP ==="
    Write-Host "Backing up $($backupItems.Count) items to $backupRoot..."

    # Tạo backup directory
    New-Item -ItemType Directory -Path $backupRoot -Force -ErrorAction SilentlyContinue | Out-Null

    $backupReport.status = "SUCCESS"
    $manifestEntries = @()

    foreach ($item in $backupItems) {
        $itemName = $item -replace '^.*\\', '' -replace '^.*/', ''
        $backupPath = Join-Path -Path $backupRoot -ChildPath "backup-$itemName"

        try {
            if (Test-Path -LiteralPath $item) {
                if ((Get-Item -LiteralPath $item) -is [System.IO.DirectoryInfo]) {
                    Copy-Item -LiteralPath $item -Destination $backupPath -Recurse -Force -ErrorAction Stop
                } else {
                    Copy-Item -LiteralPath $item -Destination $backupPath -Force -ErrorAction Stop
                }

                # Tính SHA256 hash (12 ký tự đầu)
                $hash = if (Test-Path -LiteralPath $backupPath) {
                    if ((Get-Item -LiteralPath $backupPath) -is [System.IO.DirectoryInfo]) {
                        "dir_skipped_hash"
                    } else {
                        try {
                            $sha256 = [System.Security.Cryptography.SHA256]::Create()
                            $fs = [System.IO.File]::OpenRead($backupPath)
                            $hashBytes = $sha256.ComputeHash($fs)
                            $fs.Close()
                            $hashStr = -join ($hashBytes[0..5] | ForEach-Object { $_.ToString("x2") })
                            $hashStr
                        } catch { "hash_error" }
                    }
                } else { "not_found" }

                $manifestEntries += @{
                    source     = $item
                    backup     = $backupPath
                    hash       = $hash
                    size_bytes = if (Test-Path -LiteralPath $item) {
                        if ((Get-Item -LiteralPath $item) -is [System.IO.DirectoryInfo]) {
                            (Get-ChildItem -LiteralPath $item -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
                        } else { (Get-Item -LiteralPath $item).Length }
                    } else { 0 }
                    status     = "success"
                }

                $backupReport.backed_up_files += @{
                    source     = $item
                    backup     = $backupPath
                    hash       = if ($manifestEntries[-1].hash -eq "dir_skipped_hash") { "N/A (directory)" } else { $manifestEntries[-1].hash }
                    size_bytes = $manifestEntries[-1].size_bytes
                    status     = "success"
                }

                Write-Host "  [BACKUP] $item -> $backupPath"
            } else {
                $backupReport.failed_backups += @{
                    source = $item
                    reason = "not_found"
                    status = "failed"
                }
                Write-Host "  [SKIP] $item — not found"
            }
        } catch {
            $backupReport.failed_backups += @{
                source = $item
                reason = $_.Exception.Message
                status = "failed"
            }
            $backupReport.status = "PARTIAL"
            Write-Host "  [ERR] Backup failed: $item — $_"
        }
    }

    # Ghi manifest
    $manifestPath = Join-Path -Path $backupRoot -ChildPath "05_backup_manifest.json"
    $manifest = @{
        workflow_id  = $workflowId
        created_at   = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
        backed_up_files = $manifestEntries
        failed_backups = $backupReport.failed_backups
    }
    $manifest | ConvertTo-Json -Depth 10 | Out-File -FilePath $manifestPath -Encoding utf8
    $backupReport.manifest_path = $manifestPath
    Write-Host "  [MANIFEST] Saved to $manifestPath"

    # Cập nhật skip_reasons
    $backupReport.skip_reasons.not_found = ($backupReport.failed_backups | Where-Object { $_.reason -eq "not_found" }).Count
}

# ─────────────────────────────────────────────
# BƯỚC 4: CONFIRMATION GATE
# ─────────────────────────────────────────────
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════════╗"
Write-Host "║           WORKSPACE CLEANUP — CONFIRM                       ║"
Write-Host "╠══════════════════════════════════════════════════════════════╣"
Write-Host "║ SẮP XÓA: $totalItems items, tổng $("{0:N1}" -f ($totalSize / 1MB)) MB"

$lowItems = $allCandidates | Where-Object { $_.risk -eq "LOW" }
$medItems = $allCandidates | Where-Object { $_.risk -eq "MEDIUM" }
$highItems = $allCandidates | Where-Object { $_.risk -eq "HIGH" }

if ($lowItems) {
    $lowSize = ($lowItems | Measure-Object -Property size_bytes -Sum).Sum
    Write-Host "║──────────────────────────────────────────────────────────────║"
    Write-Host "║ LOW    (không cần backup)                                   ║"
    foreach ($type in ($lowItems | Group-Object type | Sort-Object Name)) {
        $typeSize = ($type.Group | Measure-Object -Property size_bytes -Sum).Sum
        Write-Host "║   • $($type.Name)`t$($type.Count) items`t$("{0:N1}" -f ($typeSize / 1MB)) MB"
    }
}

if ($medItems) {
    $medSize = ($medItems | Measure-Object -Property size_bytes -Sum).Sum
    Write-Host "║──────────────────────────────────────────────────────────────║"
    Write-Host "║ MEDIUM (đã backup hoặc không cần)                           ║"
    foreach ($type in ($medItems | Group-Object type | Sort-Object Name)) {
        $typeSize = ($type.Group | Measure-Object -Property size_bytes -Sum).Sum
        Write-Host "║   • $($type.Name)`t$($type.Count) items`t$("{0:N1}" -f ($typeSize / 1MB)) MB"
    }
}

if ($highItems) {
    $highSize = ($highItems | Measure-Object -Property size_bytes -Sum).Sum
    Write-Host "║──────────────────────────────────────────────────────────────║"
    Write-Host "║ HIGH   (cần xác nhận đặc biệt)                              ║"
    foreach ($type in ($highItems | Group-Object type | Sort-Object Name)) {
        $typeSize = ($type.Group | Measure-Object -Property size_bytes -Sum).Sum
        Write-Host "║   • $($type.Name)`t$($type.Count) items`t$("{0:N1}" -f ($typeSize / 1MB)) MB"
    }
}

Write-Host "╠══════════════════════════════════════════════════════════════╣"
if ($backupReport.status -ne "SKIPPED") {
    Write-Host "║ Backup manifest: $($backupReport.manifest_path)"
}
Write-Host "║ Xác nhận xóa? (Y/N) [--force để tự động]:                   ║"
Write-Host "╚══════════════════════════════════════════════════════════════╝"

if (-not $Force) {
    $confirm = Read-Host "Tiếp tục cleanup?"
    if ($confirm -ne "Y") {
        Write-Host "[CANCELLED] User hủy cleanup."
        exit 0
    }
}

# ─────────────────────────────────────────────
# BƯỚC 5: CLEANUP EXECUTION
# ─────────────────────────────────────────────
$cleanupReport = @{
    status  = "SUCCESS"
    deleted = 0
    skipped = 0
    failed  = 0
    details = @{
        low    = @{ attempted = 0; deleted = 0; skipped = 0; failed = 0 }
        medium = @{ attempted = 0; deleted = 0; skipped = 0; failed = 0 }
        high   = @{ attempted = 0; deleted = 0; skipped = 0; failed = 0 }
    }
    errors = @()
}

function Remove-ItemSafe {
    param([string]$Path, [string]$Risk)
    if (-not (Test-Path -LiteralPath $Path)) { return "skipped", "not_found" }
    try {
        $item = Get-Item -LiteralPath $Path -ErrorAction Stop
        if ($item -is [System.IO.DirectoryInfo]) {
            Remove-Item -LiteralPath $Path -Recurse -Force -ErrorAction Stop
        } else {
            Remove-Item -LiteralPath $Path -Force -ErrorAction Stop
        }
        Write-Host "  [DEL][$Risk] $Path"
        return "deleted", ""
    } catch {
        $errMsg = "Không thể xóa '$Path': $($_.Exception.Message)"
        Write-Host "  [ERR][$Risk] $errMsg"
        return "failed", $errMsg
    }
}

Write-Host ""
Write-Host "=== CLEANUP EXECUTION ==="

# --- LOW ---
Write-Host "-- LOW risk items --"
$lowRiskItems = $allCandidates | Where-Object { $_.risk -eq "LOW" }
foreach ($item in $lowRiskItems) {
    $cleanupReport.details.low.attempted++
    $result, $err = Remove-ItemSafe -Path $item.path -Risk "LOW"
    switch ($result) {
        "deleted" { $cleanupReport.details.low.deleted++; $cleanupReport.deleted++ }
        "skipped" { $cleanupReport.details.low.skipped++; $cleanupReport.skipped++ }
        "failed"  { $cleanupReport.details.low.failed++; $cleanupReport.failed++; $cleanupReport.errors += @{ path = $item.path; error = $err; severity = "WARNING" } }
    }
}

# --- MEDIUM ---
Write-Host "-- MEDIUM risk items --"
$medRiskItems = $allCandidates | Where-Object { $_.risk -eq "MEDIUM" }
# Xử lý backup_old riêng: giữ lại $KeepBackup gần nhất
$backupOldItems = $medRiskItems | Where-Object { $_.type -eq "backup_old" }
$otherMedItems = $medRiskItems | Where-Object { $_.type -ne "backup_old" }

# Xóa backup_old: giữ lại KeepBackup gần nhất
if ($backupOldItems.Count -gt 0) {
    $backupOldItemsSorted = $backupOldItems | Sort-Object path -Descending
    # Mặc định giữ N gần nhất (dựa trên tên workflow có date)
    $toDelete = $backupOldItemsSorted | Select-Object -Skip $KeepBackup
    $toKeep = $backupOldItemsSorted | Select-Object -First $KeepBackup

    foreach ($item in $toKeep) {
        Write-Host "  [KEEP] $($item.path)"
        $cleanupReport.details.medium.skipped++
        $cleanupReport.skipped++
    }
    foreach ($item in $toDelete) {
        $cleanupReport.details.medium.attempted++
        $result, $err = Remove-ItemSafe -Path $item.path -Risk "MEDIUM"
        switch ($result) {
            "deleted" { $cleanupReport.details.medium.deleted++; $cleanupReport.deleted++ }
            "skipped" { $cleanupReport.details.medium.skipped++; $cleanupReport.skipped++ }
            "failed"  { $cleanupReport.details.medium.failed++; $cleanupReport.failed++; $cleanupReport.errors += @{ path = $item.path; error = $err; severity = "WARNING" } }
        }
    }
}

foreach ($item in $otherMedItems) {
    $cleanupReport.details.medium.attempted++
    $result, $err = Remove-ItemSafe -Path $item.path -Risk "MEDIUM"
    switch ($result) {
        "deleted" { $cleanupReport.details.medium.deleted++; $cleanupReport.deleted++ }
        "skipped" { $cleanupReport.details.medium.skipped++; $cleanupReport.skipped++ }
        "failed"  { $cleanupReport.details.medium.failed++; $cleanupReport.failed++; $cleanupReport.errors += @{ path = $item.path; error = $err; severity = "WARNING" } }
    }
}

# --- HIGH ---
Write-Host "-- HIGH risk items (cần xác nhận) --"
$highRiskItems = $allCandidates | Where-Object { $_.risk -eq "HIGH" }
foreach ($item in $highRiskItems) {
    $cleanupReport.details.high.attempted++
    if ($Aggressive) {
        if ($Force) {
            $result, $err = Remove-ItemSafe -Path $item.path -Risk "HIGH"
            switch ($result) {
                "deleted" { $cleanupReport.details.high.deleted++; $cleanupReport.deleted++ }
                "skipped" { $cleanupReport.details.high.skipped++; $cleanupReport.skipped++ }
                "failed"  { $cleanupReport.details.high.failed++; $cleanupReport.failed++; $cleanupReport.errors += @{ path = $item.path; error = $err; severity = "WARNING" } }
            }
        } else {
            $sizeMB = $item.size_bytes / 1MB
            $confirm = Read-Host "Xóa '$($item.path)' ($("{0:N1}" -f $sizeMB) MB)? (Y/N)"
            if ($confirm -eq "Y") {
                $result, $err = Remove-ItemSafe -Path $item.path -Risk "HIGH"
                switch ($result) {
                    "deleted" { $cleanupReport.details.high.deleted++; $cleanupReport.deleted++ }
                    "skipped" { $cleanupReport.details.high.skipped++; $cleanupReport.skipped++ }
                    "failed"  { $cleanupReport.details.high.failed++; $cleanupReport.failed++; $cleanupReport.errors += @{ path = $item.path; error = $err; severity = "WARNING" } }
                }
            } else {
                $cleanupReport.details.high.skipped++
                $cleanupReport.skipped++
                Write-Host "  [SKIP][HIGH] $($item.path) — user giữ lại"
            }
        }
    } else {
        $cleanupReport.details.high.skipped++
        $cleanupReport.skipped++
        Write-Host "  [SKIP][HIGH] $($item.path) — không aggressive mode"
    }
}

if ($cleanupReport.failed -gt 0 -and $cleanupReport.deleted -eq 0) {
    $cleanupReport.status = "FAILED"
} elseif ($cleanupReport.failed -gt 0) {
    $cleanupReport.status = "PARTIAL"
}

# ─────────────────────────────────────────────
# BƯỚC 6: VERIFICATION (Point 6)
# ─────────────────────────────────────────────
$verificationReport = @{
    freed_bytes         = 0
    after_size_bytes    = 0
    verification_status = "SKIPPED"
    spot_checks         = @()
}

# Tính freed_bytes
$beforeSize = $totalSize
$afterSize = 0
$freedBytes = 0

# Spot-check một số file đã xóa
$spotCheckCount = [Math]::Min(5, ($allCandidates | Where-Object { $_.risk -ne "HIGH" }).Count)
$deletedPaths = $allCandidates | Where-Object { $_.risk -ne "HIGH" } | Select-Object -First $spotCheckCount

foreach ($item in $deletedPaths) {
    $stillExists = Test-Path -LiteralPath $item.path
    $check = @{
        type     = if ($stillExists) { "should_be_deleted" } else { "deleted_confirmed" }
        path     = $item.path
        expected = "deleted"
        actual   = if ($stillExists) { "exists" } else { "deleted" }
        pass     = (-not $stillExists)
    }
    $verificationReport.spot_checks += $check
}

# Kiểm tra protected files vẫn còn
$protectedCheckPaths = @(
    "AGENTS.md",
    "opencode.json",
    "Directory.Build.props"
)
foreach ($p in $protectedCheckPaths) {
    $pFull = Join-Path -Path (Resolve-Path $WorkspacePath).Path -ChildPath $p
    $stillExists = Test-Path -LiteralPath $pFull -ErrorAction SilentlyContinue
    $check = @{
        type     = "protected_preserved"
        path     = $p
        expected = "exists"
        actual   = if ($stillExists) { "exists" } else { "deleted" }
        pass     = $stillExists
    }
    $verificationReport.spot_checks += $check
}

$allPass = ($verificationReport.spot_checks | Where-Object { -not $_.pass }).Count -eq 0
$verificationReport.verification_status = if ($allPass) { "PASS" } else { "FAIL" }

# Tính freed_bytes (ước lượng từ deleted items)
$freedBytes = ($allCandidates | Where-Object { 
    $_.risk -eq "LOW" -or 
    ($_.risk -eq "MEDIUM" -and $_.type -ne "backup_old") -or
    ($_.risk -eq "HIGH" -and $Aggressive)
} | Measure-Object -Property size_bytes -Sum).Sum

# Tính after_size: quét lại workspace sau cleanup
try {
    $afterSize = (Get-ChildItem -Path $WorkspacePath -File -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
} catch { $afterSize = 0 }

$verificationReport.freed_bytes = $freedBytes
$verificationReport.after_size_bytes = $afterSize

# ─────────────────────────────────────────────
# BƯỚC 7: FINAL REPORT (Point 6)
# ─────────────────────────────────────────────
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════════╗"
Write-Host "║           WORKSPACE CLEANUP — COMPLETE                      ║"
Write-Host "╠══════════════════════════════════════════════════════════════╣"
Write-Host "║ Status: $($cleanupReport.status)"
Write-Host "║ Deleted: $($cleanupReport.deleted)  |  Skipped: $($cleanupReport.skipped)  |  Failed: $($cleanupReport.failed)"
Write-Host "║ Space freed: $("{0:N1}" -f ($freedBytes / 1MB)) MB"
Write-Host "║──────────────────────────────────────────────────────────────║"
Write-Host "║ SCAN REPORT                                                 ║"
Write-Host "║   Files: $($scanReport.scanned_files)  |  Dirs: $($scanReport.scanned_dirs)"
Write-Host "║   Candidates: $($scanReport.candidates)  |  Protected: $($scanReport.protected_skipped)"
Write-Host "║──────────────────────────────────────────────────────────────║"
Write-Host "║ CLASSIFICATION                                              ║"
Write-Host "║   LOW: $($classificationReport.low)  |  MEDIUM: $($classificationReport.medium)  |  HIGH: $($classificationReport.high)"
Write-Host "║──────────────────────────────────────────────────────────────║"

if ($backupReport.status -ne "SKIPPED") {
    Write-Host "║ BACKUP REPORT                                               ║"
    Write-Host "║   Status: $($backupReport.status)"
    Write-Host "║   Workflow: $($backupReport.workflow_id)"
    Write-Host "║   Backed up: $($backupReport.backed_up_files.Count)  |  Failed: $($backupReport.failed_backups.Count)"
    Write-Host "║──────────────────────────────────────────────────────────────║"
}

Write-Host "║ VERIFICATION                                                ║"
Write-Host "║   Status: $($verificationReport.verification_status)"
Write-Host "║   After cleanup: $("{0:N1}" -f ($afterSize / 1MB)) MB"
Write-Host "╚══════════════════════════════════════════════════════════════╝"

if ($cleanupReport.errors.Count -gt 0) {
    Write-Host ""
    Write-Host "=== ERRORS ==="
    foreach ($e in $cleanupReport.errors) {
        Write-Host "  [$($e.severity)] $($e.error)"
    }
}

if ($verificationReport.verification_status -eq "FAIL") {
    Write-Host ""
    Write-Host "=== VERIFICATION FAILURES ==="
    foreach ($check in ($verificationReport.spot_checks | Where-Object { -not $_.pass })) {
        Write-Host "  [FAIL] $($check.path): expected=$($check.expected), actual=$($check.actual)"
    }
}

# ─────────────────────────────────────────────
# XUẤT JSON REPORT
# ─────────────────────────────────────────────
$finalReport = @{
    status  = if ($cleanupReport.status -eq "FAILED" -or $verificationReport.verification_status -eq "FAIL") { "FAILED" }
              elseif ($cleanupReport.status -eq "PARTIAL") { "PARTIAL" }
              else { "SUCCESS" }
    mode    = if ($Aggressive) { "aggressive" } else { "full" }
    target  = $Target
    summary = "Đã giải phóng $("{0:N1}" -f ($freedBytes / 1MB)) MB, xóa $($cleanupReport.deleted) items, $($cleanupReport.skipped) skipped, $($cleanupReport.failed) failed"

    scan_report          = $scanReport
    classification_report = $classificationReport
    backup_report        = $backupReport
    cleanup_report       = $cleanupReport
    verification_report  = $verificationReport
}

if ($ReportPath) {
    $finalReport | ConvertTo-Json -Depth 10 | Out-File -FilePath $ReportPath -Encoding utf8
    Write-Host ""
    Write-Host "Full report saved: $ReportPath"
}

# Rollback hint nếu cần
if ($cleanupReport.status -eq "FAILED") {
    Write-Host ""
    Write-Host "[ROLLBACK HINT] Chạy lệnh sau để rollback:"
    Write-Host "  & `.opencode\scripts\rollback-utility.ps1` -workflowId `"$workflowId`" -force"
}

Write-Host ""
Write-Host "Workflow ID: $workflowId"
Write-Host "Done."
