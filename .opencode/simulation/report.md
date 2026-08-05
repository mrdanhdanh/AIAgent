---
name: simulation-report
description: Simulation Report — output chi tiết: risk, confidence, prediction, warnings, recommendation.
agent: general
---

# Simulation Report

## 1. Vai trò

Output cuối của Simulation — đưa ra quyết định execute/reject.

## 2. Structure

```yaml
simulation_report:
  id: SIM-001
  workflow: feature-development
  mode: dry-run

  risk_score: 18
  risk_level: low

  confidence: 97
  confidence_level: high

  estimated:
    time: 85s
    tokens: 12000
    artifacts: 8
    events: 37

  steps:
    - { phase: planning, capability: architecture.design, agent: planner, risk: 10 }
    - { phase: implementation, capability: implementation.code, agent: builder, risk: 25 }

  scenarios:
    - { id: A, outcome: success, risk: 5, confidence: 98 }
    - { id: B, outcome: retry, risk: 30, confidence: 88 }

  warnings:
    - "Artifact PLAN-001 version 1 outdated (latest v2)"
    - "Agent builder retry history 2 failures"

  recommendation: proceed
```

## 3. Recommendation

| Value | Điều kiện |
|-------|-----------|
| `proceed` | risk <= 40, confidence >= 70 |
| `proceed-with-warning` | risk <= 60, confidence >= 50 |
| `reject` | risk > 60, confidence < 50 |

## 4. Report file

- Sinh `reports/sim-SIM-001.md` (markdown render).
- Dashboard hiển thị.

## 5. Tương tác

- `simulator.md` — build report.
- `risk-engine.md`, `confidence.md` — dữ liệu.
- `scenario.md` — scenario section.
- `metrics.md` — thống kê.