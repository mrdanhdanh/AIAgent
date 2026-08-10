---
name: spec-010-x017-extensions
description: SPEC-010 X017 - Plugin Extensions. 7 extension points, policy, lifecycle.
agent: general
---

# X017 - Plugin Extensions

> **SPEC-010**: Plugin Framework - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Plugin Framework mo rong nhu the nao ma khong pha vo core?**

## XE001 - Philosophy

- Mo rong qua Plugin (X007), khong sua core.
- Extension la tuy chon, khong bat buoc.
- Moi extension co schema + test + doc.
- Khong mo rong sang Business Data (P001).

## XE002 - Extension Points (7)

| ID | Extension | Owner | Priority |
|----|-----------|-------|----------|
| XEXT-001 | Extension Point | Plugin Framework | High |
| XEXT-002 | Custom Schema Type | Plugin Framework | Medium |
| XEXT-003 | Custom Permission Rule | Plugin Framework | Medium |
| XEXT-004 | Retention Hook | Policy (S012) | High |
| XEXT-005 | Verify Strategy | Plugin Framework | Medium |
| XEXT-006 | Snapshot Serializer | Plugin Framework | Low |
| XEXT-007 | Dashboard Widget | X020 | Low |

## XE003 - Extension Policy

- Qua Plugin X007.
- Co schema + test.
- Khong Business Data.
- Dang ky SPEC-005 Registry.
- Breaking -> ADR + RFC.

## XE004 - Lifecycle

Proposed -> Approved -> Registered -> Active -> Retired.
Gate: Approval (S012) + Registry (SPEC-005).

## XE005 - Validation

Co schema, khong pha invariants (X008), co test, co doc, Doctor X019 check.

## Tham chieu

- X007 Plugins - SPEC-010
- X008 Invariants - SPEC-010
- X019 Doctor - SPEC-010
