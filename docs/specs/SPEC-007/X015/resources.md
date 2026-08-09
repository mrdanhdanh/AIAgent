---
name: spec-007-x015-resources
description: SPEC-007 X015 - Artifact Resources. Storage, index, quota, leak detection.
agent: general
---

# X015 - Artifact Resources

> **SPEC-007**: Artifact Manager - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Artifact Manager quan ly tai nguyen nhu the nao?**

## XRM001 - Philosophy

- Artifact dung tai nguyen kiem soat (write-once, retention).
- Moi resource co quota (S012).
- Khong archive -> leak -> Doctor phat hien.
- Tai nguyen duoc thu hoi theo retention (XPOL-006).

## XRM002 - Resources (6)

| Resource | Ten | Owner | Priority |
|----------|-----|-------|----------|
| XRES-001 | Storage | Artifact Store | Critical |
| XRES-002 | Index | Artifact Store | High |
| XRES-003 | ArtifactId | Artifact Store | Critical |
| XRES-004 | Checksum CPU | Artifact Store | High |
| XRES-005 | Event Buffer | Runtime | High |
| XRES-006 | Snapshot Store | Artifact Store | Low |

## XRM003 - Allocation

- Create: storage theo quota (XPOL-007).
- Publish: content + index slot.
- Archive: thu hoi storage theo retention.
- Quota cau hinh qua Policy S012.

## XRM004 - Access Control

- Artifact chi access qua Artifact Manager API.
- Consumer doc qua API (read-only).
- Khong access truc tiep content (write-once).
- Audit moi access (X011).

## XRM005 - Lifecycle & Leak

allocate -> in_use -> archived.
Leaked: khong archive -> ARTIFACT_RESOURCE_LEAKED -> Doctor X019.
Reclamation theo retention (XPOL-006).

## XRM006 - Events (4)

ARTIFACT_RESOURCE_ALLOCATED / RELEASED / LEAKED / QUOTA_EXCEEDED (S011).

## XRM007 - Metrics (5)

artifact_storage_bytes, artifact_index_entries, artifact_resource_leaked_total,
artifact_quota_exceeded_total, artifact_archive_latency_seconds.

## Tham chieu

- XPOL-007 Quota - SPEC-007 X012
- X011 Observability - SPEC-007
- X019 Doctor - SPEC-007
- SPEC-001 Runtime Kernel
