---
name: spec-001-s016-compliance
description: >
  SPEC-001 S016 — Runtime Compliance. Trả lời: Doctor xác minh Runtime như
  thế nào? Chặn cuối chuỗi Define → Enforce → Verify.
  Validation Rules, Compliance Matrix, Health Score, Readiness Checklist,
  Runtime Certification. 16 sections CM001-CM016.
agent: general
---

# S016 — Runtime Compliance

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: ✅ Review (2026-08-08)
> **Vai trò**: Chặn cuối chuỗi **Define → Enforce → Verify** — Doctor xác minh Runtime đã thực thi đúng các quy tắc hay chưa, không định nghĩa lại quy tắc.

## Mục tiêu

> **Doctor xác minh Runtime như thế nào?**

Chuỗi trách nhiệm đầy đủ:

```text
S004  Boundaries ──┐
S007  Contracts  ──┼── Define
S012  Policies   ──┘
        │
        ▼
S013  Governance ──── Enforce
        │
        ▼
S016  Compliance ──── Verify   ← bạn đang đọc
```

Không mô tả:

- implementation
- tool
- code

Chỉ mô tả **Compliance Model** — Doctor chỉ cần đọc machine-readable.

## CM001 — Compliance Philosophy

- Compliance là xác minh, không phải thực thi.
- Doctor chỉ đọc machine-readable (S011).
- Không định nghĩa lại quy tắc đã có.
- Certification cho từng Runtime implementation.

## CM002 — Compliance Principles

- Evidence Based
- Machine-readable First
- Deterministic
- Verifiable
- Non-invasive (verify không thay đổi Execution)
- Versioned (compliance report theo version)

## CM003 — Compliance Scope

Doctor xác minh:

- Constitution (SPEC-000)
- Boundary (S004)
- Contract (S007)
- Policy (S012)
- Governance (S013)
- Registry (S014)
- Resources (S015)
- Observability (S011)

## CM004 — Validation Rules

23 rules tổng hợp từ các SPEC (mỗi rule có id, source, severity):

- Missing Enforcement (S013) · Invalid Policy (S013) · Invalid Contract (S013)
- Boundary Violation (S013) · Constitution Violation (S013) · Version Conflict (S013)
- Missing Entry (S014) · Duplicate ID (S014) · Broken Reference (S014)
- Circular Reference (S014) · Orphan Entry (S014) · Dangling Reference (S014)
- Duplicate Active Version (S014) · Missing Compatibility (S014) · Invalid Lifecycle (S014)
- Double Allocation (S015) · Resource Leak (S015) · Quota Violation (S015)
- Missing Event (S011) · Missing Metrics (S011) · Broken Trace (S011)
- Broken Lineage (S011) · Invalid Audit (S011)

## CM005 — Compliance Matrix

| Nguồn | Kiểm tra |
|-------|----------|
| Constitution (SPEC-000) | Constitution Violation |
| Boundary (S004) | Boundary Violation |
| Contract (S007) | Invalid Contract |
| Policy (S012) | Invalid Policy |
| Governance (S013) | Missing Enforcement |
| Registry (S014) | Broken Reference |
| Resources (S015) | Resource Leak |
| Observability (S011) | Missing Event |

> Doctor chỉ cần đọc matrix.

## CM006 — Health Score

- **Healthy**
- **Degraded**
- **Unhealthy**

Health được xác định từ Observability Data (S011 OB009 — nguồn: Execution, Resource, Event, Metrics, Policy).

**Rules:**

- CRITICAL violation → Unhealthy.
- Chỉ warning → Degraded.
- Không vi phạm → Healthy.

> Không nói công thức.

## CM007 — Readiness Checklist

Trước khi Runtime sẵn sàng nhận Execution:

- Constitution hợp lệ.
- Registry hợp lệ (không orphan, không circular).
- Resources không leak, không double allocation.
- Contracts hợp lệ.
- Policies Active, không conflict.
- Governance enforced đầy đủ.
- Observability đầy đủ (Event/Metrics/Trace/Audit).

**Result:** Ready → sẵn sàng. Not Ready → chặn Execution mới (S013 Deny).

## CM008 — Runtime Certification

Cấp cho từng implementation (C#, Go, Rust, Python...):

- **Not Certified** · **Certified** · **Revoked**

**Requirements:** 100% validation rules Pass; không CRITICAL violation; Health Score = Healthy.

**Rules:** Revoked khi vi phạm CRITICAL; Certification ghi vào Registry (S014); là evidence trong Compliance Report.

## CM009 — Verification Pipeline

```text
Collect Evidence (machine-readable)
    ↓
Validate Rules (compliance-matrix)
    ↓
Compute Score (health-score)
    ↓
Generate Report (compliance-report)
```

## CM010 — Compliance Events

- COMPLIANCE_PASSED
- COMPLIANCE_FAILED
- COMPLIANCE_REPORTED
- CERTIFICATION_GRANTED
- CERTIFICATION_REVOKED

> S016 định nghĩa 5 event types (CM010) — S011 cung cấp event model (fields, correlation_id).

## CM011 — Compliance Metrics

- compliance_score
- passed_rules
- failed_rules
- warning_rules
- total_rules
- certification_count

## CM012 — Compliance Audit

- Mỗi lần verify → Audit (S011).
- Mỗi report → Evidence → Audit.
- Doctor không sửa Runtime — chỉ ghi nhận (Non-invasive).

## CM013 — Compliance Report

```yaml
report:
  fields: [id, timestamp, runtime_version, matrix, score, status, certification, evidence]
```

**Rules:** Report immutable (P010); mỗi report sinh COMPLIANCE_REPORTED; evidence trỏ đến machine-readable cụ thể.

## CM014 — Machine-readable

```text
compliance.yaml
validation-rules.yaml
compliance-matrix.yaml
health-score.yaml
readiness-checklist.yaml
runtime-certification.yaml
compliance-events.yaml
compliance-metrics.yaml
compliance-report.yaml
compliance.schema.json
```

## CM015 — Traceability

```text
Compliance Report
    ↓
Validation Rules
    ↓
Evidence (S011 Event/Metrics/Trace/Audit)
    ↓
Execution
    ↓
Constitution
```

## CM016 — Success Criteria

- Doctor xác minh toàn bộ Runtime từ machine-readable.
- Mọi rule có nguồn rõ ràng (SPEC + section).
- Health Score xác định được từ Observability Data.
- Readiness Checklist chặn được Runtime chưa sẵn sàng.
- Certification chỉ cấp khi 100% Pass.
- Không chứa Business Logic.
- Không định nghĩa lại quy tắc của SPEC khác.

## Tham chiếu

- `compliance.yaml` — nguồn dữ liệu chuẩn
- `validation-rules.yaml` · `compliance-matrix.yaml` · `health-score.yaml`
- `readiness-checklist.yaml` · `runtime-certification.yaml`
- `compliance-events.yaml` · `compliance-metrics.yaml` · `compliance-report.yaml`
- `compliance.schema.json`
- S004: `../S004/boundaries.md` · S007: `../S007/contracts.md`
- S011: `../S011/observability.md` · S012: `../S012/policies.md`
- S013: `../S013/governance.md` · S014: `../S014/registry.md`
- S015: `../S015/resources.md`
- Constitution: `docs/specs/SPEC-000/`
