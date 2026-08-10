---
name: spec-007-x004-boundaries
description: SPEC-007 X004 - Artifact Boundaries. Scope Artifact, Business Data cam.
agent: general
---

# X004 - Artifact Boundaries

> **SPEC-007**: Artifact Manager - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Artifact bao gom gi va KHONG bao gom gi?**

## XB001 - Philosophy

- Artifact = output immutable (P010).
- KHONG chua Business Data (P001, S011 OB003A).
- Gioi han ro: Trong Scope / ngoai Scope / cam.

## XB002 - Boundary Matrix (10)

| Nhom | Trong Scope | Ngoai Scope | Cam |
|------|-------------|-------------|-----|
| Content | noi dung immutable | - | - |
| Metadata | artifact_id, version, checksum | - | - |
| Producer | Agent/Task | - | - |
| Consumer | Agent/Doctor/Dashboard | - | - |
| Policy | retention, quota | policy logic | - |
| Registry | definition refs | runtime entries | - |
| Event | artifact events | event history | - |
| Secret | - | - | credentials, keys |
| PII | - | - | user personal data |
| Business Data | - | - | business data |

## XB003 - Scope Rules

1. Vao Artifact: output cua Task/Agent + metadata.
2. Ngoai Artifact: business data (luu noi khac).
3. Cam tuyet doi: secret, PII, business data.
4. Mot item vi pham -> Artifact reject + event.

## XB004 - Ownership Matrix

| Thuoc tinh | Owner | Quyen |
|------------|-------|-------|
| Content | Artifact Store | write-once |
| Metadata | Artifact Store | versioned |
| Producer | Agent/Task | tao output |
| Policy | Policy (S012) | quyet dinh |

## XB005 - Enforcement

- Validate truoc publish (XFR-002).
- Vi pham -> ARTIFACT_REJECTED + audit.
- Doctor X019 check khong vi pham.

## Tham chieu

- P010 - Constitution
- S011 OB003A - SPEC-001
- X008 Data Model - SPEC-007
