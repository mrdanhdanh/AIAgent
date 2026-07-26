param(
    [ValidateSet("all", "build", "backup", "temp", "cache", "log")]
    [string]$Target = "all",

    [switch]$DryRun,

    [switch]$Force,

    [int]$KeepBackup = 5,

    [switch]$Aggressive,

    [int]$OlderThanDays = 0,

    [string]$ReportPath = "",

    [string]$WorkspacePath = "."
)

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$workflowId = "cleanup-$timestamp"

Write-Host "=== WORKSPACE CLEANER ==="
Write-Host "Mode: $(if ($DryRun) {'DRY RUN'} else {'FULL'})$(if ($Aggressive) {' + AGGRESSIVE'})"
Write-Host ""

# --- Protected patterns (never delete) ---
$protectedExtensions = @('.cs', '.razor', '.csproj', '.sln', '.md', '.json', '.gitignore', '.editorconfig')
$protectedDirectories = @('.git', '.opencode\agents', '.opencode\skills', '.opencode\scripts')
$protectedFiles = @('AGENTS.md', 'opencode.json', 'opencode.json.bak')

function Is-Protected {
    param([string]$Path)
    $name = Split-Path $Path -Leaf
    if ($protectedFiles -contains $name) { return $true }
    $ext = [System.IO.Path]::GetExtension($Path)
    if ($protectedExtensions -contains $ext) { return $true }
    foreach ($dir in $protectedDirectories) {
        if ($Path.StartsWith((Resolve-Path $dir).Path, [StringComparison]::OrdinalIgnoreCase)) {
            return $true
        }
    }
    return $false
}

# --- Bước 1: Scan ---
$scanResults = @{
    build    = @{ count = 0; size_bytes = 0; paths = @() }
    backup   = @{ count = 0; size_bytes = 0; paths = @() }
    temp_zip = @{ count = 0; size_bytes = 0; paths = @() }
    log      = @{ count = 0; size_bytes = 0; paths = @() }
    publish  = @{ count = 0; size_bytes = 0; paths = @() }
    test     = @{ count = 0; size_bytes = 0; paths = @() }
}

# Scan build artifacts
$binObj = Get-ChildItem -Path $WorkspacePath -Directory -Filter "bin","obj" -Recurse -Depth 3 -ErrorAction SilentlyContinue
foreach ($d in $binObj) {
    $size = (Get-ChildItem -LiteralPath $d.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    $scanResults.build.count++
    $scanResults.build.size_bytes += $size
    $scanResults.build.paths += $d.FullName
}

# Scan backup folders
$backups = Get-ChildItem -Path ".opencode\backup" -Directory -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending
if ($backups.Count -gt $KeepBackup) {
    $oldBackups = $backups | Select-Object -Skip $KeepBackup
    foreach ($b in $oldBackups) {
        $size = (Get-ChildItem -LiteralPath $b.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        $scanResults.backup.count++
        $scanResults.backup.size_bytes += $size
        $scanResults.backup.paths += $b.FullName
    }
}

# Scan log files
$logs = Get-ChildItem -Path $WorkspacePath -Filter "*.log" -Recurse -ErrorAction SilentlyContinue
foreach ($l in $logs) {
    if ($OlderThanDays -gt 0 -and $l.LastWriteTime -gt (Get-Date).AddDays(-$OlderThanDays)) { continue }
    $scanResults.log.count++
    $scanResults.log.size_bytes += $l.Length
    $scanResults.log.paths += $l.FullName
}

# Scan temp zip files
$zips = Get-ChildItem -Path $WorkspacePath -Filter "*.zip" -Recurse -ErrorAction SilentlyContinue
foreach ($z in $zips) {
    if ($OlderThanDays -gt 0 -and $z.LastWriteTime -gt (Get-Date).AddDays(-$OlderThanDays)) { continue }
    if ($z.Length -lt 100MB -and $OlderThanDays -eq 0) { continue } # only clean zips > 100MB by default
    $scanResults.temp_zip.count++
    $scanResults.temp_zip.size_bytes += $z.Length
    $scanResults.temp_zip.paths += $z.FullName
}

# Scan publish/release
$publishDirs = Get-ChildItem -Path $WorkspacePath -Directory -Filter "release","publish","dist" -ErrorAction SilentlyContinue
foreach ($p in $publishDirs) {
    $size = (Get-ChildItem -LiteralPath $p.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    $scanResults.publish.count++
    $scanResults.publish.size_bytes += $size
    $scanResults.publish.paths += $p.FullName
}

# Scan TestResults
$testDirs = Get-ChildItem -Path $WorkspacePath -Directory -Filter "TestResults" -Recurse -Depth 2 -ErrorAction SilentlyContinue
foreach ($t in $testDirs) {
    $size = (Get-ChildItem -LiteralPath $t.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    $scanResults.test.count++
    $scanResults.test.size_bytes += $size
    $scanResults.test.paths += $t.FullName
}

$totalSize = ($scanResults.Values | Measure-Object -Property size_bytes -Sum).Sum
$totalItems = ($scanResults.Values | Measure-Object -Property count -Sum).Sum

# --- Bước 2: Dry-run report ---
Write-Host "╔══════════════════════════════════════════════════════╗"
Write-Host "║           WORKSPACE CLEANUP — DRY RUN               ║"
Write-Host "╠══════════════════════════════════════════════════════╣"
Write-Host "║ Tổng dung lượng rác: $("{0:N1}" -f ($totalSize / 1MB)) MB"
Write-Host "║──────────────────────────────────────────────────────║"

$categories = @(
    @{name="Build artifacts"; key="build"; level=1},
    @{name="Test results"; key="test"; level=1},
    @{name="Backup cũ (giữ $KeepBackup)"; key="backup"; level=2},
    @{name="Log files"; key="log"; level=2},
    @{name="Temp zip"; key="temp_zip"; level=2},
    @{name="Publish artifacts"; key="publish"; level=3}
)

$level1Size = 0; $level2Size = 0; $level3Size = 0
foreach ($cat in $categories) {
    $data = $scanResults[$cat.key]
    if ($data.count -gt 0) {
        $sizeMB = $data.size_bytes / 1MB
        Write-Host "║ Cấp $($cat.level): $($cat.name) $($data.count) items $("{0:N1}" -f $sizeMB) MB"
        switch ($cat.level) { 1 { $level1Size += $data.size_bytes } 2 { $level2Size += $data.size_bytes } 3 { $level3Size += $data.size_bytes } }
    }
}

Write-Host "╠══════════════════════════════════════════════════════╣"
Write-Host "║ Dung lượng giải phóng dự kiến: $("{0:N1}" -f ($totalSize / 1MB)) MB"
if ($level2Size -gt 0) {
    Write-Host "║ Cần backup trước: $("{0:N1}" -f ($level2Size / 1MB)) MB (Cấp 2 items)"
}
Write-Host "╚══════════════════════════════════════════════════════╝"

if ($DryRun) {
    Write-Host "[DRY RUN] Không có thay đổi nào được thực hiện."
    exit 0
}

if (-not $Force) {
    $confirm = Read-Host "Tiếp tục cleanup? (Y/N)"
    if ($confirm -ne "Y") {
        Write-Host "Cleanup cancelled."
        exit 0
    }
}

# --- Bước 3: Backup Cấp 2 items ---
$backupItems = @()
if ($level2Size -gt 0) {
    foreach ($path in $scanResults.backup.paths) { $backupItems += $path }
    foreach ($path in $scanResults.log.paths) { $backupItems += $path }
    foreach ($path in $scanResults.temp_zip.paths) { $backupItems += $path }

    if ($backupItems.Count -gt 0) {
        Write-Host "[BACKUP] Đang backup $($backupItems.Count) items..."
        & ".opencode\scripts\backup-utility.ps1" -files $backupItems -workflowId $workflowId
    }
}

# --- Bước 4: Cleanup execution ---
$deleted = 0
$freed = 0
$errors = @()

function Remove-ItemSafe {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return }
    try {
        $item = Get-Item -LiteralPath $Path -ErrorAction Stop
        if ($item -is [System.IO.DirectoryInfo]) {
            $size = (Get-ChildItem -LiteralPath $Path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            Remove-Item -LiteralPath $Path -Recurse -Force -ErrorAction Stop
            Write-Host "  [DEL] $Path"
            return $size
        }
        else {
            Remove-Item -LiteralPath $Path -Force -ErrorAction Stop
            Write-Host "  [DEL] $Path"
            return $item.Length
        }
    }
    catch {
        $errors += "Can't delete $Path : $_"
        Write-Host "  [ERR] $Path : $_"
        return 0
    }
}

Write-Host ""
Write-Host "=== CLEANUP EXECUTION ==="

# Cấp 1: Build artifacts + Test results
Write-Host "-- Cấp 1: Build artifacts --"
foreach ($p in $scanResults.build.paths) { $freed += Remove-ItemSafe -Path $p; $deleted++ }
foreach ($p in $scanResults.test.paths) { $freed += Remove-ItemSafe -Path $p; $deleted++ }

# Cấp 2: Backup cũ, logs, zips (đã backup)
Write-Host "-- Cấp 2: Backup cũ --"
foreach ($p in $scanResults.backup.paths) { $freed += Remove-ItemSafe -Path $p; $deleted++ }
Write-Host "-- Cấp 2: Log files --"
foreach ($p in $scanResults.log.paths) { $freed += Remove-ItemSafe -Path $p; $deleted++ }
Write-Host "-- Cấp 2: Temp archives --"
foreach ($p in $scanResults.temp_zip.paths) { $freed += Remove-ItemSafe -Path $p; $deleted++ }

# Cấp 3: Publish (chỉ aggressive)
if ($Aggressive) {
    Write-Host "-- Cấp 3: Publish artifacts (aggressive) --"
    if ($Force) {
        foreach ($p in $scanResults.publish.paths) { $freed += Remove-ItemSafe -Path $p; $deleted++ }
    }
    else {
        foreach ($p in $scanResults.publish.paths) {
            $sizeMB = (Get-ChildItem -LiteralPath $p -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum / 1MB
            $confirm = Read-Host "Xóa '$p' ($("{0:N1}" -f $sizeMB) MB)? (Y/N)"
            if ($confirm -eq "Y") { $freed += Remove-ItemSafe -Path $p; $deleted++ }
        }
    }
}

# --- Bước 5: Report ---
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════╗"
Write-Host "║           WORKSPACE CLEANUP — COMPLETE               ║"
Write-Host "╠══════════════════════════════════════════════════════╣"
Write-Host "║ Items deleted: $deleted"
Write-Host "║ Space freed:   $("{0:N1}" -f ($freed / 1MB)) MB"
Write-Host "║ Backup:        $("{0:N1}" -f ($level2Size / 1MB)) MB -> .opencode/backup/$workflowId/"
if ($errors.Count -gt 0) {
    Write-Host "║ Errors:        $($errors.Count)"
    foreach ($e in $errors) { Write-Host "║   ! $e" }
}
Write-Host "╚══════════════════════════════════════════════════════╝"

# Output JSON report
$report = @{
    status         = if ($errors.Count -gt 0) { "PARTIAL" } else { "SUCCESS" }
    summary        = "Cleaned $deleted items, freed $("{0:N1}" -f ($freed / 1MB)) MB"
    files_deleted  = $deleted
    freed_bytes    = $freed
    backup_folder  = if ($backupItems.Count -gt 0) { ".opencode/backup/$workflowId/" } else { "" }
    errors         = $errors
}

if ($ReportPath) {
    $report | ConvertTo-Json -Depth 10 | Out-File -FilePath $ReportPath -Encoding utf8
    Write-Host "Report saved: $ReportPath"
}
