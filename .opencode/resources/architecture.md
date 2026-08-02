---
name: resource-architecture
description: Kiến trúc Resource Manager — budgets, reservation, enforcement, metrics.
agent: general
---

# Resource Manager — Architecture

## 1. Components

```text
Budget Store (budgets.yaml)
        │
        ▼
Resource Allocator (reserve/check)
        │
        ▼
Scheduler → Execution
        │
        ▼
Resource Metrics
```

## 2. Allocation flow

```text
Task request
  → Allocator.Reserve(task, budget)
  → enough? → dispatch
  → not enough → reduce context / defer / reject
  → after → Release + record usage
```

## 3. Enforcement

- Reserve trước chạy.
- Track usage realtime.
- Force-stop nếu vượt hard limit.

## 4. Aggregation

- Per-workflow budget.
- Per-workspace budget.
- Global budget.

## 5. Tương tác

- `resources.schema.yaml`.
- `kernel/resource-manager.md`.
- `model-router/` (Phase 17).