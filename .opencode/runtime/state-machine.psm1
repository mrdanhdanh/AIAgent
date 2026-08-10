<#
.SYNOPSIS
State Machine - quan ly trang thai phase cua AIOS runtime.
.DESCRIPTION
States: pending, running, completed, failed, skipped, cancelled, aborted.
Transition guard (chi cho phep transition hop le), checkpoint ghi state.json
DAY DU artifacts + log file (fix loi WF-20260810-001 thieu artifact cuoi, logs rong).
Export: New-StateMachine, Set-PhaseState, Add-Checkpoint, Get-RuntimeState,
Reset-StateMachine.
#>

# === States va transition map ===
$script:StateTransitions = @{
    pending   = @("running", "skipped", "cancelled", "failed")
    running   = @("completed", "failed", "cancelled", "aborted")
    completed = @("running")        # cho phep re-run
    failed    = @("running", "aborted", "cancelled")
    skipped   = @("running")
    cancelled = @()
    aborted   = @()
}

$script:RuntimeState = $null

function New-StateMachine {
    param([string]$WorkflowId, [string]$Request)
    $script:RuntimeState = @{
        workflow_id   = $WorkflowId
        request       = $Request
        phase_index   = 0
        current_phase = $null
        status        = "pending"
        retry_count   = 0
        same_error_count = 0
        error_history = @()
        artifacts     = @()
        created_at    = (Get-Date -Format "o")
        updated_at    = (Get-Date -Format "o")
    }
    return $script:RuntimeState
}

function Reset-StateMachine {
    $script:RuntimeState = $null
}

function Get-RuntimeState {
    return $script:RuntimeState
}

function Test-Transition {
    param([string]$From, [string]$To)
    if (-not $script:StateTransitions.ContainsKey($From)) { return $false }
    return ($script:StateTransitions[$From] -contains $To)
}

function Set-PhaseState {
    param(
        [Parameter(Mandatory = $true)][string]$PhaseId,
        [Parameter(Mandatory = $true)][ValidateSet("pending", "running", "completed", "failed", "skipped", "cancelled", "aborted")][string]$Status,
        [string]$ErrorCode = $null,
        [string]$ErrorDetail = $null
    )
    if ($null -eq $script:RuntimeState) { throw "STM-001: chua goi New-StateMachine" }

    $from = $script:RuntimeState.current_phase
    if ($null -ne $from -and $from -ne $PhaseId) {
        # chuyen phase: from = trang thai cua phase truoc do
        if (-not (Test-Transition $script:RuntimeState.status $Status)) {
            throw "STM-003: transition khong hop le: $($script:RuntimeState.status) -> $Status"
        }
    }

    $script:RuntimeState.current_phase = $PhaseId
    $script:RuntimeState.status = $Status
    $script:RuntimeState.updated_at = (Get-Date -Format "o")

    if ($Status -eq "completed") { $script:RuntimeState.phase_index++ }

    if ($Status -eq "failed") {
        if ($ErrorCode -and $ErrorCode -eq $script:RuntimeState.error_history[-1].code) {
            $script:RuntimeState.same_error_count++
        } else {
            $script:RuntimeState.same_error_count = 1
        }
        $script:RuntimeState.retry_count++
        $script:RuntimeState.error_history += @{
            code   = $ErrorCode
            detail = $ErrorDetail
            at     = (Get-Date -Format "o")
            phase  = $PhaseId
        }
    }
    return $script:RuntimeState
}

function Add-Checkpoint {
    param(
        [string]$ContextRoot = $null,
        [string[]]$ArtifactFiles = @()
    )
    if ($null -eq $script:RuntimeState) { throw "STM-001: chua goi New-StateMachine" }

    $root = $ContextRoot
    if (-not $root) { $root = Join-Path (Split-Path -Parent $PSScriptRoot) "workflow" }
    $wfDir = Join-Path $root $script:RuntimeState.workflow_id
    if (-not (Test-Path $wfDir)) { New-Item -ItemType Directory -Path $wfDir -Force | Out-Null }

    # Ghi DAY DU artifacts (gom ca artifact cua phase hien tai - fix loi thieu file cuoi)
    foreach ($a in $ArtifactFiles) {
        if ($a -and -not ($script:RuntimeState.artifacts -contains $a)) {
            $script:RuntimeState.artifacts += $a
        }
    }

    $state = @{
        workflow_id   = $script:RuntimeState.workflow_id
        phase_index   = $script:RuntimeState.phase_index
        current_phase = $script:RuntimeState.current_phase
        status        = $script:RuntimeState.status
        retry_count   = $script:RuntimeState.retry_count
        same_error_count = $script:RuntimeState.same_error_count
        error_history = $script:RuntimeState.error_history
        artifacts     = $script:RuntimeState.artifacts
    }
    $utf8 = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText((Join-Path $wfDir "state.json"), ($state | ConvertTo-Json -Depth 6), $utf8)

    # Log file (fix loi logs/ rong)
    $logDir = Join-Path $wfDir "logs"
    if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }
    $logLine = "$(Get-Date -Format 'o') | phase=$($script:RuntimeState.current_phase) | status=$($script:RuntimeState.status) | index=$($script:RuntimeState.phase_index)"
    Add-Content -LiteralPath (Join-Path $logDir "runtime.log") -Value $logLine -Encoding utf8

    return $state
}

Export-ModuleMember -Function New-StateMachine, Reset-StateMachine, Get-RuntimeState, Test-Transition, Set-PhaseState, Add-Checkpoint
