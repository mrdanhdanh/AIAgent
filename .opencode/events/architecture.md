---
name: event-architecture
description: Kiến trúc Event System — layers, data flow, publish/subscribe pattern, integration points.
agent: general
---

# Event System — Architecture

## 1. Layers

```text
┌──────────────────────────────────────────┐
│       Agent / Workflow Runtime            │  (publisher)
├──────────────────────────────────────────┤
│            Event SDK                      │  (abstract bus)
├──────────────────────────────────────────┤
│  ┌────────┬──────────┬─────────────────┐ │
│  │Pub/Sub │Dispatcher│ Queue            │ │
│  │        │+ Routing │ + Priority        │ │
│  ├────────┴──────────┴─────────────────┤ │
│  │         Event Store + History        │ │
│  └─────────────────────────────────────┘ │
├──────────────────────────────────────────┤
│  Context Engine / Artifact Store /       │  (subscriber)
│  Agent Runtime / Dashboard               │
└──────────────────────────────────────────┘
```

## 2. Data flow

```text
Agent produces result
        │
        ▼
    Publish Event
        │
        ▼
    Event Schema Validate
        │
        ▼
    Store (History)
        │
        ▼
    Queue (priority)
        │
        ▼
    Dispatcher → Routing → Subscriber list
        │
        ▼
    Deliver to each subscriber (Context/Artifact/Agent)
```

## 3. Publish/Subscribe pattern

- **Publisher**: module gửi event, không biết ai nhận.
- **Subscriber**: module đăng ký lắng nghe event type.
- **Bus**: trung gian 1-n.

## 4. Integration points

| Module | Role | Events |
|--------|------|--------|
| Workflow Runtime | publisher + subscriber | WF_*, PHASE_* |
| Agent Runtime | publisher + subscriber | AGENT_* |
| Artifact Store | subscriber | ARTIFACT_* |
| Context Engine | subscriber | CONTEXT_* |
| Registry | publisher | CAPABILITY_*, AGENT_* |

## 5. Event Store (persistence)

3 lớp:
- **Current**: event đang xử lý (RAM/queue).
- **History**: event đã xử lý (file/JSON).
- **Archive**: event cũ (nén, clean up định kỳ).

## 6. Tương tác

- Phase 5 (Artifact Store) → publish ARTIFACT_CREATED.
- Phase 4 (Context Engine) → subscribe ARTIFACT_CREATED để cập nhật context.
- Phase 7 (Simulation) → replay history.
- Phase 8 (Doctor) → đọc event metrics.