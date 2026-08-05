---
name: simulation-risk-engine
description: Risk Engine — tính Risk Score từ missing artifact, missing context, capability conflict, deprecated agent.
agent: general
---

# Risk Engine

## 1. Vai trò

Tính **Risk Score** (0..100) cho simulation. Cao = nguy hiểm.

## 2. Risk factors

| Factor | Điểm |
|--------|-----:|
| Missing artifact | 20 |
| Missing context | 10 |
| Capability conflict | 40 |
| Deprecated agent | 30 |
| Version conflict artifact | 25 |
| Dependency missing | 35 |
| Context budget over | 15 |
| Agent unstable (retry history) | 25 |

## 3. Formula

```
risk_score = sum(factor scores) / max_possible * 100
```

Hoặc weighted:

```
risk_score = Σ (weight_i × factor_i)
```

## 4. Risk bands

| Range | Level | Action |
|-------|-------|--------|
| 0-20 | low | proceed |
| 21-50 | medium | proceed-with-warning |
| 51-80 | high | reject (review) |
| 81-100 | critical | reject |

## 5. Per-step risk

Mỗi phase có risk riêng. Tổng = max hoặc weighted.

```text
step risk:
  analysis:      5
  planning:     10
  implementation: 25  (high — depends on missing artifact)
  review:       10
  testing:      15
```

## 6. Tương tác

- `simulator.md` — tính risk tổng.
- `confidence.md` — risk và confidence bổ sung nhau.
- `report.md` — hiển thị.