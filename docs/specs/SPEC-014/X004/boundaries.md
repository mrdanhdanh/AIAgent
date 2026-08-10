---
name: spec-014-x004-boundaries
description: SPEC-014 X004 - Dashboard Boundaries. Scope Dashboard, system ngoai.
agent: general
---

# X004 - Dashboard Boundaries

> **SPEC-014**: Dashboard - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Dashboard bao gom gi va KHONG bao gom gi?**

## XB001 - Philosophy

- Dashboard = hien thi quan sat (P005).
- KHONG thay doi he thong (XC-001).
- Gioi han ro: Trong Scope / ngoai Scope / cam.

## XB002 - Boundary Matrix (10)

| Nhom | Trong Scope | Ngoai Scope | Cam |
|------|-------------|-------------|-----|
| Content | widget + panel + view | - | - |
| Metadata | view_id, timestamp, filters | - | - |
| Data | S011 metrics (read-only) | - | - |
| View | Dashboard View | - | - |
| Policy | render scope | policy logic | - |
| Registry | definition refs | runtime entries | - |
| System | - | system | system change |
| Secret | - | - | credentials, keys |
| PII | - | - | user personal data |
| Business Data | - | - | business data |

## XB003 - Scope Rules

1. Vao Dashboard: widget + panel + view.
2. Ngoai Dashboard: system (o Runtime).
3. Cam tuyet doi: thay doi system, secret, PII, business data.
4. Mot item vi pham -> Dashboard finding + event.

## XB004 - Ownership Matrix

| Thuoc tinh | Owner | Quyen |
|------------|-------|-------|
| View | Dashboard | immutable |
| Metadata | Dashboard | versioned |
| Data | S011 Metrics | read-only |
| Policy | Policy (S012) | quyet dinh |

## XB005 - Enforcement

- Validate truoc render (XFR-001).
- Vi pham -> DASHBOARD_FAILED + audit.
- Doctor X019 check khong vi pham.

## Tham chieu

- P005 - Constitution
- S011 OB003A - SPEC-001
- X008 Data Model - SPEC-014
