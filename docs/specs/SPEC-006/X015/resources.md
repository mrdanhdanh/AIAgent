---
name: spec-006-x015-resources
description: SPEC-006 X015 - Context Resources. Memory, grants, quota, leak detection.
agent: general
---

# X015 - Context Resources

> **SPEC-006**: Context Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Context Engine quan ly tai nguyen nhu the nao?**

## XRM001 - Philosophy

- Context dung tai nguyen toi thieu (transient, metadata-only).
- Moi resource co quota (S012).
- Khong release -> leak -> Doctor phat hien.
- Tai nguyen duoc thu hoi tu dong khi Execution end.

## XRM002 - Resources (6)

| Resource | Ten | Owner | Priority |
|----------|-----|-------|----------|
| XRES-001 | Memory | Context Engine | Critical |
| XRES-002 | ContextId | Context Engine | Critical |
| XRES-003 | Grant Slot | Context Engine | High |
| XRES-004 | Event Buffer | Runtime | High |
| XRES-005 | Snapshot Store | Context Engine | Low |
| XRES-006 | Policy Evaluator | Runtime | High |

## XRM003 - Allocation

- Allocate: memory theo quota (XPOL-006).
- Distribute: grant slot.
- Release: thu hoi memory + slot.
- Quota cau hinh qua Policy S012.

## XRM004 - Access Control

- Context chi access qua Context Engine API.
- Agent access qua ContextGrant (scope).
- Khong access truc tiep (P006).
- Audit moi access (X011).

## XRM005 - Lifecycle & Leak

allocate -> in_use -> released.
Leaked: khong release -> CONTEXT_RESOURCE_LEAKED -> Doctor X019.
Reclamation tu dong khi Execution end (EF008).

## XRM006 - Events (4)

CONTEXT_RESOURCE_ALLOCATED / RELEASED / LEAKED / QUOTA_EXCEEDED (S011).

## XRM007 - Metrics (5)

context_memory_bytes, context_grant_slots_used, context_resource_leaked_total,
context_quota_exceeded_total, context_resource_release_latency_seconds.

## Tham chieu
- SPEC-001 Runtime Kernel

- XPOL-006 Quota - SPEC-006 X012
- X011 Observability - SPEC-006
- X019 Doctor - SPEC-006
