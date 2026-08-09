---
name: spec-009-x018-evolution
description: SPEC-009 X018 - Contract Evolution. Versioning, deprecation, migration.
agent: general
---

# X018 - Contract Evolution

> **SPEC-009**: Contract System - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **SPEC-009 phat trien qua cac version nhu the nao?**

## XV001 - Philosophy

- SemVer (SPEC-000).
- Backward compatible (XNF-005).
- Deprecated co chu ky notice.
- Breaking can ADR + RFC.

## XV002 - Versioning

| ID | Version | Change | Date |
|----|---------|--------|------|
| XV-001 | 1.0.0 | Initial Draft | 8/2026 |

## XV003 - Deprecation

- Qua R009 lifecycle (SPEC-005).
- Notice truoc 1 version.
- Migration guide bat buoc.

## XV004 - Compatibility

Backward: giu Contract contract cu.
Forward: tuan thu schema strict.
Check: validator + Doctor X019.

## XV005 - Migration

Upgrade/Downgrade giu compat.
Breaking: ADR + RFC + migration doc.
Runtime Contract: KHONG migrate - version moi (P004).

## Tham chieu

- SPEC-000 SemVer
- R009 Lifecycle - SPEC-005
- X019 Doctor - SPEC-009
