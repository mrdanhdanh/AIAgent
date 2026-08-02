---
name: workflow-runtime-scheduler
description: scheduler — Thành phần 5: quyết định phase nào chạy tiếp. Không gọi agent.
agent: general
---

# scheduler.md — Scheduler

> Thành phần 5. Quyết định **phase nào chạy tiếp**. Không gọi agent.

## 1. Trách nhiệm

```text
Compiled Workflow
      ↓
 DAG (đã compile)
      ↓
 Scheduler → chọn phase kế tiếp
```

- Dựa vào `depends_on` + trạng thái `completed` để chọn phase sẵn sàng.
- Ưu tiên phase có tất cả dependency đã Completed.
- Trả về một phase duy nhất để executor chạy (sau này Phase sau cho phép song song).

## 2. Ví dụ

```text
feature.workflow.yaml
phases: analyze → design → review → backup → build → test → complete

Nếu completed = [analyze, design]
→ next = review
```

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