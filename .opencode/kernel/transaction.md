---
name: kernel-transaction
description: Kernel Transaction — atomic workflow; commit/rollback toàn bộ.
agent: general
---

# Kernel Transaction

## 1. Vai trò

Đảm bảo workflow chạy atomic — thành công toàn bộ hoặc rollback.

## 2. Transaction model

```text
Kernel.Begin(tx)
  → chạy các step
  → tất cả OK → Commit
  → có lỗi → Rollback (khôi phục trạng thái)
```

## 3. Scope

- Artifact thay đổi.
- State transition.
- Context ghi.
- Event phát.

## 4. Rollback

- Artifact → khôi phục version trước.
- State → revert.
- Event → đánh dấu compensated.

## 5. Tương tác

- `recovery.md` — trigger rollback.
- `artifacts/` (Phase 5) — version khôi phục.
- `workflow-runtime/transaction.md` — reuse.