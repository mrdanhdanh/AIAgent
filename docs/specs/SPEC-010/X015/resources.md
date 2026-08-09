---
name: spec-010-x015-resources
description: SPEC-010 X015 - Plugin Resources. Storage, index, quota, leak detection.
agent: general
---

# X015 - Plugin Resources

> **SPEC-010**: Plugin Framework - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Plugin Framework quan ly tai nguyen nhu the nao?**

## XRM001 - Philosophy

- Plugin dung tai nguyen kiem soat (versioned, retention).
- Moi resource co quota (S012).
- Khong uninstall -> leak -> Doctor phat hien.
- Tai nguyen duoc thu hoi theo retention (XPOL-006).

## XRM002 - Resources (6)

| Resource | Ten | Owner | Priority |
|----------|-----|-------|----------|
| XRES-001 | Storage | Plugin Framework | Critical |
| XRES-002 | Index | Plugin Framework | High |
| XRES-003 | PluginId | Plugin Framework | Critical |
| XRES-004 | Sandbox CPU | Plugin Framework | High |
| XRES-005 | Event Buffer | Runtime | High |
| XRES-006 | Snapshot Store | Plugin Framework | Low |

## XRM003 - Allocation

- Install: storage theo quota (XPOL-007).
- Version: version slot.
- Uninstall: thu hoi storage theo retention.
- Quota cau hinh qua Policy S012.

## XRM004 - Access Control

- Plugin chi access qua Plugin Framework API.
- Plugin doc qua API (read-only).
- Khong access truc tiep Store.
- Audit moi access (X011).

## XRM005 - Lifecycle & Leak

allocate -> in_use -> uninstalled.
Leaked: khong uninstall -> PLUGIN_RESOURCE_LEAKED -> Doctor X019.
Reclamation theo retention (XPOL-006).

## XRM006 - Events (4)

PLUGIN_RESOURCE_ALLOCATED / RELEASED / LEAKED / QUOTA_EXCEEDED (S011).

## XRM007 - Metrics (5)

PLUGIN_storage_bytes, PLUGIN_version_count, PLUGIN_resource_leaked_total,
PLUGIN_quota_exceeded_total, PLUGIN_verify_latency_seconds.

## Tham chieu

- XPOL-007 Quota - SPEC-010 X012
- X011 Observability - SPEC-010
- X019 Doctor - SPEC-010
- SPEC-001 Runtime Kernel
