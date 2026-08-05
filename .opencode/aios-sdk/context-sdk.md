---
name: sdk-context
description: Context SDK — resolve context, get profile, budget.
agent: general
---

# Context SDK

## 1. Vai trò

Giao diện Context Engine.

## 2. API

| Method | Mô tả |
|--------|-------|
| `Context.Resolve(agent, wfState)` | build context package |
| `Context.GetProfile(agent)` | context profile |
| `Context.GetBudget(agent)` | budget |
| `Context.GetMetrics()` | context metrics |

## 3. DTO

```yaml
ContextPackage:
  agent_id, budget, project, task, artifacts, knowledge, runtime
```

## 4. Permission

- Resolve/GetProfile/GetBudget: `context.read`.
- GetMetrics: `doctor.read`.

## 5. Tương tác

- `context/` (Phase 4).
- Agent nhận package qua context-sdk.