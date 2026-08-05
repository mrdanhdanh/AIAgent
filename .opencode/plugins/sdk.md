---
name: plugin-sdk
description: Plugin SDK — plugin chỉ nhìn thấy SDK, không đọc Framework trực tiếp.
agent: general
---

# Plugin SDK

## 1. Vai trò

Plugin không đọc Framework. Chỉ dùng SDK — giao diện tối giản, permission-aware.

## 2. SDK components

```text
Plugin SDK
├── Runtime SDK
├── Context SDK
├── Artifact SDK
├── Registry SDK
├── Knowledge SDK
└── Event SDK
```

## 3. API per SDK

| SDK | Methods |
|-----|---------|
| Runtime SDK | `getState()`, `runWorkflow(id)` |
| Context SDK | `getProfile(agent)`, `resolve(agent, wf)` |
| Artifact SDK | `get(id)`, `save(artifact)`, `version(id)` |
| Registry SDK | `findCapability(id)`, `registerExport()` |
| Knowledge SDK | `query(term)`, `addLesson(lesson)` |
| Event SDK | `publish(type, payload)`, `subscribe(type, handler)` |

## 4. Permission enforcement

- SDK kiểm tra plugin permission trước mỗi call.
- Không permission → `PermissionDenied`.

## 5. Contract

- SDK version gắn với framework version.
- Plugin manifest khai `sdk: ">=11.0"`.

## 6. Tương tác

- `sandbox.md` — enforce.
- `permissions.md` — catalog.
- Plugin dev chỉ cần đọc SDK docs.