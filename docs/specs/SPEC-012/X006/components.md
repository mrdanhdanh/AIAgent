---
name: spec-012-x006-components
description: SPEC-012 X006 - Simulation Components. Component model, contracts, lifecycle.
agent: general
---

# X006 - Simulation Components

> **SPEC-012**: Simulation Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Simulation Engine gom nhung thanh phan nao?**

## XC001 - Component Model (12)

| Component | Trach nhiem | Layer |
|-----------|-------------|-------|
| SimulationApi | expose op | API |
| PipelineOrchestrator | pipeline flow | Engine |
| SimulationStateMachine | state transitions | Engine |
| ScenarioEngine | chay scenarios | Core |
| ConfigValidator | validate config | Core |
| PolicyGuard | policy eval | Guard |
| ScenarioStore | scenario definitions | Core |
| ResultStore | simulation results | Data |
| Comparator | compare voi ky vong | Data |
| SimulationMetrics | metrics | Data |
| RegistryClient | definition lookup | Integration |
| Reporter | simulation report | Data |

## XC002 - Contracts

- Moi component co contract (X007).
- Component chi goi qua interface.
- Khong co singletons (trong Engine).

## XC003 - Lifecycle

- SimulationApi: co khi Runtime start.
- ScenarioStore: per-Store instance.
- Others: singleton per Engine.

## XC004 - Ownership

- Simulation Team so huu toan bo component.
- S011 components thuoc Runtime.
- Workflow khong so huu component.

## XC005 - Validation

- Component co contract + test.
- Metrics day du (X011).
- Doctor X019 check component health.

## Tham chieu

- X005 Architecture - SPEC-012
- X007 Contracts - SPEC-012
- S011 Observability - SPEC-001
