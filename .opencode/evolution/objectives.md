---
name: evolution-objectives
description: Evolution Objectives — mục tiêu dài hạn; evolution tối ưu theo objective, không ngẫu nhiên.
agent: general
---

# Evolution Objectives

## 1. Vai trò

Framework có mục tiêu dài hạn — Evolution tối ưu **theo objective**, không ngẫu nhiên.

## 2. Objectives

```yaml
objectives:
  token_budget:
    target: 5000
    current: 8500
  workflow_duration:
    target: 60
    current: 85
  coverage:
    target: 100
    current: 88
  runtime_health:
    target: 98
    current: 96
  doctor_score:
    target: 95
    current: 97
```

## 3. Gap analysis

```text
gap = current - target
Objective có gap lớn → ưu tiên proposal liên quan.
```

## 4. Proposal alignment

- Proposal performance → đóng góp token_budget.
- Proposal coverage → đóng góp coverage.
- Proposal được đánh giá theo mức đóng góp objective.

## 5. Tương tác

- `analyzer.md` — pattern theo objective.
- `optimizer.md` — chọn giải pháp đạt objective.
- `metrics.md` — theo dõi gap giảm.