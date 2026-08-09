---
name: spec-011-x010-execution-flow
description: SPEC-011 X010 - Doctor Execution Flow. 6 stages, failure, lineage.
agent: general
---

# X010 - Doctor Execution Flow

> **SPEC-011**: Doctor - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Doctor chay nhu the nao?**

## XF001 - Flow Philosophy

- Doctor chay nhu Execution cua Runtime (SPEC-001).
- Doctor thuc thi pipeline - khong dinh nghia lai.
- Khong buoc nao thieu Event (S011).
- Doctor khong sua core (P015).

## XF002 - Flow Principles

- **Pipeline** - Request -> Scan -> Diagnose -> Score -> Repair -> Report.
- **Scan truoc khi repair** (XFR-001).
- **Doc-only repair** - khong sua core (P015).
- Moi buoc co trace + event (S011).

## XF003 - Execution Stages (6)

```text
Request -> Scan -> Diagnose -> Score -> Repair -> Report
```

(/doctor pipeline)

## XF004 - Canonical Doctor Flow

```text
User/CLI
  -> Request (scan_id sinh) [DOCTOR_REQUESTED]
  -> Scan (toan bo he sinh thai) [DOCTOR_SCANNING]
  -> Diagnose (findings) [DOCTOR_DIAGNOSED]
  -> Score (0-100) [DOCTOR_SCORED]
  -> Repair (doc-only, optional) [DOCTOR_REPAIRED]
  -> Report (markdown/JSON) [DOCTOR_REPORTED]
```

## XF005 - Stage Detail

| Stage | Actor | Input | Output | Event |
|-------|-------|-------|--------|-------|
| Request | Doctor | user request | Scan | DOCTOR_REQUESTED |
| Scan | ScanEngine | system | Findings | DOCTOR_SCANNING |
| Diagnose | DiagnoseEngine | findings | Diagnosed | DOCTOR_DIAGNOSED |
| Score | Scorer | findings | Score | DOCTOR_SCORED |
| Repair | RepairEngine | findings | Repairs (doc) | DOCTOR_REPAIRED |
| Report | ReportEngine | score | Report | DOCTOR_REPORTED |

## XF006 - Failure Modes

- Request fail -> khong scan + error.
- Scan fail -> DOCTOR_FAILED + partial findings.
- Diagnose fail -> giu findings, retry.
- Score fail -> khong report + event.
- Repair fail -> ghi finding, khong sua core.
- Report fail -> retry (S012).

## XF007 - Lineage

- Root Scan: parent = null.
- Follow-up Scan: parent = scan_id truoc.

## XF008 - Query Ops

GetScan / GetFindings / GetScore / GetReport / GetHistory.
Query khong can grant, khong thay doi Scan.

## XF009 - Storage

- Findings store (P005), persistent.
- Quota theo policy (X012).
- Snapshot optional.

## XF010 - Validation

- Stage order dung pipeline.
- Moi stage co event.
- Repair khong sua core (Doctor X019).

## Tham chieu

- /doctor command
- S011 Events - SPEC-001
- S012 Policies - SPEC-001
