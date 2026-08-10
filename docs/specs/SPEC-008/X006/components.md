---
name: spec-008-x006-components
description: SPEC-008 X006 - Event Components. Component model, contracts, lifecycle.
agent: general
---

# X006 - Event Components

> **SPEC-008**: Event Bus - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Event Bus gom nhung thanh phan nao?**

## XC001 - Component Model (12)

| Component | Trach nhiem | Layer |
|-----------|-------------|-------|
| EventApi | expose op | API |
| RouteOrchestrator | route events | Engine |
| EventStateMachine | state transitions | Engine |
| EventValidator | schema/invariants | Core |
| PolicyGuard | policy eval | Guard |
| EventStore | append-only log | Core |
| EventRouter | topic routing | Data |
| SubscriptionManager | subscribe/unsubscribe | Data |
| ReplayEngine | replay events | Data |
| EventMetrics | metrics | Data |
| RegistryClient | definition lookup | Integration |
| Archiver | archive + retention | Data |

## XC002 - Contracts

- Moi component co contract (X007).
- Component chi goi qua interface.
- Khong co singletons (trong Engine).

## XC003 - Lifecycle

- EventApi: co khi Runtime start.
- EventStore: per-Store instance.
- Others: singleton per Engine.

## XC004 - Ownership

- Event Team so huu toan bo component.
- S011 components thuoc Runtime.
- Producer khong so huu component.

## XC005 - Validation

- Component co contract + test.
- Metrics day du (X011).
- Doctor X019 check component health.

## Tham chieu

- X005 Architecture - SPEC-008
- X007 Contracts - SPEC-008
- S011 Observability - SPEC-001
