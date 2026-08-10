---
name: spec-012-x005-architecture
description: SPEC-012 X005 - Simulation Architecture. Layers, components, dependencies.
agent: general
---

# X005 - Simulation Architecture

> **SPEC-012**: Simulation Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Simulation Engine duoc to chuc nhu the nao?**

## XA001 - Philosophy

- Isolated, deterministic, replayable.
- Tach Pipeline (Simulation) khoi Decision (Policy S012).
- Tach Scenario Store khoi Result Store.
- Khong duong vong qua Business layer.

## XA002 - Layer Model (5)

```text
[API Layer]      Simulation API (define, configure, run, observe, compare, report)
     |
[Engine Layer]   Pipeline Orchestrator + State Machine (X009)
     |
[Guard Layer]    Policy Evaluator (S012) + Isolation Guard
     |
[Store Layer]    Scenario Store + Result Store
     |
[Integration]    Workflow (SPEC-002) + Events (S011) + Doctor (SPEC-011)
```

## XA003 - Dependency Rules

- API -> Engine -> Guard -> Store.
- Engine KHONG goi truc tiep S011 (qua port).
- Guard goi Policy qua interface (S012).
- Simulator goi Workflow qua read-only interface.

## XA004 - Communication Rules

- Define/Run: sync (blocking).
- Observe/Compare: sync.
- Events, metrics: async (S011).
- Moi op co trace_id (S011).

## XA005 - Domain Model

Simulation, Scenario, SimulationConfig, SimulationResult, SimulationReport (X008 ENT).
Domain logic trong Engine Layer.

## XA006 - Key Decisions (ADR)

| ID | Decision | Ly do |
|----|----------|-------|
| XAD-001 | Simulation isolated | RULE-007 |
| XAD-002 | Deterministic runner | P013 |
| XAD-003 | Policy qua S012 | khong tu quyet |
| XAD-004 | Scenario registry | 6 types de mo rong |

## Tham chieu

- SPEC-002 Workflow
- X006 Components - SPEC-012
- S011 Observability - SPEC-001
