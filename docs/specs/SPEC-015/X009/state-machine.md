---
name: SPEC-015-x009-state-machine
description: SPEC-015 X009 - SDK State Machine. 6 states, 5 transitions, 3 guards.
agent: general
---

# X009 - SDK State Machine

> **SPEC-015**: SDK - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **SDK chuyen trang thai nhu the nao?**

## XS001 - Philosophy

- SDK luon co dung mot State.
- State chi thay doi qua Transition (S009).
- Moi Transition sinh Event (S011).
- **SDK chay dung State Machine cua Runtime (S009) - khong dinh nghia lai.**

## XS002 - Principles

- State la nguon su that cua SDK.
- State doc lap implementation.
- Transition quyet dinh Lifecycle.
- Guard chan transition khong hop le.

## XS003 - Structure (2 tang)

1. **Definition State Machine** (XST-001..006, XTR-001..005).
2. **Run State Machine** - tham chieu S009 (Runtime).

## XS004 - Definition States (6)

| State | Category | Type | Terminal |
|-------|----------|------|----------|
| XST-001 Created | Initial | Initial | - |
| XST-002 Rendering | Preparation | Internal | - |
| XST-003 Rendered | Active | Active | - |
| XST-004 Filtered | Active | Active | - |
| XST-005 Archived | Terminal | Terminal | yes |
| XST-006 Failed | Terminal | Terminal | yes |

`initial_state: XST-001` - `terminal_states: [XST-005, XST-006]`

## XS005 - Definition Transitions (5)

| From -> To | Event | Guard |
|-----------|-------|-------|
| XST-001 -> XST-002 | SDK_RENDERING | View hop le |
| XST-002 -> XST-003 | SDK_RENDERED | Render xong |
| XST-002 -> XST-006 | SDK_FAILED | Render fail |
| XST-003 -> XST-004 | SDK_FILTERED | Filter xong |
| XST-004 -> XST-005 | SDK_ARCHIVED | Het retention |

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

1. XTR-002: S011 metrics kha dung.
2. XTR-004: Filter hop le.
3. XTR-005: Retention het han (S012).

Guard fail -> BLOCK + SDK_GUARD + Event (S011).

## XS008 - Events (5)

- Moi transition sinh dung mot event SDK_*.
- Event immutable, append-only (P010).
- Event co correlation_id (S011).

## XS009 - Registered Machines

- XSTM-001 SDK Pipeline (6 states, 5 transitions).

## XS010 - Validation

- initial_state ton tai, moi state reachable.
- Terminal chi co inbound.
- Validate bang Doctor (X019) + SDK Test.

## XS011 - Metrics

- SDK_states_total, SDK_transitions_total.
- SDK_failed_total, SDK_archived_total.

## Tham chieu

- S009 State Machine - SPEC-001
- P005 Observability First
- S011 Events - SPEC-001
