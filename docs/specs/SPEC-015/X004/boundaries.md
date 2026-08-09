---
name: SPEC-015-x004-boundaries
description: SPEC-015 X004 - SDK Boundaries. Scope SDK, system ngoai.
agent: general
---

# X004 - SDK Boundaries

> **SPEC-015**: SDK - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **SDK bao gom gi va KHONG bao gom gi?**

## XB001 - Philosophy

- SDK = hien thi quan sat (P005).
- KHONG thay doi he thong (XC-001).
- Gioi han ro: Trong Scope / ngoai Scope / cam.

## XB002 - Boundary Matrix (10)

| Nhom | Trong Scope | Ngoai Scope | Cam |
|------|-------------|-------------|-----|
| Content | widget + panel + view | - | - |
| Metadata | view_id, timestamp, filters | - | - |
| Data | S011 metrics (read-only) | - | - |
| View | SDK View | - | - |
| Policy | render scope | policy logic | - |
| Registry | definition refs | runtime entries | - |
| System | - | system | system change |
| Secret | - | - | credentials, keys |
| PII | - | - | user personal data |
| Business Data | - | - | business data |

## XB003 - Scope Rules

1. Vao SDK: widget + panel + view.
2. Ngoai SDK: system (o Runtime).
3. Cam tuyet doi: thay doi system, secret, PII, business data.
4. Mot item vi pham -> SDK finding + event.

## XB004 - Ownership Matrix

| Thuoc tinh | Owner | Quyen |
|------------|-------|-------|
| View | SDK | immutable |
| Metadata | SDK | versioned |
| Data | S011 Metrics | read-only |
| Policy | Policy (S012) | quyet dinh |

## XB005 - Enforcement

- Validate truoc render (XFR-001).
- Vi pham -> SDK_FAILED + audit.
- Doctor X019 check khong vi pham.

## Tham chieu

- P005 - Constitution
- S011 OB003A - SPEC-001
- X008 Data Model - SPEC-015
