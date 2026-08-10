---
name: spec-010-x004-boundaries
description: SPEC-010 X004 - Plugin Boundaries. Scope Plugin, Core ngoai.
agent: general
---

# X004 - Plugin Boundaries

> **SPEC-010**: Plugin Framework - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Plugin bao gom gi va KHONG bao gom gi?**

## XB001 - Philosophy

- Plugin = extension (TERM-015).
- KHONG sua Core (TERM-015).
- Gioi han ro: Trong Scope / ngoai Scope / cam.

## XB002 - Boundary Matrix (10)

| Nhom | Trong Scope | Ngoai Scope | Cam |
|------|-------------|-------------|-----|
| Content | manifest + exports | - | - |
| Metadata | plugin_id, version, permission | - | - |
| Plugin | thanh phan mo rong | - | - |
| Exported | Capability/Agent/Skill/Widget | - | - |
| Policy | permission, quota | policy logic | - |
| Registry | definition refs | runtime entries | - |
| Core | - | Core | Core |
| Secret | - | - | credentials, keys |
| PII | - | - | user personal data |
| Business Data | - | - | business data |

## XB003 - Scope Rules

1. Vao Plugin: manifest + exports.
2. Ngoai Plugin: Core (o Runtime).
3. Cam tuyet doi: sua Core, secret, PII, business data.
4. Mot item vi pham -> Plugin reject + event.

## XB004 - Ownership Matrix

| Thuoc tinh | Owner | Quyen |
|------------|-------|-------|
| Manifest | Plugin Registry | immutable |
| Metadata | Plugin Registry | versioned |
| Exports | Plugin | export |
| Policy | Policy (S012) | quyet dinh |

## XB005 - Enforcement

- Validate truoc install (XFR-002).
- Vi pham -> PLUGIN_REJECTED + audit.
- Doctor X019 check khong vi pham.

## Tham chieu

- TERM-015 - Glossary
- S011 OB003A - SPEC-001
- X008 Data Model - SPEC-010
