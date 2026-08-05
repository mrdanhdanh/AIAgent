---
name: workflow-runtime-transaction
description: transaction — Phase 1.8: workflow giống database — Phase Start → Lock → Execute → Commit → Unlock; Fail → Rollback. Không ghi dở dang.
agent: general
---

# transaction.md — Runtime Transaction

> Workflow phải **giống Database** — không ghi dở dang.

## 1. Chu trình phase

```text
Phase Start
   ↓
Lock
   ↓
Execute (qua dispatcher → agent)
   ↓
Commit
   ↓
Unlock
```

Nếu Fail:

```text
Phase Start
   ↓
Lock
   ↓
Execute → Fail
   ↓
Rollback
   ↓
Unlock
```

## 2. Trạng thái ghi

| Giai đoạn | Ghi |
|-----------|-----|
| Before execute | không ghi gì vào state chính |
| Execute | nội bộ agent (artifact ngoài scope) |
| Commit | ghi instance + state + artifact atomically |
| After commit | mới visible |

Không bao giờ để state ở **giữa chừng** (dở dang) khi khác processes đọc.

## 3. ACID tương ứng

| DB term | Runtime |
|---------|---------|
| Atomic | commit toàn bộ state+artifact+history cùng lúc |
| Consistent | validate output trước commit |
| Isolation | lock-manager chặn truy cập song song |
| Durable | persistence ghi atomic (temp→rename) |

## 4. Commit vs Rollback (recovery)

- `Commit` → Phase Completed, emit PHASE_COMPLETED.
- `Rollback` → về artifact an toàn cuối, emit WORKFLOW_ROLLBACK, qua recovery strategy.

## 5. Implementation

```text
executor.run(phase):
    lock = lock_manager.acquire(workflow_id)
    try:
        result = dispatcher.execute(phase)      # Execute
        validator.validate_output(result)       # Consistency
        persistence.save_instance(instance)      # Durable (atomic)
        state.transition(next)                   # Commit
    except:
        recovery.apply(rollback)                # Rollback
    finally:
        lock_manager.release(lock)              # Unlock
```

## 6. Không ghi dở dang

- Nếu crash giữa Execute → Commit: transaction rollback, trạng thái giữ trước đó (recovery/persistence recovery).

## 7. Module liên hệ

- `lock-manager.md` (Lock/Unlock)
- `recovery.md` (commit/rollback)
- `persistence.md` (atomic write)
- `state-store.md` (state commit)