---
name: sdk-security
description: SDK Security — permission model, audit, key-based control.
agent: general
---

# SDK Security

## 1. Vai trò

Mọi SDK access qua permission check + audit.

## 2. Permission model

- Kế thừa `plugins/permissions.md`.
- Mỗi SDK component map permission (xem từng sdk-*.md).
- Default deny — chỉ access khi có quyền.

## 3. Audit

Mọi SDK call log:
```text
{ time, caller, sdk, method, permission, result }
```
→ Event `SECURITY_SDK_ACCESS`.

## 4. Control access

- Control SDK (workflow control, evolution apply, plugin install) yêu cầu **API key**.
- Key scope per role.

## 5. Error contract

| Error | Mô tả |
|-------|-------|
| `SDK-ERR-401` | PermissionDenied |
| `SDK-ERR-403` | VersionIncompatible |
| `SDK-ERR-404` | NotFound |
| `SDK-ERR-500` | Internal |

## 6. Tương tác

- `plugins/security.md`.
- `dashboard/security.md`.
- Mọi SDK thực thi.