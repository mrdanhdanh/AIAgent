---
name: simulation-planner
description: Simulation Planner — xây dựng kế hoạch simulation từ workflow definition trước khi chạy.
agent: general
---

# Simulation Planner

## 1. Vai trò

Biến workflow definition thành **simulation plan** — danh sách steps sẽ mô phỏng.

## 2. Input

- Workflow definition (`workflow/definitions/*.yaml`).
- Execution mode.
- Option: scenario override.

## 3. Output plan

```yaml
plan:
  workflow: feature-development
  mode: dry-run
  steps:
    - { phase: analysis, capability: analysis.requirement }
    - { phase: planning, capability: architecture.design, depends_on: [analysis] }
    - { phase: implementation, capability: implementation.code, depends_on: [planning] }
    - { phase: review, capability: review.code, depends_on: [implementation] }
    - { phase: testing, capability: testing.e2e, depends_on: [review] }
```

## 4. Dependency order

Planner sắp xếp step theo `depends_on` (topological sort) — đảm bảo context/artifact hợp lệ khi simulate.

## 5. Skip logic

- Nếu phase không có capability agent → đánh dấu `PHASE_SKIPPED` dự đoán.
- Nếu workflow definition lỗi → simulation fail sớm.

## 6. Tương tác

- `simulator.md` — execute plan.
- `scenario.md` — đa scenario.
- `dependency-checker.md` — verify order.