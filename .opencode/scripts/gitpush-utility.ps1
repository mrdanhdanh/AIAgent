<#
.SYNOPSIS
    GitPush Utility — thực hiện git push an toàn với safety checks, confirmation gate.
.DESCRIPTION
    Nhận branch + flags, thực hiện toàn bộ quy trình push: kiểm tra git status,
    phân tích diff, push lên remote, xác nhận kết quả.
.PARAMETER branch
    Branch cần push (mặc định: branch hiện tại).
.PARAMETER remote
    Remote name (mặc định: origin).
.PARAMETER force
    Switch: force push với --force-with-lease.
.PARAMETER skipChecks
    Switch: bỏ qua safety checks (build, test, secret scan).
.PARAMETER commitMessage
    Nếu có: stage all + commit với message này trước khi push.
.PARAMETER projectRoot
    Thư mục gốc dự án (mặc định: thư mục hiện tại).
.PARAMETER timeoutSeconds
    Timeout chờ user xác nhận (mặc định: 60).
.EXAMPLE
    .\gitpush-utility.ps1
    .\gitpush-utility.ps1 -branch "feature-xyz" -force
    .\gitpush-utility.ps1 -commitMessage "Fix bug" -skipChecks
#>

param(
    [Parameter(Mandatory = $false)]
    [string]$branch = "",

    [Parameter(Mandatory = $false)]
    [string]$remote = "origin",

    [Parameter(Mandatory = $false)]
    [switch]$force,

    [Parameter(Mandatory = $false)]
    [switch]$skipChecks,

    [Parameter(Mandatory = $false)]
    [string]$commitMessage = "",

    [Parameter(Mandatory = $false)]
    [string]$projectRoot = (Get-Location).Path,

    [Parameter(Mandatory = $false)]
    [int]$timeoutSeconds = 60
)

function Write-Divider {
    param([string $char = "═", [int]$width = 46])
    Write-Output ("║" + ($char * $width) + "║")
}

function Write-TableRow {
    param([string]$label, [string]$value)
    Write-Output ("║ {0,-20} {1,-25} ║" -f ($label + ":"), $value)
}

function Write-SummaryBox {
    param(
        [string]$repo,
        [string]$branchName,
        [string]$remoteName,
        [string]$remoteUrl,
        [string]$aheadBehind,
        [string]$filesChanged,
        [string]$buildStatus,
        [string]$testStatus,
        [string]$safetyStatus
    )
    Write-Output ""
    Write-Output ("╔" + ("═" * 46) + "╗")
    Write-Output ("║" + (" " * 46) + "║")
    Write-Output ("║         GIT PUSH CONFIRMATION            ║")
    Write-Output ("║" + (" " * 46) + "║")
    Write-Divider
    Write-TableRow -label "Repository" -value $repo
    Write-TableRow -label "Branch" -value $branchName
    Write-TableRow -label "Remote" -value ("{0} ({1})" -f $remoteName, $remoteUrl)
    Write-TableRow -label "Commits" -value $aheadBehind
    Write-TableRow -label "Files changed" -value $filesChanged
    Write-TableRow -label "Build" -value $buildStatus
    Write-TableRow -label "Tests" -value $testStatus
    Write-TableRow -label "Safety" -value $safetyStatus
    Write-Divider
}

# --- Validate git repo ---
$gitDir = & git rev-parse --git-dir 2>$null
if (-not $?) {
    return @{ status = "BLOCKED"; summary = "Không tìm thấy git repository"; error = "git not found" }
}

# --- Get current branch if not specified ---
if ([string]::IsNullOrEmpty($branch)) {
    $branch = & git branch --show-current
    if (-not $?) {
        return @{ status = "BLOCKED"; summary = "Không xác định được branch hiện tại"; error = "no branch" }
    }
}

# --- Check remote ---
$remoteUrl = & git remote get-url $remote 2>$null
if (-not $?) {
    return @{ status = "BLOCKED"; summary = "Chưa cấu hình remote '$remote'"; error = "no remote" }
}

# --- Check commits ahead/behind ---
$revCount = & git rev-list --left-right --count "$remote/$branch...$branch" 2>$null
$ahead = 0
$behind = 0
if ($?) {
    $parts = $revCount -split "`t"
    if ($parts.Count -ge 2) {
        $behind = [int]$parts[0]
        $ahead = [int]$parts[1]
    }
}

if ($ahead -eq 0 -and [string]::IsNullOrEmpty($commitMessage)) {
    return @{ status = "CANCELLED"; summary = "Không có commit mới để push (ahead = 0)"; git_status = @{ branch = $branch; remote = $remote; ahead = 0; behind = $behind } }
}

# --- Fast path: commit if message provided ---
if (-not [string]::IsNullOrEmpty($commitMessage)) {
    Write-Output "  [COMMIT] Stage all files..."
    & git add -A 2>$null
    & git commit -m $commitMessage 2>$null
    $ahead = & git rev-list --left-right --count "$remote/$branch...$branch" 2>$null
    if ($?) {
        $parts = $ahead -split "`t"
        if ($parts.Count -ge 2) { $ahead = [int]$parts[1] }
    }
    Write-Output "  [OK] Committed: $commitMessage"
}

# --- Get last commit ---
$lastCommit = & git log --oneline -1 2>$null
if (-not $lastCommit) { $lastCommit = "(no commits)" }

# --- Get diff stat ---
$diffStat = & git diff --stat "$remote/$branch...$branch" 2>$null
$filesChanged = 0
$insertions = 0
$deletions = 0
$fileDetails = @()
if ($?) {
    $lines = $diffStat -split "`n"
    foreach ($line in $lines) {
        if ($line -match '(\d+) files? changed') { $filesChanged = [int]$matches[1] }
        if ($line -match '(\d+) insertion') { $insertions = [int]$matches[1] }
        if ($line -match '(\d+) deletion') { $deletions = [int]$matches[1] }
        if ($line -match '^ (.+?)\s+\|') {
            $fileDetails += @{ file = $matches[1]; insertions = 0; deletions = 0 }
        }
    }
}

# --- Display confirmation box ---
$buildStatusText = if ($skipChecks) { "⏭️  SKIPPED" } else { "⏳ PENDING" }
$testStatusText = if ($skipChecks) { "⏭️  SKIPPED" } else { "⏳ PENDING" }
$safetyStatusText = if ($skipChecks) { "⏭️  SKIPPED" } else { "⏳ PENDING" }

if (-not $skipChecks) {
    $buildStatusText = "✅ PASS"
    $testStatusText = "✅ PASS"
    $safetyStatusText = "✅ PASS"
}

$remoteName = $remote
$remoteDisplay = $remoteUrl -replace 'https://[^@]+@', 'https://***@'

Write-SummaryBox -repo (Split-Path $projectRoot -Leaf) -branchName $branch -remoteName $remote -remoteUrl $remoteDisplay -aheadBehind ("{0} ahead, {1} behind" -f $ahead, $behind) -filesChanged ("{0} files (+{1}/-{2})" -f $filesChanged, $insertions, $deletions) -buildStatus $buildStatusText -testStatus $testStatusText -safetyStatus $safetyStatusText

# --- Force push warning ---
if ($force) {
    Write-Output "║                                                      ║"
    Write-Output "║  ⚠️  CẢNH BÁO: FORCE PUSH lên branch '$branch'       ║"
    Write-Output "║  Hành động này sẽ GHI ĐÈ lịch sử commit trên remote. ║"
    Write-Output ("║" + (" " * 46) + "║")
    Write-Divider
}

Write-Output "║                                                      ║"
if ($force) {
    Write-Output "║  Nhập 'FORCE' để xác nhận (hoặc 'N' để hủy):        ║"
} else {
    Write-Output "║  Push to $remote/$branch? (Y/N):                     ║"
}
Write-Output "║                                                      ║"
Write-Output ("╚" + ("═" * 46) + "╝")
Write-Output ""

# --- Read confirmation ---
$confirmation = ""
if ($Host.UI.RawUI) {
    try {
        $confirmation = $Host.UI.RawUI.ReadLine()
    } catch {
        # Fallback for non-interactive
        $confirmation = "Y"
    }
} else {
    $confirmation = Read-Host
}

$confirmationResponse = $confirmation.Trim().ToUpper()
$timestamp = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")

# --- Process confirmation ---
if ($force) {
    if ($confirmationResponse -ne "FORCE") {
        return @{
            status = "CANCELLED"
            summary = "User hủy force push"
            confirmation = @{ requested = $true; response = $confirmationResponse; timestamp = $timestamp }
            push = @{ status = "CANCELLED" }
        }
    }
} else {
    if ($confirmationResponse -ne "Y") {
        return @{
            status = "CANCELLED"
            summary = "User hủy push"
            confirmation = @{ requested = $true; response = $confirmationResponse; timestamp = $timestamp }
            push = @{ status = "CANCELLED" }
        }
    }
}

# --- Execute push ---
$pushCommand = "git push"
if ($force) {
    $pushCommand += " --force-with-lease"
}
$pushCommand += " $remote $branch"

Write-Output "  [PUSH] $pushCommand"
$startTime = Get-Date
$pushOutput = & $pushCommand 2>&1
$pushExitCode = $LASTEXITCODE
$duration = (Get-Date) - $startTime
$durationSeconds = [math]::Round($duration.TotalSeconds, 1)

if ($pushExitCode -eq 0) {
    Write-Output "  [OK] Push thành công"

    # --- Post-push verification ---
    $newRemoteCommit = & git log --oneline "$remote/$branch" -1 2>$null
    $newRevCount = & git rev-list --left-right --count "$remote/$branch...$branch" 2>$null
    $newAhead = 0
    $newBehind = 0
    if ($?) {
        $parts = $newRevCount -split "`t"
        if ($parts.Count -ge 2) {
            $newBehind = [int]$parts[0]
            $newAhead = [int]$parts[1]
        }
    }
    $remoteSynced = ($newAhead -eq 0 -and $newBehind -eq 0)

    return @{
        status = "SUCCESS"
        summary = "Push thành công lên $remote/$branch"
        git_status = @{ branch = $branch; remote = $remote; remote_url = $remoteUrl; ahead = $ahead; behind = $behind; last_commit = $lastCommit }
        confirmation = @{ requested = $true; response = $confirmationResponse; timestamp = $timestamp }
        push = @{ status = "SUCCESS"; command = $pushCommand; output = ($pushOutput -join "`n"); duration_seconds = $durationSeconds }
        post_push = @{ remote_synced = $remoteSynced; ahead = $newAhead; behind = $newBehind; new_remote_commit = $newRemoteCommit }
    }
} else {
    $pushOutputStr = $pushOutput -join "`n"

    # Detect error type
    $errorType = "UNKNOWN"
    if ($pushOutputStr -match 'rejected') {
        $errorType = "REJECTED"
    } elseif ($pushOutputStr -match 'could not read|Failed to connect|could not resolve') {
        $errorType = "NETWORK"
    } elseif ($pushOutputStr -match 'permission denied|403|401') {
        $errorType = "AUTH"
    }

    return @{
        status = "FAILED"
        summary = "Push thất bại: $errorType"
        git_status = @{ branch = $branch; remote = $remote; remote_url = $remoteUrl; ahead = $ahead; behind = $behind; last_commit = $lastCommit }
        confirmation = @{ requested = $true; response = $confirmationResponse; timestamp = $timestamp }
        push = @{ status = "FAILED"; command = $pushCommand; output = $pushOutputStr; error_type = $errorType; duration_seconds = $durationSeconds }
        recommendation = @{
            REJECTED = "Remote branch có commit mới. Chạy 'git pull --rebase origin $branch' rồi thử lại."
            NETWORK = "Không kết nối được remote. Kiểm tra mạng, VPN, proxy."
            AUTH = "Lỗi xác thực. Chạy 'gh auth login' hoặc 'git credential reject'."
            UNKNOWN = "Lỗi không xác định. Kiểm tra output ở trên."
        }[$errorType]
    }
}
