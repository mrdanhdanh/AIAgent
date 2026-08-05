---
name: workflow-runtime-executor
description: executor — Thành phần 7: vòng chạy instance: load, chọn phase, execute, validate output, save artifact, update state, next.
agent: general
---

# executor.md — Executor

> Thành phần 7. Điều phối vòng chạy của một phase trong instance.

## 1. Vòng lặp executor

```text
Load Instance
      ↓
Find Current Phase
      ↓
Execute (qua dispatcher → agent)
      ↓
Validate Output
      ↓
Save Artifact
      ↓
Update State
      ↓
Next Phase (scheduler)
```

## 2. Trách nhiệm

1. Tải instance hiện tại (persistence).
2. Xác định phase cần chạy (scheduler).
3. Gọi **dispatcher** để execute (không gọi agent trực tiếp).
4. Validate output theo contract (validator runtime).
5. Lưu artifact (persistence).
6. Cập nhật state (persistence/state-machine).

## 3. Mỗi bước

| Bước | Tham chiếu |
|------|-----------|
| Load instance | persistence.md |
| Find current phase | scheduler.md |
| Execute | dispatcher.md (adapter → agent) |
| Validate output | validator.md (runtime) + CONTRACTS.md |
| Save artifact | persistence.md |
| Update state | state-machine.md |

## 4. Quyết định sau execute

| Kết quả | Hành động |
|---------|-----------|
| Output hợp lệ | Completed → lưu artifact → scheduler |
| Output lỗi | → recovery (retry/skip/abort) |
| Agent không có | → CAP-001 / fallback dispatcher |

## 5. Tương tác

- Driver: `runtime.md → ExecuteNext(instance)`.
- Không chạy song song (Phase 1).