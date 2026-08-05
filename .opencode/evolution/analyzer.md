---
name: evolution-analyzer
description: Analyzer — pattern detection từ metrics; phát hiện xu hướng vấn đề.
agent: general
---

# Evolution Analyzer

## 1. Vai trò

Đọc metrics từ Doctor/Runtime/Events → phát hiện **pattern** (xu hướng vấn đề).

## 2. Pattern sources

| Source | Pattern |
|--------|---------|
| Doctor | agent health thấp, unused capabilities |
| Runtime | retry cao, timeout |
| Events | dropped events, bottleneck phase |
| Context | avg tokens tăng |
| Artifact | orphan/broken dependency |

## 3. Pattern detection

```text
Builder retry 42%  → pattern: builder unstable
Context avg 12000  → pattern: context oversized
Capability unused 35 lần → pattern: deprecated candidate
Workflow hay dừng sau BUILD → pattern: dependency missing
```

## 4. Detect thresholds

| Metric | Threshold | Pattern |
|--------|-----------|---------|
| agent_retry_rate | > 0.2 | unstable agent |
| avg_context_tokens | > 8000 | oversized context |
| unused_days | > 90 | deprecated candidate |
| phase_retry_rate | > 0.3 | bottleneck phase |
| prediction_accuracy | < 0.85 | weak prediction |

## 5. Output

```yaml
patterns:
  - { type: unstable-agent, entity: builder, severity: medium }
  - { type: oversized-context, entity: context-engine, severity: high }
  - { type: deprecated-candidate, entity: capability.x, severity: low }
```

## 6. Tương tác

- `optimizer.md` — map pattern → optimization rule.
- `planner.md` — pattern → proposal.
- Doctor metrics — input.