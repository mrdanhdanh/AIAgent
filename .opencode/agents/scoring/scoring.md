---
name: agent-scoring
description: scoring — xếp hạng agent candidate khi nhiều agent support cùng capability. Mở rộng từ registry/scorer.md.
agent: general
---

# Agent Scoring

## 1. Formula

```
Score = w_c*CapabilityMatch + w_l*LanguageMatch + w_f*FrameworkMatch
      + w_p*Priority + w_a*Availability + w_h*HistoricalSuccess
```

Trọng số (như registry/scorer.md): Cap 0.30, Lang 0.15, Fw 0.15, Priority 0.20, Avail 0.10, Hist 0.10.

## 2. Priority nguồn

- `capabilities.priority` (agent.schema.yaml) dùng làm `Priority` khi có.
- Fallback: `agent-registry.yaml` `priority`.
- Thống nhất: nếu khai ở metadata thì ưu tiên metadata; ngược lại dùng registry (non-invasive).

## 3. Ví dụ: planning.feature

| Agent | Cap | Prio | Lang | Fw | Avail | Hist | Score |
|-------|-----|-----:|------|----|-------|------|------:|
| planner | 1.0 | 90 | 1.0 | 1.0 | 1.0 | 1.0 | **99** |
| test-planner | 0.5 | 70 | 0.8 | 0.8 | 1.0 | 1.0 | **74** |
| general | 0.5 | 50 | 0.5 | 0.5 | 1.0 | 1.0 | **61** |

Planner thắng.

## 4. Tie-break

- Score bằng → priority cao hơn.
- Vẫn bằng → version mới hơn.

## 5. Fallback

- Agent không tồn tại/disabled → candidate kế tiếp.
- Hết → `orchestration.fallback` (general). KHÔNG crash.

## 6. Lưu ý

- Phase 3 định nghĩa formula + áp dụng khi resolve.
- `enabled: false` → không đưa vào scoring.