---
name: event-subscriber
description: Event Subscriber — module đăng ký lắng nghe event type; chỉ biết contract, không biết publisher.
agent: general
---

# Event Subscriber

## 1. Vai trò

Subscriber = module đăng ký nhận sự kiện. Chỉ biết **contract event type**, không biết ai publish.

## 2. Pattern

```text
Builder.Subscribe("PLAN_COMPLETED")
    │
    ▼
Khi PLAN_COMPLETED đến → handler chạy
    │
    ▼
Builder đọc artifact_id từ payload
```

## 3. Subscriber mapping

| Subscriber | Subscribes To |
|------------|---------------|
| Builder | PLAN_COMPLETED |
| Reviewer | BUILD_COMPLETED |
| Tester | BUILD_COMPLETED |
| Guardian | BUILD_COMPLETED |
| Pusher | REVIEW_COMPLETED |
| Context Engine | ARTIFACT_CREATED |
| Artifact Store | ARTIFACT_UPDATED |
| Dashboard | All |
| Learning Agent | AGENT_FAILED |

## 4. Handler pattern

Mỗi subscriber có **handler function** — nhận event object, trả void.

```text
handler(event) {
  artifact_id = event.payload.artifact_id
  // logic...
}
```

## 5. Unsubscribe

- Sau workflow end → clean subscribers.
- Plugin hot-reload → re-subscribe.

## 6. Tương tác

- `bus.md` — delivery.
- `contracts/` — payload structure.
- `filter.md` — filter theo điều kiện.