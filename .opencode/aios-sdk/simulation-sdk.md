---
name: sdk-simulation
description: Simulation SDK — run simulation, get risk/confidence/recommendation.
agent: general
---

# Simulation SDK

## 1. Vai trò

Giao diện Simulation Engine.

## 2. API

| Method | Mô tả |
|--------|-------|
| `Simulation.Run(workflow, mode)` | chạy simulation |
| `Simulation.MultiScenario(workflow)` | đa scenario |
| `Simulation.Predict(workflow)` | ước lượng token/time |
| `Simulation.GetResult(id)` | kết quả |

## 3. DTO

```yaml
SimulationResult:
  id, mode, risk_score, confidence, recommendation, metrics
```

## 4. Permission

- Run/Predict/GetResult: `simulation.run`.

## 5. Tương tác

- `simulation/` (Phase 7).
- Evolution dùng simulation-sdk validate proposal.