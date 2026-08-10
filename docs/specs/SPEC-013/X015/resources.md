---
name: spec-013-x015-resources
description: SPEC-013 X015 - Evolution Resources. Storage, index, quota, leak detection.
agent: general
---

# X015 - Evolution Resources

> **SPEC-013**: Evolution - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Evolution quan ly tai nguyen nhu the nao?**

## XRM001 - Philosophy

- Evolution dung tai nguyen kiem soat (Results, retention).
- Moi resource co quota (S012).
- Khong archive -> leak -> Evolution phat hien.
- Tai nguyen duoc thu hoi theo retention (XPOL-006).

## XRM002 - Resources (6)

| Resource | Ten | Owner | Priority |
|----------|-----|-------|----------|
| XRES-001 | Storage | Evolution | Critical |
| XRES-002 | Index | Evolution | High |
| XRES-003 | ScanId | Evolution | Critical |
| XRES-004 | Scan CPU | Evolution | High |
| XRES-005 | Event Buffer | Runtime | High |
| XRES-006 | Snapshot Store | Evolution | Low |

## XRM003 - Allocation

- Scan: storage theo quota (XPOL-007).
- Report: report slot.
- Archive: thu hoi storage theo retention.
- Quota cau hinh qua Policy S012.

## XRM004 - Access Control

- Results chi access qua Evolution API.
- He thong bi scan qua read-only interface.
- Khong access truc tiep Store.
- Audit moi access (X011).

## XRM005 - Lifecycle & Leak

allocate -> in_use -> archived.
Leaked: khong archive -> EVOLUTION_RESOURCE_LEAKED -> Evolution X019.
Reclamation theo retention (XPOL-006).

## XRM006 - Events (4)

EVOLUTION_RESOURCE_ALLOCATED / RELEASED / LEAKED / QUOTA_EXCEEDED (S011).

## XRM007 - Metrics (5)

EVOLUTION_storage_bytes, EVOLUTION_result_count, EVOLUTION_resource_leaked_total,
EVOLUTION_quota_exceeded_total, EVOLUTION_scan_latency_seconds.

## Tham chieu

- XPOL-007 Quota - SPEC-013 X012
- X011 Observability - SPEC-013
- X019 Evolution - SPEC-013
- SPEC-001 Runtime Kernel
