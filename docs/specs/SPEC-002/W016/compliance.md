---
name: spec-002-w016-compliance
description: >
  SPEC-002 W016 — Workflow Compliance. Trả lời: Doctor xác minh Workflow
  Engine như thế nào? Dùng S016 (Runtime) + Workflow-level rules — chặn cuối
  chuỗi Define → Enforce → Verify. Mirror S016 (SPEC-001).
agent: general
---

# W016 — Workflow Compliance

> **SPEC-002**: Workflow Engine · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Doctor xác minh Workflow Engine như thế nào?**

## WMC001 — Compliance Philosophy

- Compliance là xác minh, không phải thực thi (S016).
- Doctor chỉ đọc machine-readable (S011).
- Không định nghĩa lại quy tắc đã có.
- Certification cho từng Workflow Engine implementation.

## WMC002 — Compliance Principles

- Evidence Based · Machine-readable First · Deterministic · Verifiable · Non-invasive · Versioned (S016 CM002).

## WMC003 — Compliance Scope

Doctor xác minh:

- Constitution (SPEC-000)
- Boundary (W004)
- Contract (W007)
- Policy Binding (W012)
- Governance (W013)
- Registry (W014)
- Resources (W015)
- Observability (W011)

## WMC004 — Validation Rules (12)

| ID | Rule | Source | Severity |
|----|------|--------|----------|
| WVR-001 | Invalid Workflow | W009 | Critical |
| WVR-002 | Invalid Binding | W012 | Critical |
| WVR-003 | Boundary Violation | W004 | Critical |
| WVR-004 | Registry Violation | W014 | Critical |
| WVR-005 | Resource Leak | W015 | Critical |
| WVR-006 | Contract Failure | W007 | High |
| WVR-007 | Quota Violation | W015 | High |
| WVR-008 | Missing Workflow Event | W011 | High |
| WVR-009 | Missing Workflow Metrics | W011 | Medium |
| WVR-010 | Broken Workflow Trace | W011 | Medium |
| WVR-011 | Invalid Audit | W011 | Medium |
| WVR-012 | Constitution Violation | S013 | Critical |

## WMC005 — Compliance Matrix

| Nguồn | Kiểm tra |
|-------|----------|
| Constitution (SPEC-000) | Constitution Violation |
| Boundary (W004) | Boundary Violation |
| Contract (W007) | Contract Failure |
| Policy Binding (W012) | Invalid Binding |
| Governance (W013) | Missing Enforcement |
| Registry (W014) | Registry Violation |
| Resources (W015) | Resource Leak |
| Observability (W011) | Missing Workflow Event |

> Doctor chỉ cần đọc matrix.

## WMC006 — Health Score

- **Healthy · Degraded · Unhealthy** (S016 CM006).
- Nguồn: Workflow Execution (S009), Resource (W015), Event (W011), Metrics (W011), Policy (S012).
- CRITICAL → Unhealthy; chỉ warning → Degraded; không nói công thức.

## WMC007 — Readiness Checklist

- Workflow Definition Published (W009).
- Binding Active (W012).
- Registry hợp lệ (W014).
- Resources không leak (W015).
- Contracts hợp lệ (W007).
- Governance enforced (W013).
- Observability đầy đủ (W011).

**Result:** Ready → sẵn sàng. Not Ready → chặn Workflow mới (W013 Deny).

## WMC008 — Workflow Certification

- **Not Certified · Certified · Revoked** (S016 CM008).
- Requirements: 100% Pass; không CRITICAL; Health = Healthy.
- Revoked khi vi phạm CRITICAL; ghi Registry (W014).

## WMC009 — Verification Pipeline

```text
Collect Evidence (machine-readable)
    ↓
Validate Rules (workflow-compliance-matrix)
    ↓
Compute Score (workflow-health-score)
    ↓
Generate Report (workflow-compliance-report)
```

## WMC010 — Compliance Events

- WORKFLOW_COMPLIANCE_PASSED · FAILED · REPORTED · WORKFLOW_CERTIFICATION_GRANTED · REVOKED.

> S011 reuse trực tiếp.

## WMC011 — Compliance Metrics

- workflow_compliance_score · passed_rules · failed_rules · warning_rules · total_rules · certification_count.

## WMC012 — Compliance Audit

- Mỗi lần verify → Audit (S011).
- Doctor không sửa Workflow Engine — chỉ ghi nhận (Non-invasive).

## WMC013 — Compliance Report

```yaml
report:
  fields: [id, timestamp, workflow_version, matrix, score, status, certification, evidence]
```

Report immutable (P005).

## WMC014 — Machine-readable

```text
workflow-compliance.yaml
workflow-validation-rules.yaml
workflow-compliance-matrix.yaml
workflow-health-score.yaml
workflow-readiness-checklist.yaml
workflow-certification.yaml
workflow-compliance-events.yaml
workflow-compliance-metrics.yaml
workflow-compliance-report.yaml
workflow-compliance.schema.json
```

## WMC015 — Traceability

```text
Workflow Compliance Report
    ↓
Validation Rules (WVR)
    ↓
Evidence (W011 Event/Metrics/Trace/Audit)
    ↓
Workflow Execution (S009/S010)
    ↓
Constitution
```

## WMC016 — Success Criteria

- Doctor xác minh toàn bộ Workflow từ machine-readable.
- Mọi rule có nguồn rõ ràng (W0xx).
- Health Score xác định được từ Observability Data.
- Readiness Checklist chặn được Workflow chưa sẵn sàng.
- Certification chỉ cấp khi 100% Pass.
- Không định nghĩa lại quy tắc (dùng S016 + W0xx).

## Tham chiếu

- W004: `../W004/boundaries.md` · W007: `../W007/contracts.md`
- W011: `../W011/observability.md` · W012: `../W012/policies.md`
- W013: `../W013/governance.md` · W014: `../W014/registry.md`
- W015: `../W015/resources.md`
- S016: `../../SPEC-001/S016/compliance.md` (mẫu + rules)
- Constitution: `docs/specs/SPEC-000/`
