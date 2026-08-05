---
name: architecture-lifecycle
description: LIFECYCLE — lifecycle của Workflow, Agent, Artifact, Capability, Context trong Agent Framework v4.
agent: general
---

# LIFECYCLE.md — Lifecycle

> Định nghĩa lifecycle của các đối tượng chính. State chi tiết xem STATE_MACHINE.md.

## 1. Workflow Lifecycle

```
Created → Validated → Running → Completed → Archived
                          ↘
                          Failed → Retry → Running
                          ↘
                          Rollback
```

| Stage | Mô tả |
|-------|-------|
| Created | definition được tạo |
| Validated | schema + capability + depends_on hợp lệ |
| Running | đang chạy phase |
| Completed | tất cả phase done |
| Archived | lưu trữ, không chạy nữa |
| Failed | lỗi không recover được |
| Rollback | hoàn về trạng thái an toàn |

## 2. Agent Lifecycle

```
Loaded → Ready → Running → Waiting → Completed
                    ↘
                    Failed
```

| Stage | Mô tả |
|-------|-------|
| Loaded | đăng ký vào registry |
| Ready | sẵn sàng nhận capability |
| Running | đang thực thi |
| Waiting | chờ artifact/context từ phase khác |
| Completed | hoàn thành |
| Failed | lỗi |

## 3. Artifact Lifecycle

```
Created → Validated → Versioned → Archived
```

| Stage | Mô tả |
|-------|-------|
| Created | sinh từ phase |
| Validated | checksum khớp, đúng format |
| Versioned | có version rõ (v1, v2) |
| Archived | lưu trữ không active |

## 4. Capability Lifecycle

```
Registered → Active → Deprecated
   ↘
   Partial
```

| Stage | Mô tả |
|-------|-------|
| Registered | đăng ký, chưa có provider đầy đủ |
| Active | có provider, sẵn sàng |
| Partial | provider thiếu (skill/command cover một phần) |
| Deprecated | ngừng dùng, chờ thay thế |

## 5. Context Lifecycle

```
Created → Loaded → Updated → Released
```

| Stage | Mô tả |
|-------|-------|
| Created | khởi tạo scope |
| Loaded | đưa vào runtime |
| Updated | ghi thêm dữ liệu |
| Released | giải phóng khỏi runtime |

## 6. Quy tắc chuyển pha

- Chỉ chuyển theo đúng STATE_MACHINE (không nhảy).
- Mỗi transition bắt buộc emit Event.
- Fail → Retry tối đa theo `retry` trong definition, sau đó Failed.
- Workflow Failed hoặc Completed → Archived sau khi hết thời gian active.