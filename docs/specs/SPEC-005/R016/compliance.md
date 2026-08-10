---
name: spec-005-r016-compliance
description: SPEC-005 R016 — Registry Compliance. 12 RVR.
agent: general
---

# R016 — Registry Compliance

> **SPEC-005**: Registry · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Doctor xác minh Registry như thế nào?**

## RMC001 — Compliance Philosophy

- Compliance là xác minh, không phải thực thi (S016).
- Doctor chỉ đọc machine-readable (S011).
- Không định nghĩa lại quy tắc đã có.

## RMC002 — Compliance Principles

- Evidence Based · Machine-readable First · Deterministic · Verifiable · Non-invasive · Versioned (S016 CM002).

## RMC003 — Compliance Scope

- Constitution · Boundary (R004) · Contract (R007) · Policy Binding (R012) · Governance (R013) · Registry-of-Registries (R014) · Resources (R015) · Observability (R011).

## RMC004 — Validation Rules (12)

| ID | Rule | Source | Severity |
|----|------|--------|----------|
| RVR-001 | Invalid Entry | R009 | Critical |
| RVR-002 | Invalid Binding | R012 | Critical |
| RVR-003 | Boundary Violation | R004 | Critical |
| RVR-004 | Registry Violation | R014 | Critical |
| RVR-005 | Resource Leak | R015 | Critical |
| RVR-006 | Contract Failure | R007 | High |
| RVR-007 | Quota Violation | R015 | High |
| RVR-008 | Missing Registry Event | R011 | High |
| RVR-009 | Missing Registry Metrics | R011 | Medium |
| RVR-010 | Broken Registry Trace | R011 | Medium |
| RVR-011 | Invalid Audit | R011 | Medium |
| RVR-012 | Constitution Violation | S013 | Critical |

## RMC005 — Compliance Matrix

- 8 dòng (Constitution → Observability) — Doctor chỉ cần đọc matrix.

## RMC006 — Health Score

- Healthy · Degraded · Unhealthy (S016 CM006). CRITICAL → Unhealthy; warning → Degraded.

## RMC007 — Readiness Checklist

- Entry Published (R009) · Binding Active (R012) · Registry-of-Registries hợp lệ (R014) · Resources không leak (R015) · Contracts hợp lệ (R007) · Governance enforced (R013) · Observability đầy đủ (R011).

## RMC008 — Registry Certification

- Not Certified · Certified · Revoked — 100% Pass.

## RMC009 — Verification Pipeline

```text
Collect Evidence → Validate Rules → Compute Score → Generate Report
```

## RMC010 — Compliance Events

- REGISTRY_COMPLIANCE_PASSED · FAILED · REPORTED · CERTIFICATION_GRANTED · REVOKED.

## RMC011 — Compliance Metrics

- registry_compliance_score · passed_rules · failed_rules · warning_rules · total_rules · certification_count.

## RMC012 — Compliance Audit

- Mỗi lần verify → Audit (S011). Doctor không sửa Registry (Non-invasive).

## RMC013 — Compliance Report

```yaml
report:
  fields: [id, timestamp, registry_version, matrix, score, status, certification, evidence]
```

Report immutable (P010).

## RMC014 — Machine-readable

```text
registry-compliance.yaml
registry-validation-rules.yaml
registry-compliance-matrix.yaml
registry-health-score.yaml
registry-readiness-checklist.yaml
registry-certification.yaml
registry-compliance-events.yaml
registry-compliance-metrics.yaml
registry-compliance-report.yaml
registry-compliance.schema.json
```

## RMC015 — Traceability

```text
Registry Compliance Report → Rules (RVR) → Evidence (R011) → Entry Execution → Constitution
```

## RMC016 — Success Criteria

- Doctor xác minh toàn bộ Registry từ machine-readable. · Health Score từ Observability Data. · Certification chỉ cấp khi 100% Pass.

## Tham chiếu

- S016: `../../SPEC-001/S016/compliance.md`
- Constitution: `docs/specs/SPEC-000/`
