---
name: ai-cost-manager
description: >
  AI Cost Manager v28.0 — track token/cost theo agent, workflow, workspace.
  Cuối tháng Dashboard biết: Planner $12, Builder $46, Reviewer $8.
agent: general
---

# AI Cost Manager v28.0

## 1. Vai trò

AI tốn tiền — framework theo dõi chi phí chính xác.

## 2. Cost tracking

```text
Planner → 500 tokens → $0.002
Builder → 3000 tokens → $0.02
```

## 3. Aggregation

| Dimension | Ví dụ |
|-----------|-------|
| per agent | Builder $46/tháng |
| per workflow | feature-workflow $1.2 |
| per workspace | ws-a $89 |
| per project | project-x $240 |
| per day/month | trend |

## 4. Cost model

```text
cost = tokens_in × input_rate + tokens_out × output_rate
```

Model rates từ `model-router/` (Phase 17).

## 5. Tương tác

- `cost.schema.yaml`.
- `model-router/models.yaml` — rates.
- `resources/` (Phase 16) — budget.
- `dashboard/` — cost charts.
- `governance/` — cost compliance.