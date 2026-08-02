---
name: ai-evaluation
description: >
  AI Evaluation Platform v21.0 — tự đánh giá AI: benchmark, regression, hallucination, consistency, quality, latency, cost.
  Đây là E2E cho AI.
agent: general
---

# AI Evaluation Platform v21.0

## 1. Vai trò

Framework tự đánh giá chất lượng AI.

## 2. Evaluation dimensions

| Dimension | Mô tả |
|-----------|-------|
| benchmark | chạy task chuẩn |
| regression | so với baseline |
| hallucination | phát hiện bịa |
| consistency | output ổn định? |
| quality | chất lượng output |
| latency | tốc độ |
| cost | chi phí |

## 3. Pipeline

```text
Eval Suite → chạy benchmark → collect output
  → compare với expected/golden
  → score (quality, consistency, hallucination)
  → report (latency, cost)
  → regression vs baseline
```

## 4. Tương tác

- `evaluation.schema.yaml`.
- `benchmarks/` — golden datasets.
- `model-router/` (Phase 17) — per-model score.
- `prompts/` (Phase 18) — A/B prompt.
- `release/` (Phase 22) — gate trước release.