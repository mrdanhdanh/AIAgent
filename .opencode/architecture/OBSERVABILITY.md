---
name: architecture-observability
description: OBSERVABILITY — định nghĩa metric quan sát cho Agent Framework v4: success rate, retry, token, exec time, failure rate.
agent: general
---

# OBSERVABILITY.md — Metric Quan Sát

> Mọi component đo được. Doctor/Evolution/Diagnostics đọc metric.

## 1. Core Metrics

| Metric | Loại | Mô tả |
|--------|------|-------|
| Workflow Success Rate | ratio | workflow Completed / total |
| Workflow Failure Rate | ratio | workflow Failed / total |
| Retry Count | counter | tổng lần retry |
| Average Token | gauge | token trung bình mỗi context |
| Execution Time | gauge | thời gian chạy (ms) |
| Phase Completion Rate | ratio | phase Done / total phase |
| Capability Coverage | ratio | capability Active / total |
| Event Throughput | counter | sự kiện xử lý / giây |
| Agent Utilization | ratio | agent Running time / total |

## 2. Định dạng log

Mọi log theo format:

```text
[<timestamp>] <SEVERITY> <SCOPE> <workflow_id> <metric_name>=<value>
```

Ví dụ:

```text
[2026-08-02T12:00:01Z] INFO workflow WF-20260802-004 phase_duration_ms=1200
[2026-08-02T12:00:02Z] WARN context WF-20260802-004 token_count=8200
```

## 3. Nơi lưu

- Log: `.opencode/events/` (Phase 6) hoặc runtime log file.
- Report tổng hợp: `.opencode/reports/`.
- Doctor đọc để tính health score.

## 4. Truy vấn metric

- `GET workflow/<id>` → status + metric
- `GET metric/summary` → aggregate (success rate, avg token, exec time)
- `GET metric/failure` → top failure codes

## 5. Quy tắc

- Mọi phase emit metric khi start/finish/fail.
- Không ghi PII/secret vào metric.
- Metric thay đổi ngưỡng → tham chiếu PERFORMANCE.md.