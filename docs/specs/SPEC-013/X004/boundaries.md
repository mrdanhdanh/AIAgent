---
name: SPEC-013-x004-boundaries
description: SPEC-013 X004 - Evolution Boundaries. Scope Evolution, production ngoai.
agent: general
---

# X004 - Evolution Boundaries

> **SPEC-013**: Evolution Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Evolution bao gom gi va KHONG bao gom gi?**

## XB001 - Philosophy

- Evolution = mo phong workflow (RULE-007).
- KHONG doi he thong that (RULE-007).
- Gioi han ro: Trong Scope / ngoai Scope / cam.

## XB002 - Boundary Matrix (10)

| Nhom | Trong Scope | Ngoai Scope | Cam |
|------|-------------|-------------|-----|
| Content | Diff + report | - | - |
| Metadata | Evolution_id, Diff, timestamp | - | - |
| Workflow | workflow bi mo phong | - | - |
| Result | ket qua Evolution | - | - |
| Policy | run scope | policy logic | - |
| Registry | definition refs | runtime entries | - |
| Production | - | production | production change |
| Secret | - | - | credentials, keys |
| PII | - | - | user personal data |
| Business Data | - | - | business data |

## XB003 - Scope Rules

1. Vao Evolution: Diff + Plan + result + report.
2. Ngoai Evolution: production (o Runtime).
3. Cam tuyet doi: doi production, secret, PII, business data.
4. Mot item vi pham -> Evolution reject + event.

## XB004 - Ownership Matrix

| Thuoc tinh | Owner | Quyen |
|------------|-------|-------|
| Report | Evolution Engine | immutable |
| Metadata | Evolution Engine | versioned |
| Workflow | Workflow (SPEC-002) | bi mo phong |
| Policy | Policy (S012) | quyet dinh |

## XB005 - Enforcement

- Validate truoc run (XFR-002).
- Vi pham -> Evolution_REJECTED + audit.
- Doctor X019 check khong vi pham.

## Tham chieu

- RULE-007 - Rules
- S011 OB003A - SPEC-001
- X008 Data Model - SPEC-013
