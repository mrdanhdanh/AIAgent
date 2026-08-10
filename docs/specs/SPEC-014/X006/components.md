---
name: spec-014-x006-components
description: SPEC-014 X006 - Dashboard Components. Component model, contracts, lifecycle.
agent: general
---

# X006 - Dashboard Components

> **SPEC-014**: Dashboard - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Dashboard gom nhung thanh phan nao?**

## XC001 - Component Model (12)

| Component | Trach nhiem | Layer |
|-----------|-------------|-------|
| DashboardApi | expose op | API |
| PipelineOrchestrator | pipeline flow | Engine |
| DashboardStateMachine | state transitions | Engine |
| RenderEngine | render widgets | Core |
| FilterEngine | filter data | Core |
| PolicyGuard | policy eval | Guard |
| WidgetStore | widget definitions | Core |
| ViewStore | view definitions | Data |
| RefreshEngine | refresh dinh ky | Data |
| ExportEngine | export JSON/markdown | Data |
| RegistryClient | definition lookup | Integration |
| MetricReader | doc S011 metrics | Data |

## XC002 - Contracts

- Moi component co contract (X007).
- Component chi goi qua interface.
- Khong co singletons (trong Engine).

## XC003 - Lifecycle

- DashboardApi: co khi Runtime start.
- WidgetStore: per-Store instance.
- Others: singleton per Engine.

## XC004 - Ownership

- Dashboard Team so huu toan bo component.
- S011 components thuoc Runtime.
- S011 so huu nguon du lieu.

## XC005 - Validation

- Component co contract + test.
- Metrics day du (X011).
- Doctor X019 check component health.

## Tham chieu

- X005 Architecture - SPEC-014
- X007 Contracts - SPEC-014
- S011 Observability - SPEC-001
