---
id: P007
name: Capability Driven
status: Draft
category: Runtime
severity: critical
breaking_change: true
enforced_by:
  - doctor
  - runtime
  - registry
implemented_in:
  - SPEC-003
  - SPEC-005
related:
  - P001
  - P012
statement: >
  Runtime không biết Agent cụ thể. Runtime chỉ biết Capability.
rationale: >
  Tách "cần làm gì" khỏi "ai làm". Capability không phụ thuộc implementation.
  Registry resolve Capability → Agent/Plugin.
rules:
  - Không gọi Agent cụ thể — gọi Capability.
  - Capability không phụ thuộc implementation.
  - Runtime resolve qua Registry.
implications:
  - Runtime chỉ biết "Generate Code", không biết Builder.
  - Builder Agent hoặc External Plugin đều hợp lệ.
anti_patterns:
  - Hard-code tên Agent trong Workflow.
  - Runtime biết implementation chi tiết.
exceptions:
  - Không có.
examples:
  - Generate Code → Registry → Builder Agent | External Plugin → Done.
references:
  - P001 Runtime First
  - P012 Plugin First
---

# P007 — Capability Driven

## Statement

> Runtime không biết Builder. Runtime chỉ biết "Generate Code".

## Rules

```text
Generate Code
    ↓
Registry
    ↓
Builder Agent | External Plugin
    ↓
Done
```

## Implications

- Capability không phụ thuộc implementation.
- Đổi Agent/Plugin không đổi Workflow.

## Anti Pattern

❌ Hard-code tên Agent trong Workflow.
