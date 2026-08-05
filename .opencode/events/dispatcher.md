---
name: event-dispatcher
description: Event Dispatcher — match event type → subscribers, routing rules, delivery.
agent: general
---

# Event Dispatcher

## 1. Vai trò

Dispatcher quyết định **ai nhận event** dựa trên type + routing rules.

## 2. Cơ chế

```text
Event arrives (from Queue)
        │
        ▼
Match event.type → subscriber table
        │
        ▼
Apply routing rules (filter + priority)
        │
        ▼
Deliver to each subscriber (1-n)
```

## 3. Subscriber table

| Event Type | Subscribers |
|------------|-------------|
| PLAN_COMPLETED | Builder, Context Engine, Dashboard |
| ARTIFACT_CREATED | Context Engine, Artifact Store |
| AGENT_FAILED | Retry handler, Dashboard |
| WORKFLOW_COMPLETED | Pusher, Dashboard |

## 4. Routing rules

- Subscriber đăng ký by type + optional filter (xem `filter.md`).
- Dispatcher match chính xác type → deliver.
- Event có priority (critical trước normal).

## 5. Error handling

- Subscriber error → retry (metadata.retry).
- Sau retry max → dead letter event → log + Dashboard warning.
- Không ảnh hưởng subscriber khác.

## 6. Tương tác

- `bus.md` — gọi dispatcher.
- `queue.md` — order event.
- `routing.md` — routing rules.
- `filter.md` — filter conditions.