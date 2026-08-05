---
name: workflow-runtime-scheduler
description: scheduler — Thành phần 5: quyết định phase nào chạy tiếp. Không gọi agent.
agent: general
---

# scheduler.md — Scheduler

> Thành phần 5. Quyết định **phase nào chạy tiếp**. Không gọi agent.

## 1. Trách nhiệm

```text
Compiled Workflow (execution_plan + DAG)
      ↓
 Scheduler → chọn step hiện tại (có thể nhiều phase song song)
      ↓
Trả về danh sách phase sẵn sàng để executor chạy
```

- Dựa vào `execution_plan` (compiler) + trạng thái `completed` chọn step sẵn sàng.
- **Mỗi step có thể chứa nhiều phase song song** (Phase DAG) — tiền đề Parallel Execution (v5).
- Phase 1: scheduler trả từng phase một (tuần tự); v5 cho chạy cả step song song.
- Trả về phase → executor chạy.

## 2. Ví dụ (single-thread Phase 1)

```text
feature.workflow.yaml
phases: analyze → design → review → backup → build → test → complete

Nếu completed = [analyze, design]
→ next = review
```

Step song song (nếu workflow có design + explore cùng step) — Phase 1 xử lý tuần tự từng một, v5 chạy song song.

Retry:

```text
build → Failed
→ retry build (không nhảy sang phase khác)
```

## 3. Quy tắc chọn phase

| Điều kiện | Phase kế tiếp |
|-----------|----------------|
| Có phase Ready (dependency Completed, chưa chạy) | chọn phase đó |
| Phase đang Running nhưng bị Fail + retry còn | retry lại cùng phase |
| Phase Fail + hết retry | báo recovery (abort/skip) |
| Hết phase chưa chạy | completed workflow |

## 4. Không làm

- Không gọi agent.
- Không sinh artifact.
- Không thay đổi state (chỉ đề xuất).

## 5. Output → Executor

- Trả `next_phase_id` → `executor.md` chạy.
- Nếu `null` (hết phase) → báo runtime hoàn tất.

## 6. Tương tác

- Gọi bởi `runtime.md → ExecuteNext(instance)`.
- Đọc `instance.completed` + `instance.failed`.