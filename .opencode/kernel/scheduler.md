---
name: kernel-scheduler
description: Scheduler — điều phối task/phase; priority, queue, retry.
agent: general
---

# Kernel Scheduler

## 1. Vai trò

Lên lịch + điều phối mọi task trong kernel.

## 2. API

| Method | Mô tả |
|--------|-------|
| `Schedule(task)` | thêm task vào queue |
| `Dispatch()` | chạy task sẵn sàng |
| `Pause(id)` / `Resume(id)` | tạm dừng/tiếp tục |
| `Cancel(id)` | hủy |
| `GetStatus(id)` | trạng thái |

## 3. Priority

- critical > high > normal > low (như Event Queue P6).
- Resource-bound: nếu vượt budget → defer.

## 4. Queue

- FIFO trong cùng priority.
- Max concurrency (cấu hình).
- Backpressure khi queue đầy.

## 5. Tương tác

- `resource-manager.md` — budget check trước dispatch.
- `state-machine.md` — update trạng thái.
- Phase 6 (Event) — event khi task bắt đầu/hoàn thành.