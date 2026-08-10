---
name: spec-009-x006-components
description: SPEC-009 X006 - Contract Components. Component model, contracts, lifecycle.
agent: general
---

# X006 - Contract Components

> **SPEC-009**: Contract System - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Contract System gom nhung thanh phan nao?**

## XC001 - Component Model (12)

| Component | Trach nhiem | Layer |
|-----------|-------------|-------|
| ContractApi | expose op | API |
| LifecycleOrchestrator | lifecycle flow | Engine |
| ContractStateMachine | state transitions | Engine |
| ContractValidator | schema validation | Core |
| CompatChecker | backward compatible check | Core |
| PolicyGuard | policy eval | Guard |
| ContractStore | contract versions | Core |
| VersionIndex | version lookup | Data |
| Verifier | verify contract | Data |
| ContractMetrics | metrics | Data |
| RegistryClient | definition lookup | Integration |
| Retirer | retire + retention | Data |

## XC002 - Contracts

- Moi component co contract (X007).
- Component chi goi qua interface.
- Khong co singletons (trong Engine).

## XC003 - Lifecycle

- ContractApi: co khi Runtime start.
- ContractStore: per-Store instance.
- Others: singleton per Engine.

## XC004 - Ownership

- Contract Team so huu toan bo component.
- S011 components thuoc Runtime.
- Provider khong so huu component.

## XC005 - Validation

- Component co contract + test.
- Metrics day du (X011).
- Doctor X019 check component health.

## Tham chieu

- X005 Architecture - SPEC-009
- X007 Contracts - SPEC-009
- S011 Observability - SPEC-001
