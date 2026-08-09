---
name: spec-009-x009-state-machine
description: SPEC-009 X009 - Contract State Machine. 6 states, 6 transitions, 3 guards.
agent: general
---

# X009 - Contract State Machine

> **SPEC-009**: Contract System - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Contract chuyen trang thai nhu the nao?**

## XS001 - Philosophy

- Contract luon co dung mot State.
- State chi thay doi qua Transition (S009).
- Moi Transition sinh Event (S011).
- **Contract chay dung State Machine cua Runtime (S009) - khong dinh nghia lai.**

## XS002 - Principles

- State la nguon su that cua Contract.
- State doc lap implementation.
- Transition quyet dinh Lifecycle (S007).
- Guard chan transition khong hop le.

## XS003 - Structure (2 tang)

1. **Definition State Machine** (XST-001..006, XTR-001..006).
2. **Run State Machine** - tham chieu S009 (Runtime).

## XS004 - Definition States (6)

| State | Category | Type | Terminal |
|-------|----------|------|----------|
| XST-001 Declared | Initial | Initial | - |
| XST-002 Validating | Preparation | Internal | - |
| XST-003 Published | Active | Active | - |
| XST-004 Resolved | Active | Active | - |
| XST-005 Retired | Terminal | Terminal | yes |
| XST-006 Rejected | Terminal | Terminal | yes |

`initial_state: XST-001` - `terminal_states: [XST-005, XST-006]`

## XS005 - Definition Transitions (6)

| From -> To | Event | Guard |
|-----------|-------|-------|
| XST-001 -> XST-002 | CONTRACT_VALIDATING | Khai bao hop le |
| XST-002 -> XST-003 | CONTRACT_PUBLISHED | Validate pass + compat OK |
| XST-002 -> XST-006 | CONTRACT_REJECTED | Validate fail |
| XST-003 -> XST-004 | CONTRACT_RESOLVED | Caller resolve thanh cong |
| XST-003 -> XST-003 | CONTRACT_VERSIONED | Version moi (P004) |
| XST-004 -> XST-005 | CONTRACT_RETIRED | Het han |

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

1. XTR-002: Validate pass + backward compatible.
2. XTR-005: Version moi khong pha caller cu.
3. XTR-006: Retention het han (S012).

Guard fail -> BLOCK + CONTRACT_GUARD + Event (S011).

## XS008 - Events (6)

- Moi transition sinh dung mot event CONTRACT_*.
- Event immutable, append-only (P005).
- Event co correlation_id (S011).

## XS009 - Registered Machines

- XSTM-001 Contract Lifecycle (6 states, 6 transitions).

## XS010 - Validation

- initial_state ton tai, moi state reachable.
- Terminal chi co inbound.
- Validate bang Doctor (X019) + Contract Test.

## XS011 - Metrics

- contract_states_total, contract_transitions_total.
- contract_rejected_total, contract_retired_total.

## Tham chieu

- S009 State Machine - SPEC-001
- S007 Contract Model - SPEC-001
- TERM-014 Contract
