---
name: sdk-registry
description: Registry SDK — capability/agent/skill/command lookup + register.
agent: general
---

# Registry SDK

## 1. Vai trò

Giao diện Registry.

## 2. API

| Method | Mô tả |
|--------|-------|
| `Registry.FindCapability(id)` | tìm capability |
| `Registry.FindAgents(cap)` | agent hỗ trợ capability |
| `Registry.FindSkills(cap)` | skill |
| `Registry.FindCommands(cap)` | command |
| `Registry.Resolve(cap, context)` | resolver pipeline |
| `Registry.Register(def)` | đăng ký (plugin export) |

## 3. DTO

```yaml
CapabilityInfo: { id, name, version, category, stability }
AgentMatch: { agent, score, compatible }
```

## 4. Permission

- Find*/Resolve: `registry.read`.
- Register: `registry.write`.

## 5. Tương tác

- `registry/` (Phase 2).
- Resolver/scorer/compat tái sử dụng.