---
name: event-metrics
description: Event Metrics — total events, dispatch time, queue time, subscriber count, dropped events.
agent: general
---

# Event Metrics

## 1. Chỉ số

| Metric | Mô tả |
|--------|-------|
| total.events | tổng event |
| by.type | count per event type |
| by.priority | count per priority |
| dispatch.time.avg | thời gian dispatch trung bình (ms) |
| queue.time.avg | thời gian chờ queue (ms) |
| subscriber.count | số subscriber |
| dropped.events | event bị overflow/reject |
| dead.letter | event fail hết retry |
| replay.count | số lần replay |

## 2. Lưu trữ

- `events/metrics.json` — dump định kỳ.
- Doctor đọc tổng hợp.

## 3. Alert

- dropped.events > 0 → WARNING.
- dispatch.time > 500ms → WARNING.
- dead.letter > 5 → CRITICAL.

## 4. Tương tác

- `bus.md` — ghi metrics sau dispatch.
- `queue.md` — ghi queue.time.
- Phase 8 (Doctor) — đọc metrics.