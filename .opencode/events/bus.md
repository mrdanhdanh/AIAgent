---
name: event-bus
description: Event Bus — trung gian pub/sub; publish → store → dispatch. Không chứa logic.
agent: general
---

# Event Bus

## 1. Vai trò

Bus là **trung gian** — nhận event từ publisher, phân phối tới subscriber. Không xử lý logic.

## 2. Core API

| Method | Mô tả |
|--------|-------|
| `Publish(event)` | nhận event object |
| `Subscribe(type, handler)` | đăng ký subscriber cho event type |
| `Unsubscribe(type, handler)` | hủy đăng ký |

## 3. Publish flow

1. Validate event schema.
2. Store event (history).
3. Enqueue (priority queue).
4. Dispatcher: match event type → subscribers.
5. Deliver to each subscriber.
6. Record metrics (dispatch time).

## 4. Subscribe example

```text
Builder.Subscribe(PLAN_COMPLETED, handler)
ContextEngine.Subscribe(ARTIFACT_CREATED, handler)
Dashboard.Subscribe(WORKFLOW_COMPLETED, handler)
```

## 5. Delivery guarantee

- At-least-once delivery.
- Nếu subscriber fail → retry (retry count từ metadata).
- Hết retry → dead letter (log, không crash).

## 6. Tương tác

- `dispatcher.md` — matching + delivery.
- `queue.md` — priority + ordering.
- `history.md` — persistence.
- `sdk.md` — facade cho module.