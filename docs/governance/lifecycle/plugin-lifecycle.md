---
name: lifecycle-plugin
description: >
  Plugin Lifecycle — Installed → Validated → Enabled → Disabled → Removed.
agent: general
---

# Plugin Lifecycle

> D005 — Vòng đời Plugin (POLICY-008).

## States

```text
Installed
   │
Validated
   │
Enabled
   │
Disabled
   │
Removed
```

## Transitions

| From | To | Điều kiện |
|------|-----|-----------|
| Installed | Validated | Manifest + permission hợp lệ |
| Validated | Enabled | Approval (POLICY-001) |
| Enabled | Disabled | Lỗi / người dùng tắt |
| Disabled | Removed | Uninstall |

## Quy tắc

- Plugin không được sửa Core (P012, P019).
- Plugin chạy trong sandbox theo permission (RULE-008).
- Mọi transition phát Event.

## Tham chiếu

- POLICY-008 Plugin
- RULE-008 Security (Permission Model)
- P012 Plugin First
