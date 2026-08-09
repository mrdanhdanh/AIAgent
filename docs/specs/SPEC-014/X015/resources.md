---
name: spec-014-x015-resources
description: SPEC-014 X015 - Dashboard Resources. Storage, index, quota, leak detection.
agent: general
---

# X015 - Dashboard Resources

> **SPEC-014**: Dashboard - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Dashboard quan ly tai nguyen nhu the nao?**

## XRM001 - Philosophy

- Dashboard dung tai nguyen kiem soat (Results, retention).
- Moi resource co quota (S012).
- Khong archive -> leak -> Dashboard phat hien.
- Tai nguyen duoc thu hoi theo retention (XPOL-006).

## XRM002 - Resources (6)

| Resource | Ten | Owner | Priority |
|----------|-----|-------|----------|
| XRES-001 | Storage | Dashboard | Critical |
| XRES-002 | Index | Dashboard | High |
| XRES-003 | ScanId | Dashboard | Critical |
| XRES-004 | Scan CPU | Dashboard | High |
| XRES-005 | Event Buffer | Runtime | High |
| XRES-006 | Snapshot Store | Dashboard | Low |

## XRM003 - Allocation

- Scan: storage theo quota (XPOL-007).
- Report: report slot.
- Archive: thu hoi storage theo retention.
- Quota cau hinh qua Policy S012.

## XRM004 - Access Control

- Results chi access qua Dashboard API.
- He thong bi scan qua read-only interface.
- Khong access truc tiep Store.
- Audit moi access (X011).

## XRM005 - Lifecycle & Leak

allocate -> in_use -> archived.
Leaked: khong archive -> DASHBOARD_RESOURCE_LEAKED -> Dashboard X019.
Reclamation theo retention (XPOL-006).

## XRM006 - Events (4)

DASHBOARD_RESOURCE_ALLOCATED / RELEASED / LEAKED / QUOTA_EXCEEDED (S011).

## XRM007 - Metrics (5)

DASHBOARD_storage_bytes, DASHBOARD_result_count, DASHBOARD_resource_leaked_total,
DASHBOARD_quota_exceeded_total, DASHBOARD_scan_latency_seconds.

## Tham chieu

- XPOL-007 Quota - SPEC-014 X012
- X011 Observability - SPEC-014
- X019 Dashboard - SPEC-014
- SPEC-001 Runtime Kernel
