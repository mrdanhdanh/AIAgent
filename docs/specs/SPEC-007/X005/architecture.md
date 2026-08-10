---
name: spec-007-x005-architecture
description: SPEC-007 X005 - Artifact Architecture. Layers, components, dependencies.
agent: general
---

# X005 - Artifact Architecture

> **SPEC-007**: Artifact Manager - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Artifact Manager duoc to chuc nhu the nao?**

## XA001 - Philosophy

- Write-once content, versioned metadata.
- Tach Lifecycle (Artifact Store) khoi Decision (Policy S012).
- Tach Event/Metric (S011) khoi Logic.
- Khong duong vong qua Business layer.

## XA002 - Layer Model (5)

```text
[API Layer]      Artifact API (create, publish, version, consume, archive)
     |
[Engine Layer]   Lifecycle Orchestrator + State Machine (X009)
     |
[Guard Layer]    Policy Evaluator (S012) + Validator + Checksum
     |
[Store Layer]    Artifact Store (immutable content) + Index
     |
[Integration]    Registry (SPEC-005) + Events/Metrics (S011)
```

## XA003 - Dependency Rules

- API -> Engine -> Guard -> Store.
- Engine KHONG goi truc tiep S011 (qua port).
- Guard goi Policy qua interface (S012).
- Khong dependency vong.

## XA004 - Communication Rules

- Sync: create/publish/version (blocking).
- Async: events, metrics (S011).
- Consume: read-only, khong can grant.
- Moi op co trace_id (S011).

## XA005 - Domain Model

Artifact, ArtifactVersion, ArtifactMetadata, ArtifactChecksum, ArtifactState (X008 ENT).
Domain logic trong Engine Layer.

## XA006 - Key Decisions (ADR)

| ID | Decision | Ly do |
|----|----------|-------|
| XAD-001 | Content write-once | P010 immutable |
| XAD-002 | Metadata versioned | P004 |
| XAD-003 | Policy qua S012 | khong tu quyet |
| XAD-004 | Store tach Index | query performance |

## Tham chieu

- S008 ENT-008 - SPEC-001
- X006 Components - SPEC-007
- S011 Observability - SPEC-001
