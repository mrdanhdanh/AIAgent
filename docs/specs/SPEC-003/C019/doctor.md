---
name: spec-003-c019-doctor
description: >
  SPEC-003 C019 — Capability Doctor. Trả lời: Doctor kiểm tra sức khỏe
  Capability System như thế nào? Tổng hợp checks từ C011..C018 + S016,
  Health Score, self-repair an toàn. Mirror W019 (SPEC-002).
agent: general
---

# C019 — Capability Doctor

> **SPEC-003**: Capability System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Doctor kiểm tra sức khỏe Capability System như thế nào?**

## CDR001 — Doctor Philosophy

- Capability Doctor là cơ chế kiểm tra sức khỏe Capability System.
- Doctor chỉ đọc machine-readable (C011).
- Không định nghĩa lại quy tắc (C016 đã tổng hợp).
- Self-repair chỉ thay đổi an toàn, có giới hạn.

## CDR002 — Doctor Principles

- Evidence Based · Machine-readable First · Non-invasive · Deterministic · Repairable · Auditable.

## CDR003 — Doctor Scope

**Kiểm tra 9 domain:**

- Constitution (SPEC-000) · Contracts (C007) · Policy Binding (C012) · Governance (C013) · Registry (C014) · Resources (C015) · Compliance (C016) · Extensions (C017) · Observability (C011).

**Không đọc:** Implementation · Business Data · Agent Internal State · Plugin Internal State.

## CDR004 — Check Categories

| Nguồn | Số checks |
|-------|-----------|
| C011 Observability | 5 |
| C013 Governance | 6 |
| C014 Registry | 7 |
| C015 Resources | 5 |
| C016 Compliance | 12 |
| C017 Extensions | 6 |
| C018 Evolution | 6 |

> Tổng: **47 checks** — tham chiếu, không định nghĩa lại.

## CDR005 — Health Score

- **Healthy · Degraded · Unhealthy** (C016 CMC006).

## CDR006 — Doctor Pipeline

```text
Collect (machine-readable)
    ↓
Validate (checks per domain)
    ↓
Score (health — C016 CMC006)
    ↓
Report (capability-doctor-report)
    ↓
Repair (nếu an toàn, self-repair)
```

Mỗi lần chạy sinh CAPABILITY_DOCTOR_RUN + Audit (C011).

## CDR007 — Doctor Checks

47 checks từ 7 nguồn (CDR004). Mỗi check: có evidence (C011), có SPEC source, kết quả Pass/Warning/Fail.

## CDR008 — Self-Repair

- Chỉ **Low impact**.
- Qua Approval (C013) hoặc auto cho quen thuộc.
- Có rollback.
- Ghi Audit (C011).
- **Không sửa implementation.**
- Không Repair vi phạm CRITICAL — báo cáo lên người.

## CDR009 — Doctor Report

```yaml
report:
  fields: [id, timestamp, capability_version, checks, score, status, repair, evidence]
```

Report immutable (P005).

## CDR010 — Doctor Events

- CAPABILITY_DOCTOR_RUN · PASSED · FAILED · REPORTED · REPAIRED.

> S011 reuse trực tiếp.

## CDR011 — Doctor Metrics

- health_score · passed_checks · failed_checks · warning_checks · total_checks · repair_count.

## CDR012 — Doctor Governance

- Doctor không bypass Governance (C013).
- Repair qua Approval Gate (C013).
- Vi phạm CRITICAL → báo cáo lên người.
- Mọi hành động ghi Audit (C011).

## CDR013 — Doctor Registry

- Doctor kiểm tra Registry (C014) là một trong 9 domain.
- Certification (C016) dựa trên Capability Doctor Report.

## CDR014 — Machine-readable

```text
capability-doctor.yaml
capability-doctor-scope.yaml
capability-doctor-checks.yaml
capability-doctor-pipeline.yaml
capability-doctor-self-repair.yaml
capability-doctor-report.yaml
capability-doctor-events.yaml
capability-doctor-metrics.yaml
capability-doctor-validation.yaml
capability-doctor.schema.json
```

## CDR015 — Traceability

```text
Capability Doctor Report → Checks → Evidence (C011) → SPEC source (C0xx)
```

## CDR016 — Success Criteria

- Doctor chỉ đọc machine-readable.
- Tổng hợp 47 checks từ 7 nguồn — không định nghĩa lại.
- Health Score xác định được từ Observability Data.
- Self-repair chỉ Low impact, có rollback, có Audit.
- Doctor không bypass Governance (C013).
- Report immutable (P005).

## Tham chiếu

- C011: `../C011/observability.md`
- C013: `../C013/governance.md`
- C014: `../C014/registry.md`
- C015: `../C015/resources.md`
- C016: `../C016/compliance.md`
- C017: `../C017/extensions.md`
- C018: `../C018/evolution.md`
- W019: `../../SPEC-002/W019/doctor.md` (mẫu)
- Constitution: `docs/specs/SPEC-000/`
