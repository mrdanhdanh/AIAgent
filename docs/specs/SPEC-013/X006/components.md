---
name: spec-013-x006-components
description: SPEC-013 X006 - Evolution Components. Component model, contracts, lifecycle.
agent: general
---

# X006 - Evolution Components

> **SPEC-013**: Evolution Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Evolution Engine gom nhung thanh phan nao?**

## XC001 - Component Model (12)

| Component | Trach nhiem | Layer |
|-----------|-------------|-------|
| EvolutionApi | expose op | API |
| PipelineOrchestrator | pipeline flow | Engine |
| EvolutionStateMachine | state transitions | Engine |
| DiffEngine | semantic diff | Core |
| CompatChecker | backward compatible check | Core |
| PolicyGuard | policy eval | Guard |
| DiffStore | diff results | Core |
| MigrationStore | migration plans | Data |
| MigrationEngine | thuc hien migration | Data |
| SelfHealEngine | doc-only repair | Data |
| ModuleRegistry | 9 module lookup | Integration |
| HealthScorer | health score | Data |

## XC002 - Contracts

- Moi component co contract (X007).
- Component chi goi qua interface.
- Khong co singletons (trong Engine).

## XC003 - Lifecycle

- EvolutionApi: co khi Runtime start.
- DiffStore: per-Store instance.
- Others: singleton per Engine.

## XC004 - Ownership

- Evolution Team so huu toan bo component.
- S011 components thuoc Runtime.
- He thong khong so huu component.

## XC005 - Validation

- Component co contract + test.
- Metrics day du (X011).
- Doctor X019 check component health.

## Tham chieu

- X005 Architecture - SPEC-013
- X007 Contracts - SPEC-013
- S011 Observability - SPEC-001
