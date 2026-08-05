---
name: plugin-architecture
description: >
  Plugin Architecture v11.0 — AIOS thành Platform. Plugin = Micro Framework mở rộng mọi phần mà không sửa Core.
  Loader, Validator, Registry, Sandbox, Certification.
agent: general
---

# Plugin Architecture v11.0

## 1. Mục tiêu

Thêm Agent/Skill/Capability/Command/Workflow/Knowledge **không cần sửa Core**.

```text
Core → Plugin Loader → Plugin Registry → [Plugin A, Plugin B, ...]
```

## 2. Kiến trúc

```text
              Framework Core (AIOS)
                    │
            Plugin Manager
                    │
   ┌─────────┼─────────┐
   │         │         │
Loader  Validator  Registry
   │         │         │
   └─────────┼─────────┘
                    │
           Installed Plugins
                    │
  Agent Skill Capability Command Workflow Knowledge
```

## 3. Plugin = Micro Framework

Plugin không chỉ là "thư mục" — nó mở rộng gần như mọi phần AIOS:

```text
Plugin
├── Metadata (plugin.yaml + manifest)
├── Runtime Extension
├── Context Provider
├── Capabilities
├── Knowledge
├── Doctor Rules
├── Event Subscribers
├── Dashboard Widgets
└── Evolution Policies
```

## 4. Plugin types

| Type | Export |
|------|--------|
| Agent Plugin | agents/ |
| Skill Plugin | skills/ |
| Workflow Plugin | workflows/ |
| Knowledge Plugin | knowledge/ |
| Capability Plugin | capabilities/ |
| Command Plugin | commands/ |
| UI Plugin | widgets/ |
| Doctor Plugin | doctor_rules/ |

## 5. Nguyên tắc

- Plugin chỉ dùng **SDK**, không gọi Runtime trực tiếp.
- Khai báo **permissions** rõ — Framework cấp quyền (sandbox).
- **Dependency** thiếu → không enable.
- **Certification** bắt buộc trước khi enable (đề xuất).

## 6. File hệ thống

| File | Vai trò |
|------|---------|
| `plugin.schema.yaml` | Plugin schema |
| `architecture.md` | Kiến trúc |
| `manager.md` | Plugin Manager |
| `loader.md` | Loader |
| `installer.md` | Install/update |
| `registry.md` | Plugin Registry |
| `lifecycle.md` | Plugin lifecycle |
| `sandbox.md` | Sandbox isolation |
| `permissions.md` | Permission model |
| `security.md` | Security |
| `compatibility.md` | Compat check |
| `validator.md` | Validation |
| `marketplace.md` | Marketplace |
| `sdk.md` | Plugin SDK |
| `manifest.md` | Plugin Manifest |
| `certification.md` | Certification |
| `metrics.md` | Metrics |
| `tests.md` | Tests |

## 7. Sau Phase 11

Core hoàn chỉnh. Phase 12 = System Dashboard & Control Center (Control Tower của AIOS).