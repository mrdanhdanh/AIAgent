---
name: dashboard-widgets
description: Widgets — thành phần hiển thị; plugin có thể thêm widget riêng.
agent: general
---

# Dashboard Widgets

## 1. Vai trò

Dashboard = tập widget. Mỗi widget render 1 phần snapshot.

## 2. Core widgets

| Widget | Hiển thị |
|--------|----------|
| HealthWidget | health score + gauge |
| WorkflowWidget | workflow states + progress |
| AgentWidget | agent status table |
| CapabilityWidget | registered/used/unused |
| ContextWidget | avg tokens + cache + compression |
| EventWidget | live event log |
| DoctorWidget | health scores + history |
| EvolutionWidget | proposals list |
| PluginWidget | plugin status |

## 3. Widget contract

```yaml
widget:
  id: health
  title: Health Score
  data: dashboard.schema.yaml → health
  size: { w: 2, h: 1 }
  refresh: realtime
```

## 4. Plugin widgets

Plugin (Phase 11) khai báo `widgets` trong manifest → Dashboard render.
```yaml
exports:
  widgets: [oracle-optimizer-widget]
```

## 5. Layout

- Grid-based, drag-resize.
- Widget data từ snapshot (Read Model) — không query Core.

## 6. Tương tác

- `projection/` — data.
- `monitor/` — modules.
- `plugins/manifest.md` — plugin widgets.