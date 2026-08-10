---
name: spec-007-x006-components
description: SPEC-007 X006 - Artifact Components. Component model, contracts, lifecycle.
agent: general
---

# X006 - Artifact Components

> **SPEC-007**: Artifact Manager - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Artifact Manager gom nhung thanh phan nao?**

## XC001 - Component Model (12)

| Component | Trach nhiem | Layer |
|-----------|-------------|-------|
| ArtifactApi | expose op | API |
| LifecycleOrchestrator | lifecycle flow | Engine |
| ArtifactStateMachine | state transitions | Engine |
| ChecksumEngine | tinh checksum | Core |
| ArtifactValidator | schema/invariants | Core |
| PolicyGuard | policy eval | Guard |
| ArtifactStore | immutable content | Core |
| ArtifactIndexer | index metadata | Data |
| ArtifactEvents | publish events | Data |
| ArtifactMetrics | metrics | Data |
| RegistryClient | definition lookup | Integration |
| Archiver | archive + retention | Data |

## XC002 - Contracts

- Moi component co contract (X007).
- Component chi goi qua interface.
- Khong co singletons (trong Engine).

## XC003 - Lifecycle

- ArtifactApi: co khi Runtime start.
- ArtifactStore: per-Store instance.
- Others: singleton per Engine.

## XC004 - Ownership

- Artifact Team so huu toan bo component.
- S011 components thuoc Runtime.
- Khong component nao thuoc Agent.

## XC005 - Validation

- Component co contract + test.
- Metrics day du (X011).
- Doctor X019 check component health.

## Tham chieu

- X005 Architecture - SPEC-007
- X007 Contracts - SPEC-007
- S011 Observability - SPEC-001
