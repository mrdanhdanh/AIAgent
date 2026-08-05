---
name: simulation-tests
description: Simulation Tests — test dry-run, replay, risk, prediction, dependency, context, capability, artifact.
agent: general
---

# Simulation Tests

## 1. Test cases

| # | Scenario | Expected |
|---|----------|----------|
| 1 | Dry run | không side-effect, no state persist |
| 2 | Replay | event history replay đúng order |
| 3 | Risk calc | risk_score đúng theo factors |
| 4 | Confidence calc | confidence đúng theo criteria |
| 5 | Prediction | tokens/time/artifacts/events hợp lý |
| 6 | Dependency check | thiếu → reject |
| 7 | Context check | thiếu context → SIM-004 |
| 8 | Capability check | không agent → SIM-003 |
| 9 | Artifact version | conflict → SIM-005 |
| 10 | Multi-scenario | success/retry/abort riêng biệt |
| 11 | Conflict detect | builder conflict phát hiện |
| 12 | Recommendation | risk+confidence → decision |

## 2. Cách chạy

- Unit test gọi Simulator với mock registry/context.
- Không cần Agent/LLM.
- `simulation-validator.ps1` — gate Phase 7 (structure).

## 3. Target

- Coverage: dry-run, replay, risk, confidence, dependency.
- Recommendation accuracy.