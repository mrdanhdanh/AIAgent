---
name: event-system
description: >
  Event System v6.0 — chuyển framework từ Call-based sang Event-driven.
  Event Bus + Publish/Subscribe + Queue + Replay + Contract + Lineage.
  Mọi module chỉ phát Event, không gọi trực tiếp nhau.
agent: general
---

# Event System v6.0

## 1. Chuyển đổi Call-based → Event-driven

**Trước**: Planner → Builder → Tester (chain gọi trực tiếp).

**Sau**: Planner → `PLAN_COMPLETED` → Event Bus → Builder.

Mọi module chỉ **publish event** — không biết ai nhận.

## 2. Kiến trúc

```text
Workflow Runtime / Agent
        │
   Publish Event
        │
   Event Dispatcher
        │
   Event Bus / Queue
        │
  ┌─────┼─────┐
  │     │     │
Context Artifact Agent
Engine  Store  Runtime
```

## 3. Event Object

```yaml
id: EVT-001
type: PLAN_COMPLETED
version: 1
timestamp: ISO8601
source: planner
workflow: WF-0421
phase: planning
artifact: PLAN-001
payload: { artifact_id, version, checksum }
metadata: { duration, priority }
```

## 4. Event Categories (6 nhóm)

| Category | Example events |
|----------|---------------|
| Workflow | CREATED, STARTED, COMPLETED, FAILED |
| Phase | STARTED, COMPLETED, SKIPPED, FAILED |
| Agent | STARTED, COMPLETED, FAILED |
| Artifact | CREATED, UPDATED, ARCHIVED |
| Context | CREATED, COMPRESSED, DELIVERED |
| Registry | CAPABILITY_REGISTERED, AGENT_REGISTERED |

## 5. Event Lineage

Sự kiện tạo **chain** (không chỉ riêng lẻ):

```
WORKFLOW_STARTED → PHASE_PLANNING → PLAN_COMPLETED → BUILD_COMPLETED → TEST_COMPLETED → WORKFLOW_COMPLETED
```

→ Dashboard xem timeline. Simulation (Phase 7) replay workflow. Evolution (Phase 10) phân tích bottleneck.

## 6. Event Contract

Mỗi event type có payload contract — subscriber chỉ cần đọc contract, không cần biết publisher.

## 7. File hệ thống

| File | Vai trò |
|------|---------|
| `event.schema.yaml` | Event object schema |
| `categories.yaml` | 6 event categories |
| `contracts/` | Payload contract per event type |
| `bus.md` | Event Bus core |
| `dispatcher.md` | Dispatch logic |
| `publisher.md` | Publish mechanism |
| `subscriber.md` | Subscribe mechanism |
| `queue.md` | Event queue (async support) |
| `routing.md` | Event routing rules |
| `filter.md` | Event filter |
| `priority.md` | Critical/High/Normal/Low |
| `history.md` | Event log persistence |
| `replay.md` | Replay events |
| `lineage.md` | Event lineage chain |
| `metrics.md` | Event metrics |
| `sdk.md` | Event SDK |

## 8. Nguyên tắc

- Module không gọi Bus trực tiếp — qua SDK.
- Event immutable sau khi publish.
- Queue support async (sau này scale).
- History lưu toàn bộ → replay cho Simulation/Doctor.