---
name: evolution-policy
description: Evolution Policy — giới hạn proposal được phép tạo/apply theo category.
agent: general
---

# Evolution Policy

## 1. Vai trò

Không phải proposal nào cũng được phép tạo. Policy định nghĩa giới hạn.

## 2. Policies

```yaml
policies:
  performance:
    auto_propose: true
    auto_apply: false
  architecture:
    auto_propose: true
    auto_apply: false
  context:
    auto_propose: true
    auto_apply: false
  runtime:
    requires_review: true
    auto_apply: false
  workflow:
    auto_propose: true
    auto_apply: false
  capability:
    auto_propose: true
    requires_review: true
  plugin:
    manual_only: true
```

## 3. Policy fields

| Field | Ý nghĩa |
|-------|---------|
| auto_propose | engine tự sinh proposal |
| auto_apply | tự apply (thường false) |
| requires_review | phải review con người |
| manual_only | chỉ tay tạo |

## 4. Approval gate

- `auto_apply: false` → luôn cần approval.
- `manual_only` → engine không sinh.
- `requires_review` → proposal vào queue review.

## 5. Tương tác

- `planner.md` — filter theo policy.
- `migration.md` — apply theo policy.
- Dashboard — hiển thị approval queue.