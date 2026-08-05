---
name: experiment-architecture
description: Kiến trúc Experiment Platform — variant split, measurement, winner selection.
agent: general
---

# Experiment Platform — Architecture

## 1. Components

```text
Experiment Store (experiments.yaml)
        │
        ▼
Traffic Split (variant assignment)
        │
        ▼
Measurement Collector (quality/cost/time)
        │
        ▼
Winner Selector
        │
        ▼
Promote → Release
```

## 2. Traffic split

- 50/50 hoặc weighted.
- Consistent hash theo workflow id → variant ổn định.

## 3. Measurement

- Mỗi variant chạy N sample.
- Thu quality (evaluation), cost (cost), time (observability), success (events).

## 4. Winner selector

```text
score = w_q×quality + w_c×(1-cost_norm) + w_t×(1-latency_norm) + w_s×success
```

- Chọn variant score cao nhất.
- Statistical significance check trước promote.

## 5. Tương tác

- `experiment.schema.yaml`.
- `evaluation/` — quality.
- `cost/` — cost.
- `release/` — promote.
- `dashboard/` — experiment UI.