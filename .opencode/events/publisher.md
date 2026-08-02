---
name: event-publisher
description: Event Publisher — module gửi event; không biết ai nhận. Qua SDK hoặc trực tiếp Bus.
agent: general
---

# Event Publisher

## 1. Vai trò

Publisher = bất kỳ module nào tạo event. Publisher **không biết** ai nhận.

## 2. Pattern

```text
Planner done
    │
    ▼
Publish(PLAN_COMPLETED, payload)
    │
    ▼
Done — không chờ kết quả từ subscriber
```

## 3. Cách publish

```text
// Qua SDK
EventSDK.Publish(type: "PLAN_COMPLETED", payload: { artifact_id, version })

// SDK tự fill: id, timestamp, source, workflow, phase
```

## 4. Publisher nào publish gì

| Publisher | Event |
|-----------|-------|
| Workflow Runtime | WORKFLOW_*, PHASE_* |
| Agent Runtime | AGENT_* |
| Artifact Manager | ARTIFACT_* |
| Context Engine | CONTEXT_* |
| Registry | CAPABILITY_*, AGENT_*, PLUGIN_* |
| Doctor | DIAGNOSTIC_* |

## 5. Contract compliance

- Publisher phải tuân thủ payload contract trong `contracts/contracts.yaml`.
- Bus validate contract trước khi deliver.

## 6. Tương tác

- `sdk.md` — interface publish.
- `bus.md` — nhận event.
- `contracts/` — payload validation.