---
name: event-tests
description: Event Tests — test cases cho publish, subscribe, queue, replay, priority, history, routing, lineage.
agent: general
---

# Event Tests

## 1. Test cases

| # | Scenario | Expected |
|---|----------|----------|
| 1 | Publish event | event stored, dispatch to subscribers |
| 2 | Subscribe + receive | subscriber handler called |
| 3 | Unsubscribe | subscriber không nhận event sau |
| 4 | Queue priority | critical dequeued trước normal |
| 5 | Event history | history.json có event |
| 6 | Replay | events replayed đúng thứ tự |
| 7 | Filter | subscriber chỉ nhận event matching filter |
| 8 | Routing | event đến đúng subscriber |
| 9 | Dead letter | subscriber fail hết retry → dead letter |
| 10 | Lineage chain | parent_event → child → child |
| 11 | Contract validation | payload mismatch → reject |
| 12 | Overflow | queue vượt max → event dropped |

## 2. Cách chạy

- Unit test gọi EventSDK với mock Bus.
- Không cần Agent/LLM.
- `event-validator.ps1` là gate Phase 6.

## 3. Target

- Coverage: Publish/Subscribe/Replay/Routing/Priority.
- Lineage chain + replay accuracy.