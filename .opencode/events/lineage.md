---
name: event-lineage
description: Event Lineage — event chain; trace cả workflow từ start tới end.
agent: general
---

# Event Lineage

## 1. Khái niệm

Event không đứng riêng lẻ. Chúng tạo **chain** — mỗi event có `parent_event`.

## 2. Chain

```text
WORKFLOW_STARTED (EVT-001)
    │
PHASE_PLANNING_STARTED (EVT-002, parent=EVT-001)
    │
PLAN_COMPLETED (EVT-003, parent=EVT-002)
    │
BUILD_STARTED (EVT-004, parent=EVT-003)
    │
BUILD_COMPLETED (EVT-005, parent=EVT-004)
    │
TEST_COMPLETED (EVT-006, parent=EVT-005)
    │
WORKFLOW_COMPLETED (EVT-007, parent=EVT-006)
```

## 3. Lineage fields

| Field | Mô tả |
|-------|-------|
| `parent_event` | event trước trong chain |
| `correlation_id` | ID xuyên suốt (thường = workflow_id) |

## 4. Query chain

```text
EventSDK.Lineage(event_id) → full chain forward + backward
EventSDK.LineageForward(event_id) → các event sau
EventSDK.LineageBackward(event_id) → chain tổ tiên
```

## 5. Ứng dụng

- **Dashboard**: hiển thị timeline workflow.
- **Simulation (Phase 7)**: phát lại workflow từ event chain mà không cần Agent.
- **Evolution (Phase 10)**: phân tích bottleneck (ví dụ: thường fail sau `BUILD_COMPLETED`).
- **Knowledge Graph (Phase 9)**: edge từ lineage.

## 6. Tương tác

- `event.schema.yaml` — parent_event, correlation_id.
- `history.md` — persistence chain.
- `replay.md` — replay theo chain.