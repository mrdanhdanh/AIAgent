---
id: P013
name: Simulation Before Execution
status: Draft
category: AI
severity: high
breaking_change: true
enforced_by:
  - doctor
  - runtime
implemented_in:
  - SPEC-014
related:
  - P011
  - P015
  - P016
statement: >
  Workflow mới phải qua Simulation trước khi Execute.
rationale: >
  Dự đoán kết quả trước khi chạy thật → giảm rủi ro, phát hiện lỗi thiết kế sớm.
  Simulation không tốn tài nguyên thật.
rules:
  - Workflow mới/thay đổi → Simulation.
  - Simulation báo rủi ro trước khi Execute.
  - Có Approval trước khi chạy thật.
implications:
  - Workflow mới → Simulation → Doctor → Approval → Execute.
anti_patterns:
  - Chạy workflow mới mà không mô phỏng.
  - Bỏ qua kết quả simulation.
exceptions:
  - Workflow đã freeze không cần simulation lại.
examples:
  - Workflow mới → Simulation → Doctor → Approval → Execute.
references:
  - P011 Explicit Dependency
  - P015 Fail Safe
  - P016 Human Approval
---

# P013 — Simulation Before Execution

## Statement

> Workflow mới → Simulation → Doctor → Approval → Execute.

## Rules

```text
Workflow mới
    ↓
Simulation
    ↓
Doctor
    ↓
Approval
    ↓
Execute
```

## Implications

- Dự đoán trước khi chạy thật.
- Giảm rủi ro.

## Anti Pattern

❌ Chạy workflow mới mà không mô phỏng.
