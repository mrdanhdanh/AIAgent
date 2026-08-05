---
name: event-replay
description: Event Replay — phát lại event từ history; dùng cho Debug, Simulation, Audit.
agent: general
---

# Event Replay

## 1. Mục đích

- **Debug**: workflow fail → replay để phân tích.
- **Simulation (Phase 7)**: mô phỏng workflow từ event history.
- **Audit**: truy vết toàn bộ quá trình.

## 2. Cơ chế

```text
History.load(workflow_id)
    │
    ▼
Sắp xếp theo timestamp
    │
    ▼
Replay từng event (publish lại vào bus với flag replay=true)
    │
    ▼
Subscriber replay handler (có thể skip side-effect)
```

## 3. Replay mode

| Mode | Mô tả |
|------|-------|
| observe | chỉ log, không trigger side-effect |
| simulate | gọi subscriber nhưng mock output |
| live | replay thật (kèm cảnh báo) |

## 4. Replay filter

```text
Replay(workflow_id, from_time, to_time, event_types=[PLAN_COMPLETED, BUILD_COMPLETED])
```

## 5. Tương tác

- `history.md` — nguồn dữ liệu replay.
- `bus.md` — publish replay event.
- Phase 7 (Simulation) — dùng replay để mô phỏng.