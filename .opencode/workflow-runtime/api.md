---
name: workflow-runtime-api
description: api — Phase 1.13: Runtime API. Command không gọi Kernel trực tiếp, chỉ gọi qua runtime api.
agent: general
---

# Workflow Runtime API

> Command không làm sâu — mọi thao tác đều đi qua **Runtime API**. Mở rộng từ `runtime.md` section 3.

## 1. Runtime API

| API | Vai trò |
|-----|---------|
| `CreateWorkflow(def)` | nạp + đăng ký definition |
| `CompileWorkflow(id)` | sinh compiled.workflow.json |
| `ExecuteWorkflow(id, vars)` | tạo instance + chạy |
| `PauseWorkflow(id)` | dừng tạm |
| `ResumeWorkflow(id)` | tiếp tục |
| `CancelWorkflow(id)` | hủy |
| `RetryWorkflow(id)` | tự retry |
| `RollbackWorkflow(id)` | rollback |
| `GetState(id)` | state hiện tại |
| `GetMetrics(id)` | metrics |

## 2. API → Kernel → SDK

```text
command (/team)
   ↓
Runtime API
   ↓
Runtime Kernel (service)
```

Mọi `command` gọi qua `api.md`, không gọi Kernel/store trực tiếp.

## 3. API Contract

- Mỗi method trả `Result`:

```text
Result { ok, data, error_code, status }
```

- Error code theo `ERROR_HANDLING.md` (WF-001.., CAP-001...).
- Lock: `Pause/Resume/Retry` cần lock-manager trước khi đổi state.

## 4. Calling convention

```text
CreateWorkflow → Validate → Compile → CreateInstance → ExecuteNext → ... → Complete(Cancel|Rollback)
```

## 5. Idempotency

- `RetryWorkflow` nếu workflow đã Failed → chạy lại từ phase fail.
- `CancelWorkflow` chỉ đồng ý khi state Running/Paused.

## 6. Tương tác

- Dùng bởi: `sdk.md`, command, plugin (Phase 11), simulation, doctor, dashboard.
- Layer: `api.md` → `kernel.md` → stores.