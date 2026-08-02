---
name: workflow-runtime-recovery
description: recovery — Thành phần 8: xử lý fail của phase/agent. Quyết strategy retry/rollback/skip/abort. Không nằm trong /team.
agent: general
---

# recovery.md — Recovery

> Thành phần 8. Xử lý khi phase/agent **fail**. Quyết định chiến lược khôi phục.

## 1. Chiến lược

```
Fail
 │
 ├── Retry      (còn lần thử, lỗi tạm thời)
 ├── Skip       (phase optional, có thể bỏ)
 ├── Rollback   (fail nghiêm trọng, có rollback plan)
 └── Abort      (fail không hồi phục)
```

Không nằm trong `/team` — nằm trong runtime.

## 2. Quyết định strategy

| Điều kiện | Strategy |
|-----------|----------|
| `phase.retry` còn + lỗi tạm thời (INF) | Retry |
| `phase optional: true` | Skip |
| `optional: false` + có rollback | Rollback |
| hết retry + không rollback | Abort → workflow Failed |

## 3. Retry

- Đếm mỗi lần thử, theo `phase.retry` (default 1).
- Reset counter khi phase thành công.
- Thời gian chờ retry (backoff) ghi trong `phase.retry_delay`.

## 4. Rollback

- Kích hoạt khi phase FATAL.
- Runtime quay về artifact an toàn cuối cùng (persistence).
- Workflow.state → `failed` (hoặc quay `running` nếu khôi phục được) — xem state-machine.md.

## 5. Skip

- Chỉ dùng khi `phase.optional: true`.
- Không sinh artifact, đánh dấu Skipped, chuyển phase kế.

## 6. Abort

- Dừng toàn workflow, state `failed`, ghi failure record vào `.opencode/memory/`.

## 7. Tương tác

- Gọi từ `executor.md` khi output lỗi.
- Dispatcher lỗi AG/CAP → recovery quyết.
- Tham chiếu `ERROR_HANDLING.md` (WF-004, WF-005).