---
name: evolution-simulator
description: Simulator — validation proposal qua Simulation (Phase 7) + Backtest.
agent: general
---

# Evolution Simulator

## 1. Vai trò

Mọi proposal → Simulation. Risk cao → Reject.

## 2. Simulation flow

```text
Proposal
  → chạy simulation (phase 7, mode predict/what-if)
  → risk_score + confidence
  → high risk → reject
  → pass → backtest
```

## 3. Integration

- Reuse Simulation Engine (Phase 7) — không engine mới.
- Proposal `simulation` field lưu kết quả.

## 4. Decision

| Simulation result | Action |
|-------------------|--------|
| risk <= 40, confidence >= 70 | proceed → backtest |
| risk 41-60 | proceed-with-warning |
| risk > 60 | reject proposal |

## 5. Tương tác

- `simulation/` (Phase 7) — engine.
- `backtesting.md` — validate thêm.
- `planner.md` — proposal nhận kết quả.