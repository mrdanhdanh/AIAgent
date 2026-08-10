---
name: spec-013-x005-architecture
description: SPEC-013 X005 - Evolution Architecture. Layers, components, dependencies.
agent: general
---

# X005 - Evolution Architecture

> **SPEC-013**: Evolution Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Evolution Engine duoc to chuc nhu the nao?**

## XA001 - Philosophy

- Safe evolution, module registry, doc-only heal.
- Tach Pipeline (Evolution) khoi Decision (Policy S012).
- Tach Diff Store khoi Migration Store.
- Khong duong vong qua Business layer.

## XA002 - Layer Model (5)

```text
[API Layer]      Evolution API (diff, compat, migrate, heal, score, evolve)
     |
[Engine Layer]   Pipeline Orchestrator + State Machine (X009)
     |
[Guard Layer]    Policy Evaluator (S012) + Safe-Evolution Guard
     |
[Store Layer]    Diff Store + Migration Store
     |
[Integration]    Modules (9) + Doctor (SPEC-011) + Simulation (SPEC-012) + Events (S011)
```

## XA003 - Dependency Rules

- API -> Engine -> Guard -> Store.
- Engine KHONG goi truc tiep S011 (qua port).
- Guard goi Policy qua interface (S012).
- Modules goi system qua read-only interface.

## XA004 - Communication Rules

- Diff/Compat: sync (blocking).
- Migrate/Heal: sync, doc-only.
- Events, metrics: async (S011).
- Moi op co trace_id (S011).

## XA005 - Domain Model

Evolution, SemanticDiff, CompatibilityReport, MigrationPlan, EvolutionReport (X008 ENT).
Domain logic trong Engine Layer.

## XA006 - Key Decisions (ADR)

| ID | Decision | Ly do |
|----|----------|-------|
| XAD-001 | Khong pha vo he thong | P013 |
| XAD-002 | Module registry | 9 modules de mo rong |
| XAD-003 | Policy qua S012 | khong tu quyet |
| XAD-004 | Diff tach Migration Store | migration history |

## Tham chieu

- /team-syncdocs
- X006 Components - SPEC-013
- S011 Observability - SPEC-001
