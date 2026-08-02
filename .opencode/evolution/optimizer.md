---
name: evolution-optimizer
description: Optimizer — optimization rules map pattern → giải pháp đề xuất.
agent: general
---

# Optimizer

## 1. Vai trò

Map **pattern** → **giải pháp** qua optimization rules.

## 2. Optimization rules

| Pattern | Rule | Giải pháp |
|---------|------|-----------|
| agent retry > 20% | OPT-001 | review agent prompt/contract |
| context > 8000 | OPT-002 | enable context compression |
| unused capability | OPT-003 | deprecate capability |
| bottleneck phase | OPT-004 | thêm context/artifact cho phase |
| duplicate profile | OPT-005 | merge context profiles |
| broken dependency | OPT-006 | fix artifact dependency chain |
| low coverage | OPT-007 | thêm agent/skill cho capability |
| weak prediction | OPT-008 | refine simulation model |

## 3. Output

```yaml
optimizations:
  - { pattern: oversized-context, rule: OPT-002, solution: enable_context_compression, gain: "-35% tokens" }
  - { pattern: deprecated-candidate, rule: OPT-003, solution: deprecate_capability, gain: "less debt" }
```

## 4. Gain estimation

Mỗi giải pháp ước lượng gain:
- Token giảm X%.
- Health tăng Y.
- Debt giảm Z.

## 5. Tương tác

- `analyzer.md` — input pattern.
- `planner.md` — solution → proposal.
- `objectives.md` — gain hướng tới objective.