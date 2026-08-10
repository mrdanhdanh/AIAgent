---
name: spec-013-x009-state-machine
description: SPEC-013 X009 - Evolution State Machine. 6 states, 5 transitions, 3 guards.
agent: general
---

# X009 - Evolution State Machine

> **SPEC-013**: Evolution Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Evolution chuyen trang thai nhu the nao?**

## XS001 - Philosophy

- Evolution luon co dung mot State.
- State chi thay doi qua Transition (S009).
- Moi Transition sinh Event (S011).
- **Evolution chay dung State Machine cua Runtime (S009) - khong dinh nghia lai.**

## XS002 - Principles

- State la nguon su that cua Evolution.
- State doc lap implementation.
- Transition quyet dinh Lifecycle.
- Guard chan transition khong hop le.

## XS003 - Structure (2 tang)

1. **Definition State Machine** (XST-001..006, XTR-001..005).
2. **Run State Machine** - tham chieu S009 (Runtime).

## XS004 - Definition States (6)

| State | Category | Type | Terminal |
|-------|----------|------|----------|
| XST-001 Diffed | Initial | Initial | - |
| XST-002 CompatChecked | Preparation | Internal | - |
| XST-003 Planned | Active | Active | - |
| XST-004 Migrated | Active | Active | - |
| XST-005 Evolved | Terminal | Terminal | yes |
| XST-006 Failed | Terminal | Terminal | yes |

`initial_state: XST-001` - `terminal_states: [XST-005, XST-006]`

## XS005 - Definition Transitions (5)

| From -> To | Event | Guard |
|-----------|-------|-------|
| XST-001 -> XST-002 | EVOLUTION_COMPAT_CHECKED | Diff hop le |
| XST-002 -> XST-003 | EVOLUTION_PLANNED | Compat pass |
| XST-002 -> XST-006 | EVOLUTION_FAILED | Compat fail (breaking) |
| XST-003 -> XST-004 | EVOLUTION_MIGRATED | Migration xong |
| XST-004 -> XST-005 | EVOLUTION_EVOLVED | Evolve xong |

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

1. XTR-002: Backward compatible (P013).
2. XTR-004: Migration plan day du.
3. XTR-005: Evolve xong + report.

Guard fail -> BLOCK + EVOLUTION_GUARD + Event (S011).

## XS008 - Events (5)

- Moi transition sinh dung mot event EVOLUTION_*.
- Event immutable, append-only (P005).
- Event co correlation_id (S011).

## XS009 - Registered Machines

- XSTM-001 Evolution Pipeline (6 states, 5 transitions).

## XS010 - Validation

- initial_state ton tai, moi state reachable.
- Terminal chi co inbound.
- Validate bang Doctor (X019) + Evolution Test.

## XS011 - Metrics

- evolution_states_total, evolution_transitions_total.
- evolution_failed_total, evolution_evolved_total.

## Tham chieu

- S009 State Machine - SPEC-001
- P013 Deterministic Execution
- S011 Events - SPEC-001
