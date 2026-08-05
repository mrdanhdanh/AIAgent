---
name: simulation-engine
description: >
  Simulation Engine v7.0 — Execution Mode của Runtime. Dự đoán kết quả, Risk Analysis,
  Confidence Score, Multi-scenario trước khi chạy thật. Không gọi AI.
agent: general
---

# Simulation Engine v7.0

## 1. Vị trí

> Simulation là **Execution Mode của Runtime** — không phải engine song song.

```text
Workflow Runtime
├── Execute Mode
├── Simulation Mode   ← Phase 7
├── Replay Mode
└── Benchmark Mode
```

Lợi ích: 1 lõi thực thi, tái sử dụng Scheduler/State Machine/Resolver 100%, tránh Runtime & Simulation lệch nhau.

## 2. Giá trị

Dự đoán **kết quả trước khi chạy thật** — đa số Agent Framework không có.

```text
/team → Simulation → Risk Analysis → Approval → Execute
```

## 3. Kiến trúc

```text
Workflow Runtime
        │
  Simulation Engine (mode)
        │
  ┌──────┼──────┐
  │      │      │
Scenario Risk  Dependency
Engine  Engine Check
  │      │      │
  └──────┼──────┘
        │
  Simulation Report
        │
  Execute / Reject
```

## 4. Simulation Pipeline

```text
Workflow
  → Load Runtime (same core)
  → Resolve Capability
  → Resolve Agent
  → Resolve Context
  → Resolve Artifact
  → Dependency Check
  → Risk Analysis
  → Confidence Score
  → Multi-Scenario
  → Simulation Report
```

**Không gọi AI. Không sửa file.**

## 5. 5 Modes

| Mode | Mô tả |
|------|-------|
| dry-run | read-only, không sửa gì |
| mock | sinh dữ liệu giả |
| predict | ước lượng token/time/risk |
| replay | phát lại workflow từ history |
| what-if | mô phỏng nhánh lỗi/rollback |

## 6. Simulation Object

```yaml
id: SIM-001
workflow: feature-development
mode: dry-run
risk_score: 18
confidence: 97
recommendation: proceed
```

## 7. File hệ thống

| File | Vai trò |
|------|---------|
| `simulation.schema.yaml` | Simulation object |
| `architecture.md` | Kiến trúc + Execution Mode |
| `simulator.md` | Engine core |
| `planner.md` | Kế hoạch simulation |
| `modes.md` | 5 modes |
| `scenario.md` | Scenario engine |
| `risk-engine.md` | Risk score |
| `confidence.md` | Confidence score |
| `dependency-checker.md` | Dependency validation |
| `validator.md` | Validation checks |
| `conflict-detection.md` | Conflict detection |
| `event-prediction.md` | Event forecast |
| `report.md` | Simulation report |
| `metrics.md` | Metrics |
| `tests.md` | Tests |

## 8. Nguyên tắc

- Simulation không gọi AI, không mutate state.
- Tái sử dụng toàn bộ runtime core (mode-switch).
- Risk + Confidence dùng chung để quyết định.
- Recommendation: proceed / proceed-with-warning / reject.