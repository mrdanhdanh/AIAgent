---
name: plugin-lifecycle
description: Plugin Lifecycle — Installed → Validated → Loaded → Enabled → Running → Disabled → Uninstalled.
agent: general
---

# Plugin Lifecycle

## 1. States

```text
Installed → Validated → Loaded → Enabled → Running
                                        │
                                        ↓
                                    Disabled → Uninstalled
```

| State | Ý nghĩa |
|-------|---------|
| Installed | package có, chưa validate |
| Validated | pass schema/dependency/compat/permission |
| Loaded | metadata đã load |
| Enabled | sandbox active, exports registered |
| Running | plugin hoạt động |
| Disabled | tắt, exports removed |
| Uninstalled | gỡ hoàn toàn |

## 2. Transitions

| From | To | Điều kiện |
|------|-----|-----------|
| Installed | Validated | validator PASS |
| Validated | Loaded | loader đọc xong |
| Loaded | Enabled | certify PASS + sandbox |
| Enabled | Running | activated |
| Running | Disabled | disable call |
| Disabled | Uninstalled | uninstall |
| Disabled | Enabled | re-enable |

## 3. Failed states

- Validated fail → giữ Installed (có thể sửa rồi re-validate).
- Enabled fail → rollback về Disabled.
- Running error → error log, không crash Core.

## 4. Events

Plugin lifecycle phát event (Event Bus):
- `PLUGIN_INSTALLED`, `PLUGIN_ENABLED`, `PLUGIN_DISABLED`, `PLUGIN_REMOVED`.

## 5. Tương tác

- `manager.md` — trigger transitions.
- `validator.md` — validated gate.
- `certification.md` — loaded→enabled gate.