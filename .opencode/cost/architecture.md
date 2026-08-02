---
name: cost-architecture
description: Kiến trúc Cost Manager — cost recorder, aggregator, report.
agent: general
---

# AI Cost Manager — Architecture

## 1. Components

```text
Cost Recorder (per call)
  └ tokens, model, rates
        │
        ▼
Aggregator (per agent/workflow/workspace)
        │
        ▼
Cost Report (day/month/trend)
        │
        ▼
Dashboard · Governance · Budget
```

## 2. Recorder

```text
call hoàn thành → CostRecorder.Record({
  agent, model, tokens_in, tokens_out
})
→ cost = tokens_in×in_rate + tokens_out×out_rate
```

## 3. Aggregation queries

- `CostByAgent(month)` → { builder: 46, planner: 12 }
- `CostByWorkflow(id)` → total
- `CostByWorkspace(ws)` → total
- `CostTrend(days)` → daily series

## 4. Budget enforcement

- Cost budget (Phase 16) — cảnh báo khi vượt.
- Hard stop nếu exceed.

## 5. Tương tác

- `cost.schema.yaml`.
- `model-router/` — rates.
- `dashboard/metrics/`.
- `governance/` — compliance.