---
name: spec-016-x010-execution-flow
description: SPEC-016 X010 - CLI Execution Flow. 6 stages, failure, lineage.
agent: general
---

# X010 - CLI Execution Flow

> **SPEC-016**: CLI - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **CLI chay nhu the nao?**

## XF001 - Flow Philosophy

- CLI chay nhu Execution cua Runtime (SPEC-001).
- CLI thuc thi pipeline - khong dinh nghia lai.
- Khong buoc nao thieu Event (S011).
- CLI khong thay doi he thong (XC-001).

## XF002 - Flow Principles

- **Pipeline** - Create -> Render -> Compose -> Filter -> Refresh -> Export.
- **Doc S011 read-only** (P005).
- **KhÃ´ng tao nguon moi** (XC-002).
- Moi buoc co trace + event (S011).

## XF003 - Execution Stages (6)

```text
Create -> Render -> Compose -> Filter -> Refresh -> Export
```

(aios-cli pipeline)

## XF004 - Canonical CLI Flow

```text
User/CLI
  -> Create (CLI_id sinh) [CLI_CREATED]
  -> Render (doc S011 metrics) [CLI_RENDERING]
  -> Compose (widget -> panel) [CLI_COMPOSED]
  -> Filter (thoi gian/scope) [CLI_FILTERED]
  -> Refresh (dinh ky) [CLI_REFRESHED]
  -> Export (JSON/markdown) [CLI_EXPORTED]
```

## XF005 - Stage Detail

| Stage | Actor | Input | Output | Event |
|-------|-------|-------|--------|-------|
| Create | CLI | user request | CLI | CLI_CREATED |
| Render | RenderEngine | S011 metrics | Widgets | CLI_RENDERING |
| Compose | CLI | widgets | Panels | CLI_COMPOSED |
| Filter | FilterEngine | panels | Filtered | CLI_FILTERED |
| Refresh | RefreshEngine | filtered | Refreshed | CLI_REFRESHED |
| Export | ExportEngine | refreshed | Export | CLI_EXPORTED |

## XF006 - Failure Modes

- Create fail -> khong CLI + error.
- Render fail -> CLI_FAILED + retry.
- Compose fail -> giu widget, retry.
- Filter fail -> giu view cu, retry.
- Refresh fail -> giu view cu, retry.
- Export fail -> retry (S012).

## XF007 - Lineage

- Root CLI: parent = null.
- View chain: parent = CLI_id truoc.

## XF008 - Query Ops

GetCLI / GetWidgets / GetViews / GetExport / GetHistory.
Query khong can grant, khong thay doi CLI.

## XF009 - Storage

- View store (P005), persistent.
- Quota theo policy (X012).
- Snapshot optional.

## XF010 - Validation

- Stage order dung pipeline.
- Moi stage co event.
- Doc S011 read-only (Doctor X019).

## Tham chieu

- aios-cli
- S011 Metrics - SPEC-001
- S012 Policies - SPEC-001
