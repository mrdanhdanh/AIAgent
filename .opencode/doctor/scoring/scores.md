---
name: doctor-scoring
description: Scoring — trọng số từng nhóm, cách tính overall score, bands.
agent: general
---

# Scoring

## 1. Group weights

| Group | Weight |
|-------|-------:|
| architecture | 0.15 |
| runtime | 0.15 |
| context | 0.15 |
| workflow | 0.15 |
| registry | 0.10 |
| agent | 0.10 |
| artifact | 0.08 |
| event | 0.07 |
| simulation | 0.05 |

## 2. Overall

```
overall = Σ(weight_i × score_i)
```

## 3. Score bands

| Range | Level |
|-------|-------|
| 90-100 | excellent |
| 80-89 | good |
| 70-79 | acceptable |
| <70 | critical |

## 4. Per-group formula

Mỗi group = 100 − penalties:

```text
group_score = 100 − Σ(penalty_rule_matches)
```

Ví dụ registry: duplicate 5 (−1 mỗi), deprecated 2 (−2 mỗi), unused 18 (−0.5 mỗi) → 100 − 15 = 85.

## 5. Penalty table

| Issue | Penalty |
|-------|--------:|
| duplicate | 1 each |
| deprecated active | 2 each |
| unused capability | 0.5 each |
| missing artifact | 3 each |
| dropped event | 2 each |
| retry > 20% | 5 |
| context > target | 5 |

## 6. Tương tác

- `health.md` — compute groups.
- `rules/rules.yaml` — penalty mapping.
- `doctor.schema.yaml` — output fields.