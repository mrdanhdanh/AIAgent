---
name: spec-004-a019-doctor
description: >
  SPEC-004 A019 — Agent Doctor. Trả lời: Doctor kiểm tra sức khỏe Agent System
  như thế nào? Tổng hợp checks từ A011..A018 + S016, Health Score, self-repair
  an toàn. Mirror C019 (SPEC-003).
agent: general
---

# A019 — Agent Doctor

> **SPEC-004**: Agent System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Doctor kiểm tra sức khỏe Agent System như thế nào?**

## ADR001 — Doctor Philosophy

- Agent Doctor là cơ chế kiểm tra sức khỏe Agent System.
- Doctor chỉ đọc machine-readable (A011).
- Không định nghĩa lại quy tắc (A016 đã tổng hợp).
- Self-repair chỉ thay đổi an toàn, có giới hạn.

## ADR002 — Doctor Principles

- Evidence Based · Machine-readable First · Non-invasive · Deterministic · Repairable · Auditable.

## ADR003 — Doctor Scope

**Kiểm tra 9 domain:**

- Constitution (SPEC-000) · Contracts (A007) · Policy Binding (A012) · Governance (A013) · Registry (A014) · Resources (A015) · Compliance (A016) · Extensions (A017) · Observability (A011).

**Không đọc:** Implementation · Business Data · Agent Internal State · Plugin Internal State.

## ADR004 — Check Categories

| Nguồn | Số checks |
|-------|-----------|
| A011 Observability | 5 |
| A013 Governance | 6 |
| A014 Registry | 7 |
| A015 Resources | 5 |
| A016 Compliance | 12 |
| A017 Extensions | 6 |
| A018 Evolution | 6 |

> Tổng: **47 checks** — tham chiếu, không định nghĩa lại.

## ADR005 — Health Score

- **Healthy · Degraded · Unhealthy** (A016 AMC006).

## ADR006 — Doctor Pipeline

```text
Collect (machine-readable)
    ↓
Validate (checks per domain)
    ↓
Score (health — A016 AMC006)
    ↓
Report (agent-doctor-report)
    ↓
Repair (nếu an toàn, self-repair)
```

Mỗi lần chạy sinh AGENT_DOCTOR_RUN + Audit (A011).

## ADR007 — Doctor Checks

47 checks từ 7 nguồn (ADR004). Mỗi check: có evidence (A011), có SPEC source, kết quả Pass/Warning/Fail.

## ADR008 — Self-Repair

- Chỉ **Low impact**.
- Qua Approval (A013) hoặc auto cho quen thuộc.
- Có rollback.
- Ghi Audit (A011).
- **Không sửa implementation.**
- Không Repair vi phạm CRITICAL — báo cáo lên người.

## ADR009 — Doctor Report

```yaml
report:
  fields: [id, timestamp, agent_version, checks, score, status, repair, evidence]
```

Report immutable (P010).

## ADR010 — Doctor Events

- AGENT_DOCTOR_RUN · PASSED · FAILED · REPORTED · REPAIRED.

> S011 reuse trực tiếp.

## ADR011 — Doctor Metrics

- health_score · passed_checks · failed_checks · warning_checks · total_checks · repair_count.

## ADR012 — Doctor Governance

- Doctor không bypass Governance (A013).
- Repair qua Approval Gate (A013).
- Vi phạm CRITICAL → báo cáo lên người.
- Mọi hành động ghi Audit (A011).

## ADR013 — Doctor Registry

- Doctor kiểm tra Registry (A014) là một trong 9 domain.
- Certification (A016) dựa trên Agent Doctor Report.

## ADR014 — Machine-readable

```text
agent-doctor.yaml
agent-doctor-scope.yaml
agent-doctor-checks.yaml
agent-doctor-pipeline.yaml
agent-doctor-self-repair.yaml
agent-doctor-report.yaml
agent-doctor-events.yaml
agent-doctor-metrics.yaml
agent-doctor-validation.yaml
agent-doctor.schema.json
```

## ADR015 — Traceability

```text
Agent Doctor Report → Checks → Evidence (A011) → SPEC source (A0xx)
```

## ADR016 — Success Criteria

- Doctor chỉ đọc machine-readable.
- Tổng hợp 47 checks từ 7 nguồn — không định nghĩa lại.
- Health Score xác định được từ Observability Data.
- Self-repair chỉ Low impact, có rollback, có Audit.
- Doctor không bypass Governance (A013).
- Report immutable (P010).

## Tham chiếu

- A011: `../A011/observability.md`
- A013: `../A013/governance.md`
- A014: `../A014/registry.md`
- A015: `../A015/resources.md`
- A016: `../A016/compliance.md`
- A017: `../A017/extensions.md`
- A018: `../A018/evolution.md`
- C019: `../../SPEC-003/C019/doctor.md` (mẫu)
- Constitution: `docs/specs/SPEC-000/`