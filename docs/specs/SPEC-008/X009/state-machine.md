---
name: spec-008-x009-state-machine
description: SPEC-008 X009 - Event State Machine. 6 states, 6 transitions, 3 guards.
agent: general
---

# X009 - Event State Machine

> **SPEC-008**: Event Bus - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Event chuyen trang thai nhu the nao?**

## XS001 - Philosophy

- Event luon co dung mot State.
- State chi thay doi qua Transition (S009).
- Moi Transition sinh Event (S011).
- **Event chay dung State Machine cua Runtime (S009) - khong dinh nghia lai.**

## XS002 - Principles

- State la nguon su that cua Event.
- State doc lap implementation.
- Transition quyet dinh Lifecycle (S011).
- Guard chan transition khong hop le.

## XS003 - Structure (2 tang)

1. **Definition State Machine** (XST-001..006, XTR-001..006).
2. **Run State Machine** - tham chieu S009 (Runtime).

## XS004 - Definition States (6)

| State | Category | Type | Terminal |
|-------|----------|------|----------|
| XST-001 Created | Initial | Initial | - |
| XST-002 Validating | Preparation | Internal | - |
| XST-003 Published | Active | Active | - |
| XST-004 Delivered | Active | Active | - |
| XST-005 Archived | Terminal | Terminal | yes |
| XST-006 Rejected | Terminal | Terminal | yes |

`initial_state: XST-001` - `terminal_states: [XST-005, XST-006]`

## XS005 - Definition Transitions (6)

| From -> To | Event | Guard |
|-----------|-------|-------|
| XST-001 -> XST-002 | EVENT_VALIDATING | Khai bao hop le |
| XST-002 -> XST-003 | EVENT_PUBLISHED | Validate pass + lineage OK |
| XST-002 -> XST-006 | EVENT_REJECTED | Validate fail |
| XST-003 -> XST-004 | EVENT_DELIVERED | Co subscriber nhan |
| XST-004 -> XST-005 | EVENT_ARCHIVED | Het retention |
| XST-003 -> XST-005 | EVENT_ARCHIVED | Het retention (khong consumed) |

## XS006 - Transition Matrix

```text
XST-001 -> XST-002
XST-002 -> XST-003 | XST-006
XST-003 -> XST-004 | XST-005
XST-004 -> XST-005
XST-005 -> (terminal)
XST-006 -> (terminal)
```

## XS007 - Guards (3)

1. XTR-002: Validate pass + lineage khop.
2. XTR-004: Subscriber ton tai va active.
3. XTR-005: Retention het han (S012).

Guard fail -> BLOCK + EVENT_GUARD + Event (S011).

## XS008 - Events (6)

- Moi transition sinh dung mot event EVENT_*.
- Event immutable, append-only (P005).
- Event co correlation_id (S011).

## XS009 - Registered Machines

- XSTM-001 Event Lifecycle (6 states, 6 transitions).

## XS010 - Validation

- initial_state ton tai, moi state reachable.
- Terminal chi co inbound.
- Validate bang Doctor (X019) + Event Test.

## XS011 - Metrics

- event_states_total, event_transitions_total.
- event_rejected_total, event_archived_total.

## Tham chieu

- S009 State Machine - SPEC-001
- S011 Event Model - SPEC-001
- RULE-007 Event
