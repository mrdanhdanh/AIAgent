---
name: spec-009-x015-resources
description: SPEC-009 X015 - Contract Resources. Storage, index, quota, leak detection.
agent: general
---

# X015 - Contract Resources

> **SPEC-009**: Contract System - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Contract System quan ly tai nguyen nhu the nao?**

## XRM001 - Philosophy

- Contract dung tai nguyen kiem soat (versioned, retention).
- Moi resource co quota (S012).
- Khong retire -> leak -> Doctor phat hien.
- Tai nguyen duoc thu hoi theo retention (XPOL-006).

## XRM002 - Resources (6)

| Resource | Ten | Owner | Priority |
|----------|-----|-------|----------|
| XRES-001 | Storage | Contract System | Critical |
| XRES-002 | Index | Contract System | High |
| XRES-003 | ContractId | Contract System | Critical |
| XRES-004 | Verify CPU | Contract System | High |
| XRES-005 | Event Buffer | Runtime | High |
| XRES-006 | Snapshot Store | Contract System | Low |

## XRM003 - Allocation

- Declare: storage theo quota (XPOL-007).
- Version: version slot.
- Retire: thu hoi storage theo retention.
- Quota cau hinh qua Policy S012.

## XRM004 - Access Control

- Contract chi access qua Contract System API.
- Caller doc qua resolve (read-only).
- Khong access truc tiep Store.
- Audit moi access (X011).

## XRM005 - Lifecycle & Leak

allocate -> in_use -> retired.
Leaked: khong retire -> CONTRACT_RESOURCE_LEAKED -> Doctor X019.
Reclamation theo retention (XPOL-006).

## XRM006 - Events (4)

CONTRACT_RESOURCE_ALLOCATED / RELEASED / LEAKED / QUOTA_EXCEEDED (S011).

## XRM007 - Metrics (5)

contract_storage_bytes, contract_version_count, contract_resource_leaked_total,
contract_quota_exceeded_total, contract_verify_latency_seconds.

## Tham chieu

- XPOL-007 Quota - SPEC-009 X012
- X011 Observability - SPEC-009
- X019 Doctor - SPEC-009
- SPEC-001 Runtime Kernel
