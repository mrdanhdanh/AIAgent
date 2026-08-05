---
name: resource-manager
description: >
  Resource Manager v16.0 — quản lý token/memory/time/cost/model budget cho mọi agent.
  Scheduler quyết định dựa trên budget.
agent: general
---

# Resource Manager v16.0

## 1. Vai trò

AI tốn tài nguyên — framework quản lý budget tập trung.

## 2. Budget types

| Budget | Ví dụ |
|--------|-------|
| token | max 4000 |
| memory | max 512MB |
| time | timeout 30s |
| cost | max $0.05 |
| model | quota per model |

## 3. Per-agent config

```yaml
planner:
  max_tokens: 4000
  timeout: 30s
  budget: 0.05
```

## 4. Scheduler integration

- Reserve budget trước dispatch.
- Vượt → defer/reduce context.
- Scheduler quyết định.

## 5. Tương tác

- `kernel/resource-manager.md` — enforce.
- `context/` (Phase 4) — context budget.
- `model-router/` (Phase 17) — model cost.