---
name: plugin-sandbox
description: Plugin Sandbox — cô lập plugin; chỉ truy cập qua permissions.
agent: general
---

# Plugin Sandbox

## 1. Vai trò

Plugin không truy cập toàn bộ Framework — chỉ theo permissions khai báo.

## 2. Permission enforcement

```yaml
permissions:
  - context.read
  - artifact.read
  - knowledge.query
```

Không có `runtime.modify` → plugin không thể sửa runtime.

## 3. Sandbox boundary

| Cho phép | Không cho phép |
|----------|----------------|
| SDK APIs đã cấp quyền | Runtime modify |
| Context/Artifact read | Core file sửa |
| Event subscribe | Registry write (trừ export) |
| Knowledge query | Sandbox escape |

## 4. Enforcement points

- SDK kiểm tra permission trước mỗi call.
- Vi phạm → PermissionDenied error, log security event.
- Plugin cố tình vi phạm → auto-disable + cảnh báo Doctor.

## 5. Isolation

- Plugin code chạy trong sandbox (không access file hệ thống ngoài quyền).
- Script plugin chạy restricted execution policy.

## 6. Tương tác

- `permissions.md` — model.
- `security.md` — audit.
- `sdk.md` — permission-aware SDK.