---
name: workflow-runtime-extensions
description: extensions — Phase 1.16: Runtime Extension Points. Không module nào được sửa Runtime Core — chỉ hook. Plugin đăng ký hook.
agent: general
---

# extensions.md — Runtime Extension Points

> **Không module nào sửa Runtime Core.** Chỉ được "hook". Plugin (Phase 11) đăng ký hook.

## 1. Extension Points

```text
               Workflow Runtime
                      │
      ┌───────────────┼────────────────┐
      │               │                │
 Before Phase     After Phase     On Error
      │               │                │
      └───────────────┼────────────────┘
                      │
                 Extension
```

| Hook Point | Chạy khi | Ví dụ |
|-----------|----------|-------|
| `before_phase` | trước mỗi phase | validate, inject context |
| `after_phase` | sau mỗi phase xong | generate report |
| `on_error` | khi phase fail | notify, cleanup |

## 2. Ví dụ usage

```text
Before Build
    ↓
Validate
    ↓
Inject Context
```

```text
After Test
    ↓
Generate Report
```

Không sửa Runtime.

## 3. Hook Definition

```yaml
hook:
  id: validate-before-build
  event: before_phase
  phase: build
  priority: 100
  enabled: true
```

| Field | Mô tả |
|-------|-------|
| id | tên hook duy nhất |
| event | before_phase / after_phase / on_error |
| phase | (optional) giới hạn phase |
| priority | thấp chạy trước (default 100) |
| enabled | bật/tắt |

## 4. Contract hook

```text
hook(context) → void
context { workflow_id, phase, instance, error? }
```

Hook không trả dữ liệu mới — chỉ mutate context (inject) hoặc ghi log/report. Nếu hook lỗi → xử lý riêng, không làm hỏng phase chính.

## 5. Quy tắc

- Hook không gọi AI (AI gắn qua hook từ Phase 2+).
- Hook không thay đổi state machine/transaction.
- Hook chạy ngoài transaction chính (không lock lâu).

## 6. Đăng ký

- Plugin (Phase 11) đăng ký hook vào registry hooks.
- Runtime gọi hook theo `priority`.

## 7. Tương tác

- `extensions.md` được dùng bởi: `runtime.md` (gọi hook), `plugin.md` (Phase 11 đăng ký), `sdk.md`.