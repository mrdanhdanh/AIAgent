---
name: spec-001-s020-dashboard
description: >
  SPEC-001 S020 — Runtime Dashboard. Trả lời: Dashboard hiển thị trạng thái
  Runtime như thế nào? Chỉ đọc (S011 OB010) — view từ machine-readable,
  không đọc implementation. 16 sections DB001-DB016.
agent: general
---

# S020 — Runtime Dashboard

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: Draft
> **Vai trò**: Mắt quan sát Runtime — SPEC cuối cùng của SPEC-001, tổng hợp view từ mọi SPEC trước.

## Mục tiêu

> **Dashboard hiển thị trạng thái Runtime như thế nào?**

Không mô tả:

- implementation
- UI framework
- code

Chỉ mô tả **Dashboard Model** — Dashboard chỉ đọc machine-readable (S011 OB010).

## DB001 — Dashboard Philosophy

- Dashboard là mắt quan sát Runtime.
- Dashboard chỉ đọc, không ghi.
- Dashboard không đọc implementation.
- Mọi view dùng machine-readable.

## DB002 — Dashboard Principles

- **Read Only**
- **Machine-readable First** (S011)
- **Event Driven** (P005 — refresh theo event, không polling)
- **Single File** (Registry S014 registry-registry.yaml)
- **Least Privilege** (S012 POL-SEC-001)
- **Immutable Views** (view là projection, không sửa nguồn)

## DB003 — Dashboard Scope

**Đọc (Read):**

- Events (S011)
- Metrics (S011)
- Trace (S011)
- Audit (S011)
- Health (S011)
- Registry (S014)
- Governance (S013)
- Compliance (S016)
- Doctor (S019)

**Không đọc:**

- Implementation
- Business Data
- Agent Internal State
- Plugin Internal State

> Đồng bộ S011 OB010 (Dashboard Model).

## DB004 — Data Sources

| Source | Nội dung |
|--------|----------|
| S011 | Event/Metrics/Trace/Audit/Health — 5 domains |
| S013 | Governance Graph (governance-registry.yaml) |
| S014 | Registry Graph (registry-registry.yaml — 1 file) |
| S015 | Resource metrics |
| S016 | Compliance report + matrix |
| S019 | Doctor report (checks, repair) |

## DB005 — Dashboard Views

- **Execution View** — state + outcome distribution (S009/S010).
- **Registry View** — registry-registry.yaml (S014).
- **Governance View** — governance graph (S013).
- **Resource View** — resource metrics (S015).
- **Health View** — health status + compliance score (S011 + S016).
- **Compliance View** — compliance report + matrix (S016).
- **Doctor View** — doctor report (S019).

## DB006 — Dashboard Widgets

- State distribution (S009).
- Outcome distribution (S010 EF024).
- Metrics charts (S011).
- Trace viewer (S011).
- Audit log (S011).
- Health status (S011/S016).
- Governance graph (S013).
- Registry graph (S014).

## DB007 — Read Model

```yaml
read_model:
  fields: [id, timestamp, runtime_version, views, sources, refresh]
```

**Rules:** Read model là projection immutable (P010); không sửa nguồn khi view.

## DB008 — Refresh Model

- **Event Driven** (P005): refresh khi có event mới.
- **Không polling.**
- View là projection immutable (P010).
- Mỗi refresh sinh DASHBOARD_REFRESHED (S011).

## DB009 — Dashboard Events

- DASHBOARD_VIEWED
- DASHBOARD_REFRESHED
- DASHBOARD_ERROR

> S011 reuse trực tiếp.

## DB010 — Dashboard Metrics

- views_count
- widgets_count
- refresh_count
- source_errors
- avg_render_time

## DB011 — Dashboard Governance

- Dashboard không thay đổi Runtime — chỉ đọc (S013 không bị bypass).
- View qua Governance: chỉ hiển thị dữ liệu hợp lệ (S016).
- Dashboard không sinh quyết định — chỉ quan sát.

## DB012 — Dashboard Security

- Permission qua POL-SEC-001 (S012).
- Read-only permission, least privilege.
- Deny mặc định cho mọi ghi (S013).

## DB013 — Dashboard Validation

Doctor kiểm tra:

- Missing Source
- Stale Data
- Unauthorized Read
- Broken View
- Invalid Report

**Result:** Valid → Dashboard phản ánh đúng Runtime. Invalid → View bị chặn, có Invalid Audit (S013).

## DB014 — Machine-readable

```text
dashboard.yaml
dashboard-scope.yaml
dashboard-views.yaml
dashboard-read-model.yaml
dashboard-refresh.yaml
dashboard-events.yaml
dashboard-metrics.yaml
dashboard-validation.yaml
dashboard.schema.json
```

## DB015 — Traceability

```text
Dashboard View
    ↓
Source (S011/S013/S014/S015/S016/S019)
    ↓
Execution
    ↓
Constitution
```

## DB016 — Success Criteria

- Dashboard chỉ đọc machine-readable.
- Không đọc implementation.
- Refresh event-driven — không polling (P005).
- View là projection immutable (P010).
- Dashboard không thể sửa Runtime (chỉ đọc).
- Doctor xác minh Dashboard từ machine-readable.

## Tham chiếu

- `dashboard.yaml` — nguồn dữ liệu chuẩn
- `dashboard-scope.yaml` · `dashboard-views.yaml` · `dashboard-read-model.yaml`
- `dashboard-refresh.yaml` · `dashboard-events.yaml`
- `dashboard-metrics.yaml` · `dashboard-validation.yaml`
- `dashboard.schema.json`
- S011 OB010: `../S011/observability.md`
- S013: `../S013/governance.md`
- S014: `../S014/registry.md`
- S015: `../S015/resources.md`
- S016: `../S016/compliance.md`
- S019: `../S019/doctor.md`
- Constitution: `docs/specs/SPEC-000/`
