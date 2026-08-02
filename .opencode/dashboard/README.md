---
name: system-dashboard
description: >
  System Dashboard v12.0 — Control Tower của AIOS. Trung tâm điều hành: monitor, control, visualization.
  Dùng CQRS: Dashboard chỉ đọc Snapshot (Read Model), không đọc Core.
agent: general
---

# System Dashboard v12.0

## 1. Vai trò

Không chỉ hiển thị — là **Trung tâm điều hành Framework** (Control Tower của AIOS).

```text
Runtime · Registry · Context · Artifacts · Events · Simulation
Doctor · Evolution · Knowledge Graph · Plugins
        │
        ▼
    System Dashboard
```

## 2. Kiến trúc

```text
Dashboard
    │
┌───┼───────┐
│   │       │
Runtime Monitor Control
│   │       │
└───┼───────┘
    │
Visualization
    │
  User
```

## 3. CQRS (đề xuất nâng cấp)

Dashboard **không đọc trực tiếp** Workflow/Artifact/Registry/Context/Knowledge.

```text
Write Side:  Runtime · Event Bus · Artifact Store
Read Side:   Dashboard Snapshot
```

```text
Runtime → Events → Projection Engine → Dashboard Snapshot → Dashboard
```

Mỗi event cập nhật snapshot → realtime, không refresh, không ảnh hưởng Runtime.

## 4. Dashboard modules

Overview · Runtime · Workflow · Agents · Capabilities · Context · Artifacts · Events · Knowledge · Simulation · Doctor · Evolution · Plugins

## 5. Control (không chỉ xem)

Retry · Pause · Resume · Stop · Replay · Simulate workflow.

Security roles: Viewer / Operator / Administrator.

## 6. File hệ thống

| File | Vai trò |
|------|---------|
| `dashboard.schema.yaml` | Snapshot schema |
| `README.md` | Tổng quan |
| `architecture.md` | Kiến trúc + CQRS |
| `api/` | Dashboard API |
| `monitor/` | 13 monitors |
| `control/` | Control actions |
| `widgets/` | Widget system |
| `metrics/` | Metrics |
| `reports/` | Daily/weekly/monthly |
| `projection/` | Read Model builder |

## 7. Tương tác

- Event Bus (Phase 6) — nguồn realtime.
- Doctor (Phase 8) — health.
- Evolution (Phase 10) — proposal center.
- Plugins (Phase 11) — thêm widgets.
- Phase 13 (AIOS SDK) — dashboard qua SDK.