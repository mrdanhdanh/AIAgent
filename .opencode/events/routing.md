---
name: event-routing
description: Event Routing — quy tắc định tuyến event đến subscriber theo type + filter.
agent: general
---

# Event Routing

## 1. Route table

| Event Type | Routes To |
|------------|-----------|
| PLAN_COMPLETED | Builder, Context Engine |
| BUILD_COMPLETED | Reviewer, Tester, Guardian |
| TEST_COMPLETED | Pusher, Context Engine |
| REVIEW_COMPLETED | Pusher |
| ARTIFACT_CREATED | Context Engine |
| AGENT_FAILED | Retry Handler, Learning Agent |
| WORKFLOW_COMPLETED | Dashboard, Pusher |

## 2. Dynamic routing

- Subscriber đăng ký runtime (không hard-code table).
- Dispatcher build subscriber list khi event đến.
- Plugin có thể đăng ký route mới.

## 3. Fan-out

Một event → nhiều subscriber (1-n):

```text
BUILD_COMPLETED → Reviewer, Tester, Guardian (cùng lúc)
```

## 4. Route conflict

- Nếu cùng type, cùng subscriber → deliver 1 lần (dedup).
- Order: theo priority subscriber (cao trước).

## 5. Tương tác

- `dispatcher.md` — resolve route.
- `subscriber.md` — đăng ký route.
- `filter.md` — filter bổ sung.