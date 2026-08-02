---
name: agent-lifecycle
description: lifecycle — vòng đời của Agent Object từ Created → Running → Archived (kèm Failed/Retry/Disabled).
agent: general
---

# Agent Lifecycle

> Agent là thực thể có cấu trúc (Identity+Capability+Behavior+Runtime) do Runtime quản lý.
> Lifecycle mô tả trạng thái một agent instance xuyên suốt một task.

## 1. State Machine

```text
Created
   ↓
Loaded
   ↓
Validated
   ↓
Ready ──────┐
   ↓        │ lỗi → Failed → Retry
Running     └─────────┐
   │                  ↓
   ↓                (retry hết)
Waiting               Disabled
   ↓
Completed
   ↓
Archived
```

## 2. State mô tả

| State | Ý nghĩa |
|-------|---------|
| Created | metadata được tạo, chưa nạp |
| Loaded | agent.yaml + prompt đã load vào memory |
| Validated | pass schema/capability/contract/dependency/compat |
| Ready | sẵn sàng nhận task |
| Running | đang thực thi |
| Waiting | chờ dependency/context/input |
| Completed | hoàn thành, output đã validate |
| Archived | kết thúc, lưu lịch sử |
| Failed | lỗi chạy |
| Disabled | retry cạn kiệt → tắt |

## 3. Transition

| Từ | Sang | Điều kiện |
|----|------|-----------|
| Created | Loaded | registry đọc được agent |
| Loaded | Validated | validator PASS |
| Validated | Ready | không còn ràng buộc |
| Ready | Running | resolver gán task |
| Running | Waiting | thiếu context/input |
| Waiting | Running | có đủ context |
| Running | Completed | output hợp lệ |
| Running | Failed | lỗi |
| Failed | Retry | còn retry budget |
| Retry | Ready | hết retry → sẵn sàng lại |
| Failed/Retry | Disabled | hết retry & không recover |
| Completed | Archived | end of task |

## 4. Fallback

- Agent Failed → Recovery (workflow-runtime/recovery.md) triển khai retry theo `retry` field.
- Hết retry → Disabled → Resolver chọn candidate kế tiếp. KHÔNG crash.
- `orchestration.fallback` (general) là agent cuối dự phòng.

## 5. Event tương tác

- Phase 6 (Event System) theo dõi lifecycle transition (state change event).
- Phase 8 (Doctor) đọc trạng thái để báo health.
- `state-machine.md` có chi tiết transition/guard.