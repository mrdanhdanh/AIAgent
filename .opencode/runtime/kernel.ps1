<#
.SYNOPSIS
Runtime Kernel - single entry point cua AIOS runtime. Moi hoat dong di qua day.
.DESCRIPTION
Kernel import event-bus + state-machine, route call, ghi log entry + metrics JSON.
Cach dung: . .opencode/runtime/kernel.ps1  (dot-source) hoac chay qua aios.ps1.
Export: Initialize-Runtime, Invoke-Kernel, Get-RuntimeMetrics, Get-RuntimeLog.
#>

# === Import modules (mot lan) ===
$script:KernelLoaded = $false

function Import-RuntimeModules {
    if ($script:KernelLoaded) { return }
    $rtDir = Split-Path -Parent $PSScriptRoot
    Import-Module (Join-Path $rtDir "event-bus.psm1") -Force -ErrorAction Stop
    Import-Module (Join-Path $rtDir "state-machine.psm1") -Force -ErrorAction Stop
    $script:KernelLoaded = $true
}

function Initialize-Runtime {
    param([string]$WorkflowId = $null, [string]$Request = $null)
    Import-RuntimeModules
    Reset-EventBus
    if ($WorkflowId) {
        New-StateMachine -WorkflowId $WorkflowId -Request $Request
    }
    Write-RuntimeLog "kernel" "initialized" "workflow=$WorkflowId"
    return @{
        kernel   = "v1.0"
        modules  = @("event-bus", "state-machine")
        workflow = $WorkflowId
        at       = (Get-Date -Format "o")
    }
}

function Invoke-Kernel {
    param(
        [Parameter(Mandatory = $true)][ValidateSet("event", "state", "checkpoint", "metrics", "status")][string]$Action,
        $Arg1 = $null,
        $Arg2 = $null
    )
    Import-RuntimeModules
    switch ($Action) {
        "event"     { $r = Publish-Event -Event $Arg1; break }
        "state"     { $r = Set-PhaseState -PhaseId $Arg1.phase -Status $Arg1.status -ErrorCode $Arg1.code -ErrorDetail $Arg1.detail; break }
        "checkpoint" { $r = Add-Checkpoint -ContextRoot $Arg1 -ArtifactFiles $Arg2; break }
        "metrics"   { $r = Get-RuntimeMetrics; break }
        "status"    { $r = Get-RuntimeState; break }
        default     { throw "KRN-001: action khong ho tro: $Action" }
    }
    Write-RuntimeLog "kernel" "invoke" "action=$Action"
    return $r
}

function Get-RuntimeMetrics {
    Import-RuntimeModules
    $evt = Get-EventBusStats
    $st = Get-RuntimeState
    return @{
        captured_at = (Get-Date -Format "o")
        event_bus   = $evt
        state       = if ($st) { @{ workflow = $st.workflow_id; status = $st.status; phase = $st.current_phase; index = $st.phase_index; retries = $st.retry_count } } else { $null }
    }
}

function Get-RuntimeLog {
    param([int]$Tail = 20)
    $logFile = Join-Path (Split-Path -Parent $PSScriptRoot) "runtime\logs\kernel.log"
    if (-not (Test-Path $logFile)) { return @() }
    return @(Get-Content -LiteralPath $logFile -Tail $Tail -ErrorAction SilentlyContinue)
}

function Write-RuntimeLog {
    param([string]$Source, [string]$Action, [string]$Detail = "")
    $logDir = Join-Path (Split-Path -Parent $PSScriptRoot) "runtime\logs"
    if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }
    $line = "$(Get-Date -Format 'o') | $Source | $Action | $Detail"
    Add-Content -LiteralPath (Join-Path $logDir "kernel.log") -Value $line -Encoding utf8
}
