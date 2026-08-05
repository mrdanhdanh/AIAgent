---
name: dashboard-control
description: Control — Trung tâm điều hành: retry, pause, resume, stop, replay, simulate; gửi command qua Runtime.
agent: general
---

# Dashboard Control

## 1. Vai trò

Không chỉ xem — **điều hành** workflow từ Dashboard.

## 2. Control actions

| Action | Command | Mô tả |
|--------|---------|-------|
| Retry | `retry` | chạy lại workflow fail |
| Pause | `pause` | tạm dừng |
| Resume | `resume` | tiếp tục |
| Stop | `stop` | dừng hẳn |
| Replay | `replay` | phát lại từ history |
| Simulate | `simulate` | chạy simulation trước |

## 3. Flow

```text
User click "Retry"
  → API Control (operator+)
  → Command → Runtime
  → workflow retry
  → event → projection → snapshot cập nhật
```

## 4. Simulation-first

Trước action phá hoại (stop) → yêu cầu simulate preview:
```text
Simulate(stop) → impact → confirm → execute
```

## 5. Permission

- Retry/Pause/Resume/Replay: operator+.
- Stop: operator+ (confirm).
- Simulate: viewer+ (read-only).
- Apply Evolution: administrator.

## 6. Tương tác

- `api/` — control API.
- `simulation/` (Phase 7) — simulate-first.
- `runtime/` (Phase 1) — thực thi command.