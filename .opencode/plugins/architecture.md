---
name: plugin-architecture-detail
description: Kiến trúc chi tiết Plugin System — layers, load flow, integration với AIOS modules.
agent: general
---

# Plugin System — Architecture

## 1. Layers

```text
┌──────────────────────────────────────┐
│          AIOS Framework Core          │
│  Runtime · Registry · Context ·       │
│  Artifact · Event · Simulation ·      │
│  Doctor · Knowledge Graph · Evolution  │
├──────────────────────────────────────┤
│            Plugin SDK                 │
│  Runtime/Context/Artifact/Registry/   │
│  Knowledge/Event SDK                  │
├──────────────────────────────────────┤
│         Plugin Manager                │
│  Loader · Validator · Registry ·      │
│  Sandbox · Installer · Lifecycle      │
├──────────────────────────────────────┤
│         Installed Plugins             │
└──────────────────────────────────────┘
```

## 2. Plugin package structure

```text
oracle-plugin/
  plugin.yaml        # schema
  manifest.yaml      # exports count
  README.md
  agents/            # agent metadata + prompts
  skills/            # skills
  commands/          # commands
  capabilities/      # capabilities
  knowledge/         # knowledge sources
  workflows/         # workflow definitions
  scripts/           # PS1 tools
  tests/             # plugin tests
```

## 3. Load flow

```text
Install (copy package)
  → Validate (schema, dependency, compat, permission)
  → Certify (simulation + doctor + security)
  → Load metadata (loader, không load code ngay)
  → Register exports vào Registry (agent/skill/capability/command)
  → Enable (sandbox active)
  → Running
```

## 4. Integration with AIOS

| AIOS module | Plugin extension |
|-------------|------------------|
| Registry | đăng ký capability/agent/skill/command |
| Context | thêm context provider |
| Knowledge Graph | indexer đọc plugin knowledge |
| Doctor | thêm doctor rules |
| Event Bus | subscribe/publish events |
| Simulation | tham gia certification |
| Evolution | đăng ký policies |
| Dashboard | thêm widgets |

## 5. Core bất biến

- Plugin KHÔNG sửa file Core.
- Mọi thay đổi qua registry + SDK.
- Update plugin → reload exports (không restart Core).

## 6. Tương tác

- `manager.md` — orchestrate.
- `sdk.md` — plugin chỉ thấy SDK.
- `certification.md` — gate enable.
- Phase 12 (Dashboard) — hiển thị plugins.