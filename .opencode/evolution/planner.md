---
name: evolution-planner
description: Planner — Proposal Generator; sinh Evolution Proposal Object từ pattern + optimization.
agent: general
---

# Evolution Planner (Proposal Generator)

## 1. Vai trò

Sinh **Evolution Proposal Object** (evolution.schema.yaml) từ pattern + optimization. Không sửa gì.

## 2. Proposal structure

```yaml
id: EVO-001
category: performance
title: "Enable Context Compression"
priority: high
reason: "Context avg 12000 > target 5000"
impact:
  affected: [context-engine]
  estimated_gain: "-35% tokens"
  risk: low
migration:
  steps: ["Update profile to enable compression"]
  backward_compatible: true
simulation:
  risk_score: 12
  confidence: 95
  result: pass
status: proposed
```

## 3. Generation flow

```text
patterns (analyzer) + solutions (optimizer)
  → filter theo policy (được phép?)
  → generate proposal object
  → attach impact estimate (predictor)
  → submit to simulation + backtest
```

## 4. Categories

| Category | Ví dụ |
|----------|-------|
| performance | context compression, cache tuning |
| architecture | layer refactor, mode switch |
| context | budget tối ưu, profile merge |
| capability | deprecate/add capability |
| workflow | phase optimization |
| knowledge | graph refine |
| runtime | retry/recovery tuning |
| quality | validator rule cải tiến |

## 5. Không auto-apply

Proposal luôn status `proposed` → approval gate.

## 6. Tương tác

- `optimizer.md` — giải pháp.
- `predictor.md` — impact.
- `simulator.md` — validate.
- `policy.md` — giới hạn.