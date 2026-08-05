---
name: sdk-plugin
description: Plugin SDK — plugin lifecycle, exports, permission model.
agent: general
---

# Plugin SDK

## 1. Vai trò

Giao diện lập trình Plugin — lifecycle + exports.

## 2. API

| Method | Mô tả |
|--------|-------|
| `Plugin.Install(pkg)` | cài plugin |
| `Plugin.Uninstall(id)` | gỡ |
| `Plugin.Enable(id)` | enable |
| `Plugin.Disable(id)` | disable |
| `Plugin.Update(id, ver)` | update |
| `Plugin.List()` | list plugins |
| `Plugin.RegisterExport(type, def)` | đăng ký export |

## 3. Export types

- agent, skill, command, capability, workflow, knowledge, doctor_rules, events, widgets, policies.

## 4. Permission

- Plugin SDK tự kiểm tra `permissions` trong plugin.yaml.
- Vi phạm → `PermissionDenied`.

## 5. Tương tác

- `plugins/` (Phase 11).
- `plugins/sdk.md` — chi tiết.
- Plugin dev entry point.