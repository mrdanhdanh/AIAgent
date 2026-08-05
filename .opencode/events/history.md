---
name: event-history
description: Event History — persistence 3 lớp (Current/History/Archive); lưu toàn bộ event.
agent: general
---

# Event History

## 1. 3 lớp persistence

| Layer | Scope | Format |
|-------|-------|--------|
| Current | đang xử lý | RAM |
| History | đã xử lý | File JSON |
| Archive | cũ, nén | Compressed JSON |

## 2. History file

`events/history.json`:
```json
{
  "version": "6.0",
  "workflow": "WF-0421",
  "events": [
    { "id": "EVT-001", "type": "WORKFLOW_STARTED", "timestamp": "..." },
    { "id": "EVT-002", "type": "PHASE_STARTED", "parent_event": "EVT-001" },
    { "id": "EVT-003", "type": "PLAN_COMPLETED", "parent_event": "EVT-002" }
  ]
}
```

## 3. Retention

- Current: clear sau workflow end.
- History: giữ 30 ngày mặc định.
- Archive: nén sau 30 ngày, xoá sau 90.

## 4. Query

- `History(workflow_id)` → full event chain.
- `History(event_id)` → single event.

## 5. Tương tác

- `replay.md` — đọc history để replay.
- `lineage.md` — xây dựng chain từ history.
- Dashboard — hiển thị timeline.
- Simulation (Phase 7) — replay events.