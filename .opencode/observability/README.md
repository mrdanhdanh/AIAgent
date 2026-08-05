---
name: observability-platform
description: >
  Observability Platform v20.0 — logging, tracing, metrics, profiling, telemetry, distributed trace.
  Dashboard để xem; Observability để phân tích.
agent: general
---

# Observability Platform v20.0

## 1. Vai trò

Dashboard = xem. Observability = **phân tích**.

## 2. Pillars

```text
Logging · Tracing · Metrics · Profiling · Telemetry · Distributed Trace
```

## 3. Distributed trace

```text
Workflow → Planner → Builder → Reviewer → Tester
```

Biết mỗi bước mất bao lâu, token bao nhiêu, lỗi gì.

## 4. Tương tác

- `observability.schema.yaml`.
- `logging.md`, `tracing.md`, `metrics.md`, `profiling.md`.
- `events/` (Phase 6) — trace via event lineage.
- `dashboard/` (Phase 12) — display.
- `evaluation/` (Phase 21) — latency/cost data.