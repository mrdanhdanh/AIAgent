---
name: spec-006-x006-components
description: SPEC-006 X006 - Context Components. Component model, contracts, lifecycle.
agent: general
---

# X006 - Context Components

> **SPEC-006**: Context Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Context Engine gom nhung thanh phan nao?**

## XC001 - Component Model

| Component | Trach nhiem | Dependencies |
|-----------|-------------|--------------|
| ContextApi | expose op | Engine |
| LifecycleOrchestrator | EF008 flow | StateMachine, Store |
| ContextStateMachine | state transitions | S009 |
| PolicyGuard | policy eval | S012 |
| ScopeChecker | grant scope | - |
| ContextValidator | schema/invariants | X008 |
| ContextStore | in-memory data | - |
| ContextEvents | publish events | S011 |
| ContextMetrics | metrics | S011 |
| ContextRegistryClient | definition lookup | SPEC-005 |

## XC002 - Contracts

- Moi component co contract (X007).
- Component chi goi qua interface.
- Khong co singletons (trong Engine).

## XC003 - Lifecycle

- ContextApi: co khi Runtime start.
- Store: per-Execution (tao/release voi Context).
- Others: singleton per Engine.

## XC004 - Ownership

- Context Engine so huu toan bo component.
- S011 components thuoc Runtime.
- Khong component nao thuoc Agent.

## XC005 - Validation

- Component co contract + test.
- Metrics day du (X011).
- Doctor X019 check component health.

## Tham chieu

- X005 Architecture - SPEC-006
- X007 Contracts - SPEC-006
- S011 Observability - SPEC-001
