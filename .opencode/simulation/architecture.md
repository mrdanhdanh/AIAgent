---
name: simulation-architecture
description: Kiến trúc Simulation — Execution Mode của Runtime; reuse core scheduler/state/resolver.
agent: general
---

# Simulation — Architecture

## 1. Execution Modes (thay vì module riêng)

```text
                Workflow Runtime
                        │
        ┌───────────────┼────────────────┐
        │               │                │
  Execute Mode      Simulation Mode   Replay Mode
        │               │                │
        └───────────────┼────────────────┘
                        │
              Runtime Core (shared)
        Scheduler · State Machine · Capability Resolver
        Context Resolver · Artifact Resolver · Contract
```

## 2. Reuse 100%

| Runtime Core | Simulation dùng lại |
|--------------|---------------------|
| Scheduler | chạy phase tuần tự (không execute) |
| State Machine | transition mô phỏng (không persist) |
| Capability Resolver | resolve capability → agent |
| Context Resolver | resolve context → check đủ |
| Artifact Resolver | resolve artifact → check version/dependency |
| Contract Validator | validate output contract (predict) |

Khác biệt: Simulation **không persist state**, **không gọi AI**, **không mutate artifact**.

## 3. Simulation Pipeline

```text
1. Load workflow definition
2. Resolve capability per phase
3. Resolve agent per capability
4. Resolve context per agent
5. Resolve artifact (input/output)
6. Dependency check
7. Risk analysis (per step + total)
8. Confidence score
9. Multi-scenario (success/retry/abort)
10. Event prediction
11. Build report
12. Recommend (execute/reject)
```

## 4. Layers

```text
┌─────────────────────────────┐
│  Simulation Orchestrator     │ (simulator.md)
├─────────────────────────────┤
│  Scenario / Risk / Confidence│
│  Dependency / Conflict        │
├─────────────────────────────┤
│  Runtime Core (reused)        │
├─────────────────────────────┤
│  Registry / Context / Store   │
└─────────────────────────────┘
```

## 5. Không gây side-effect

| Thứ | Execute | Simulation |
|-----|---------|------------|
| Persist state | ✅ | ❌ |
| Gọi AI | ✅ | ❌ |
| Tạo artifact | ✅ | ❌ (chỉ predict) |
| Publish event | ✅ | ❌ (chỉ dự đoán) |
| Ghi file | ✅ | ❌ |

## 6. Tương tác

- `simulator.md` — core engine.
- `modes.md` — 5 modes.
- `planner.md` — simulation plan.
- Phase 1 (Workflow Runtime) — core reuse.
- Phase 7 (Doctor) — đọc simulation report.