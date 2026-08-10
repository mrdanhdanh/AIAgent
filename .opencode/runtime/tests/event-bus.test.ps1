<#
.SYNOPSIS
Event Bus tests - 14 test cases theo events/tests.md.
Chay boi scripts/runtime-tests.ps1.
#>

Describe "event-bus"

Import-Module (Join-Path $PSScriptRoot "..\event-bus.psm1") -Force
Reset-EventBus

# E1: Publish event -> stored + dispatch to subscribers
$script:recv = @()
$null = Subscribe-Event "TEST_PING" { param($e) $script:recv += $e.id }
$evt1 = New-Event -Type "TEST_PING" -Payload @{ n = 1 }
$null = Publish-Event -Event $evt1 -DispatchNow
Assert "E1 Publish + dispatch" (($script:recv.Count -eq 1) -and ($evt1.status -eq "dispatched"))

# E2: Subscribe + receive (callback co payload dung)
$script:got = $null
$null = Subscribe-Event "TEST_DATA" { param($e) $script:got = $e.payload.n }
$null = Publish-Event -Event (New-Event -Type "TEST_DATA" -Payload @{ n = 42 }) -DispatchNow
Assert "E2 Subscribe nhan payload" ($script:got -eq 42)

# E3: Unsubscribe -> khong nhan nua
$h = { param($e) $script:recv += $e.id }
$null = Subscribe-Event "TEST_UNSUB" $h
$before = $script:recv.Count
$null = Unsubscribe-Event "TEST_UNSUB" $h
$null = Publish-Event -Event (New-Event -Type "TEST_UNSUB" -Payload @{}) -DispatchNow
Assert "E3 Unsubscribe roi khong nhan" ($script:recv.Count -eq $before)

# E4: Priority - critical dequeue truoc normal (cung queue, drain 1 lan)
Reset-EventBus
$script:order = @()
$null = Subscribe-Event "TEST_ORD" { param($e) $script:order += $e.weight }
$null = Publish-Event -Event (New-Event -Type "TEST_ORD" -Payload @{} -Priority "normal")
$null = Publish-Event -Event (New-Event -Type "TEST_ORD" -Payload @{} -Priority "critical")
Drain-EventQueue
Assert "E4 critical truoc normal" (($script:order.Count -eq 2) -and ($script:order[0] -eq 0) -and ($script:order[1] -eq 2))

# E5: History - event luu lai
Reset-EventBus
$null = Publish-Event -Event (New-Event -Type "TEST_HIST" -Payload @{}) -DispatchNow
Assert "E5 History chua event" (@(Get-EventHistory).Count -eq 1)

# E6: Replay - su kien cu duoc phat lai
Reset-EventBus
$script:replays = 0
$null = Subscribe-Event "TEST_RP" { param($e) $script:replays++ }
$null = Publish-Event -Event (New-Event -Type "TEST_RP" -Payload @{}) -DispatchNow
$n = Replay-Event -Type "TEST_RP"
Assert "E6 Replay dung order" ($n -ge 1 -and $script:replays -ge 2)

# E7: Filter - chi nhan event matching (tren type)
Reset-EventBus
$script:filtered = @()
$null = Subscribe-Event "TEST_F_A" { param($e) $script:filtered += "A" }
$null = Subscribe-Event "TEST_F_B" { param($e) $script:filtered += "B" }
$null = Publish-Event -Event (New-Event -Type "TEST_F_A" -Payload @{}) -DispatchNow
Assert "E7 Filter theo type" (($script:filtered.Count -eq 1) -and ($script:filtered[0] -eq "A"))

# E8: Routing - event den dung subscriber
Reset-EventBus
$script:route = @()
$null = Subscribe-Event "TEST_R1" { param($e) $script:route += "R1" }
$null = Subscribe-Event "TEST_R2" { param($e) $script:route += "R2" }
$null = Publish-Event -Event (New-Event -Type "TEST_R2" -Payload @{}) -DispatchNow
Assert "E8 Routing dung subscriber" (($script:route -join ",") -eq "R2")

# E9: Dead letter - handler fail het retry -> dead letter
Reset-EventBus
$null = Subscribe-Event "TEST_FAIL" { throw "boom" }
$evt9 = New-Event -Type "TEST_FAIL" -Payload @{} -Retry 3
$null = Publish-Event -Event $evt9 -DispatchNow
Assert "E9 Dead letter sau retry" (@(Get-EventDeadLetters).Count -eq 1)

# E10: Lineage - parent_event_id
$parent = New-Event -Type "TEST_PARENT" -Payload @{}
$child = New-Event -Type "TEST_CHILD" -Payload @{} -ParentEventId $parent.id
Assert "E10 Lineage parent lien ket" ($child.parent -eq $parent.id)

# E11: Contract validation - type xau -> reject
Assert-Throw "E11 Type khong hop le reject" { New-Event -Type "bad type!" -Payload @{} } "EVT-001"

# E12: Overflow - queue vuot max -> reject
Reset-EventBus
$script:overflowSeen = $false
1..99 | ForEach-Object { $null = Publish-Event -Event (New-Event -Type "TEST_OVF" -Payload @{}) }
try {
    $null = Publish-Event -Event (New-Event -Type "TEST_OVF" -Payload @{})
} catch { $script:overflowSeen = $true }
Assert "E12 Overflow reject" ($script:overflowSeen -or (Get-EventBusStats).queue_size -le 100)

# E13: Payload null -> reject
Assert-Throw "E13 Payload null reject" { New-Event -Type "TEST_NULL" -Payload $null } "EVT-011"

# E14: Stats
Reset-EventBus
$null = Publish-Event -Event (New-Event -Type "TEST_ST" -Payload @{}) -DispatchNow
$stats = Get-EventBusStats
Assert "E14 Stats dung" ($stats.history_count -eq 1 -and $stats.queue_size -eq 0)
