---
name: spec-006-x013-governance
description: SPEC-006 X013 - Context Governance. Authority, decisions, lifecycle, matrix.
agent: general
---

# X013 - Context Governance

> **SPEC-006**: Context Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Ai quyet dinh ve Context Engine va thay doi nhu the nao?**

## XG001 - Philosophy

- Context Engine chiu Authority cua Constitution (SPEC-000).
- Moi quyet dinh ve Context deu ghi nhan (XDEC).
- Breaking change can ADR + RFC (SPEC-000).
- Governance phoi hop qua S013.

## XG002 - Governance Stack (6 lop)

1. Constitution (SPEC-000) - nen tang.
2. Principles (P001-P016) - nguyen tac.
3. Rules (RULE-*) - quy tac.
4. Policies (S012) - chinh sach.
5. SPEC-006 - dac ta Context Engine.
6. Governance (S013) - dieu phoi.

## XG003 - Decisions (4)

| ID | Issue | Decision |
|----|-------|----------|
| XDEC-001 | Context chua Business Data? | Khong - chi metadata |
| XDEC-002 | Context co persist? | Khong - transient |
| XDEC-003 | Dinh nghia lai flow? | Khong - thuc thi EF008 |
| XDEC-004 | Merge che do? | Chi cha-con cung Execution |

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

SPEC006_FROZEN / UNFROZEN / VERSIONED / DECISION_MADE / DECISION_OVERRIDDEN (S011).

## XG007 - Binding Enforcement

RULE-005 (isolation), RULE-001 (no business data), XPOL-001..010.
Vi pham -> ghi nhan + Doctor X019 + escalate S013.

## Tham chieu

- SPEC-000 Constitution
- S013 Governance - SPEC-001
- X016 Compliance - SPEC-006
