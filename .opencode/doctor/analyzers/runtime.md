---
name: doctor-analyzer-runtime
description: Runtime Analyzer — phân tích execution: time, retry, rollback, timeout, lock, recovery, scheduler.
agent: general
---

# Runtime Analyzer

## 1. Vai trò

Phân tích **runtime execution** từ workflow-runtime metrics + event metrics.

## 2. Checks

| Metric | Nguồn | Vấn đề nếu |
|--------|-------|------------|
| execution_time | runtime metrics | > threshold |
| retry_count | events history | cao |
| rollback_count | events history | > 0 nhiều |
| timeout_count | events history | > 0 |
| lock_wait_time | runtime metrics | cao |
| deadlock_count | runtime metrics | > 0 |
| recovery_rate | runtime metrics | < 90% |
| scheduler_queue | runtime metrics | backlog |

## 3. Runtime health

```text
Execution success 98%
Retry rate        1%
Recovery rate     100%
Deadlock          0
Lock wait avg     12ms
```

→ runtime score 96.

## 4. Alert

- deadlock > 0 → CRITICAL.
- recovery < 90% → HIGH.
- scheduler queue tăng → WARNING.

## 5. Tương tác

- `workflow-runtime/` — metrics.
- `events/metrics.md` — event runtime.
- `health.md` — runtime score.