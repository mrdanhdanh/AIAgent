---
name: spec-015-x015-resources
description: SPEC-015 X015 - SDK Resources. Storage, index, quota, leak detection.
agent: general
---

# X015 - SDK Resources

> **SPEC-015**: SDK - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **SDK quan ly tai nguyen nhu the nao?**

## XRM001 - Philosophy

- SDK dung tai nguyen kiem soat (Results, retention).
- Moi resource co quota (S012).
- Khong archive -> leak -> SDK phat hien.
- Tai nguyen duoc thu hoi theo retention (XPOL-006).

## XRM002 - Resources (6)

| Resource | Ten | Owner | Priority |
|----------|-----|-------|----------|
| XRES-001 | Storage | SDK | Critical |
| XRES-002 | Index | SDK | High |
| XRES-003 | ScanId | SDK | Critical |
| XRES-004 | Scan CPU | SDK | High |
| XRES-005 | Event Buffer | Runtime | High |
| XRES-006 | Snapshot Store | SDK | Low |

## XRM003 - Allocation

- Scan: storage theo quota (XPOL-007).
- Report: report slot.
- Archive: thu hoi storage theo retention.
- Quota cau hinh qua Policy S012.

## XRM004 - Access Control

- Results chi access qua SDK API.
- He thong bi scan qua read-only interface.
- Khong access truc tiep Store.
- Audit moi access (X011).

## XRM005 - Lifecycle & Leak

allocate -> in_use -> archived.
Leaked: khong archive -> SDK_RESOURCE_LEAKED -> SDK X019.
Reclamation theo retention (XPOL-006).

## XRM006 - Events (4)

SDK_RESOURCE_ALLOCATED / RELEASED / LEAKED / QUOTA_EXCEEDED (S011).

## XRM007 - Metrics (5)

SDK_storage_bytes, SDK_result_count, SDK_resource_leaked_total,
SDK_quota_exceeded_total, SDK_scan_latency_seconds.

## Tham chieu

- XPOL-007 Quota - SPEC-015 X012
- X011 Observability - SPEC-015
- X019 SDK - SPEC-015
- SPEC-001 Runtime Kernel
