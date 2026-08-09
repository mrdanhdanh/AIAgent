---
name: spec-016-x006-components
description: SPEC-016 X006 - CLI Components. Component model, contracts, lifecycle.
agent: general
---

# X006 - CLI Components

> **SPEC-016**: CLI - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **CLI gom nhung thanh phan nao?**

## XC001 - Component Model (12)

| Component | Trach nhiem | Layer |
|-----------|-------------|-------|
| CLIApi | expose op | API |
| PipelineOrchestrator | pipeline flow | Engine |
| CLIStateMachine | state transitions | Engine |
| CommandEngine | chay command | Core |
| FlagEngine | phan tich flag | Core |
| PolicyGuard | policy eval | Guard |
| WidgetStore | widget definitions | Core |
| ViewStore | view definitions | Data |
| CompletionEngine | hoan thanh lenh | Data |
| TriggerEngine | trigger workflow | Data |
| RegistryCommand | definition lookup | Integration |
| HelpEngine | hien thi help | Data |

## XC002 - Contracts

- Moi component co contract (X007).
- Component chi goi qua interface.
- Khong co singletons (trong Engine).

## XC003 - Lifecycle

- CLIApi: co khi Runtime start.
- WidgetStore: per-Store instance.
- Others: singleton per Engine.

## XC004 - Ownership

- CLI Team so huu toan bo component.
- S011 components thuoc Runtime.
- S011 so huu nguon du lieu.

## XC005 - Validation

- Component co contract + test.
- Metrics day du (X011).
- Doctor X019 check component health.

## Tham chieu

- X005 Architecture - SPEC-016
- X007 Contracts - SPEC-016
- S011 Observability - SPEC-001
