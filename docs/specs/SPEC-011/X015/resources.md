---
name: spec-011-x015-resources
description: SPEC-011 X015 - Doctor Resources. Storage, index, quota, leak detection.
agent: general
---

# X015 - Doctor Resources

> **SPEC-011**: Doctor - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Doctor quan ly tai nguyen nhu the nao?**

## XRM001 - Philosophy

- Doctor dung tai nguyen kiem soat (findings, retention).
- Moi resource co quota (S012).
- Khong archive -> leak -> Doctor phat hien.
- Tai nguyen duoc thu hoi theo retention (XPOL-006).

## XRM002 - Resources (6)

| Resource | Ten | Owner | Priority |
|----------|-----|-------|----------|
| XRES-001 | Storage | Doctor | Critical |
| XRES-002 | Index | Doctor | High |
| XRES-003 | ScanId | Doctor | Critical |
| XRES-004 | Scan CPU | Doctor | High |
| XRES-005 | Event Buffer | Runtime | High |
| XRES-006 | Snapshot Store | Doctor | Low |

## XRM003 - Allocation

- Scan: storage theo quota (XPOL-007).
- Report: report slot.
- Archive: thu hoi storage theo retention.
- Quota cau hinh qua Policy S012.

## XRM004 - Access Control

- Findings chi access qua Doctor API.
- He thong bi scan qua read-only interface.
- Khong access truc tiep Store.
- Audit moi access (X011).

## XRM005 - Lifecycle & Leak

allocate -> in_use -> archived.
Leaked: khong archive -> DOCTOR_RESOURCE_LEAKED -> Doctor X019.
Reclamation theo retention (XPOL-006).

## XRM006 - Events (4)

DOCTOR_RESOURCE_ALLOCATED / RELEASED / LEAKED / QUOTA_EXCEEDED (S011).

## XRM007 - Metrics (5)

doctor_storage_bytes, doctor_finding_count, doctor_resource_leaked_total,
doctor_quota_exceeded_total, doctor_scan_latency_seconds.

## Tham chieu

- XPOL-007 Quota - SPEC-011 X012
- X011 Observability - SPEC-011
- X019 Doctor - SPEC-011
- SPEC-001 Runtime Kernel
