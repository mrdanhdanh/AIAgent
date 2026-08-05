---
name: event-priority
description: Event Priority — Critical/High/Normal/Low mapping cho queue + dispatcher.
agent: general
---

# Event Priority

## 1. Levels

| Level | Value | Ví dụ Event |
|-------|-------|-------------|
| critical | 4 | WORKFLOW_FAILED, SYSTEM_ERROR |
| high | 3 | AGENT_FAILED, PHASE_FAILED, DIAGNOSTIC_FAILED |
| normal | 2 | PLAN_COMPLETED, BUILD_COMPLETED, ARTIFACT_CREATED |
| low | 1 | CONTEXT_DELIVERED, DIAGNOSTIC_COMPLETED, METRICS |

## 2. Mapping logic

- Error/Failure events → high/critical.
- Completion events → normal.
- Diagnostic/metrics → low.

## 3. Queue behavior

- Priority queue: dequeue luôn chọn critical trước.
- Trong cùng priority → FIFO.

## 4. Subscriber override

Subscriber có thể ghi đè priority khi subscribe:

```text
Dashboard.Subscribe("METRICS", priority: "high")
```

## 5. Tương tác

- `queue.md` — priority queue.
- `event.schema.yaml` — metadata.priority field.
- `metrics.md` — count per priority.