---
name: spec-001-s019-doctor
description: >
  SPEC-001 S019 — Runtime Doctor. Trả lời: Doctor kiểm tra sức khỏe Runtime
  như thế nào? Tổng hợp checks từ S011..S020, Health Score, self-repair an
  toàn. 16 sections DR001-DR016.
agent: general
---

# S019 — Runtime Doctor

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: ✅ Frozen (2026-08-08)
> **Vai trò**: Kiểm tra sức khỏe Runtime — tổng hợp toàn bộ checks từ S011..S020, không định nghĩa lại quy tắc (S016 đã tổng hợp).

## Mục tiêu

> **Doctor kiểm tra sức khỏe Runtime như thế nào?**

Không mô tả:

- implementation
- tool
- code

Chỉ mô tả **Doctor Model** — Doctor chỉ đọc machine-readable (S011).

## DR001 — Doctor Philosophy

- Doctor là cơ chế kiểm tra sức khỏe Runtime.
- Doctor chỉ đọc machine-readable (S011).
- Không định nghĩa lại quy tắc (S016 đã tổng hợp).
- Self-repair chỉ thay đổi an toàn, có giới hạn.

## DR002 — Doctor Principles

- Evidence Based
- Machine-readable First
- Non-invasive
- Deterministic
- Repairable (self-repair an toàn)
- Auditable

## DR003 — Doctor Scope

**Kiểm tra 10 domain:**

- Constitution (SPEC-000)
- Contracts (S007)
- Policies (S012)
- Governance (S013)
- Registry (S014)
- Resources (S015)
- Compliance (S016)
- Plugins (S017)
- Observability (S011)
- Dashboard (S020)

**Không đọc:**

- Implementation
- Business Data
- Agent Internal State
- Plugin Internal State

## DR004 — Check Categories

| Nguồn | Số checks | Tham chiếu |
|-------|-----------|------------|
| S011 Observability | 5 | OB011 |
| S013 Governance | 6 | GV017 |
| S014 Registry | 11 | RG011 |
| S015 Resources | 6 | RS014 |
| S016 Compliance | 23 | CM004 |
| S017 Plugins | 6 | PL016 |
| S018 Evolution | 6 | EV014 |
| S020 Dashboard | 5 | DB013 |

> Tổng: 68 checks — tham chiếu, không định nghĩa lại.

## DR005 — Health Score

- **Healthy**
- **Degraded**
- **Unhealthy**

Từ S016 CM006 (Health xác định từ Observability Data — không nói công thức).

## DR006 — Doctor Pipeline

```text
Collect (machine-readable)
    ↓
Validate (checks per domain)
    ↓
Score (health — S016 CM006)
    ↓
Report (doctor-report)
    ↓
Repair (nếu an toàn, self-repair)
```

**Rules:** Mỗi lần chạy sinh DOCTOR_RUN + Audit (S011); kết quả deterministic — cùng trạng thái, cùng kết quả.

## DR007 — Doctor Checks

Doctor chạy 68 checks từ 8 nguồn (DR004). Mỗi check:

- Có evidence (S011).
- Có SPEC source.
- Kết quả: Pass / Warning / Fail.

## DR008 — Self-Repair

- Chỉ **Low impact**.
- Qua Approval (S013) hoặc auto cho quen thuộc.
- Có rollback.
- Ghi Audit (S011).
- **Không sửa implementation.**
- Không Repair vi phạm CRITICAL — báo cáo lên người.

## DR009 — Doctor Report

```yaml
report:
  fields: [id, timestamp, runtime_version, checks, score, status, repair, evidence]
```

**Rules:** Report immutable (P010); mỗi report sinh DOCTOR_REPORTED (S011).

## DR010 — Doctor Events

- DOCTOR_RUN
- DOCTOR_PASSED
- DOCTOR_FAILED
- DOCTOR_REPORTED
- DOCTOR_REPAIRED

> S019 định nghĩa 5 event types (DR010) — S011 cung cấp event model (fields, correlation_id).

## DR011 — Doctor Metrics

- health_score
- passed_checks
- failed_checks
- warning_checks
- total_checks
- repair_count

## DR012 — Doctor Governance

- Doctor không bypass Governance (S013).
- Repair qua Approval Gate (S013).
- Vi phạm CRITICAL → báo cáo lên người, không tự sửa.
- Mọi hành động của Doctor ghi Audit (S011).

## DR013 — Doctor Registry

- Doctor kiểm tra Registry (S014) là một trong 10 domain.
- Doctor đăng ký kết quả vào Registry nếu cần (S014 entry).
- Certification (S016) dựa trên Doctor Report.

## DR014 — Machine-readable

```text
doctor.yaml
doctor-scope.yaml
doctor-checks.yaml
doctor-pipeline.yaml
doctor-self-repair.yaml
doctor-report.yaml
doctor-events.yaml
doctor-metrics.yaml
doctor-validation.yaml
doctor.schema.json
```

## DR015 — Traceability

```text
Doctor Report
    ↓
Checks
    ↓
Evidence (S011)
    ↓
SPEC source (S007..S020)
```

## DR016 — Success Criteria

- Doctor chỉ đọc machine-readable.
- Tổng hợp 68 checks từ 8 nguồn — không định nghĩa lại.
- Health Score xác định được từ Observability Data.
- Self-repair chỉ Low impact, có rollback, có Audit.
- Doctor không bypass Governance (S013).
- Doctor xác minh chính mình (doctor-validation.yaml 6 checks).
- Report immutable (P010).

## Tham chiếu

- `doctor.yaml` — nguồn dữ liệu chuẩn
- `doctor-scope.yaml` · `doctor-checks.yaml` · `doctor-pipeline.yaml`
- `doctor-self-repair.yaml` · `doctor-report.yaml`
- `doctor-events.yaml` · `doctor-metrics.yaml` · `doctor-validation.yaml`
- `doctor.schema.json`
- S011 OB011: `../S011/observability.md`
- S013 GV017: `../S013/governance.md`
- S014 RG011: `../S014/registry.md`
- S015 RS014: `../S015/resources.md`
- S016 CM004: `../S016/compliance.md`
- S017: `../S017/plugins.md`
- S018: `../S018/evolution.md`
- S020 DB013: `../S020/dashboard.md`
- Constitution: `docs/specs/SPEC-000/`
