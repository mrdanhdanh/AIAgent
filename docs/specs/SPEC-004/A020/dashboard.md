---
name: spec-004-a020-dashboard
description: >
  SPEC-004 A020 — Agent Dashboard. Trả lời: Dashboard hiển thị trạng thái
  Agent System như thế nào? Chỉ đọc (S011 OB010) — view từ machine-readable.
  Mirror C020 (SPEC-003). Section CUỐI CÙNG của SPEC-004.
agent: general
---

# A020 — Agent Dashboard

> **SPEC-004**: Agent System · **Version**: 1.0.0 · **Trạng thái**: Draft
> **Vai trò**: Mắt quan sát Agent System — SPEC cuối cùng của SPEC-004, tổng hợp view từ mọi SPEC trước.

## Câu hỏi duy nhất

> **Dashboard hiển thị trạng thái Agent System như thế nào?**

## ADB001 — Dashboard Philosophy

- Agent Dashboard là mắt quan sát Agent System.
- Dashboard chỉ đọc, không ghi.
- Dashboard không đọc implementation.
- Mọi view dùng machine-readable.

## ADB002 — Dashboard Principles

- **Read Only** · **Machine-readable First** (A011) · **Event Driven** (P005 — không polling) · **Single File** (A014 agent-registry-registry.yaml) · **Least Privilege** (S012 POL-SEC-001) · **Immutable Views** (P010).

## ADB003 — Dashboard Scope

**Đọc (9):**

- Agent Events (A011) · Metrics (A011) · Trace (A011) · Audit (A011) · Health (A011) · Registry (A014) · Governance (A013) · Compliance (A016) · Doctor (A019).

**Không đọc (4):**

- Implementation · Business Data · Agent Internal State · Plugin Internal State.

## ADB004 — Data Sources

| Source | Nội dung |
|--------|----------|
| A011 | Event/Metrics/Trace/Audit/Health |
| A013 | Governance Graph |
| A014 | Registry Graph (agent-registry-registry.yaml — 1 file) |
| A015 | Resource metrics |
| A016 | Compliance report |
| A019 | Doctor report |

## ADB005 — Dashboard Views

- **Agent View** — state + outcome distribution (A009/A010).
- **Definition View** — definition version + binding (A012).
- **Registry View** — agent-registry-registry.yaml (A014).
- **Governance View** — governance graph (A013).
- **Resource View** — resource metrics (A015).
- **Health View** — health status + compliance score (A011 + A016).
- **Compliance + Doctor View** — compliance report + doctor report (A016 + A019).

## ADB006 — Dashboard Widgets

- Agent state distribution (A009).
- Outcome distribution (A010).
- Execution metrics (A011).
- Binding usage (A012).
- Trace viewer (A011).
- Audit log (A011).
- Health status (A011/A016).
- Governance graph (A013).
- Registry graph (A014).

## ADB007 — Read Model

```yaml
read_model:
  fields: [id, timestamp, agent_version, views, sources, refresh]
```

Read model là projection immutable (P010).

## ADB008 — Refresh Model

- **Event Driven** (P005): refresh khi có event mới.
- **Không polling.**
- View là projection immutable (P010).

## ADB009 — Dashboard Events

- AGENT_DASHBOARD_VIEWED · REFRESHED · ERROR.

> S011 reuse trực tiếp.

## ADB010 — Dashboard Metrics

- views_count · widgets_count · refresh_count · source_errors · avg_render_time.

## ADB011 — Dashboard Governance

- Dashboard không thay đổi Agent System — chỉ đọc (A013 không bị bypass).
- View qua Governance: chỉ hiển thị dữ liệu hợp lệ (A016).

## ADB012 — Dashboard Security

- Permission qua POL-SEC-001 (S012).
- Read-only, least privilege.
- Deny mặc định cho mọi ghi (A013).

## ADB013 — Dashboard Validation

Doctor kiểm tra: Missing Source · Stale Data · Unauthorized Read · Broken View · Invalid Report.

## ADB014 — Machine-readable

```text
agent-dashboard.yaml
agent-dashboard-scope.yaml
agent-dashboard-views.yaml
agent-dashboard-read-model.yaml
agent-dashboard-refresh.yaml
agent-dashboard-events.yaml
agent-dashboard-metrics.yaml
agent-dashboard-validation.yaml
agent-dashboard.schema.json
```

## ADB015 — Traceability

```text
Agent Dashboard View → Source (A011/A013/A014/A015/A016/A019) → Agent Execution → Constitution
```

## ADB016 — Success Criteria

- Dashboard chỉ đọc machine-readable.
- Không đọc implementation.
- Refresh event-driven — không polling (P005).
- View là projection immutable (P010).
- Dashboard không thể sửa Agent System (chỉ đọc).
- Doctor xác minh từ machine-readable.

## Tham chiếu

- A011: `../A011/observability.md`
- A013: `../A013/governance.md`
- A014: `../A014/registry.md`
- A015: `../A015/resources.md`
- A016: `../A016/compliance.md`
- A019: `../A019/doctor.md`
- C020: `../../SPEC-003/C020/dashboard.md` (mẫu)
- Constitution: `docs/specs/SPEC-000/`