---
name: sdk-event
description: Event SDK — publish/subscribe, lineage, replay, history.
agent: general
---

# Event SDK

## 1. Vai trò

Giao diện Event Bus.

## 2. API

| Method | Mô tả |
|--------|-------|
| `Event.Publish(type, payload)` | phát event |
| `Event.Subscribe(type, handler, filter?)` | đăng ký |
| `Event.Unsubscribe(subId)` | hủy |
| `Event.History(workflowId)` | event history |
| `Event.Lineage(eventId)` | event chain |
| `Event.Replay(workflowId, mode)` | replay |

## 3. DTO

```yaml
Event:
  id, type, version, timestamp, source, payload, parent_event
```

## 4. Permission

- Publish: `event.publish`.
- Subscribe: `event.subscribe`.
- History/Lineage/Replay: `event.subscribe` + `runtime.read`.

## 5. Tương tác

- `events/` (Phase 6).
- Reuse `events/sdk.md`.