---
name: SPEC-015-x010-execution-flow
description: SPEC-015 X010 - SDK Execution Flow. 6 stages, failure, lineage.
agent: general
---

# X010 - SDK Execution Flow

> **SPEC-015**: SDK - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **SDK chay nhu the nao?**

## XF001 - Flow Philosophy

- SDK chay nhu Execution cua Runtime (SPEC-001).
- SDK thuc thi pipeline - khong dinh nghia lai.
- Khong buoc nao thieu Event (S011).
- SDK khong thay doi he thong (XC-001).

## XF002 - Flow Principles

- **Pipeline** - Create -> Render -> Compose -> Filter -> Refresh -> Export.
- **Doc S011 read-only** (P005).
- **KhÃ´ng tao nguon moi** (XC-002).
- Moi buoc co trace + event (S011).

## XF003 - Execution Stages (6)

```text
Create -> Render -> Compose -> Filter -> Refresh -> Export
```

(aios-sdk pipeline)

## XF004 - Canonical SDK Flow

```text
User/CLI
  -> Create (SDK_id sinh) [SDK_CREATED]
  -> Render (doc S011 metrics) [SDK_RENDERING]
  -> Compose (widget -> panel) [SDK_COMPOSED]
  -> Filter (thoi gian/scope) [SDK_FILTERED]
  -> Refresh (dinh ky) [SDK_REFRESHED]
  -> Export (JSON/markdown) [SDK_EXPORTED]
```

## XF005 - Stage Detail

| Stage | Actor | Input | Output | Event |
|-------|-------|-------|--------|-------|
| Create | SDK | user request | SDK | SDK_CREATED |
| Render | RenderEngine | S011 metrics | Widgets | SDK_RENDERING |
| Compose | SDK | widgets | Panels | SDK_COMPOSED |
| Filter | FilterEngine | panels | Filtered | SDK_FILTERED |
| Refresh | RefreshEngine | filtered | Refreshed | SDK_REFRESHED |
| Export | ExportEngine | refreshed | Export | SDK_EXPORTED |

## XF006 - Failure Modes

- Create fail -> khong SDK + error.
- Render fail -> SDK_FAILED + retry.
- Compose fail -> giu widget, retry.
- Filter fail -> giu view cu, retry.
- Refresh fail -> giu view cu, retry.
- Export fail -> retry (S012).

## XF007 - Lineage

- Root SDK: parent = null.
- View chain: parent = SDK_id truoc.

## XF008 - Query Ops

GetSDK / GetWidgets / GetViews / GetExport / GetHistory.
Query khong can grant, khong thay doi SDK.

## XF009 - Storage

- View store (P005), persistent.
- Quota theo policy (X012).
- Snapshot optional.

## XF010 - Validation

- Stage order dung pipeline.
- Moi stage co event.
- Doc S011 read-only (Doctor X019).

## Tham chieu

- aios-sdk
- S011 Metrics - SPEC-001
- S012 Policies - SPEC-001
