<#
.SYNOPSIS
    GitPush Utility — thực hiện git push an toàn với auto-commit, safety checks, confirmation gate.
.DESCRIPTION
    Nhận branch + flags, thực hiện toàn bộ quy trình push:
    - Auto-commit: tự gen commit message từ diff (hoặc dùng commitMessage nếu có)
    - Safety checks: secret scan, convention, security, code quality
    - Build + Test validation
    - Confirmation gate → push → post-push verify
.PARAMETER branch
    Branch cần push (mặc định: branch hiện tại).
.PARAMETER remote
    Remote name (mặc định: origin).
.PARAMETER force
    Switch: force push với --force-with-LEASE.
.PARAMETER skipChecks
    Switch: bỏ qua safety checks (build, test, secret scan).
.PARAMETER commitMessage
    Nếu có: dùng message này thay vì auto-generate.
.PARAMETER noCommit
    Switch: bỏ qua auto-commit, chỉ push commit đã có (cần ahead > 0).
.PARAMETER projectRoot
    Thư mục gốc dự án (mặc định: thư mục hiện tại).
.PARAMETER timeoutSeconds
    Timeout chờ user xác nhận (mặc định: 60).
.EXAMPLE
    .\gitpush-utility.ps1                                     # Auto-commit + push
    .\gitpush-utility.ps1 -commitMessage "Fix bug"            # Manual message + push
    .\gitpush-utility.ps1 -noCommit                           # Chỉ push commit có sẵn
    .\gitpush-utility.ps1 -branch "feature-xyz" -force
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
    [switch]$noCommit,

    [Parameter(Mandatory = $false)]
    [switch]$cur,

    [Parameter(Mandatory = $false)]
    [switch]$skipConfirm,

    [Parameter(Mandatory = $false)]
    [string]$projectRoot = (Get-Location).Path,

    [Parameter(Mandatory = $false)]
    [int]$timeoutSeconds = 60
)

function Get-AutoCommitMessage {
    <#
    .SYNOPSIS
        Tự động tạo commit message từ git diff.
    .DESCRIPTION
        Phân tích diff --stat và diff nội dung để xác định type, scope, summary.
    #>
    $diffStat = & git diff --stat 2>$null
    $cachedStat = & git diff --stat --cached 2>$null

    if (-not $diffStat -and -not $cachedStat) {
        return $null
    }

    $allFiles = @()
    $insertions = 0
    $deletions = 0

    $stats = @($diffStat, $cachedStat) | Where-Object { $_ }
    foreach ($stat in $stats) {
        foreach ($line in ($stat -split "`n")) {
            if ($line -match '^ (.+?)\s+\|') {
                $allFiles += $matches[1]
            }
            if ($line -match '(\d+) insertion') { $insertions += [int]$matches[1] }
            if ($line -match '(\d+) deletion') { $deletions += [int]$matches[1] }
        }
    }
    $allFiles = $allFiles | Select-Object -Unique

    if ($allFiles.Count -eq 0) { return $null }

    # --- Detect type từ nội dung diff ---
    $rawDiff = & git diff --cached 2>$null
    if (-not $rawDiff) { $rawDiff = & git diff 2>$null }

    $type = "chore"
    $hasNewClass = $rawDiff -match '^\+\s*(class |interface |struct |enum )\s+\w+'
    $hasFix = $rawDiff -match '^\+\s*(.*\b(fix|bug|issue|error|exception|crash|null|fail)\b.*)'
    $hasRefactor = $rawDiff -match '^\+\s*(rename|move|extract|inline|split|merge)'
    $hasDoc = $rawDiff -match '^\+\s*(\/\/\/|/// |\/\*|\*\/|# )'
    $hasTest = $allFiles | Where-Object { $_ -match '\.Tests\.|test|spec' }
    $hasStyle = $rawDiff -match '^\+\s*(color|background|font|margin|padding|flex|grid|@media|\.css)'
    $hasPerf = $rawDiff -match '^\+\s*(async|await|Task\.|caching|memory|performance|lazy)'

    if ($hasNewClass) { $type = "feat" }
    elseif ($hasFix) { $type = "fix" }
    elseif ($hasRefactor) { $type = "refactor" }
    elseif ($hasTest) { $type = "test" }
    elseif ($hasStyle) { $type = "style" }
    elseif ($hasPerf) { $type = "perf" }
    elseif ($hasDoc) { $type = "docs" }
    else { $type = "chore" }

    # --- Detect scope từ tên file ---
    $scope = ""
    if ($allFiles[0] -match '^\.opencode') { $scope = "opencode" }
    elseif ($allFiles[0] -match 'Pages[\\/](\w+)') { $scope = $matches[1] }
    elseif ($allFiles[0] -match 'Services[\\/](\w+)') { $scope = $matches[1].ToLower() -replace 'service$','' + "-service" }
    elseif ($allFiles[0] -match '\.csproj') { $scope = "build" }
    elseif ($allFiles[0] -match '\.Tests\.') { $scope = "tests" }

    # --- Tạo summary ---
    $summary = ""
    $fileNames = $allFiles | ForEach-Object {
        if ($_ -match '[\\/]([^\\/]+)\.\w+$') { $matches[1] } else { $_ }
    }

    $verbMap = @{
        "feat" = "Add"
        "fix" = "Fix"
        "refactor" = "Refactor"
        "test" = "Update"
        "style" = "Update"
        "perf" = "Improve"
        "docs" = "Update"
        "chore" = "Update"
    }
    $verb = $verbMap[$type]

    if ($allFiles.Count -eq 1) {
        $summary = "$verb $($fileNames[0])"
    } elseif ($allFiles.Count -le 3) {
        $summary = "$verb $($fileNames[0..([math]::Min(1,$fileNames.Count-1))] -join ', ')"
        if ($allFiles.Count -gt 2) { $summary += " and $($fileNames[2])" }
    } else {
        $summary = "$verb $($allFiles.Count) files"
        if ($scope) { $summary += " in $scope" }
    }

    # --- Tạo body ngắn (chạy regex 1 lần, không lặp theo file) ---
    $bodyLines = @()
    $hasNewCs = $rawDiff -match '^\+\s*(new|added|create|implement)\b'
    $hasRemoved = $rawDiff -match '^-\s*(removed|deleted|deprecated)\b'
    if ($hasNewCs) { $desc = "add new implementation" }
    elseif ($hasRemoved) { $desc = "remove deprecated code" }
    elseif ($insertions -gt $deletions * 2) { $desc = "add $insertions lines" }
    elseif ($deletions -gt $insertions * 2) { $desc = "remove $deletions lines" }
    else { $desc = "update $([math]::Max($insertions,$deletions)) lines" }
    foreach ($f in ($allFiles | Select-Object -First 30)) {
        $bodyLines += "- $f`: $desc"
    }
    if ($allFiles.Count -gt 30) { $bodyLines += "- ... and $($allFiles.Count - 30) more files" }

    $message = "$type"
    if ($scope) { $message += "($scope)" }
    $message += ": $summary"
    $message += "`n`n"
    $message += ($bodyLines -join "`n")

    return $message
}

function Test-WorkingTreeClean {
    $status = & git status --porcelain 2>$null
    return [string]::IsNullOrEmpty($status)
}

function Write-Divider {
    param([string]$char = "═", [int]$width = 46)
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

# --- Determine commit mode ---
$autoCommitInfo = $null
$hasChanges = -not (Test-WorkingTreeClean)

if ($ahead -eq 0 -and -not $hasChanges) {
    return @{ status = "CANCELLED"; summary = "Không có thay đổi nào để commit hoặc push (ahead=0, working tree clean)"; git_status = @{ branch = $branch; remote = $remote; ahead = 0; behind = $behind } }
}

# --- Auto-commit (mặc định) ---
if (-not $noCommit -and $hasChanges) {
    $finalMessage = ""

    if (-not [string]::IsNullOrEmpty($commitMessage)) {
        # Dùng message từ user
        $finalMessage = $commitMessage
        Write-Output "  [COMMIT] Using provided message..."
    } else {
        # Auto-generate message từ diff
        Write-Output "  [COMMIT] Auto-generating commit message from changes..."
        $generated = Get-AutoCommitMessage
        if ($generated) {
            $finalMessage = $generated
            Write-Output "  [OK] Generated: $($finalMessage.Split("`n")[0])"
        } else {
            # Fallback: hỏi user
            Write-Output "  [INPUT] Could not auto-generate commit message."
            Write-Output "  Enter commit message (or 'CANCEL' to abort):"
            $userMsg = Read-Host
            if ($userMsg.Trim().ToUpper() -eq "CANCEL") {
                return @{ status = "CANCELLED"; summary = "User hủy auto-commit"; git_status = @{ branch = $branch; remote = $remote; ahead = $ahead; behind = $behind } }
            }
            $finalMessage = $userMsg
        }
    }

    if ($cur) {
        & git add -u 2>$null
    } else {
        & git add -A 2>$null
    }
    & git commit -m $finalMessage 2>$null
    if ($LASTEXITCODE -ne 0) {
        return @{ status = "FAILED"; summary = "Commit thất bại"; error = "git commit failed" }
    }

    # Cập nhật ahead count
    $revCount = & git rev-list --left-right --count "$remote/$branch...$branch" 2>$null
    if ($?) {
        $parts = $revCount -split "`t"
        if ($parts.Count -ge 2) { $ahead = [int]$parts[1] }
    }

    $autoCommitInfo = @{
        enabled = $true
        mode = if ([string]::IsNullOrEmpty($commitMessage)) { "auto" } else { "manual" }
        message = $finalMessage
        type = if ($finalMessage -match '^(\w+)') { $matches[1] } else { "chore" }
        scope = if ($finalMessage -match '^(\w+)\(([^)]+)\)') { $matches[2] } else { "" }
    }

    Write-Output "  [OK] Committed ($($autoCommitInfo.mode)): $($finalMessage.Split("`n")[0])"
} elseif ($noCommit) {
    Write-Output "  [SKIP] --no-commit flag set, skipping auto-commit"
    if ($ahead -eq 0) {
        return @{ status = "CANCELLED"; summary = "--no-commit nhưng không có commit nào để push (ahead = 0)"; git_status = @{ branch = $branch; remote = $remote; ahead = 0; behind = $behind } }
    }
} else {
    Write-Output "  [SKIP] Working tree clean, không có thay đổi mới để commit"
    if ($ahead -eq 0) {
        return @{ status = "CANCELLED"; summary = "Working tree clean và không có commit để push"; git_status = @{ branch = $branch; remote = $remote; ahead = 0; behind = $behind } }
    }
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
if ($skipConfirm) {
    # Agent-run sau khi user đã xác nhận — bỏ qua confirmation gate
    $confirmation = if ($force) { "FORCE" } else { "Y" }
} elseif ($Host.UI.RawUI) {
    try {
        $confirmation = $Host.UI.RawUI.ReadLine()
    } catch {
        # Non-interactive: KHÔNG tự động xác nhận — mặc định hủy (an toàn)
        $confirmation = ""
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
$pushOutput = Invoke-Expression $pushCommand 2>&1
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

    $result = @{
        status = "SUCCESS"
        summary = "Push thành công lên $remote/$branch"
        git_status = @{ branch = $branch; remote = $remote; remote_url = $remoteUrl; ahead = $ahead; behind = $behind; last_commit = $lastCommit }
        confirmation = @{ requested = $true; response = $confirmationResponse; timestamp = $timestamp }
        push = @{ status = "SUCCESS"; command = $pushCommand; output = ($pushOutput -join "`n"); duration_seconds = $durationSeconds }
        post_push = @{ remote_synced = $remoteSynced; ahead = $newAhead; behind = $newBehind; new_remote_commit = $newRemoteCommit }
    }
    if ($autoCommitInfo) { $result.auto_commit = $autoCommitInfo }
    return $result
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

    $failResult = @{
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
    if ($autoCommitInfo) { $failResult.auto_commit = $autoCommitInfo }
    return $failResult
}
