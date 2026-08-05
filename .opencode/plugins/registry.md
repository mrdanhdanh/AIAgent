---
name: plugin-registry
description: Plugin Registry — plugin exports đăng ký vào Registry chính; resolver tự tìm.
agent: general
---

# Plugin Registry

## 1. Vai trò

Khi plugin enabled, các exports (capability/agent/skill/command) đăng ký vào Registry chính.

## 2. Registration

```text
Plugin exports
  capability: oracle.optimize
  agent: oracle-agent
  skill: oracle-skill
  command: oracle-optimize
    ↓
Registry (capabilities.yaml + agent-registry + skill-registry + command-registry)
```

Resolver (Phase 2) sẽ tự tìm — plugin không cần Core biết.

## 3. Namespace

- Plugin capability id dùng namespace: `oracle.optimize`, `blazor.audit`.
- Tránh conflict với core (`implementation.code`).

## 4. Registry sync

- Plugin load → thêm entries.
- Plugin unload → gỡ entries.
- Registry validator (capability-validator) kiểm tra consistency.

## 5. Ví dụ

```yaml
# plugin đăng ký:
capabilities:
  - id: oracle.optimize
    category: analysis
    agent: oracle-agent
```

## 6. Tương tác

- `registry/` (Phase 2) — nguồn đăng ký.
- `manager.md` — trigger register/unregister.
- `resolver.md` — tự tìm plugin capability.