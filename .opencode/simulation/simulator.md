---
name: simulation-simulator
description: Simulator core — orchestrate pipeline, produce Simulation Object, không gọi AI.
agent: general
---

# Simulator

## 1. Vai trò

Core của Simulation Mode — chạy pipeline, tổng hợp Risk + Confidence, sinh Simulation Object.

## 2. API

| Method | Mô tả |
|--------|-------|
| `Simulate(workflow, mode)` | chạy simulation |
| `SimulateScenario(workflow, scenario)` | chạy 1 scenario |
| `MultiScenario(workflow)` | chạy success/retry/abort |
| `Predict(workflow)` | ước lượng token/time/artifact/event |

## 3. Flow

```text
Load workflow
  → per phase: resolve cap → agent → context → artifact
  → dependency check
  → risk per step (risk-engine)
  → confidence (confidence engine)
  → scenarios (scenario engine)
  → event prediction
  → build report
  → recommendation
```

## 4. Simulation Object output

```yaml
id: SIM-001
workflow: feature-development
mode: dry-run
risk_score: 18
confidence: 97
status: completed
steps: [ {phase, capability, agent, risk} ]
metrics: { tokens, duration, artifacts, events, scenarios }
recommendation: proceed
warnings: []
report_path: reports/sim-SIM-001.md
```

## 5. Không side-effect

- Không persist.
- Không gọi AI.
- Không tạo artifact/event.

## 6. Tương tác

- `scenario.md` — scenario variants.
- `risk-engine.md` — risk scoring.
- `confidence.md` — confidence scoring.
- `report.md` — output report.