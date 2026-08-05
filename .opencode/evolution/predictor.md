---
name: evolution-predictor
description: Predictor — ước lượng tác động proposal (token, health, debt) trước khi apply.
agent: general
---

# Predictor

## 1. Vai trò

Dự đoán tác động của proposal trước khi apply — dùng trong proposal generator + backtest.

## 2. Prediction types

| Type | Mô tả |
|------|-------|
| token_gain | token giảm sau proposal |
| health_impact | Doctor score thay đổi |
| debt_impact | technical debt thay đổi |
| risk | rủi ro apply |
| compatibility | khả năng vỡ compat |

## 3. Model

```text
prediction = f(proposal type, current metrics, historical outcomes)
```

Lịch sử outcomes từ evolution history → cải thiện prediction theo thời gian.

## 4. Ví dụ

```text
Proposal: Enable Context Compression
  predicted token_gain: -35%
  predicted health: +2 (context score)
  risk: low
```

## 5. Validation

- Sau apply, so sánh predicted vs actual.
- Sai số lớn → điều chỉnh model (learning loop).

## 6. Tương tác

- `planner.md` — đề xuất gain.
- `backtesting.md` — validate prediction.
- `metrics.md` — prediction accuracy.