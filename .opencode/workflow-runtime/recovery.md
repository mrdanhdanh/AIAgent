---
name: workflow-runtime-recovery
description: recovery — Thành phần 8: xử lý fail. Nhiều strategy: Retry/Rollback/Skip/Resume/Abort/Escalate. Không nằm trong /team.
agent: general
---

# recovery.md — Recovery

> Xử lý khi phase/agent **fail**. Recovery không chỉ Retry — có nhiều strategy, sau này AI tự chọn.

## 1. Chuỗi strategy (Phase 1.10)

```text
Retry
  ↓
Rollback
  ↓
Skip
  ↓
Resume
  ↓
Abort
  ↓
Escalate
```

Không nằm trong `/team` — nằm trong runtime.

## 2. Quyết định strategy

| Điều kiện | Strategy |
|-----------|----------|
| `phase.retry` còn + lỗi tạm thời (INF) | Retry |
| Fail + có rollback plan + muốn khôi phục dữ liệu | Rollback |
| `phase.optional: true` | Skip |
| Fail trung gian nhưng có thể tiếp tục từ checkpoint | Resume |
| hết retry + không rollback/skip | Abort → workflow Failed |
| Lỗi vượt khả năng local, cần người/ngoài quyết | Escalate |

## 3. Retry

- Đếm theo `phase.retry` (default 1), backoff qua `retry_delay`.
- Reset counter khi thành công.

## 4. Rollback vs Resume

| | Rollback | Resume |
|---|----------|--------|
| Mục đích | quay về artifact an toàn | tiếp tục từ checkpoint |
| State | về trước phase này | giữ nguyên, bỏ qua phase lỗi |
| Dựa vào | snapshot cuối | persisted instance |

Cả hai dùng persistence/state-store.

## 5. Skip

- Chỉ khi `optional: true`, không sinh artifact, đánh dấu Skipped.

## 6. Abort

- Dừng workflow, state `failed`, ghi failure record vào `.opencode/memory/`.

## 7. Escalate

- Khi Critical (health.md) hoặc quyết định vượt runtime scope.
- Báo user/cấp trên, giữ instance để xem, không tự hủy.
- Sau này có thể do AI quyết (learning).

## 8. Đo lường

Recovery ghi `recovery_count`, `strategy_used` vào metrics.md.

## 9. Tương tác

- Gọi từ `executor.md` khi output lỗi.
- Phụ thuộc `state-store.md`, `metrics.md`, `health.md`, `ERROR_HANDLING.md` (WF-004, WF-005).