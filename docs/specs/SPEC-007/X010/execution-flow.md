---
name: spec-007-x010-execution-flow
description: SPEC-007 X010 - Artifact Execution Flow. 8 stages ENT-008, failure, lineage.
agent: general
---

# X010 - Artifact Execution Flow

> **SPEC-007**: Artifact Manager - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Artifact chay nhu the nao trong Runtime?**

## XF001 - Flow Philosophy

- Artifact chay nhu Execution cua Runtime (SPEC-001).
- Artifact Manager thuc thi ENT-008 - khong dinh nghia lai flow.
- Khong buoc nao thieu Event (S011).
- Artifact luon immutable sau publish (P010).

## XF002 - Flow Principles

- **ENT-008** - Create -> Validate -> Checksum -> Publish -> Version -> Index -> Consume -> Archive.
- **Validate truoc khi publish** (XFR-002).
- **No Overwrite** - thay doi = version moi (P010).
- Moi buoc co trace + event (S011).

## XF003 - Execution Stages (8)

```text
Create -> Validate -> Checksum -> Publish -> Version -> Index -> Consume -> Archive
```

(S008 ENT-008 - Artifact Manager thuc thi)

## XF004 - Canonical Artifact Flow

```text
Task/Agent output
  -> Create (artifact_id sinh) [ARTIFACT_CREATED]
  -> Validate (schema + invariants) [ARTIFACT_VALIDATING]
  -> Checksum (SHA-256) [ARTIFACT_CHECKSUMMED]
  -> Publish (immutable) [ARTIFACT_PUBLISHED]
  -> Version (sua = version moi) [ARTIFACT_VERSIONED]
  -> Index (metadata) [ARTIFACT_INDEXED]
  -> Consume (Agent/Doctor/Dashboard) [ARTIFACT_CONSUMED]
Het retention
  -> Archive (thu hoi + cleanup) [ARTIFACT_ARCHIVED]
```

## XF005 - Stage Detail

| Stage | Actor | Input | Output | Event |
|-------|-------|-------|--------|-------|
| Create | Artifact Store | output | Artifact + artifact_id | ARTIFACT_CREATED |
| Validate | Artifact Store | content | Validated Artifact | ARTIFACT_VALIDATING |
| Checksum | Artifact Store | content | checksum | ARTIFACT_CHECKSUMMED |
| Publish | Artifact Store | validated | Immutable Artifact | ARTIFACT_PUBLISHED |
| Version | Artifact Store | new content | New version | ARTIFACT_VERSIONED |
| Index | Indexer | metadata | Index entry | ARTIFACT_INDEXED |
| Consume | Consumer | artifact_id | Content | ARTIFACT_CONSUMED |
| Archive | Artifact Store | - | Archived | ARTIFACT_ARCHIVED |

## XF006 - Failure Modes

- Create fail -> khong tao Artifact + error.
- Validate fail -> ARTIFACT_REJECTED + cleanup.
- Checksum fail -> khong publish + event.
- Publish fail -> retry (S012).
- Version fail -> giu version cu (P004).
- Index fail -> publish OK, index retry.
- Archive fail -> giu Artifact, retry.

## XF007 - Lineage

- Root Artifact: parent = null.
- Chain Artifact: parent = artifact_id truoc (output -> input).

## XF008 - Query Ops

GetArtifact / GetVersion / SearchArtifacts / ListByExecution / GetHistory.
Query khong can grant, khong thay doi Artifact.

## XF009 - Storage

- Content-addressable (checksum), persistent (P010).
- Quota theo policy (X012).
- Snapshot optional cho Doctor.

## XF010 - Validation

- Stage order dung ENT-008.
- Moi stage co event.
- Khong overwrite (Doctor X019).

## Tham chieu

- S008 ENT-008 - SPEC-001
- S011 Events - SPEC-001
- S012 Policies - SPEC-001
