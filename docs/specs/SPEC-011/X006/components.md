---
name: spec-011-x006-components
description: SPEC-011 X006 - Doctor Components. Component model, contracts, lifecycle.
agent: general
---

# X006 - Doctor Components

> **SPEC-011**: Doctor - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Doctor gom nhung thanh phan nao?**

## XC001 - Component Model (12)

| Component | Trach nhiem | Layer |
|-----------|-------------|-------|
| DoctorApi | expose op | API |
| PipelineOrchestrator | pipeline flow | Engine |
| DoctorStateMachine | state transitions | Engine |
| ScanEngine | chay scanners | Core |
| DiagnoseEngine | chan doan findings | Core |
| PolicyGuard | policy eval | Guard |
| FindingsStore | findings storage | Core |
| ScoreStore | score history | Data |
| RepairEngine | doc-only repair | Data |
| ReportEngine | markdown/JSON report | Data |
| ScannerRegistry | scanner lookup | Integration |
| BenchmarkRunner | capability benchmark | Data |

## XC002 - Contracts

- Moi component co contract (X007).
- Component chi goi qua interface.
- Khong co singletons (trong Engine).

## XC003 - Lifecycle

- DoctorApi: co khi Runtime start.
- FindingsStore: per-Store instance.
- Others: singleton per Engine.

## XC004 - Ownership

- Doctor Team so huu toan bo component.
- S011 components thuoc Runtime.
- He thong khong so huu component.

## XC005 - Validation

- Component co contract + test.
- Metrics day du (X011).
- Doctor X019 check component health.

## Tham chieu

- X005 Architecture - SPEC-011
- X007 Contracts - SPEC-011
- S011 Observability - SPEC-001
