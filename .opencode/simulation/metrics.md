---
name: simulation-metrics
description: Simulation Metrics — simulation time, prediction accuracy, average risk, token/duration estimate.
agent: general
---

# Simulation Metrics

## 1. Chỉ số

| Metric | Mô tả |
|--------|-------|
| simulation.time | thời gian chạy simulation (ms) |
| prediction.accuracy | độ chính xác dự đoán (so với thực tế sau execute) |
| avg.risk | risk trung bình các simulation |
| avg.confidence | confidence trung bình |
| estimated.tokens | token dự đoán |
| estimated.duration | duration dự đoán |
| reject.rate | tỉ lệ simulation reject |
| accuracy.by_mode | accuracy per mode |

## 2. So sánh predict vs thực tế

Sau khi execute thật, đối chiếu:

```text
predicted: tokens 12000, duration 85s
actual:    tokens 13500, duration 92s
accuracy:  89%
```

## 3. Lưu trữ

- `simulation/metrics.json`.
- Doctor đọc tổng hợp.

## 4. Tương tác

- `simulator.md` — ghi metrics.
- `report.md` — hiển thị estimate.
- Phase 10 (Evolution) — dùng prediction accuracy cải tiến.