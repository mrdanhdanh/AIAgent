---
name: spec-011-x004-boundaries
description: SPEC-011 X004 - Doctor Boundaries. Scope Doctor, core ngoai.
agent: general
---

# X004 - Doctor Boundaries

> **SPEC-011**: Doctor - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Doctor bao gom gi va KHONG bao gom gi?**

## XB001 - Philosophy

- Doctor = kiem tra suc khoe (P015).
- KHONG sua core (P015).
- Gioi han ro: Trong Scope / ngoai Scope / cam.

## XB002 - Boundary Matrix (10)

| Nhom | Trong Scope | Ngoai Scope | Cam |
|------|-------------|-------------|-----|
| Content | report + score | - | - |
| Metadata | scan_id, timestamp, scope | - | - |
| System | toan bo he sinh thai | - | - |
| Repair | doc-only fixes | - | core fixes |
| Policy | repair scope | policy logic | - |
| Registry | definition refs | runtime entries | - |
| Core | - | Core | core modify |
| Secret | - | - | credentials, keys |
| PII | - | - | user personal data |
| Business Data | - | - | business data |

## XB003 - Scope Rules

1. Vao Doctor: scan + findings + score + report.
2. Ngoai Doctor: core (o Runtime).
3. Cam tuyet doi: sua core, secret, PII, business data.
4. Mot item vi pham -> Finding + event.

## XB004 - Ownership Matrix

| Thuoc tinh | Owner | Quyen |
|------------|-------|-------|
| Report | Doctor | immutable |
| Metadata | Doctor | versioned |
| System | chu so huu tung he thong | bi scan |
| Policy | Policy (S012) | quyet dinh |

## XB005 - Enforcement

- Scan truoc khi repair (XFR-001).
- Vi pham -> DOCTOR_FINDING + audit.
- Doctor X019 check khong vi pham.

## Tham chieu

- P015 - Constitution
- S011 OB003A - SPEC-001
- X008 Data Model - SPEC-011
