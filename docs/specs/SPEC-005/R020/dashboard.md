---
name: spec-005-r020-dashboard
description: SPEC-005 R020 — Registry Dashboard. Section CUỐI CÙNG của SPEC-005.
agent: general
---

# R020 — Registry Dashboard

> **SPEC-005**: Registry · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Dashboard hiển thị trạng thái Registry như thế nào?**

## RDB001 — Dashboard Philosophy

- Registry Dashboard là mắt quan sát Registry.
- Dashboard chỉ đọc, không ghi.
- Dashboard không đọc implementation.

## RDB002 — Dashboard Principles

- Read Only · Machine-readable First (R011) · Event Driven (P005 — không polling) · Single File (R014) · Least Privilege (POL-SEC-001) · Immutable Views (P010).

## RDB003 — Dashboard Scope

**Đọc (9):** Registry Events/Metrics/Trace/Audit/Health (R011) · Registry-of-Registries (R014) · Governance (R013) · Compliance (R016) · Doctor (R019).

**Không đọc (4):** Implementation · Business Data · Agent Internal State · Plugin Internal State.

## RDB004 — Data Sources

- R011 (5 domains) · R013 (governance graph) · R014 (1 file) · R015 (metrics) · R016 (report) · R019 (doctor report).

## RDB005 — Dashboard Views

- **Registry View** (state + outcome R009/R010) · **Entry View** (binding R012) · **Registry-of-Registries View** (R014) · **Governance View** (R013) · **Resource View** (R015) · **Health View** (R011+R016) · **Compliance + Doctor View** (R016+R019).

## RDB006 — Dashboard Widgets

- State distribution (R009) · Outcome distribution (R010) · Lookup metrics (R011) · Binding usage (R012) · Trace viewer (R011) · Audit log (R011) · Health (R011/R016) · Registry graph (R014).

## RDB007 — Read Model

```yaml
read_model:
  fields: [id, timestamp, registry_version, views, sources, refresh]
```

Projection immutable (P010).

## RDB008 — Refresh Model

- Event Driven (P005) · Không polling · Projection immutable (P010).

## RDB009 — Dashboard Events

- REGISTRY_DASHBOARD_VIEWED · REFRESHED · ERROR.

## RDB010 — Dashboard Metrics

- views_count · widgets_count · refresh_count · source_errors · avg_render_time.

## RDB011 — Dashboard Governance

- Dashboard không thay đổi Registry — chỉ đọc (R013 không bị bypass).

## RDB012 — Dashboard Security

- Permission qua POL-SEC-001 (S012). · Read-only, least privilege. · Deny mọi ghi (R013).

## RDB013 — Dashboard Validation

- Missing Source · Stale Data · Unauthorized Read · Broken View · Invalid Report.

## RDB014 — Machine-readable

```text
registry-dashboard.yaml
registry-dashboard-scope.yaml
registry-dashboard-views.yaml
registry-dashboard-read-model.yaml
registry-dashboard-refresh.yaml
registry-dashboard-events.yaml
registry-dashboard-metrics.yaml
registry-dashboard-validation.yaml
registry-dashboard.schema.json
```

## RDB015 — Traceability

```text
Registry Dashboard View → Source (R011/R013/R014/R015/R016/R019) → Entry Execution → Constitution
```

## RDB016 — Success Criteria

- Dashboard chỉ đọc machine-readable. · Refresh event-driven (P005). · View projection immutable (P010). · Dashboard không thể sửa Registry.

## Tham chiếu

- R011: `../R011/observability.md` · R014: `../R014/registry-of-registries.md`
- S020: `../../SPEC-001/S020/dashboard.md`
- Constitution: `docs/specs/SPEC-000/`
