---
name: spec-006-x009-state-machine
description: SPEC-006 X009 - Context State Machine. 8 states, 11 transitions, 5 guards.
agent: general
---

# X009 - Context State Machine

> **SPEC-006**: Context Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Execution Context chuyen trang thai nhu the nao?**

## XS001 - Philosophy

- Context luon co dung mot State.
- State chi thay doi qua Transition (S009).
- Moi Transition sinh Event (S011).
- **Context chay dung State Machine cua Runtime (S009) - khong dinh nghia lai.**

## XS002 - Principles

- State la nguon su that cua Context.
- State doc lap implementation.
- Transition quyet dinh Lifecycle (EF008).
- Guard chan transition khong hop le.

## XS003 - Structure (2 tang)

1. **Definition State Machine** (XST-001..008, XTR-001..011).
2. **Run State Machine** - tham chieu S009 (Runtime).

## XS004 - Definition States (8)

| State | Category | Type | Terminal |
|-------|----------|------|----------|
| XST-001 Allocated | Initial | Initial | - |
| XST-002 Populating | Preparation | Internal | - |
| XST-003 Active | Active | Active | - |
| XST-004 Distributed | Active | Active | - |
| XST-005 Merging | Preparation | Internal | - |
| XST-006 Collected | Active | Active | - |
| XST-007 Released | Terminal | Terminal | yes |
| XST-008 Rejected | Terminal | Terminal | yes |

`initial_state: XST-001` - `terminal_states: [XST-007, XST-008]`

## XS005 - Definition Transitions (11)

| From -> To | Event | Guard |
|-----------|-------|-------|
| XST-001 -> XST-002 | CONTEXT_POPULATED | Khai bao section hop le |
| XST-002 -> XST-003 | CONTEXT_ACTIVE | Populate pass validate |
| XST-002 -> XST-008 | CONTEXT_REJECTED | Populate fail |
| XST-003 -> XST-004 | CONTEXT_DISTRIBUTED | Grant tao thanh cong |
| XST-004 -> XST-003 | CONTEXT_MUTATED | Mutation trong scope |
| XST-004 -> XST-005 | CONTEXT_MERGING | Nhan Context con |
| XST-005 -> XST-003 | CONTEXT_MERGED | Merge pass |
| XST-005 -> XST-008 | CONTEXT_MERGE_FAILED | Merge fail |
| XST-003 -> XST-006 | CONTEXT_COLLECTING | Thu ket qua |
| XST-006 -> XST-007 | CONTEXT_RELEASED | Execution ket thuc |
| XST-006 -> XST-008 | CONTEXT_RELEASED_FAILED | Release fail |

## XS006 - Transition Matrix

```text
XST-001 -> XST-002
XST-002 -> XST-003 | XST-008
XST-003 -> XST-004 | XST-006
XST-004 -> XST-003 | XST-005
XST-005 -> XST-003 | XST-008
XST-006 -> XST-007 | XST-008
XST-007 -> (terminal)
XST-008 -> (terminal)
```

## XS007 - Guards (5)

1. XTR-002: Validate pass.
2. XTR-004: Grant scope hop le.
3. XTR-005: Key trong scope cua grant.
4. XTR-007: Merge khong conflict key.
5. XTR-010: Execution terminal.

Guard fail -> BLOCK + CONTEXT_GUARD + Event (S011).

## XS008 - Events (11)

- Moi transition sinh dung mot event CONTEXT_*.
- Event immutable, append-only (P010).
- Event co correlation_id (S011).

## XS009 - Registered Machines

- XSTM-001 Context Lifecycle (8 states, 11 transitions).
- XSTM-002 Context Grant (3 states, 4 transitions).

## XS010 - Validation

- initial_state ton tai, moi state reachable.
- Terminal chi co inbound.
- Validate bang Doctor (X019) + Context Test.

## XS011 - Metrics

- context_states_total, context_transitions_total.
- context_rejected_total, context_released_total.
- context_release_latency_seconds.

## Tham chieu

- S009 State Machine - SPEC-001
- S010 EF008 - SPEC-001
- S011 Events - SPEC-001
