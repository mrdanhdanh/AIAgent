---
name: spec-007-x008-data-model
description: SPEC-007 X008 - Artifact Data Model. Entity, relation, invariant, validation.
agent: general
---

# X008 - Artifact Data Model

> **SPEC-007**: Artifact Manager - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Artifact luu giu du lieu gi va rang buoc gi?**

## XD001 - Philosophy

- Artifact la persistent metadata cua Execution (S008 ENT-008).
- Content immutable (P010) - write-once.
- Artifact chi chua metadata ve output - KHONG chua Business Data (S011 OB003A).
- Artifact co version + checksum (P004/P010).

## XD002 - Principles

- **Immutable** - content khong doi (P010).
- **No Overwrite** - khong bao gio overwrite (TERM-008).
- **Versioned** - thay doi = version moi (P004).
- **Validated** - moi publish validate truoc.
- **Observable** - moi thay doi sinh Event (S011).

## XD003 - Structure (3 lop)

```text
Artifact (AggregateRoot)
  +- ArtifactDefinition (Entity)
  +- ArtifactVersion (Entity) 1..*
  +- ArtifactMetadata (Entity)
  +- ArtifactChecksum (Value)
  +- ArtifactState (Transient)
  +- ArtifactIndex (Entity)
  +- ArtifactSnapshot (Entity) 0..*
  +- refs: ExecutionRef, ProducerRef, ConsumerRef, PolicyRef
```

## XD004 - Entities (15 ENT)

| ENT | Name | Kind | Owner | Immutable |
|-----|------|------|-------|-----------|
| ENT-X001 | Artifact | AggregateRoot | Artifact Store | - |
| ENT-X002 | ArtifactDefinition | Entity | Artifact Store | yes |
| ENT-X003 | ArtifactVersion | Entity | Artifact Store | yes |
| ENT-X004 | ArtifactMetadata | Entity | Artifact Store | yes |
| ENT-X005 | ArtifactChecksum | Value | Artifact Store | yes |
| ENT-X006 | ArtifactState | Transient | Artifact Store | - |
| ENT-X007 | ArtifactIndex | Entity | Artifact Store | - |
| ENT-X008 | ArtifactEvent | Ref (S011) | Runtime | yes |
| ENT-X009 | ArtifactMetric | Ref (S011) | Runtime | yes |
| ENT-X010 | ArtifactSnapshot | Entity | Artifact Store | - |
| ENT-X011 | ExecutionRef | Ref (SPEC-001) | Execution | yes |
| ENT-X012 | ProducerRef | Ref (SPEC-004/002) | Agent/Task | yes |
| ENT-X013 | ConsumerRef | Ref (SPEC-004) | Agent | yes |
| ENT-X014 | PolicyRef | Ref (S012) | Runtime | yes |
| ENT-X015 | ArtifactExtension | Value | Artifact Store | yes |

## XD005 - Identity

- artifact_id: UUID (Create sinh ra).
- version: SemVer (P004).
- checksum: SHA-256 (content address).

## XD006 - Relations (9)

| REL | From | To | Card |
|-----|------|----|------|
| REL-X001 | Artifact | ArtifactDefinition | 1..1 |
| REL-X002 | Artifact | ArtifactVersion | 1..* |
| REL-X003 | Artifact | ArtifactMetadata | 1..1 |
| REL-X004 | Artifact | ArtifactChecksum | 1..1 |
| REL-X005 | Artifact | ArtifactState | 1..1 |
| REL-X006 | Artifact | ArtifactIndex | 0..1 |
| REL-X007 | Artifact | ExecutionRef | 1..1 |
| REL-X008 | Artifact | ArtifactEvent | 0..* |
| REL-X009 | Artifact | ArtifactSnapshot | 0..* |

## XD007 - Invariants (7)

1. Unique ArtifactId.
2. Single Owner - mot Execution.
3. Immutable Content.
4. Checksum khop content.
5. Version tang don dieu.
6. KHONG overwrite.
7. KHONG chua Business Data.

## XD008 - Validation

- Validate khi: Create, Publish, Version.
- Vi pham -> BLOCK + error ARTIFACT_INVARIANT.
- Validation co trace (S011).

## XD009 - Storage

- Content-addressable (checksum).
- Persistent metadata (P010).
- ArtifactSnapshot optional (debug/doctor).

## XD010 - Open Questions

- Khi nao snapshot huu ich cho Doctor?
- Gioi han kich thuoc Artifact?

## Tham chieu

- S008 ENT-008 - SPEC-001
- P010 Immutable Artifact
- SPEC-005 Registry
