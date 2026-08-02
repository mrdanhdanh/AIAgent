---
name: event-queue
description: Event Queue — hàng đợi event theo priority; async support cho scale sau này.
agent: general
---

# Event Queue

## 1. Vai trò

Buffer event giữa publish và dispatch. Cho phép async + priority.

## 2. Priority levels

| Priority | Weight | Ví dụ |
|----------|--------|-------|
| critical | 0 | WORKFLOW_FAILED |
| high | 1 | AGENT_FAILED, PHASE_FAILED |
| normal | 2 | PLAN_COMPLETED, ARTIFACT_CREATED |
| low | 3 | CONTEXT_DELIVERED, DIAGNOSTIC_COMPLETED |

Dispatcher luôn dequeue critical trước.

## 3. Queue mode

- **Sync** (default): publish → enqueue → immediate dispatch.
- **Async** (future): publish → enqueue, dispatcher worker pool.

## 4. Backpressure

- Max queue size (config).
- Over threshold → reject với error (không crash, log overflow event).

## 5. Tương tác

- `bus.md` — enqueue sau publish.
- `dispatcher.md` — dequeue.
- `priority.md` — priority mapping.
- `metrics.md` — queue size, wait time.