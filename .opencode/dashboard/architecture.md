---
name: dashboard-architecture
description: Kiến trúc Dashboard — CQRS Read Side, projection engine, snapshot, control plane.
agent: general
---

# Dashboard — Architecture

## 1. CQRS layers

```text
┌────────────────────┐     ┌─────────────────────┐
│   Write Side        │     │   Read Side          │
│  Runtime            │     │  Projection Engine   │
│  Event Bus          │     │  Dashboard Snapshot  │
│  Artifact Store     │     │  Dashboard UI        │
└─────────┬──────────┘     └─────────┬───────────┘
          │ events → projections →  │
          └──────────────────────────┘
```

- **Write Side**: Runtime/Event Bus/Artifact Store — chạy workflow.
- **Read Side**: Projection → Snapshot — hiển thị.

Dashboard không đọc Core. Không ảnh hưởng Runtime.

## 2. Projection Engine

```text
Event stream (Event Bus)
  → per module projection:
     WorkflowProjection, AgentProjection, ContextProjection...
  → update read models
  → build Dashboard Snapshot (dashboard.schema.yaml)
```

```text
BUILD_COMPLETED → Workflow Projection → Snapshot cập nhật → Dashboard
```

## 3. Modules

```text
┌────────────────────────────────────┐
│  Dashboard (UI)                    │
│  Widgets · Search · Timeline ·     │
│  Alerts · Reports                  │
├────────────────────────────────────┤
│  Dashboard API (Read + Control)    │
├────────────────────────────────────┤
│  Dashboard Snapshot (Read Model)   │
├────────────────────────────────────┤
│  Projection Engine                 │
├────────────────────────────────────┤
│  Event Bus · Metrics · Doctor      │
└────────────────────────────────────┘
```

## 4. Control plane

- Control action → gửi **command** (không sửa snapshot trực tiếp).
- Command → Runtime execute (retry/pause/resume/stop/replay/simulate).
- Kết quả → event → projection cập nhật lại snapshot.

## 5. Roles

| Role | Quyền |
|------|-------|
| viewer | đọc snapshot |
| operator | + control (retry, pause, simulate) |
| administrator | + plugin install, config, evolution apply |

## 6. Tương tác

- `projection/` — Read Model builder.
- `api/` — read + control API.
- `monitor/` — per-module views.
- `control/` — commands.