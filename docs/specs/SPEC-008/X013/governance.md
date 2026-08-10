---
name: spec-008-x013-governance
description: SPEC-008 X013 - Event Governance. Authority, decisions, lifecycle, matrix.
agent: general
---

# X013 - Event Governance

> **SPEC-008**: Event Bus - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Ai quyet dinh ve Event Bus va thay doi nhu the nao?**

## XG001 - Philosophy

- Event Bus chiu Authority cua Constitution (SPEC-000).
- Moi quyet dinh ve Event deu ghi nhan (XDEC).
- Breaking change can ADR + RFC (SPEC-000).
- Governance phoi hop qua S013.

## XG002 - Governance Stack (6 lop)

1. Constitution (SPEC-000) - nen tang.
2. Principles (P001-P016) - nguyen tac.
3. Rules (RULE-*) - quy tac.
4. Policies (S012) - chinh sach.
5. SPEC-008 - dac ta Event Bus.
6. Governance (S013) - dieu phoi.

## XG003 - Decisions (4)

| ID | Issue | Decision |
|----|-------|----------|
| XDEC-001 | Event co mutable? | Khong - immutable (P010) |
| XDEC-002 | Event co xoa duoc? | Khong - append-only (P005) |
| XDEC-003 | Event chua Business Data? | Khong - chi metadata |
| XDEC-004 | Deliver guarantee? | at-least-once (S012) |

## XG004 - Change Matrix

| Change | Authority | Process |
|--------|-----------|---------|
| Typo/Editorial | Owner | Direct fix + note |
| Clarify | Owner | Review + version bump |
| Add (backward) | Owner + Reviewer | ADR |
| Breaking | Governance (S013) | ADR + RFC |

## XG005 - Lifecycle

Draft -> Review -> Approved -> Frozen -> Deprecated.
Frozen chi thay doi qua ADR + RFC.

## XG006 - Events

SPEC008_FROZEN / UNFROZEN / VERSIONED / DECISION_MADE / DECISION_OVERRIDDEN (S011).

## XG007 - Binding Enforcement

RULE-007 (event), RULE-005 (immutable), XPOL-001..010.
Vi pham -> ghi nhan + Doctor X019 + escalate S013.

## Tham chieu

- SPEC-000 Constitution
- S013 Governance - SPEC-001
- X016 Compliance - SPEC-008
