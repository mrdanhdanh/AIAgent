---
name: evolution-metrics
description: Evolution Metrics — proposal count, accepted/rejected, success rate, estimated vs actual gain.
agent: general
---

# Evolution Metrics

## 1. Chỉ số

| Metric | Mô tả |
|--------|-------|
| proposal.count | tổng proposal |
| accepted | số approved |
| rejected | số rejected |
| success.rate | proposal applied thành công |
| estimated.gain | gain dự đoán |
| actual.gain | gain thực tế sau apply |
| prediction.accuracy | độ chính xác predictor |
| backtest.rate | tỉ lệ backtest pass |

## 2. So sánh estimated vs actual

```text
Proposal EVO-001: estimated -35%, actual -32% → accuracy 91%
```

## 3. Learning loop

```text
Proposal applied
  → Doctor đo lại
  → improved? → ghi knowledge (pattern tốt)
  → not improved? → ghi learning (đừng đề xuất lại)
```

## 4. Lưu trữ

- `evolution/metrics.json`.
- Doctor đọc + Dashboard hiển thị.

## 5. Tương tác

- `predictor.md` — accuracy.
- `history.md` — outcomes.
- Dashboard (Phase 12) — hiển thị.