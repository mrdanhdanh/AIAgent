---
name: SPEC-013-x005-architecture
description: SPEC-013 X005 - Evolution Architecture. Layers, components, dependencies.
agent: general
---

# X005 - Evolution Architecture

> **SPEC-013**: Evolution Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Evolution Engine duoc to chuc nhu the nao?**

## XA001 - Philosophy

- Isolated, deterministic, replayable.
- Tach Pipeline (Evolution) khoi Decision (Policy S012).
- Tach Diff Store khoi Result Store.
- Khong duong vong qua Business layer.

## XA002 - Layer Model (5)

```text
[API Layer]      Evolution API (Diffed, Planure, run, observe, compare, report)
     |
[Engine Layer]   Pipeline Orchestrator + State Machine (X009)
     |
[Guard Layer]    Policy Evaluator (S012) + Isolation Guard
     |
[Store Layer]    Diff Store + Result Store
     |
[Integration]    Workflow (SPEC-002) + Events (S011) + Doctor (SPEC-011)
```

## XA003 - Dependency Rules

- API -> Engine -> Guard -> Store.
- Engine KHONG goi truc tiep S011 (qua port).
- Guard goi Policy qua interface (S012).
- Simulator goi Workflow qua read-only interface.

## XA004 - Communication Rules

- Diffed/Run: sync (blocking).
- Observe/Compare: sync.
- Events, metrics: async (S011).
- Moi op co trace_id (S011).

## XA005 - Domain Model

Evolution, Diff, EvolutionPlan, EvolutionResult, EvolutionReport (X008 ENT).
Domain logic trong Engine Layer.

## XA006 - Key Decisions (ADR)

| ID | Decision | Ly do |
|----|----------|-------|
| XAD-001 | Evolution isolated | RULE-007 |
| XAD-002 | Deterministic runner | P013 |
| XAD-003 | Policy qua S012 | khong tu quyet |
| XAD-004 | Diff registry | 6 types de mo rong |

## Tham chieu

- SPEC-002 Workflow
- X006 Components - SPEC-013
- S011 Observability - SPEC-001
