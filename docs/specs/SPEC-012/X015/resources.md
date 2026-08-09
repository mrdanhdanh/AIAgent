---
name: spec-012-x015-resources
description: SPEC-012 X015 - Simulation Resources. Storage, index, quota, leak detection.
agent: general
---

# X015 - Simulation Resources

> **SPEC-012**: Simulation - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Simulation quan ly tai nguyen nhu the nao?**

## XRM001 - Philosophy

- Simulation dung tai nguyen kiem soat (Results, retention).
- Moi resource co quota (S012).
- Khong archive -> leak -> Simulation phat hien.
- Tai nguyen duoc thu hoi theo retention (XPOL-006).

## XRM002 - Resources (6)

| Resource | Ten | Owner | Priority |
|----------|-----|-------|----------|
| XRES-001 | Storage | Simulation | Critical |
| XRES-002 | Index | Simulation | High |
| XRES-003 | ScanId | Simulation | Critical |
| XRES-004 | Scan CPU | Simulation | High |
| XRES-005 | Event Buffer | Runtime | High |
| XRES-006 | Snapshot Store | Simulation | Low |

## XRM003 - Allocation

- Scan: storage theo quota (XPOL-007).
- Report: report slot.
- Archive: thu hoi storage theo retention.
- Quota cau hinh qua Policy S012.

## XRM004 - Access Control

- Results chi access qua Simulation API.
- He thong bi scan qua read-only interface.
- Khong access truc tiep Store.
- Audit moi access (X011).

## XRM005 - Lifecycle & Leak

allocate -> in_use -> archived.
Leaked: khong archive -> SIMULATION_RESOURCE_LEAKED -> Simulation Doctor.
Reclamation theo retention (XPOL-006).

## XRM006 - Events (4)

SIMULATION_RESOURCE_ALLOCATED / RELEASED / LEAKED / QUOTA_EXCEEDED (S011).

## XRM007 - Metrics (5)

SIMULATION_storage_bytes, SIMULATION_result_count, SIMULATION_resource_leaked_total,
SIMULATION_quota_exceeded_total, SIMULATION_scan_latency_seconds.

## Tham chieu

- XPOL-007 Quota - SPEC-012 X012
- X011 Observability - SPEC-012
- X019 Simulation - SPEC-012
- SPEC-001 Runtime Kernel
