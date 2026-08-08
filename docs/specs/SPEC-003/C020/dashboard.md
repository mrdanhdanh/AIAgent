---
name: spec-003-c020-dashboard
description: >
  SPEC-003 C020 — Capability Dashboard. Trả lời: Dashboard hiển thị trạng thái
  Capability System như thế nào? Chỉ đọc (S011 OB010) — view từ
  machine-readable. Mirror W020 (SPEC-002). Section CUỐI CÙNG của SPEC-003.
agent: general
---

# C020 — Capability Dashboard

> **SPEC-003**: Capability System · **Version**: 1.0.0 · **Trạng thái**: Draft
> **Vai trò**: Mắt quan sát Capability System — SPEC cuối cùng của SPEC-003, tổng hợp view từ mọi SPEC trước.

## Câu hỏi duy nhất

> **Dashboard hiển thị trạng thái Capability System như thế nào?**

## CDB001 — Dashboard Philosophy

- Capability Dashboard là mắt quan sát Capability System.
- Dashboard chỉ đọc, không ghi.
- Dashboard không đọc implementation.
- Mọi view dùng machine-readable.

## CDB002 — Dashboard Principles

- **Read Only** · **Machine-readable First** (C011) · **Event Driven** (P005 — không polling) · **Single File** (C014 capability-registry-registry.yaml) · **Least Privilege** (S012 POL-SEC-001) · **Immutable Views** (P010).

## CDB003 — Dashboard Scope

**Đọc (9):**

- Capability Events (C011) · Metrics (C011) · Trace (C011) · Audit (C011) · Health (C011) · Registry (C014) · Governance (C013) · Compliance (C016) · Doctor (C019).

**Không đọc (4):**

- Implementation · Business Data · Agent Internal State · Plugin Internal State.

## CDB004 — Data Sources

| Source | Nội dung |
|--------|----------|
| C011 | Event/Metrics/Trace/Audit/Health |
| C013 | Governance Graph |
| C014 | Registry Graph (capability-registry-registry.yaml — 1 file) |
| C015 | Resource metrics |
| C016 | Compliance report |
| C019 | Doctor report |

## CDB005 — Dashboard Views

- **Capability View** — state + outcome distribution (C009/C010).
- **Definition View** — definition version + binding (C012).
- **Registry View** — capability-registry-registry.yaml (C014).
- **Governance View** — governance graph (C013).
- **Resource View** — resource metrics (C015).
- **Health View** — health status + compliance score (C011 + C016).
- **Compliance + Doctor View** — compliance report + doctor report (C016 + C019).

## CDB006 — Dashboard Widgets

- Capability state distribution (C009).
- Outcome distribution (C010).
- Resolution metrics (C011).
- Binding usage (C012).
- Trace viewer (C011).
- Audit log (C011).
- Health status (C011/C016).
- Governance graph (C013).
- Registry graph (C014).

## CDB007 — Read Model

```yaml
read_model:
  fields: [id, timestamp, capability_version, views, sources, refresh]
```

Read model là projection immutable (P010).

## CDB008 — Refresh Model

- **Event Driven** (P005): refresh khi có event mới.
- **Không polling.**
- View là projection immutable (P010).

## CDB009 — Dashboard Events

- CAPABILITY_DASHBOARD_VIEWED · REFRESHED · ERROR.

> S011 reuse trực tiếp.

## CDB010 — Dashboard Metrics

- views_count · widgets_count · refresh_count · source_errors · avg_render_time.

## CDB011 — Dashboard Governance

- Dashboard không thay đổi Capability System — chỉ đọc (C013 không bị bypass).
- View qua Governance: chỉ hiển thị dữ liệu hợp lệ (C016).

## CDB012 — Dashboard Security

- Permission qua POL-SEC-001 (S012).
- Read-only, least privilege.
- Deny mặc định cho mọi ghi (C013).

## CDB013 — Dashboard Validation

Doctor kiểm tra: Missing Source · Stale Data · Unauthorized Read · Broken View · Invalid Report.

## CDB014 — Machine-readable

```text
capability-dashboard.yaml
capability-dashboard-scope.yaml
capability-dashboard-views.yaml
capability-dashboard-read-model.yaml
capability-dashboard-refresh.yaml
capability-dashboard-events.yaml
capability-dashboard-metrics.yaml
capability-dashboard-validation.yaml
capability-dashboard.schema.json
```

## CDB015 — Traceability

```text
Capability Dashboard View → Source (C011/C013/C014/C015/C016/C019) → Capability Execution → Constitution
```

## CDB016 — Success Criteria

- Dashboard chỉ đọc machine-readable.
- Không đọc implementation.
- Refresh event-driven — không polling (P005).
- View là projection immutable (P010).
- Dashboard không thể sửa Capability System (chỉ đọc).
- Doctor xác minh từ machine-readable.

## Tham chiếu

- C011: `../C011/observability.md`
- C013: `../C013/governance.md`
- C014: `../C014/registry.md`
- C015: `../C015/resources.md`
- C016: `../C016/compliance.md`
- C019: `../C019/doctor.md`
- W020: `../../SPEC-002/W020/dashboard.md` (mẫu)
- Constitution: `docs/specs/SPEC-000/`
