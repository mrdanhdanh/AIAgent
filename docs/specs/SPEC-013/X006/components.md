---
name: SPEC-013-x006-components
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
| DiffEngine | chay Diffs | Core |
| PlanValidator | validate Plan | Core |
| PolicyGuard | policy eval | Guard |
| DiffStore | Diff definitions | Core |
| ResultStore | Evolution results | Data |
| Comparator | compare voi ky vong | Data |
| EvolutionMetrics | metrics | Data |
| RegistryClient | definition lookup | Integration |
| Reporter | Evolution report | Data |

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
- Workflow khong so huu component.

## XC005 - Validation

- Component co contract + test.
- Metrics day du (X011).
- Doctor X019 check component health.

## Tham chieu

- X005 Architecture - SPEC-013
- X007 Contracts - SPEC-013
- S011 Observability - SPEC-001
