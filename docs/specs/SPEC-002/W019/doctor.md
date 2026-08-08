---
name: spec-002-w019-doctor
description: >
  SPEC-002 W019 — Workflow Doctor. Trả lời: Doctor kiểm tra sức khỏe Workflow
  Engine như thế nào? Tổng hợp checks từ W011..W018 + S016, Health Score,
  self-repair an toàn. Mirror S019 (SPEC-001).
agent: general
---

# W019 — Workflow Doctor

> **SPEC-002**: Workflow Engine · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Doctor kiểm tra sức khỏe Workflow Engine như thế nào?**

## WDR001 — Doctor Philosophy

- Workflow Doctor là cơ chế kiểm tra sức khỏe Workflow Engine.
- Doctor chỉ đọc machine-readable (W011).
- Không định nghĩa lại quy tắc (W016 đã tổng hợp).
- Self-repair chỉ thay đổi an toàn, có giới hạn.

## WDR002 — Doctor Principles

- Evidence Based · Machine-readable First · Non-invasive · Deterministic · Repairable · Auditable.

## WDR003 — Doctor Scope

**Kiểm tra 9 domain:**

- Constitution (SPEC-000) · Contracts (W007) · Policy Binding (W012) · Governance (W013) · Registry (W014) · Resources (W015) · Compliance (W016) · Extensions (W017) · Observability (W011).

**Không đọc:** Implementation · Business Data · Agent Internal State · Plugin Internal State.

## WDR004 — Check Categories

| Nguồn | Số checks |
|-------|-----------|
| W011 Observability | 5 |
| W013 Governance | 6 |
| W014 Registry | 6 |
| W015 Resources | 5 |
| W016 Compliance | 12 |
| W017 Extensions | 6 |
| W018 Evolution | 6 |

> Tổng: **46 checks** — tham chiếu, không định nghĩa lại.

## WDR005 — Health Score

- **Healthy · Degraded · Unhealthy** (W016 WMC006).

## WDR006 — Doctor Pipeline

```text
Collect (machine-readable)
    ↓
Validate (checks per domain)
    ↓
Score (health — W016 WMC006)
    ↓
Report (workflow-doctor-report)
    ↓
Repair (nếu an toàn, self-repair)
```

Mỗi lần chạy sinh WORKFLOW_DOCTOR_RUN + Audit (W011).

## WDR007 — Doctor Checks

46 checks từ 7 nguồn (WDR004). Mỗi check: có evidence (W011), có SPEC source, kết quả Pass/Warning/Fail.

## WDR008 — Self-Repair

- Chỉ **Low impact**.
- Qua Approval (W013) hoặc auto cho quen thuộc.
- Có rollback.
- Ghi Audit (W011).
- **Không sửa implementation.**
- Không Repair vi phạm CRITICAL — báo cáo lên người.

## WDR009 — Doctor Report

```yaml
report:
  fields: [id, timestamp, workflow_version, checks, score, status, repair, evidence]
```

Report immutable (P005).

## WDR010 — Doctor Events

- WORKFLOW_DOCTOR_RUN · PASSED · FAILED · REPORTED · REPAIRED.

> S011 reuse trực tiếp.

## WDR011 — Doctor Metrics

- health_score · passed_checks · failed_checks · warning_checks · total_checks · repair_count.

## WDR012 — Doctor Governance

- Doctor không bypass Governance (W013).
- Repair qua Approval Gate (W013).
- Vi phạm CRITICAL → báo cáo lên người.
- Mọi hành động ghi Audit (W011).

## WDR013 — Doctor Registry

- Doctor kiểm tra Registry (W014) là một trong 9 domain.
- Certification (W016) dựa trên Workflow Doctor Report.

## WDR014 — Machine-readable

```text
workflow-doctor.yaml
workflow-doctor-scope.yaml
workflow-doctor-checks.yaml
workflow-doctor-pipeline.yaml
workflow-doctor-self-repair.yaml
workflow-doctor-report.yaml
workflow-doctor-events.yaml
workflow-doctor-metrics.yaml
workflow-doctor-validation.yaml
workflow-doctor.schema.json
```

## WDR015 — Traceability

```text
Workflow Doctor Report → Checks → Evidence (W011) → SPEC source (W0xx)
```

## WDR016 — Success Criteria

- Doctor chỉ đọc machine-readable.
- Tổng hợp 46 checks từ 7 nguồn — không định nghĩa lại.
- Health Score xác định được từ Observability Data.
- Self-repair chỉ Low impact, có rollback, có Audit.
- Doctor không bypass Governance (W013).
- Report immutable (P005).

## Tham chiếu

- W011: `../W011/observability.md`
- W013: `../W013/governance.md`
- W014: `../W014/registry.md`
- W015: `../W015/resources.md`
- W016: `../W016/compliance.md`
- W017: `../W017/extensions.md`
- W018: `../W018/evolution.md`
- S019: `../../SPEC-001/S019/doctor.md` (mẫu)
- Constitution: `docs/specs/SPEC-000/`
