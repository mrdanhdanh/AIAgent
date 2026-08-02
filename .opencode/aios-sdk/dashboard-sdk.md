---
name: sdk-dashboard
description: Dashboard SDK — snapshot read + control (CQRS).
agent: general
---

# Dashboard SDK

## 1. Vai trò

Giao diện Dashboard — đọc snapshot + gửi control command.

## 2. API

| Method | Mô tả |
|--------|-------|
| `Dashboard.GetSnapshot()` | snapshot hiện tại |
| `Dashboard.GetHealth()` | health |
| `Dashboard.Search(query)` | tìm kiếm |
| `Dashboard.Control(action, target)` | retry/pause/resume/stop |
| `Dashboard.Simulate(workflow)` | simulation preview |
| `Dashboard.GetReports(period)` | báo cáo |

## 3. DTO

```yaml
Snapshot: dashboard.schema.yaml (Read Model)
```

## 4. Permission

- GetSnapshot/GetHealth/Search: viewer+.
- Control: operator+.
- Reports: viewer+.

## 5. CQRS

- Read từ snapshot (không đọc Core).
- Control gửi command → Runtime → event → projection.

## 6. Tương tác

- `dashboard/` (Phase 12).
- Dashboard UI implement qua dashboard-sdk.