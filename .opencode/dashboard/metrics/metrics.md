---
name: dashboard-metrics
description: Metrics — dashboard aggregates: workflow/day, avg token, avg time, health, simulation accuracy, evolution gain.
agent: general
---

# Dashboard Metrics

## 1. Chỉ số

| Metric | Mô tả |
|--------|-------|
| workflow.day | workflow mỗi ngày |
| avg.token | token trung bình/workflow |
| avg.time | thời gian trung bình |
| health | health score hiện tại |
| simulation.accuracy | độ chính xác simulation |
| evolution.gain | gain từ proposal applied |
| cache.hit | context cache hit |
| plugin.count | plugin enabled |
| error.rate | tỉ lệ lỗi |

## 2. Aggregation

- Per-day/weekly aggregation.
- Trend line theo thời gian.

## 3. Nguồn

- Snapshot projections.
- Doctor metrics.
- Event metrics.
- Simulation metrics.

## 4. Lưu trữ

- `dashboard/metrics.json` — aggregates.
- Dashboard hiển thị charts.

## 5. Tương tác

- `projection/` — data.
- `reports/` — sinh báo cáo từ metrics.
- Doctor/Evolution metrics — nguồn.