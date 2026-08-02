---
name: experiment-platform
description: >
  Experiment Platform v29.0 — A/B test prompt/agent/model; đo quality, cost, time, success.
  Framework tự chọn winner.
agent: general
---

# Experiment Platform v29.0

## 1. Vai trò

Nơi thử nghiệm có kiểm soát:

```text
Prompt v1 vs Prompt v2
Builder A vs Builder B
Model X vs Model Y
```

## 2. Measure

| Metric | Mô tả |
|--------|-------|
| quality | output score (evaluation P21) |
| cost | chi phí (cost P28) |
| time | latency |
| success_rate | tỉ lệ thành công |

## 3. Experiment

```yaml
experiment:
  id: EXP-001
  type: prompt-ab
  variants: [planner.v7, planner.v8]
  metric: [quality, cost]
  samples: 100
  status: running
```

## 4. Winner selection

- So score các variants.
- Framework tự chọn winner.
- Winner → release (Phase 22).

## 5. Tương tác

- `experiment.schema.yaml`.
- `evaluation/` (Phase 21) — score.
- `prompts/` (Phase 18) — prompt variants.
- `release/` (Phase 22) — promote winner.
- `model-router/` (Phase 17) — model variants.