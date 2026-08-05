---
name: observability-metrics
description: Metrics + Profiling — đo hiệu năng, budget, hot path.
agent: general
---

# Metrics & Profiling

## 1. Metrics

| Metric | Nguồn |
|--------|-------|
| step.duration | tracing |
| token.per_step | context/resources |
| cost.per_workflow | resources/model-router |
| error.rate | events |
| cache.hit | context |
| queue.wait | kernel |

## 2. Profiling

- Hot path: bước nào chậm nhất → ưu tiên tối ưu.
- Memory: peak memory per workflow.
- Model: latency per model (cho Model Router).

## 3. Telemetry export

- Aggregates → Dashboard.
- Raw → Evaluation (Phase 21).
- Distributed trace → cross-machine.

## 4. Tương tác

- `observability.schema.yaml`.
- `dashboard/metrics/`.
- `evaluation/` (Phase 21).