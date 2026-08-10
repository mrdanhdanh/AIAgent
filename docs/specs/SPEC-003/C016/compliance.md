---
name: spec-003-c016-compliance
description: >
  SPEC-003 C016 — Capability Compliance. Trả lời: Doctor xác minh Capability
  System như thế nào? Dùng S016 (Runtime) + Capability-level rules — chặn
  cuối chuỗi Define → Enforce → Verify. Mirror W016 (SPEC-002).
agent: general
---

# C016 — Capability Compliance

> **SPEC-003**: Capability System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Doctor xác minh Capability System như thế nào?**

## CMC001 — Compliance Philosophy

- Compliance là xác minh, không phải thực thi (S016).
- Doctor chỉ đọc machine-readable (S011).
- Không định nghĩa lại quy tắc đã có.
- Certification cho từng Capability System implementation.

## CMC002 — Compliance Principles

- Evidence Based · Machine-readable First · Deterministic · Verifiable · Non-invasive · Versioned (S016 CM002).

## CMC003 — Compliance Scope

Doctor xác minh:

- Constitution (SPEC-000)
- Boundary (C004)
- Contract (C007)
- Policy Binding (C012)
- Governance (C013)
- Registry (C014)
- Resources (C015)
- Observability (C011)

## CMC004 — Validation Rules (12)

| ID | Rule | Source | Severity |
|----|------|--------|----------|
| CVR-001 | Invalid Capability | C009 | Critical |
| CVR-002 | Invalid Binding | C012 | Critical |
| CVR-003 | Boundary Violation | C004 | Critical |
| CVR-004 | Registry Violation | C014 | Critical |
| CVR-005 | Resource Leak | C015 | Critical |
| CVR-006 | Contract Failure | C007 | High |
| CVR-007 | Quota Violation | C015 | High |
| CVR-008 | Missing Capability Event | C011 | High |
| CVR-009 | Missing Capability Metrics | C011 | Medium |
| CVR-010 | Broken Capability Trace | C011 | Medium |
| CVR-011 | Invalid Audit | C011 | Medium |
| CVR-012 | Constitution Violation | S013 | Critical |

## CMC005 — Compliance Matrix

| Nguồn | Kiểm tra |
|-------|----------|
| Constitution (SPEC-000) | Constitution Violation |
| Boundary (C004) | Boundary Violation |
| Contract (C007) | Contract Failure |
| Policy Binding (C012) | Invalid Binding |
| Governance (C013) | Missing Enforcement |
| Registry (C014) | Registry Violation |
| Resources (C015) | Resource Leak |
| Observability (C011) | Missing Capability Event |

> Doctor chỉ cần đọc matrix.

## CMC006 — Health Score

- **Healthy · Degraded · Unhealthy** (S016 CM006).
- Nguồn: Capability Execution (S009), Resource (C015), Event (C011), Metrics (C011), Policy (S012).
- CRITICAL → Unhealthy; chỉ warning → Degraded; không nói công thức.

## CMC007 — Readiness Checklist

- Capability Definition Published (C009).
- Binding Active (C012).
- Registry hợp lệ (C014).
- Resources không leak (C015).
- Contracts hợp lệ (C007).
- Governance enforced (C013).
- Observability đầy đủ (C011).

**Result:** Ready → sẵn sàng. Not Ready → chặn Capability mới (C013 Deny).

## CMC008 — Capability Certification

- **Not Certified · Certified · Revoked** (S016 CM008).
- Requirements: 100% Pass; không CRITICAL; Health = Healthy.
- Revoked khi vi phạm CRITICAL; ghi Registry (C014).

## CMC009 — Verification Pipeline

```text
Collect Evidence (machine-readable)
    ↓
Validate Rules (capability-compliance-matrix)
    ↓
Compute Score (capability-health-score)
    ↓
Generate Report (capability-compliance-report)
```

## CMC010 — Compliance Events

- CAPABILITY_COMPLIANCE_PASSED · FAILED · REPORTED · CAPABILITY_CERTIFICATION_GRANTED · REVOKED.

> C016 định nghĩa 5 event types — S011 cung cấp event model (fields, correlation_id).

## CMC011 — Compliance Metrics

- capability_compliance_score · passed_rules · failed_rules · warning_rules · total_rules · certification_count.

## CMC012 — Compliance Audit

- Mỗi lần verify → Audit (S011).
- Doctor không sửa Capability System — chỉ ghi nhận (Non-invasive).

## CMC013 — Compliance Report

```yaml
report:
  fields: [id, timestamp, capability_version, matrix, score, status, certification, evidence]
```

Report immutable (P010).

## CMC014 — Machine-readable

```text
capability-compliance.yaml
capability-validation-rules.yaml
capability-compliance-matrix.yaml
capability-health-score.yaml
capability-readiness-checklist.yaml
capability-certification.yaml
capability-compliance-events.yaml
capability-compliance-metrics.yaml
capability-compliance-report.yaml
capability-compliance.schema.json
```

## CMC015 — Traceability

```text
Capability Compliance Report
    ↓
Validation Rules (CVR)
    ↓
Evidence (C011 Event/Metrics/Trace/Audit)
    ↓
Capability Execution (S009/S010)
    ↓
Constitution
```

## CMC016 — Success Criteria

- Doctor xác minh toàn bộ Capability từ machine-readable.
- Mọi rule có nguồn rõ ràng (C0xx).
- Health Score xác định được từ Observability Data.
- Readiness Checklist chặn được Capability chưa sẵn sàng.
- Certification chỉ cấp khi 100% Pass.
- Không định nghĩa lại quy tắc (dùng S016 + C0xx).

## Tham chiếu

- C004: `../C004/boundaries.md` · C007: `../C007/contracts.md`
- C011: `../C011/observability.md` · C012: `../C012/policies.md`
- C013: `../C013/governance.md` · C014: `../C014/registry.md`
- C015: `../C015/resources.md`
- W016: `../../SPEC-002/W016/compliance.md` (mẫu)
- S016: `../../SPEC-001/S016/compliance.md` (rules)
- Constitution: `docs/specs/SPEC-000/`
