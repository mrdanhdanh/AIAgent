---
name: spec-013-x004-boundaries
description: SPEC-013 X004 - Evolution Boundaries. Scope Evolution, core ngoai.
agent: general
---

# X004 - Evolution Boundaries

> **SPEC-013**: Evolution Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Evolution bao gom gi va KHONG bao gom gi?**

## XB001 - Philosophy

- Evolution = tien hoa he thong (P013).
- KHONG pha vo he thong (P013).
- Gioi han ro: Trong Scope / ngoai Scope / cam.

## XB002 - Boundary Matrix (10)

| Nhom | Trong Scope | Ngoai Scope | Cam |
|------|-------------|-------------|-----|
| Content | diff + migration plan + report | - | - |
| Metadata | evolution_id, version_from/to | - | - |
| System | toan bo he sinh thai | - | - |
| Self-Heal | doc-only fixes | - | core fixes |
| Policy | migration scope | policy logic | - |
| Registry | definition refs | runtime entries | - |
| Core | - | Core | core modify |
| Secret | - | - | credentials, keys |
| PII | - | - | user personal data |
| Business Data | - | - | business data |

## XB003 - Scope Rules

1. Vao Evolution: diff + plan + report.
2. Ngoai Evolution: core (o Runtime).
3. Cam tuyet doi: sua core, secret, PII, business data.
4. Mot item vi pham -> Evolution finding + event.

## XB004 - Ownership Matrix

| Thuoc tinh | Owner | Quyen |
|------------|-------|-------|
| Report | Evolution Engine | immutable |
| Metadata | Evolution Engine | versioned |
| System | chu so huu tung he thong | bi evolution |
| Policy | Policy (S012) | quyet dinh |

## XB005 - Enforcement

- Compat check truoc migrate (XFR-002).
- Vi pham -> EVOLUTION_FAILED + audit.
- Doctor X019 check khong vi pham.

## Tham chieu

- P013 - Constitution
- S011 OB003A - SPEC-001
- X008 Data Model - SPEC-013
