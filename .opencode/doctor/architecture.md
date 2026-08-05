---
name: doctor-architecture
description: Kiến trúc Doctor v2 — layers, analyzers, health engine, rule engine, report pipeline.
agent: general
---

# Doctor v2 — Architecture

## 1. Layers

```text
┌──────────────────────────────────────┐
│            Doctor Engine              │  (orchestrator)
├──────────────────────────────────────┤
│  Analyzers                           │
│  Static · Behavioral · Runtime ·      │
│  Coverage                            │
├──────────────────────────────────────┤
│  Health Engine · Rule Engine          │
├──────────────────────────────────────┤
│  Scoring · Debt · Readiness           │
├──────────────────────────────────────┤
│  Improvement Engine · Report          │
└──────────────────────────────────────┘
```

## 2. Data sources

| Analyzer | Đọc từ |
|----------|--------|
| Static | registry/, agents/, context/, artifacts/, events/, simulation/ |
| Behavioral | events/history, artifacts/history, memory/failure-records |
| Runtime | workflow-runtime metrics, event metrics, simulation metrics |
| Coverage | registry capabilities vs agents/skills/commands |

## 3. Analysis pipeline

```text
Discover sources
  → Load metadata (validators đảm bảo hợp lệ)
  → Static analysis (run validators: capability, agent, context, artifact, event, simulation)
  → Behavioral analysis (read history + metrics)
  → Runtime analysis (read runtime metrics)
  → Coverage analysis (capabilities covered)
  → Score (Health Engine + Rule Engine)
  → Recommendation (Improvement Engine)
  → Report (reports/)
```

## 4. Health Engine

Tổng hợp điểm từng nhóm:

| Nhóm | Nguồn |
|------|-------|
| Architecture | static (schemas, layers) |
| Runtime | runtime metrics |
| Context | context metrics (token avg) |
| Workflow | workflow health |
| Registry | registry health |
| Agent | agent health (behavior) |
| Artifact | artifact health |
| Event | event health |
| Simulation | prediction accuracy |

Overall = weighted avg.

## 5. Improvement Engine

Ánh xạ vấn đề → đề xuất:

```text
Context quá lớn → thêm Compression Profile
Capability unused → deprecated
Agent retry cao → review prompt/contract
Simulation accuracy thấp → refine prediction
```

## 6. Tương tác

- Gọi tất cả validator scripts (Phase 2-7) như static checks.
- `rules/rules.yaml` — Rule Engine (không hard-code).
- `scoring/` — debt + readiness.