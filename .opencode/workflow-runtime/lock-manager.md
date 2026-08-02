---
name: workflow-runtime-lock-manager
description: lock-manager — Phase 1.9: Workflow/Artifact/Context Lock. Rất nhiều framework Agent bỏ qua.
agent: general
---

# lock-manager.md — Runtime Lock

> Phòng chống 2 command (vd `/team`, `/team-review`) cùng sửa một instance.

## 1. Vấn đề

```text
/team        ──⟶  WF-001  ⟵──  /team-review
```

Cùng đọc/ghi `WF-001` → race → state hỏng.

## 2. Các loại lock

| Lock | Đối tượng | Tránh |
|------|-----------|-------|
| Workflow Lock | workflow instance | hai command chạy cùng 1 workflow |
| Phase Lock | phase hiện tại | hai process sửa cùng phase |
| Artifact Lock | artifact file | ghi đè/đọc trong khi đang ghi |
| Context Lock | context scope | race khi update context |

## 3. API

```text
acquire(scope, id)   → LockHandle  (blocking / try-lock)
tryAcquire(scope, id) → LockHandle | null      (non-blocking)
release(handle)
isLocked(scope, id)  → bool
```

## 4. Quy tắc

- Thời gian lock ngắn (chỉ quanh Execute → Commit).
- Nếu `tryAcquire` null → command nhận `WF-006` (already running) hoặc xếp queue (tùy policy).
- Lock được quản lý trong transaction (`acquire` → execute → `commit` → `unlock`).
- Không release lock chưa acquire (double unlock → lỗi).

## 5. Deadlock chống

- Order encode lock acquisition theo scope_id cố định.
- Timeout lock (ví dụ 60s), tự release nếu hết giờ.

## 6. Module liên hệ

- `transaction.md` (acquire/release quanh giao dịch)
- `executor.md` (chạy phase dưới lock)
- `persistence.md` (đọc/ghi artifact cần artifact lock)
- `recovery.md` (rollback phải có lock)