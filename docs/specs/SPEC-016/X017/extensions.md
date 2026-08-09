---
name: SPEC-016-x017-extensions
description: SPEC-016 X017 - CLI Extensions. 7 extension points, policy, lifecycle.
agent: general
---

# X017 - CLI Extensions

> **SPEC-016**: CLI - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **CLI mo rong nhu the nao ma khong pha vo core?**

## XE001 - Philosophy

- Mo rong qua Contract (X007), khong sua core.
- Extension la tuy chon, khong bat buoc.
- Moi extension co schema + test + doc.
- Khong mo rong sang Business Data (P001).

## XE002 - Extension Points (7)

| ID | Extension | Owner | Priority |
|----|-----------|-------|----------|
| XEXT-001 | Extension Point | CLI | High |
| XEXT-002 | Custom Scanner | CLI | High |
| XEXT-003 | Custom Scoring Rule | CLI | Medium |
| XEXT-004 | Repair Hook | Policy (S012) | High |
| XEXT-005 | Report Strategy | CLI | Medium |
| XEXT-006 | Snapshot Serializer | CLI | Low |
| XEXT-007 | CLI Widget | X020 | Low |

## XE003 - Extension Policy

- Qua Contract X007.
- Co schema + test.
- Khong Business Data.
- Dang ky SPEC-005 Registry.
- Breaking -> ADR + RFC.

## XE004 - Lifecycle

Proposed -> Approved -> Registered -> Active -> Retired.
Gate: Approval (S012) + Registry (SPEC-005).

## XE005 - Validation

Co schema, khong pha invariants (X008), co test, co doc, CLI X019 check.

## Tham chieu

- X007 Contracts - SPEC-016
- X008 Invariants - SPEC-016
- X019 CLI - SPEC-016
