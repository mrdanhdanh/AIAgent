---
name: event-sdk
description: Event SDK — facade cho module; Publish/Subscribe/Lineage thay vì gọi Bus trực tiếp.
agent: general
---

# Event SDK

## 1. Vai trò

Module không gọi Bus trực tiếp — qua SDK. SDK cung cấp interface đơn giản.

## 2. API

| Method | Mô tả |
|--------|-------|
| `Publish(type, payload)` | publish event, SDK tự fill id/timestamp/source |
| `Subscribe(type, handler, filter?)` | đăng ký subscriber |
| `Unsubscribe(subscription_id)` | hủy đăng ký |
| `History(workflow_id)` | lấy event history |
| `Lineage(event_id)` | lấy event chain |
| `Replay(workflow_id, mode)` | replay event |

## 3. Auto-fill

Khi Publish, SDK tự:

- Generate event id (EVT-NNN).
- Set timestamp.
- Set source (agent/module).
- Set workflow/phase từ context.
- Set correlation_id.
- Set parent_event từ event hiện tại.

## 4. Example

```text
// Planner done
EventSDK.Publish("PLAN_COMPLETED", { artifact_id: "PLAN-001", version: 2 })

// SDK tự fill: id, timestamp, source=planner, workflow=WF-0421
```

## 5. Tương tác

- `bus.md` — backend.
- `contracts/` — validate payload.
- Mọi module dùng SDK (không gọi Bus trực tiếp).