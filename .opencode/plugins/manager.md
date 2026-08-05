---
name: plugin-manager
description: Plugin Manager — điều phối install, validate, load, register, activate.
agent: general
---

# Plugin Manager

## 1. Vai trò

Orchestrator của Plugin System — quản lý vòng đời plugin.

## 2. API

| Method | Mô tả |
|--------|-------|
| `Install(package)` | cài plugin |
| `Uninstall(id)` | gỡ plugin |
| `Update(id, version)` | nâng cấp |
| `Enable(id)` | kích hoạt |
| `Disable(id)` | tắt |
| `List()` | danh sách plugin |
| `Get(id)` | thông tin plugin |

## 3. Install flow

```text
Install
  → Validate (validator)
  → Certify (certification)
  → Load metadata (loader)
  → Register exports (registry)
  → Enable
```

## 4. Enable gate

- Plugin phải PASS validation + certification trước enable.
- Thiếu dependency → không enable.
- Compat fail → không enable.

## 5. State tracking

Manager lưu trạng thái mỗi plugin (lifecycle.md):
`installed → validated → loaded → enabled → running`

## 6. Tương tác

- `loader.md` — load metadata.
- `validator.md` — validate.
- `registry.md` — register exports.
- `lifecycle.md` — state.