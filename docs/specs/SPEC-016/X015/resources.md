---
name: spec-016-x015-resources
description: SPEC-016 X015 - CLI Resources. Storage, index, quota, leak detection.
agent: general
---

# X015 - CLI Resources

> **SPEC-016**: CLI - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **CLI quan ly tai nguyen nhu the nao?**

## XRM001 - Philosophy

- CLI dung tai nguyen kiem soat (Results, retention).
- Moi resource co quota (S012).
- Khong archive -> leak -> CLI phat hien.
- Tai nguyen duoc thu hoi theo retention (XPOL-006).

## XRM002 - Resources (6)

| Resource | Ten | Owner | Priority |
|----------|-----|-------|----------|
| XRES-001 | Storage | CLI | Critical |
| XRES-002 | Index | CLI | High |
| XRES-003 | ScanId | CLI | Critical |
| XRES-004 | Scan CPU | CLI | High |
| XRES-005 | Event Buffer | Runtime | High |
| XRES-006 | Snapshot Store | CLI | Low |

## XRM003 - Allocation

- Scan: storage theo quota (XPOL-007).
- Report: report slot.
- Archive: thu hoi storage theo retention.
- Quota cau hinh qua Policy S012.

## XRM004 - Access Control

- Results chi access qua CLI API.
- He thong bi scan qua read-only interface.
- Khong access truc tiep Store.
- Audit moi access (X011).

## XRM005 - Lifecycle & Leak

allocate -> in_use -> archived.
Leaked: khong archive -> CLI_RESOURCE_LEAKED -> CLI X019.
Reclamation theo retention (XPOL-006).

## XRM006 - Events (4)

CLI_RESOURCE_ALLOCATED / RELEASED / LEAKED / QUOTA_EXCEEDED (S011).

## XRM007 - Metrics (5)

CLI_storage_bytes, CLI_result_count, CLI_resource_leaked_total,
CLI_quota_exceeded_total, CLI_scan_latency_seconds.

## Tham chieu

- XPOL-007 Quota - SPEC-016 X012
- X011 Observability - SPEC-016
- X019 CLI - SPEC-016
- SPEC-001 Runtime Kernel
