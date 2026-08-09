---
name: spec-004-a016-compliance
description: >
  SPEC-004 A016 — Agent Compliance. Trả lời: Doctor xác minh Agent System như
  thế nào? Dùng S016 (Runtime) + Agent-level rules — chặn cuối chuỗi
  Define → Enforce → Verify. Mirror C016 (SPEC-003).
agent: general
---

# A016 — Agent Compliance

> **SPEC-004**: Agent System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Doctor xác minh Agent System như thế nào?**

## AMC001 — Compliance Philosophy

- Compliance là xác minh, không phải thực thi (S016).
- Doctor chỉ đọc machine-readable (S011).
- Không định nghĩa lại quy tắc đã có.
- Certification cho từng Agent System implementation.

## AMC002 — Compliance Principles

- Evidence Based · Machine-readable First · Deterministic · Verifiable · Non-invasive · Versioned (S016 CM002).

## AMC003 — Compliance Scope

Doctor xác minh:

- Constitution (SPEC-000)
- Boundary (A004)
- Contract (A007)
- Policy Binding (A012)
- Governance (A013)
- Registry (A014)
- Resources (A015)
- Observability (A011)

## AMC004 — Validation Rules (12)

| ID | Rule | Source | Severity |
|----|------|--------|----------|
| AVR-001 | Invalid Agent | A009 | Critical |
| AVR-002 | Invalid Binding | A012 | Critical |
| AVR-003 | Boundary Violation | A004 | Critical |
| AVR-004 | Registry Violation | A014 | Critical |
| AVR-005 | Resource Leak | A015 | Critical |
| AVR-006 | Contract Failure | A007 | High |
| AVR-007 | Quota Violation | A015 | High |
| AVR-008 | Missing Agent Event | A011 | High |
| AVR-009 | Missing Agent Metrics | A011 | Medium |
| AVR-010 | Broken Agent Trace | A011 | Medium |
| AVR-011 | Invalid Audit | A011 | Medium |
| AVR-012 | Constitution Violation | S013 | Critical |

## AMC005 — Compliance Matrix

| Nguồn | Kiểm tra |
|-------|----------|
| Constitution (SPEC-000) | Constitution Violation |
| Boundary (A004) | Boundary Violation |
| Contract (A007) | Contract Failure |
| Policy Binding (A012) | Invalid Binding |
| Governance (A013) | Missing Enforcement |
| Registry (A014) | Registry Violation |
| Resources (A015) | Resource Leak |
| Observability (A011) | Missing Agent Event |

> Doctor chỉ cần đọc matrix.

## AMC006 — Health Score

- **Healthy · Degraded · Unhealthy** (S016 CM006).
- Nguồn: Agent Execution (S009), Resource (A015), Event (A011), Metrics (A011), Policy (S012).
- CRITICAL → Unhealthy; chỉ warning → Degraded; không nói công thức.

## AMC007 — Readiness Checklist

- Agent Definition Published (A009).
- Binding Active (A012).
- Registry hợp lệ (A014).
- Resources không leak (A015).
- Contracts hợp lệ (A007).
- Governance enforced (A013).
- Observability đầy đủ (A011).

**Result:** Ready → sẵn sàng. Not Ready → chặn Agent mới (A013 Deny).

## AMC008 — Agent Certification

- **Not Certified · Certified · Revoked** (S016 CM008).
- Requirements: 100% Pass; không CRITICAL; Health = Healthy.
- Revoked khi vi phạm CRITICAL; ghi Registry (A014).

## AMC009 — Verification Pipeline

```text
Collect Evidence (machine-readable)
    ↓
Validate Rules (agent-compliance-matrix)
    ↓
Compute Score (agent-health-score)
    ↓
Generate Report (agent-compliance-report)
```

## AMC010 — Compliance Events

- AGENT_COMPLIANCE_PASSED · FAILED · REPORTED · AGENT_CERTIFICATION_GRANTED · REVOKED.

> S011 reuse trực tiếp.

## AMC011 — Compliance Metrics

- agent_compliance_score · passed_rules · failed_rules · warning_rules · total_rules · certification_count.

## AMC012 — Compliance Audit

- Mỗi lần verify → Audit (S011).
- Doctor không sửa Agent System — chỉ ghi nhận (Non-invasive).

## AMC013 — Compliance Report

```yaml
report:
  fields: [id, timestamp, agent_version, matrix, score, status, certification, evidence]
```

Report immutable (P005).

## AMC014 — Machine-readable

```text
agent-compliance.yaml
agent-validation-rules.yaml
agent-compliance-matrix.yaml
agent-health-score.yaml
agent-readiness-checklist.yaml
agent-certification.yaml
agent-compliance-events.yaml
agent-compliance-metrics.yaml
agent-compliance-report.yaml
agent-compliance.schema.json
```

## AMC015 — Traceability

```text
Agent Compliance Report
    ↓
Validation Rules (AVR)
    ↓
Evidence (A011 Event/Metrics/Trace/Audit)
    ↓
Agent Execution (S009/S010)
    ↓
Constitution
```

## AMC016 — Success Criteria

- Doctor xác minh toàn bộ Agent từ machine-readable.
- Mọi rule có nguồn rõ ràng (A0xx).
- Health Score xác định được từ Observability Data.
- Readiness Checklist chặn được Agent chưa sẵn sàng.
- Certification chỉ cấp khi 100% Pass.
- Không định nghĩa lại quy tắc (dùng S016 + A0xx).

## Tham chiếu

- A004: `../A004/boundaries.md` · A007: `../A007/contracts.md`
- A011: `../A011/observability.md` · A012: `../A012/policies.md`
- A013: `../A013/governance.md` · A014: `../A014/registry.md`
- A015: `../A015/resources.md`
- C016: `../../SPEC-003/C016/compliance.md` (mẫu)
- S016: `../../SPEC-001/S016/compliance.md` (rules)
- Constitution: `docs/specs/SPEC-000/`