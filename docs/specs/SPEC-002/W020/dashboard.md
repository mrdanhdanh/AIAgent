---
name: spec-002-w020-dashboard
description: >
  SPEC-002 W020 — Workflow Dashboard. Trả lời: Dashboard hiển thị trạng thái
  Workflow Engine như thế nào? Chỉ đọc (S011 OB010) — view từ
  machine-readable. Mirror S020 (SPEC-001). Section CUỐI CÙNG của SPEC-002.
agent: general
---

# W020 — Workflow Dashboard

> **SPEC-002**: Workflow Engine · **Version**: 1.0.0 · **Trạng thái**: Draft
> **Vai trò**: Mắt quan sát Workflow Engine — SPEC cuối cùng của SPEC-002, tổng hợp view từ mọi SPEC trước.

## Câu hỏi duy nhất

> **Dashboard hiển thị trạng thái Workflow Engine như thế nào?**

## WDB001 — Dashboard Philosophy

- Workflow Dashboard là mắt quan sát Workflow Engine.
- Dashboard chỉ đọc, không ghi.
- Dashboard không đọc implementation.
- Mọi view dùng machine-readable.

## WDB002 — Dashboard Principles

- **Read Only** · **Machine-readable First** (W011) · **Event Driven** (P005 — không polling) · **Single File** (W014 workflow-registry-registry.yaml) · **Least Privilege** (S012 POL-SEC-001) · **Immutable Views** (P010).

## WDB003 — Dashboard Scope

**Đọc (9):**

- Workflow Events (W011) · Metrics (W011) · Trace (W011) · Audit (W011) · Health (W011) · Registry (W014) · Governance (W013) · Compliance (W016) · Doctor (W019).

**Không đọc (4):**

- Implementation · Business Data · Agent Internal State · Plugin Internal State.

## WDB004 — Data Sources

| Source | Nội dung |
|--------|----------|
| W011 | Event/Metrics/Trace/Audit/Health |
| W013 | Governance Graph |
| W014 | Registry Graph (workflow-registry-registry.yaml — 1 file) |
| W015 | Resource metrics |
| W016 | Compliance report |
| W019 | Doctor report |

## WDB005 — Dashboard Views

- **Workflow View** — state + outcome distribution (W009/W010).
- **Definition View** — definition version + binding (W012).
- **Registry View** — workflow-registry-registry.yaml (W014).
- **Governance View** — governance graph (W013).
- **Resource View** — resource metrics (W015).
- **Health View** — health status + compliance score (W011 + W016).
- **Compliance + Doctor View** — compliance report + doctor report (W016 + W019).

## WDB006 — Dashboard Widgets

- Workflow state distribution (W009).
- Outcome distribution (W010).
- Binding usage (W012).
- Trace viewer (W011).
- Audit log (W011).
- Health status (W011/W016).
- Governance graph (W013).
- Registry graph (W014).

## WDB007 — Read Model

```yaml
read_model:
  fields: [id, timestamp, workflow_version, views, sources, refresh]
```

Read model là projection immutable (P010).

## WDB008 — Refresh Model

- **Event Driven** (P005): refresh khi có event mới.
- **Không polling.**
- View là projection immutable (P010).

## WDB009 — Dashboard Events

- WORKFLOW_DASHBOARD_VIEWED · REFRESHED · ERROR.

> W020 định nghĩa 3 event types WORKFLOW_DASHBOARD_* — S011 cung cấp event model (fields, correlation_id).

## WDB010 — Dashboard Metrics

- views_count · widgets_count · refresh_count · source_errors · avg_render_time.

## WDB011 — Dashboard Governance

- Dashboard không thay đổi Workflow Engine — chỉ đọc (W013 không bị bypass).
- View qua Governance: chỉ hiển thị dữ liệu hợp lệ (W016).

## WDB012 — Dashboard Security

- Permission qua POL-SEC-001 (S012).
- Read-only, least privilege.
- Deny mặc định cho mọi ghi (W013).

## WDB013 — Dashboard Validation

Doctor kiểm tra: Missing Source · Stale Data · Unauthorized Read · Broken View · Invalid Report.

## WDB014 — Machine-readable

```text
workflow-dashboard.yaml
workflow-dashboard-scope.yaml
workflow-dashboard-views.yaml
workflow-dashboard-read-model.yaml
workflow-dashboard-refresh.yaml
workflow-dashboard-events.yaml
workflow-dashboard-metrics.yaml
workflow-dashboard-validation.yaml
workflow-dashboard.schema.json
```

## WDB015 — Traceability

```text
Workflow Dashboard View → Source (W011/W013/W014/W015/W016/W019) → Workflow Execution → Constitution
```

## WDB016 — Success Criteria

- Dashboard chỉ đọc machine-readable.
- Không đọc implementation.
- Refresh event-driven — không polling (P005).
- View là projection immutable (P010).
- Dashboard không thể sửa Workflow Engine (chỉ đọc).
- Doctor xác minh từ machine-readable.

## Tham chiếu

- W011: `../W011/observability.md`
- W013: `../W013/governance.md`
- W014: `../W014/registry.md`
- W015: `../W015/resources.md`
- W016: `../W016/compliance.md`
- W019: `../W019/doctor.md`
- S020: `../../SPEC-001/S020/dashboard.md` (mẫu)
- Constitution: `docs/specs/SPEC-000/`
