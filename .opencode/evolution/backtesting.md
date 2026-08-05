---
name: evolution-backtesting
description: Backtesting — replay N workflow cũ so sánh trước/sau proposal trước khi apply.
agent: general
---

# Evolution Backtesting

## 1. Vai trò

Trước khi apply proposal → **replay N workflow cũ** để so sánh hiệu quả. Không chỉ Simulation.

## 2. Flow

```text
Proposal
  → chọn 100 workflow lịch sử (events history)
  → replay với proposal giả lập
  → so sánh trước vs sau
  → improved? → apply
  → not improved? → reject
```

## 3. Comparison metrics

| Metric | Trước | Sau |
|--------|------:|----:|
| tokens | 12000 | 7800 |
| duration | 85s | 60s |
| retry | 1.2 | 0.9 |
| success | 98% | 99% |

## 4. Result

```yaml
backtest:
  replayed: 100
  improved: true
  gain_pct: 35
  details: [...]
```

## 5. Điều kiện apply

- `improved: true` + gain đáng kể → apply.
- Không cải thiện → reject, ghi learning (không đề xuất lại).

## 6. Tương tác

- `events/replay.md` — replay engine.
- `simulator.md` — simulation trước backtest.
- `history.md` — ghi backtest result.
- Learning loop — không lặp proposal thất bại.