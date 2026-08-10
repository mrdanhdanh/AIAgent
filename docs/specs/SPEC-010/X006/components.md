---
name: spec-010-x006-components
description: SPEC-010 X006 - Plugin Components. Component model, contracts, lifecycle.
agent: general
---

# X006 - Plugin Components

> **SPEC-010**: Plugin Framework - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Plugin Framework gom nhung thanh phan nao?**

## XC001 - Component Model (12)

| Component | Trach nhiem | Layer |
|-----------|-------------|-------|
| PluginApi | expose op | API |
| LifecycleOrchestrator | lifecycle flow | Engine |
| PluginStateMachine | state transitions | Engine |
| ManifestValidator | schema + permission | Core |
| SandboxEnforcer | sandbox isolation | Core |
| PolicyGuard | policy eval | Guard |
| PluginStore | plugin manifests | Core |
| ManifestIndex | manifest lookup | Data |
| ExportManager | export capability/agent/skill/widget | Data |
| PluginMetrics | metrics | Data |
| RegistryClient | definition lookup | Integration |
| Uninstaller | disable + uninstall | Data |

## XC002 - Contracts

- Moi component co contract (X007).
- Component chi goi qua interface.
- Khong co singletons (trong Engine).

## XC003 - Lifecycle

- PluginApi: co khi Runtime start.
- PluginStore: per-Store instance.
- Others: singleton per Engine.

## XC004 - Ownership

- Plugin Team so huu toan bo component.
- S011 components thuoc Runtime.
- Plugin khong so huu component.

## XC005 - Validation

- Component co contract + test.
- Metrics day du (X011).
- Doctor X019 check component health.

## Tham chieu

- X005 Architecture - SPEC-010
- X007 Contracts - SPEC-010
- S011 Observability - SPEC-001
