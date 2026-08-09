---
name: spec-011-x011-observability
description: SPEC-011 X011 - Doctor Observability. Events, metrics, audit, traces (S011).
agent: general
---

# X011 - Doctor Observability

> **SPEC-011**: Doctor - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Trang thai Scan quan sat duoc nhu the nao?**

## XO001 - Philosophy

- Doctor la observable (RULE-014).
- Moi thay doi Scan phai phat Event (S011).
- Khong the debug Doctor ma khong co event/trace.
- Observability la bat buoc (P005, XNF-004).

## XO002 - Principles

- **Event-first** - moi stage/transition co event.
- **Immutable events** - chi append (P010).
- **Correlated** - correlation_id xuyen suot.
- **Metrics co label** - phan tich duoc.
- **Audit day du** - ai lam gi, khi nao (XFR-016).

## XO003 - Events (12)

| Event | Y nghia |
|-------|---------|
| DOCTOR_REQUESTED | Scan request |
| DOCTOR_SCANNING | Dang scan |
| DOCTOR_DIAGNOSED | Chan doan xong |
| DOCTOR_SCORED | Cham diem xong |
| DOCTOR_STATE_REPAIRED | Repair xong |
| DOCTOR_STATE_REPORTED | Report xong |
| DOCTOR_STATE_FAILED | Scan loi |
| DOCTOR_FINDING | Finding moi |
| DOCTOR_SCORE_LOW | Score thap (<80) |
| DOCTOR_REPAIR_BLOCKED | Repair bi chan (core) |
| DOCTOR_REPAIRED_DOC | Repair doc xong |
| DOCTOR_RESTORED | Phuc hoi |

Event immutable, append-only, co correlation_id (S011).

## XO004 - Metrics (9)

doctor_scans_total, doctor_reports_total, doctor_failed_total,
doctor_repairs_total, doctor_findings_total, doctor_score_current,
doctor_scan_duration_seconds, doctor_repair_latency_seconds, doctor_coverage_pct.

Labels: scan_id, state, execution_id, domain.

## XO005 - Traces (6 spans)

doctor.request / scan / diagnose / score / repair / report.
Span attrs: scan_id, execution_id, scope, domain.

## XO006 - Audit

who / what / when / where / why - append-only (S011).
XFR-016 bat buoc ghi audit moi lan chay Doctor.

## XO007 - Correlation

correlation_id (Scan) + trace_id (Runtime) + execution_id (Execution)
-> lien ket moi observability voi Execution.

## XO008 - Dashboard

Health Trend, Findings by Domain, Failures, Repair Status, Coverage.
Tool: X020 Doctor Dashboard.

## XO009 - Health Checks (5)

scan_ok, score_ok (0-100), repair_ok (khong sua core),
event_ok (day du), policy_ok (S012).
Score tinh trong X019 Doctor.

## Tham chieu

- S011 Observability - SPEC-001
- /doctor command
- X019 Doctor - SPEC-011
