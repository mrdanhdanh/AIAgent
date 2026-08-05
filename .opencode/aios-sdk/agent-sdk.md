---
name: sdk-agent
description: Agent SDK — tạo/chạy agent, get metadata, capability lookup.
agent: general
---

# Agent SDK

## 1. Vai trò

Giao diện lập trình với Agent component.

## 2. API

| Method | Mô tả |
|--------|-------|
| `Agent.Get(id)` | get agent metadata |
| `Agent.List()` | list agents |
| `Agent.Run(id, task)` | chạy agent (qua runtime) |
| `Agent.GetCapabilities(id)` | capability của agent |
| `Agent.GetStatus(id)` | trạng thái agent |
| `Agent.Create(definition)` | tạo agent definition (plugin) |

## 3. DTO

```yaml
AgentInfo:
  id, name, version, status, priority
  capabilities: []
  resources: { max_tokens, timeout }
```

## 4. Permission

- Get/List/GetCapabilities: `registry.read`.
- Run: `workflow.execute`.
- Create: `registry.write`.

## 5. Tương tác

- `agents/metadata/` (Phase 3).
- `registry/` (Phase 2).
- Plugin agent-sdk.