---
name: spec-007-x009-state-machine
description: SPEC-007 X009 - Artifact State Machine. 6 states, 7 transitions, 3 guards.
agent: general
---

# X009 - Artifact State Machine

> **SPEC-007**: Artifact Manager - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Artifact chuyen trang thai nhu the nao?**

## XS001 - Philosophy

- Artifact luon co dung mot State.
- State chi thay doi qua Transition (S009).
- Moi Transition sinh Event (S011).
- **Artifact chay dung State Machine cua Runtime (S009) - khong dinh nghia lai.**

## XS002 - Principles

- State la nguon su that cua Artifact.
- State doc lap implementation.
- Transition quyet dinh Lifecycle (ENT-008).
- Guard chan transition khong hop le.

## XS003 - Structure (2 tang)

1. **Definition State Machine** (XST-001..006, XTR-001..007).
2. **Run State Machine** - tham chieu S009 (Runtime).

## XS004 - Definition States (6)

| State | Category | Type | Terminal |
|-------|----------|------|----------|
| XST-001 Created | Initial | Initial | - |
| XST-002 Validating | Preparation | Internal | - |
| XST-003 Published | Active | Active | - |
| XST-004 Consumed | Active | Active | - |
| XST-005 Archived | Terminal | Terminal | yes |
| XST-006 Rejected | Terminal | Terminal | yes |

`initial_state: XST-001` - `terminal_states: [XST-005, XST-006]`

## XS005 - Definition Transitions (7)

| From -> To | Event | Guard |
|-----------|-------|-------|
| XST-001 -> XST-002 | ARTIFACT_VALIDATING | Khai bao hop le |
| XST-002 -> XST-003 | ARTIFACT_PUBLISHED | Validate pass + checksum OK |
| XST-002 -> XST-006 | ARTIFACT_REJECTED | Validate fail |
| XST-003 -> XST-004 | ARTIFACT_CONSUMED | Co consumer doc |
| XST-003 -> XST-003 | ARTIFACT_VERSIONED | Version moi (P004) |
| XST-004 -> XST-005 | ARTIFACT_ARCHIVED | Het retention |
| XST-003 -> XST-005 | ARTIFACT_ARCHIVED | Het retention (khong consumed) |

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

1. XTR-002: Validate pass + checksum khop.
2. XTR-005: Content doi -> version moi (khong overwrite).
3. XTR-006: Retention het han (S012).

Guard fail -> BLOCK + ARTIFACT_GUARD + Event (S011).

## XS008 - Events (7)

- Moi transition sinh dung mot event ARTIFACT_*.
- Event immutable, append-only (P010).
- Event co correlation_id (S011).

## XS009 - Registered Machines

- XSTM-001 Artifact Lifecycle (6 states, 7 transitions).

## XS010 - Validation

- initial_state ton tai, moi state reachable.
- Terminal chi co inbound.
- Validate bang Doctor (X019) + Artifact Test.

## XS011 - Metrics

- artifact_states_total, artifact_transitions_total.
- artifact_rejected_total, artifact_archived_total.

## Tham chieu

- S009 State Machine - SPEC-001
- S008 ENT-008 - SPEC-001
- S011 Events - SPEC-001
