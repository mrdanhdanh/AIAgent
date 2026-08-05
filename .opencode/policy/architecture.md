---
name: policy-architecture
description: Kiến trúc Policy Engine — policy store, evaluator, enforcement points.
agent: general
---

# Policy Engine — Architecture

## 1. Components

```text
Policy Store (policies.yaml)
        │
        ▼
Policy Evaluator
  (match actor + action vs rules)
        │
        ▼
Enforcement Points
  Kernel · Plugin · Dashboard · Evolution
```

## 2. Rule model

```yaml
rule:
  subject: planner          # actor
  effect: allow | deny
  action: planning.*        # pattern
```

## 3. Match semantics

- Exact: `planning.task`.
- Wildcard: `planning.*`, `artifact.*`.
- Deny thắng allow (nếu overlap).
- Default deny khi không match.

## 4. Enforcement points

| Point | Check |
|-------|-------|
| Kernel.Execute | task actor vs policy |
| Plugin SDK | plugin permission |
| Dashboard API | role policy |
| Evolution Apply | admin policy |

## 5. Tương tác

- `policy.schema.yaml` — format.
- `evaluator.md` — logic.
- `kernel/` — enforce.