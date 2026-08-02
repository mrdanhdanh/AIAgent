---
name: workflow-runtime-metrics
description: metrics — Phase 1.11: Runtime Metrics đầy đủ: Phase Time, Retry, Recovery, Agent Time, Artifact Count, Execution Graph, Waiting Time...
agent: general
---

# metrics.md — Runtime Metrics

> Không chỉ Duration. Metrics xuyên suốt để Doctor (Phase 8) + Dashboard (12) dùng. Mở rộng từ `OBSERVABILITY.md`.

## 1. Bảng metrics

| metric | Mô tả |
|--------|-------|
| workflow_duration | tổng thời gian 1 workflow |
| phase_time | thời gian từng phase |
| retry_count | tổng số lần retry |
| recovery_count | bao nhiêu lần recovery (mọi strategy) |
| agent_time | thời gian agent thực hiện mỗi phase |
| artifact_count | số artifact trong workflow |
| execution_graph | DAG compile ra (để tái hiện) |
| waiting_time | thời gian chờ dependency/context |
| error_count | tổng lỗi ghi nhận |
| phase_success_rate | Completed / total phase |

## 2. Thu thập

| Nơi ghi | Metric |
|---------|--------|
| compiler | execution_graph, cycle check |
| executor | phase_time, agent_time, artifact_count |
| scheduler | waiting_time |
| recovery | retry_count, recovery_count |
| validator/executor | error_count |

## 3. Lưu

- Per-workflow: `instance.metrics` (instance.json).
- Aggregate: `.opencode/reports/` (Doctor/Evolution đọc).

## 4. Truy vấn

```text
GetMetrics() → snapshot trong runtime log
```

## 5. Phân tích

- `waiting_time` cao → scheduling/song song tệ (cải v5).
- `retry_count` cao → phase không ổn định → recovery/escalate.
- `execution_graph` lưu DAG để tái hiện & debug.

## 6. Module liên hệ

- `health.md` (dùng metrics để chấm sức khỏe)
- `runtime.md/recovery.md` (ghi metrics)
- `OBSERVABILITY.md` (chuẩn tổng thể)
- `PERFORMANCE.md` (ngưỡng)