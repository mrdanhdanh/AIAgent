---
name: spec-008-x015-resources
description: SPEC-008 X015 - Event Resources. Storage, index, quota, leak detection.
agent: general
---

# X015 - Event Resources

> **SPEC-008**: Event Bus - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Event Bus quan ly tai nguyen nhu the nao?**

## XRM001 - Philosophy

- Event dung tai nguyen kiem soat (append-only, retention).
- Moi resource co quota (S012).
- Khong archive -> leak -> Doctor phat hien.
- Tai nguyen duoc thu hoi theo retention (XPOL-006).

## XRM002 - Resources (6)

| Resource | Ten | Owner | Priority |
|----------|-----|-------|----------|
| XRES-001 | Storage | Event Bus | Critical |
| XRES-002 | Index | Event Bus | High |
| XRES-003 | EventId | Event Bus | Critical |
| XRES-004 | Deliver Threads | Event Bus | High |
| XRES-005 | Event Buffer | Runtime | High |
| XRES-006 | Snapshot Store | Event Bus | Low |

## XRM003 - Allocation

- Publish: storage theo quota (XPOL-007).
- Deliver: deliver threads.
- Archive: thu hoi storage theo retention.
- Quota cau hinh qua Policy S012.

## XRM004 - Access Control

- Event chi access qua Event Bus API.
- Subscriber nhan qua deliver (read-only).
- Khong access truc tiep log (append-only).
- Audit moi access (X011).

## XRM005 - Lifecycle & Leak

allocate -> in_use -> archived.
Leaked: khong archive -> EVENT_RESOURCE_LEAKED -> Doctor X019.
Reclamation theo retention (XPOL-006).

## XRM006 - Events (4)

EVENT_RESOURCE_ALLOCATED / RELEASED / LEAKED / QUOTA_EXCEEDED (S011).

## XRM007 - Metrics (5)

event_storage_bytes, event_index_entries, event_resource_leaked_total,
event_quota_exceeded_total, event_deliver_threads_used.

## Tham chieu

- XPOL-007 Quota - SPEC-008 X012
- X011 Observability - SPEC-008
- X019 Doctor - SPEC-008
- SPEC-001 Runtime Kernel
