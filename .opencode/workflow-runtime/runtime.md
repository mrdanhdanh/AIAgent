---
name: workflow-runtime-runtime
description: runtime — thành phần trung tâm Workflow Runtime v1: API, event, metrics, contract, test.
agent: general
---

# runtime.md — Workflow Runtime

> Thành phần trung tâm. Ra mắt toàn bộ API, event, metrics, contract, test của Runtime.

## 1. Trách nhiệm

| Trách nhiệm | Chi tiết |
|-------------|----------|
| Điều phối | dẫn dắt workflow từ Created → Archived |
| Không biết agent | chỉ biết Workflow/Phase/State/Contract/Artifact |
| Giao phối | loader → validator → compiler → scheduler → executor → dispatcher → recovery → persistence |

## 2. Thành phần hợp tác

| Module | Gọi khi |
|--------|---------|
| `loader.md` | nạp definition yaml → object |
| `validator.md` | validate definition trước khi chạy |
| `scheduler.md` | quyết phase kế tiếp |
| `executor.md` | chạy phase |
| `dispatcher.md` | gọi agent (adapter) |
| `recovery.md` | lỗi phase |
| `persistence.md` | lưu instance/state |

## 3. Runtime API

| API | Mô tả |
|-----|-------|
| `LoadWorkflow(id)` | nạp definition (qua loader) |
| `ValidateWorkflow(wf)` | validate definition (qua validator) |
| `CreateInstance(wf, vars)` | tạo instance mới |
| `ExecuteNext(instance)` | chạy phase hiện tại + chuyển phase kế tiếp |
| `Pause(instance)` | dừng tạm workflow (state Pending→Paused) |
| `Resume(instance)` | tiếp tục workflow từ Paused |
| `Retry(instance)` | thử lại phase lỗi |
| `Rollback(instance)` | hoàn về trạng thái an toàn |
| `Complete(instance)` | đánh dấu hoàn thành |

Mọi command (Phase 3+) đều gọi qua API này, không gọi agent trực tiếp.

## 4. Runtime Event

| Event | Khi nào |
|-------|---------|
| `WORKFLOW_CREATED` | instance tạo mới |
| `WORKFLOW_VALIDATED` | definition hợp lệ |
| `WORKFLOW_STARTED` | vào state Running |
| `PHASE_STARTED` | phase chạy |
| `PHASE_COMPLETED` | phase xong |
| `PHASE_FAILED` | phase lỗi |
| `WORKFLOW_PAUSED` | Pause() |
| `WORKFLOW_RESUMED` | Resume() |
| `WORKFLOW_FINISHED` | Completed |
| `WORKFLOW_ARCHIVED` | Archived |

Phase 6 đổi cách publish, giữ nguyên tên event.

## 5. Runtime Metrics (per workflow)

| Metric | Nguồn |
|--------|-------|
| started | workflow start time |
| finished | end time |
| duration | finished - started |
| retry_count | recovery |
| error_count | validator/executor |
| agent_count | dispatcher |
| artifact_count | persistence |

Doctor (Phase 8) đọc các metric này.

## 6. Runtime Contract

```text
Input Contract → Execution → Output Contract
```

- Runtime yêu cầu `outputs` đúng contract (CONTRACTS.md) trước khi chuyển phase.
- Không biết Planner/Builder/Tester — chỉ biết contract.

## 7. Runtime Test (không cần AI)

| Test | Kỳ vọng |
|------|---------|
| Workflow hợp lệ | create instance, chạy đến Completed |
| Workflow chồng phase | validator chặn khi compile |
| Workflow loop (dependency vòng) | validator chặn, không chạy |
| Dependency sai phase | validator báo WF-001 |
| Retry phase | sau retry phase chạy lại thành công |
| Rollback | khi fail → rollback về trạng thái an toàn |
| Dispatcher fallback | agent thiếu → CAP-001 / fallback |

## 8. Lỗi liên quan

- WF-001..WF-005, CFG-001, CAP-001 (xem ERROR_HANDLING.md)

## 9. Non-goals (Phase 1)

- Không multi-agent song song (v5).
- Không tự UI.
- Không tự ghi knowledge/memory.

## 10. Runtime Context (Phase 1.7)

> KHÔNG phải Context Engine (Phase 4). Đây là **Runtime Context** — chỉ runtime dùng.

```text
Workflow ID · Current Phase · Retry · State · Metrics · Current Artifact
```

- Không cho AI/agent truy cập.
- Lưu bởi `state-store.md`.
- Lifecycle: Created → Loaded → Updated → Released.
