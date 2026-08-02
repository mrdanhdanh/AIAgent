---
name: plugin-loader
description: Plugin Loader — đọc plugin.yaml + manifest, load metadata; không load code ngay.
agent: general
---

# Plugin Loader

## 1. Vai trò

Đọc metadata plugin (plugin.yaml + manifest.yaml). **Không load code ngay** — lazy.

## 2. Load steps

```text
Đọc plugin.yaml (schema)
  → Đọc manifest.yaml (exports count)
  → Xác minh exports tồn tại (agents/, skills/, ...)
  → Build Plugin Metadata object
  → Trả cho Manager đăng ký
```

## 3. Metadata object

```yaml
plugin:
  id: oracle
  name: Oracle Support
  version: 1.0.0
  framework: ">=4.0"
  dependencies: [runtime>=1, capability>=1]
  exports: { agents: 3, skills: 2, capabilities: 5 }
  permissions: [knowledge.read, artifact.read]
```

## 4. Lazy loading

- Metadata load khi install.
- Code/skills chỉ load khi plugin **enable + được gọi**.
- Lazy → giảm boot time + memory.

## 5. Error

- plugin.yaml sai schema → loader fail → plugin không install.
- exports thiếu → warning (khớp manifest count).

## 6. Tương tác

- `manager.md` — gọi loader.
- `plugin.schema.yaml` — format.
- `manifest.md` — exports count.