---
name: spec-015-x006-components
description: SPEC-015 X006 - SDK Components. Component model, contracts, lifecycle.
agent: general
---

# X006 - SDK Components

> **SPEC-015**: SDK - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **SDK gom nhung thanh phan nao?**

## XC001 - Component Model (12)

| Component | Trach nhiem | Layer |
|-----------|-------------|-------|
| SDKApi | expose op | API |
| PipelineOrchestrator | pipeline flow | Engine |
| SDKStateMachine | state transitions | Engine |
| ClientEngine | render widgets | Core |
| AuthEngine | filter data | Core |
| PolicyGuard | policy eval | Guard |
| ClientStore | widget definitions | Core |
| BindingStore | view definitions | Data |
| VersionEngine | refresh dinh ky | Data |
| CallEngine | export JSON/markdown | Data |
| RegistryClient | definition lookup | Integration |
| RegistryReader | doc S011 metrics | Data |

## XC002 - Contracts

- Moi component co contract (X007).
- Component chi goi qua interface.
- Khong co singletons (trong Engine).

## XC003 - Lifecycle

- SDKApi: co khi Runtime start.
- ClientStore: per-Store instance.
- Others: singleton per Engine.

## XC004 - Ownership

- SDK Team so huu toan bo component.
- S011 components thuoc Runtime.
- S011 so huu nguon du lieu.

## XC005 - Validation

- Component co contract + test.
- Metrics day du (X011).
- Doctor X019 check component health.

## Tham chieu

- X005 Architecture - SPEC-015
- X007 Contracts - SPEC-015
- S011 Observability - SPEC-001
