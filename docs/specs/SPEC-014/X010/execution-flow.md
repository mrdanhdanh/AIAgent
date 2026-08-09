---
name: spec-014-x010-execution-flow
description: SPEC-014 X010 - Dashboard Execution Flow. 6 stages, failure, lineage.
agent: general
---

# X010 - Dashboard Execution Flow

> **SPEC-014**: Dashboard - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Dashboard chay nhu the nao?**

## XF001 - Flow Philosophy

- Dashboard chay nhu Execution cua Runtime (SPEC-001).
- Dashboard thuc thi pipeline - khong dinh nghia lai.
- Khong buoc nao thieu Event (S011).
- Dashboard khong thay doi he thong (XC-001).

## XF002 - Flow Principles

- **Pipeline** - Create -> Render -> Compose -> Filter -> Refresh -> Export.
- **Doc S011 read-only** (P005).
- **KhÃ´ng tao nguon moi** (XC-002).
- Moi buoc co trace + event (S011).

## XF003 - Execution Stages (6)

```text
Create -> Render -> Compose -> Filter -> Refresh -> Export
```

(dashboard-sdk pipeline)

## XF004 - Canonical Dashboard Flow

```text
User/CLI
  -> Create (dashboard_id sinh) [DASHBOARD_CREATED]
  -> Render (doc S011 metrics) [DASHBOARD_RENDERING]
  -> Compose (widget -> panel) [DASHBOARD_COMPOSED]
  -> Filter (thoi gian/scope) [DASHBOARD_FILTERED]
  -> Refresh (dinh ky) [DASHBOARD_REFRESHED]
  -> Export (JSON/markdown) [DASHBOARD_EXPORTED]
```

## XF005 - Stage Detail

| Stage | Actor | Input | Output | Event |
|-------|-------|-------|--------|-------|
| Create | Dashboard | user request | Dashboard | DASHBOARD_CREATED |
| Render | RenderEngine | S011 metrics | Widgets | DASHBOARD_RENDERING |
| Compose | Dashboard | widgets | Panels | DASHBOARD_COMPOSED |
| Filter | FilterEngine | panels | Filtered | DASHBOARD_FILTERED |
| Refresh | RefreshEngine | filtered | Refreshed | DASHBOARD_REFRESHED |
| Export | ExportEngine | refreshed | Export | DASHBOARD_EXPORTED |

## XF006 - Failure Modes

- Create fail -> khong dashboard + error.
- Render fail -> DASHBOARD_FAILED + retry.
- Compose fail -> giu widget, retry.
- Filter fail -> giu view cu, retry.
- Refresh fail -> giu view cu, retry.
- Export fail -> retry (S012).

## XF007 - Lineage

- Root Dashboard: parent = null.
- View chain: parent = dashboard_id truoc.

## XF008 - Query Ops

GetDashboard / GetWidgets / GetViews / GetExport / GetHistory.
Query khong can grant, khong thay doi Dashboard.

## XF009 - Storage

- View store (P005), persistent.
- Quota theo policy (X012).
- Snapshot optional.

## XF010 - Validation

- Stage order dung pipeline.
- Moi stage co event.
- Doc S011 read-only (Doctor X019).

## Tham chieu

- dashboard-sdk
- S011 Metrics - SPEC-001
- S012 Policies - SPEC-001
