---
name: kernel-recovery
description: Kernel Recovery — retry, failover, rollback khi task lỗi.
agent: general
---

# Kernel Recovery

## 1. Vai trò

Xử lý lỗi task — retry, failover, rollback transaction.

## 2. Recovery strategies

| Strategy | Khi nào |
|----------|---------|
| retry | transient error (timeout) |
| failover | agent disabled → candidate khác |
| rollback | transaction fail → revert |
| skip | lỗi không critical → skip phase |
| dead-letter | hết retry → log + alert |

## 3. Retry policy

- retry_count < max (từ metadata agent).
- Exponential backoff.
- Reset sau thành công.

## 4. Tương tác

- `transaction.md` — rollback.
- `scheduler.md` — re-schedule.
- Phase 1 (`workflow-runtime/recovery.md`) — reuse.
- Phase 6 (Event) — publish AGENT_FAILED.