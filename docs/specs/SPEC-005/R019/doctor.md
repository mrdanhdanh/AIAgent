---
name: spec-005-r019-doctor
description: SPEC-005 R019 — Registry Doctor. 47 checks.
agent: general
---

# R019 — Registry Doctor

> **SPEC-005**: Registry · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Doctor kiểm tra sức khỏe Registry như thế nào?**

## RDR001 — Doctor Philosophy

- Registry Doctor kiểm tra sức khỏe Registry.
- Doctor chỉ đọc machine-readable (R011).
- Không định nghĩa lại quy tắc (R016 đã tổng hợp).
- Self-repair chỉ thay đổi an toàn, có giới hạn.

## RDR002 — Doctor Principles

- Evidence Based · Machine-readable First · Non-invasive · Deterministic · Repairable · Auditable.

## RDR003 — Doctor Scope

- 9 domains: Constitution · Contracts (R007) · Policy Binding (R012) · Governance (R013) · Registry-of-Registries (R014) · Resources (R015) · Compliance (R016) · Extensions (R017) · Observability (R011).

## RDR004 — Check Categories

| Nguồn | Số checks |
|-------|-----------|
| R011 Observability | 5 |
| R013 Governance | 6 |
| R014 Registry-of-Registries | 7 |
| R015 Resources | 5 |
| R016 Compliance | 12 |
| R017 Extensions | 6 |
| R018 Evolution | 6 |

> Tổng: **47 checks** — tham chiếu, không định nghĩa lại.

## RDR005 — Health Score

- Healthy · Degraded · Unhealthy (R016 RMC006).

## RDR006 — Doctor Pipeline

```text
Collect → Validate → Score → Report → Repair
```

## RDR007 — Doctor Checks

- 47 checks từ 7 nguồn. Mỗi check: evidence (R011), SPEC source, Pass/Warning/Fail.

## RDR008 — Self-Repair

- Chỉ Low impact · Qua Approval (R013) · Có rollback · Ghi Audit (R011) · Không sửa implementation · Không Repair CRITICAL (báo cáo người).

## RDR009 — Doctor Report

```yaml
report:
  fields: [id, timestamp, registry_version, checks, score, status, repair, evidence]
```

Report immutable (P005).

## RDR010 — Doctor Events

- REGISTRY_DOCTOR_RUN · PASSED · FAILED · REPORTED · REPAIRED.

## RDR011 — Doctor Metrics

- health_score · passed_checks · failed_checks · warning_checks · total_checks · repair_count.

## RDR012 — Doctor Governance

- Doctor không bypass Governance (R013). · Repair qua Approval Gate. · CRITICAL → báo cáo người.

## RDR013 — Doctor Registry

- Doctor kiểm tra Registry-of-Registries (R014). · Certification (R016) dựa trên Doctor Report.

## RDR014 — Machine-readable

```text
registry-doctor.yaml
registry-doctor-scope.yaml
registry-doctor-checks.yaml
registry-doctor-pipeline.yaml
registry-doctor-self-repair.yaml
registry-doctor-report.yaml
registry-doctor-events.yaml
registry-doctor-metrics.yaml
registry-doctor-validation.yaml
registry-doctor.schema.json
```

## RDR015 — Traceability

```text
Registry Doctor Report → Checks → Evidence (R011) → SPEC source (R0xx)
```

## RDR016 — Success Criteria

- Doctor chỉ đọc machine-readable. · 47 checks từ 7 nguồn. · Self-repair an toàn. · Không bypass Governance (R013). · Report immutable (P005).

## Tham chiếu

- R016: `../R016/compliance.md`
- S019: `../../SPEC-001/S019/doctor.md`
- Constitution: `docs/specs/SPEC-000/`
