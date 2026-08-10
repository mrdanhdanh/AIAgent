---
name: spec-012-x013-governance
description: SPEC-012 X013 - Simulation Governance. Authority, decisions, lifecycle, matrix.
agent: general
---

# X013 - Simulation Governance

> **SPEC-012**: Simulation Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Ai quyet dinh ve Simulation Engine va thay doi nhu the nao?**

## XG001 - Philosophy

- Simulation Engine chiu Authority cua Constitution (SPEC-000).
- Moi quyet dinh ve Simulation deu ghi nhan (XDEC).
- Breaking change can ADR + RFC (SPEC-000).
- Governance phoi hop qua S013.

## XG002 - Governance Stack (6 lop)

1. Constitution (SPEC-000) - nen tang.
2. Principles (P001-P016) - nguyen tac.
3. Rules (RULE-*) - quy tac.
4. Policies (S012) - chinh sach.
5. SPEC-012 - dac ta Simulation Engine.
6. Governance (S013) - dieu phoi.

## XG003 - Decisions (4)

| ID | Issue | Decision |
|----|-------|----------|
| XDEC-001 | Simulation co doi he thong that? | Khong - isolated (RULE-007) |
| XDEC-002 | Simulation co deterministic? | Co - P013 |
| XDEC-003 | Simulation chua Business Data? | Khong - chi metadata |
| XDEC-004 | Scenario types? | 6 types |

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

SPEC012_FROZEN / UNFROZEN / VERSIONED / DECISION_MADE / DECISION_OVERRIDDEN (S011).

## XG007 - Binding Enforcement

RULE-007 (event), RULE-013 (deterministic), XPOL-001..010.
Vi pham -> ghi nhan + Doctor X019 + escalate S013.

## Tham chieu

- SPEC-000 Constitution
- S013 Governance - SPEC-001
- X016 Compliance - SPEC-012
