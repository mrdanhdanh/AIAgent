---
name: policy-evaluator
description: Policy Evaluator — match request với rules; deny thắng allow; default deny.
agent: general
---

# Policy Evaluator

## 1. Vai trò

Đánh giá request (actor, action) so với policies.

## 2. Algorithm

```text
Evaluate(actor, action):
  rules = policies[actor]
  if deny rule matches action → DENY
  if allow rule matches action → ALLOW
  else → DENY (default)
```

## 3. Pattern match

| Pattern | Match |
|---------|-------|
| `planning.task` | planning.task |
| `planning.*` | planning.task, planning.test |
| `artifact.delete` | artifact.delete |
| `artifact.*` | artifact.read, artifact.delete |

## 4. Precedence

- **deny > allow** (khi overlap).
- Rule cụ thể > wildcard.

## 5. Output

```text
{ decision: allow|deny, matched_rule, reason }
```

## 6. Tương tác

- `policy.schema.yaml`.
- Enforcement points gọi evaluator.