---
name: plugin-permissions
description: Plugin Permissions — model quyền; plugin khai báo rõ, framework cấp.
agent: general
---

# Plugin Permissions

## 1. Vai trò

Plugin khai báo rõ quyền truy cập; Framework cấp theo yêu cầu.

## 2. Permission catalog

| Permission | Mô tả |
|------------|-------|
| context.read | đọc context |
| context.write | ghi context |
| artifact.read | đọc artifact |
| artifact.write | ghi/tạo artifact |
| knowledge.read | đọc knowledge |
| knowledge.write | thêm knowledge |
| event.publish | phát event |
| event.subscribe | đăng ký event |
| registry.read | đọc registry |
| registry.write | ghi registry (export) |
| runtime.read | đọc runtime state |
| doctor.read | đọc doctor report |
| workflow.execute | chạy workflow |
| simulation.run | chạy simulation |

## 3. Least privilege

- Plugin chỉ xin quyền cần thiết.
- Manager có thể từ chối yêu cầu quyền quá mức.

## 4. Default

- Plugin core plugins: rộng hơn.
- Plugin community: read-only mặc định, write cần duyệt.

## 5. Audit

- Mọi permission access log (security events).
- Doctor đọc audit → phát hiện lạm dụng.

## 6. Tương tác

- `sandbox.md` — enforce.
- `security.md` — audit.
- `plugin.schema.yaml` — permissions field.