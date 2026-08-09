---
name: spec-011-x009-state-machine
description: SPEC-011 X009 - Doctor State Machine. 6 states, 5 transitions, 3 guards.
agent: general
---

# X009 - Doctor State Machine

> **SPEC-011**: Doctor - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Scan chuyen trang thai nhu the nao?**

## XS001 - Philosophy

- Scan luon co dung mot State.
- State chi thay doi qua Transition (S009).
- Moi Transition sinh Event (S011).
- **Doctor chay dung State Machine cua Runtime (S009) - khong dinh nghia lai.**

## XS002 - Principles

- State la nguon su that cua Scan.
- State doc lap implementation.
- Transition quyet dinh Lifecycle.
- Guard chan transition khong hop le.

## XS003 - Structure (2 tang)

1. **Definition State Machine** (XST-001..006, XTR-001..005).
2. **Run State Machine** - tham chieu S009 (Runtime).

## XS004 - Definition States (6)

| State | Category | Type | Terminal |
|-------|----------|------|----------|
| XST-001 Requested | Initial | Initial | - |
| XST-002 Scanning | Preparation | Internal | - |
| XST-003 Diagnosed | Active | Active | - |
| XST-004 Scored | Active | Active | - |
| XST-005 Reported | Terminal | Terminal | yes |
| XST-006 Failed | Terminal | Terminal | yes |

`initial_state: XST-001` - `terminal_states: [XST-005, XST-006]`

## XS005 - Definition Transitions (5)

| From -> To | Event | Guard |
|-----------|-------|-------|
| XST-001 -> XST-002 | DOCTOR_SCANNING | Request hop le |
| XST-002 -> XST-003 | DOCTOR_DIAGNOSED | Scan xong + findings |
| XST-002 -> XST-006 | DOCTOR_STATE_FAILED | Scan fail |
| XST-003 -> XST-004 | DOCTOR_SCORED | Score tinh xong |
| XST-004 -> XST-005 | DOCTOR_STATE_REPORTED | Report xong |

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

1. XTR-002: Scan day du + khong loi.
2. XTR-004: Score 0-100 hop le.
3. XTR-005: Report day du (markdown/JSON).

Guard fail -> BLOCK + DOCTOR_GUARD + Event (S011).

## XS008 - Events (5)

- Moi transition sinh dung mot event DOCTOR_*.
- Event immutable, append-only (P010).
- Event co correlation_id (S011).

## XS009 - Registered Machines

- XSTM-001 Doctor Pipeline (6 states, 5 transitions).

## XS010 - Validation

- initial_state ton tai, moi state reachable.
- Terminal chi co inbound.
- Validate bang Doctor (X019) + Doctor Test.

## XS011 - Metrics

- doctor_states_total, doctor_transitions_total.
- doctor_failed_total, doctor_reported_total.

## Tham chieu

- S009 State Machine - SPEC-001
- /doctor command
- S011 Events - SPEC-001
