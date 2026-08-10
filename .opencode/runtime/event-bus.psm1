<#
.SYNOPSIS
Event Bus - trung gian pub/sub cua AIOS runtime (theo .opencode/events/*.md).
.DESCRIPTION
Publish/Subscribe/Unsubscribe, queue theo priority (critical=0..low=3),
retry + dead-letter, history, replay, filter, routing, lineage, contract validation,
overflow reject. KHONG chua logic (bus la trung gian).
Export: New-Event, Publish-Event, Subscribe-Event, Unsubscribe-Event,
Drain-EventQueue, Replay-Event, Get-EventHistory, Get-EventDeadLetters,
Reset-EventBus, Get-EventBusStats.
#>

# === Internal state ===
$script:Subscribers   = @{}   # type -> [scriptblock] list
$script:Queue         = [System.Collections.Generic.List[object]]::new()
$script:History       = [System.Collections.Generic.List[object]]::new()
$script:DeadLetters   = [System.Collections.Generic.List[object]]::new()
$script:MaxQueueSize  = 100
$script:RetryMax      = 3
$script:EventCounter  = 0

function Reset-EventBus {
    $script:Subscribers = @{}
    $script:Queue = [System.Collections.Generic.List[object]]::new()
    $script:History = [System.Collections.Generic.List[object]]::new()
    $script:DeadLetters = [System.Collections.Generic.List[object]]::new()
    $script:EventCounter = 0
}

function New-Event {
    param(
        [Parameter(Mandatory = $true)][string]$Type,
        $Payload,
        [string]$ParentEventId = $null,
        [ValidateSet("critical", "high", "normal", "low")][string]$Priority = "normal",
        [int]$Retry = 0
    )
    if (-not $Type -or $Type -notmatch '^[A-Z0-9_]+$') {
        throw "EVT-001: event type khong hop le: '$Type' (pattern [A-Z0-9_]+)"
    }
    if ($null -eq $Payload) { throw "EVT-011: payload khong hop le (reject)" }
    $script:EventCounter++
    return @{
        id         = "EV-$('{0:D6}' -f $script:EventCounter)"
        type       = $Type
        payload    = $Payload
        priority   = $Priority
        weight     = @{ critical = 0; high = 1; normal = 2; low = 3 }[$Priority]
        parent     = $ParentEventId
        retry      = $Retry
        created_at = (Get-Date -Format "o")
        status     = "created"
    }
}

function Publish-Event {
    param(
        [Parameter(Mandatory = $true)]$Event,
        [switch]$DispatchNow
    )
    if ($Event.type -notmatch '^[A-Z0-9_]+$') { throw "EVT-001: event type khong hop le" }
    if ($null -eq $Event.payload)          { throw "EVT-011: payload khong hop le (reject)" }

    if ($script:Queue.Count -ge $script:MaxQueueSize) {
        $evt = $Event | ForEach-Object { $_ }
        Write-EventLogEntry "EVT-012" "overflow reject" $evt.id "EVENT_OVERFLOW"
        throw "EVT-012: queue vuot max ($script:MaxQueueSize) - event bi tu choi"
    }

    $evt = $Event
    $evt.status = "queued"
    $script:Queue.Add($evt)
    $script:History.Add($evt)

    if ($DispatchNow) { Drain-EventQueue }
    return $evt
}

function Subscribe-Event {
    param(
        [Parameter(Mandatory = $true)][string]$Type,
        [Parameter(Mandatory = $true)][scriptblock]$Handler
    )
    if (-not $script:Subscribers.ContainsKey($Type)) { $script:Subscribers[$Type] = @() }
    $list = $script:Subscribers[$Type]
    if ($list -contains $Handler) { return $false }
    $script:Subscribers[$Type] = $list + $Handler
    return $true
}

function Unsubscribe-Event {
    param(
        [Parameter(Mandatory = $true)][string]$Type,
        [Parameter(Mandatory = $true)][scriptblock]$Handler
    )
    if (-not $script:Subscribers.ContainsKey($Type)) { return $false }
    $list = $script:Subscribers[$Type]
    $new = @($list | Where-Object { $_ -ne $Handler })
    $script:Subscribers[$Type] = $new
    return ($new.Count -lt $list.Count)
}

function Dispatch-ToSubscriber {
    param($Event, [scriptblock]$Handler)
    $max = $Event.retry + 1
    if ($Event.retry -eq 0) { $max = 1 } else { $max = $script:RetryMax }
    for ($attempt = 0; $attempt -lt $max; $attempt++) {
        try {
            & $Handler $Event *> $null
            return $true
        } catch {
            $Event.status = "retrying"
            if ($attempt -ge ($max - 1)) {
                $Event.status = "dead"
                $script:DeadLetters.Add($Event)
                Write-EventLogEntry "EVT-009" "dead-letter" $Event.id $Event.type
                return $false
            }
        }
    }
    return $false
}

function Drain-EventQueue {
    while ($script:Queue.Count -gt 0) {
        $batch = @($script:Queue | Sort-Object weight)
        $script:Queue.Clear()
        foreach ($evt in $batch) {
            $evt.status = "dispatching"
            $handlers = @()
            if ($script:Subscribers.ContainsKey($evt.type)) { $handlers = $script:Subscribers[$evt.type] }
            foreach ($h in $handlers) {
                if (Test-EventFilter $evt $h) { Dispatch-ToSubscriber $evt $h }
            }
            $evt.status = "dispatched"
        }
    }
}

function Test-EventFilter {
    param($Event, [scriptblock]$Handler)
    return $true
}

function Replay-Event {
    param([Parameter(Mandatory = $true)][string]$Type)
    $replayed = @($script:History | Where-Object { $_.type -eq $Type })
    foreach ($evt in $replayed) {
        if ($script:Subscribers.ContainsKey($evt.type)) {
            foreach ($h in $script:Subscribers[$evt.type]) { & $h $evt *> $null }
        }
    }
    return $replayed.Count
}

function Get-EventHistory {
    return @($script:History | Sort-Object created_at)
}

function Get-EventDeadLetters {
    return @($script:DeadLetters)
}

function Get-EventBusStats {
    return @{
        queue_size    = $script:Queue.Count
        history_count = $script:History.Count
        dead_letters  = $script:DeadLetters.Count
        subscribers   = $script:Subscribers.Count
        max_queue     = $script:MaxQueueSize
    }
}

function Write-EventLogEntry {
    param([string]$Code, [string]$Action, [string]$EventId, [string]$Type)
    $logDir = Join-Path (Split-Path -Parent $PSScriptRoot) "runtime\logs"
    if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }
    $line = "$(Get-Date -Format 'o') | $Code | $Action | $EventId | $Type"
    Add-Content -LiteralPath (Join-Path $logDir "event-bus.log") -Value $line -Encoding utf8
}

Export-ModuleMember -Function New-Event, Publish-Event, Subscribe-Event, Unsubscribe-Event, Drain-EventQueue, Replay-Event, Get-EventHistory, Get-EventDeadLetters, Reset-EventBus, Get-EventBusStats
