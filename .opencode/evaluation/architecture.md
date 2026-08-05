---
name: evaluation-architecture
description: Kiến trúc Evaluation — benchmark runner, scorer, regression, report.
agent: general
---

# AI Evaluation — Architecture

## 1. Components

```text
Benchmark Suite (benchmarks/)
        │
        ▼
Runner (chạy task trên model)
        │
        ▼
Scorer (so output vs golden)
        │
        ▼
Regression (so baseline)
        │
        ▼
Report (quality/latency/cost)
```

## 2. Benchmark entry

```yaml
id: bench-001
capability: implementation.code
model: deepseek
prompt: planner.v7
input: "..."
golden: "..."
```

## 3. Scoring

| Score | Công thức |
|-------|-----------|
| quality | similarity(output, golden) |
| consistency | variance over N runs |
| hallucination | claims không trong context |
| latency | avg response ms |
| cost | tokens × rate |

## 4. Regression

```text
evaluate(current) vs evaluate(baseline)
  → quality regression? → cảnh báo
  → prompt v8 tốt hơn v7? → recommend
```

## 5. Tương tác

- `evaluation.schema.yaml`.
- `model-router/` — per-model.
- `release/` — gate.