---
name: spec-010-x013-governance
description: SPEC-010 X013 - Plugin Governance. Authority, decisions, lifecycle, matrix.
agent: general
---

# X013 - Plugin Governance

> **SPEC-010**: Plugin Framework - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Ai quyet dinh ve Plugin Framework va thay doi nhu the nao?**

## XG001 - Philosophy

- Plugin Framework chiu Authority cua Constitution (SPEC-000).
- Moi quyet dinh ve Plugin deu ghi nhan (XDEC).
- Breaking change can ADR + RFC (SPEC-000).
- Governance phoi hop qua S013.

## XG002 - Governance Stack (6 lop)

1. Constitution (SPEC-000) - nen tang.
2. Principles (P001-P016) - nguyen tac.
3. Rules (RULE-*) - quy tac.
4. Policies (S012) - chinh sach.
5. SPEC-010 - dac ta Plugin Framework.
6. Governance (S013) - dieu phoi.

## XG003 - Decisions (4)

| ID | Issue | Decision |
|----|-------|----------|
| XDEC-001 | Plugin co sua Core? | Khong - sandbox (TERM-015) |
| XDEC-002 | Plugin co vuot permission? | Khong - permission scoped (TERM-015) |
| XDEC-003 | Plugin chua Business Data? | Khong - chi metadata |
| XDEC-004 | Uninstall che do? | disable truoc uninstall (TERM-015) |

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

SPEC010_FROZEN / UNFROZEN / VERSIONED / DECISION_MADE / DECISION_OVERRIDDEN (S011).

## XG007 - Binding Enforcement

RULE-005 (no mutable), RULE-014 (observability), XPOL-001..010.
Vi pham -> ghi nhan + Doctor X019 + escalate S013.

## Tham chieu

- SPEC-000 Constitution
- S013 Governance - SPEC-001
- X016 Compliance - SPEC-010
