---
name: doctor-analyzer-behavioral
description: Behavioral Analyzer — phân tích agent/workflow behavior từ history: success rate, retry, patterns.
agent: general
---

# Behavioral Analyzer

## 1. Vai trò

Phân tích **hành vi thực tế** từ history — không đọc file, đọc kết quả.

## 2. Data sources

- `events/history.json` — AGENT_*, WORKFLOW_* events.
- `artifacts/history.json` — ai sửa, bao nhiêu version.
- `memory/failure-records/` — lỗi lặp lại.
- `simulation/metrics.json` — prediction accuracy.

## 3. Agent behavior

| Metric | Công thức |
|--------|-----------|
| success_rate | completed / (completed + failed) |
| retry_rate | retry / total runs |
| avg_duration | tổng duration / runs |
| failure_pattern | common error codes |

Ví dụ:

```text
Planner success 99%
Builder retry 42%  ← vấn đề
```

## 4. Workflow behavior

| Metric | Mô tả |
|--------|-------|
| completion_rate | workflow hoàn thành |
| retry_per_phase | phase nào retry nhiều |
| bottleneck_phase | phase hay fail/dừng |

## 5. Pattern detection

- Builder hay fail sau BUILD → context thiếu.
- Tester retry cao → test flaky.
- Workflow hay dừng sau BUILD_COMPLETED → dependency thiếu.

## 6. Tương tác

- `events/history.md` — nguồn.
- `health.md` — agent health.
- `rules/` — rule phát hiện pattern.
- Phase 10 (Evolution) — dùng kết quả.