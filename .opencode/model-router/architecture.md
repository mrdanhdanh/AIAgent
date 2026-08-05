---
name: model-router-architecture
description: Kiến trúc Model Router — model catalog, scoring, routing flow, fallback.
agent: general
---

# Model Router — Architecture

## 1. Components

```text
Model Catalog (models.yaml)
        │
        ▼
Router Core (score + pick)
        │
        ▼
Provider Adapters (GPT/Claude/...)
        │
        ▼
Execution
```

## 2. Model entry

```yaml
deepseek:
  provider: deepseek
  cost_per_1k: 0.001
  latency_ms: 800
  context_limit: 64000
  quality: 0.9
```

## 3. Scoring

```text
score = w_cost×(1-cost) + w_latency×(1-latency_norm)
      + w_quality×quality + w_avail×availability
```

- Task difficulty cao → ưu tiên quality.
- Budget hẹp → ưu tiên cost.

## 4. Fallback chain

```text
preferred unavailable → next best → local LLM → error
```

## 5. Tương tác

- `models.yaml` — catalog.
- `routing-policy.yaml` — per-capability model policy.
- `resources/` — cost.
- `evaluation/` (Phase 21) — quality score.