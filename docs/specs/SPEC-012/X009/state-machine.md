---
name: spec-012-x009-state-machine
description: SPEC-012 X009 - Simulation State Machine. 6 states, 5 transitions, 3 guards.
agent: general
---

# X009 - Simulation State Machine

> **SPEC-012**: Simulation Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Simulation chuyen trang thai nhu the nao?**

## XS001 - Philosophy

- Simulation luon co dung mot State.
- State chi thay doi qua Transition (S009).
- Moi Transition sinh Event (S011).
- **Simulation chay dung State Machine cua Runtime (S009) - khong dinh nghia lai.**

## XS002 - Principles

- State la nguon su that cua Simulation.
- State doc lap implementation.
- Transition quyet dinh Lifecycle.
- Guard chan transition khong hop le.

## XS003 - Structure (2 tang)

1. **Definition State Machine** (XST-001..006, XTR-001..005).
2. **Run State Machine** - tham chieu S009 (Runtime).

## XS004 - Definition States (6)

| State | Category | Type | Terminal |
|-------|----------|------|----------|
| XST-001 Defined | Initial | Initial | - |
| XST-002 Configured | Preparation | Internal | - |
| XST-003 Running | Active | Active | - |
| XST-004 Observed | Active | Active | - |
| XST-005 Reported | Terminal | Terminal | yes |
| XST-006 Failed | Terminal | Terminal | yes |

`initial_state: XST-001` - `terminal_states: [XST-005, XST-006]`

## XS005 - Definition Transitions (5)

| From -> To | Event | Guard |
|-----------|-------|-------|
| XST-001 -> XST-002 | SIMULATION_CONFIGURED | Scenario hop le |
| XST-002 -> XST-003 | SIMULATION_RUNNING | Config hop le |
| XST-002 -> XST-006 | SIMULATION_FAILED | Config fail |
| XST-003 -> XST-004 | SIMULATION_OBSERVED | Run xong + result |
| XST-004 -> XST-005 | SIMULATION_REPORTED | Report xong |

## XS006 - Transition Matrix

```text
XST-001 -> XST-002
XST-002 -> XST-003 | XST-006
XST-003 -> XST-004
XST-004 -> XST-005
XST-005 -> (terminal)
XST-006 -> (terminal)
```

## XS007 - Guards (3)

1. XTR-002: Config hop le + isolated.
2. XTR-004: Result day du + deterministic.
3. XTR-005: Report day du (success rate).

Guard fail -> BLOCK + SIMULATION_GUARD + Event (S011).

## XS008 - Events (5)

- Moi transition sinh dung mot event SIMULATION_*.
- Event immutable, append-only (P005).
- Event co correlation_id (S011).

## XS009 - Registered Machines

- XSTM-001 Simulation Pipeline (6 states, 5 transitions).

## XS010 - Validation

- initial_state ton tai, moi state reachable.
- Terminal chi co inbound.
- Validate bang Doctor (X019) + Simulation Test.

## XS011 - Metrics

- simulation_states_total, simulation_transitions_total.
- simulation_failed_total, simulation_reported_total.

## Tham chieu

- S009 State Machine - SPEC-001
- RULE-007 Event
- S011 Events - SPEC-001
