---
id: P005
name: Event Driven
status: Draft
category: Runtime
severity: critical
breaking_change: true
enforced_by:
  - doctor
  - runtime
implemented_in:
  - SPEC-010
  - SPEC-011
related:
  - P001
  - P014
statement: >
  Không notify trực tiếp. Mọi state change phát Event.
rationale: >
  Event immutable + lineage → replay/simulate/audit không cần chạy lại.
  Tách producer khỏi consumer.
rules:
  - Mọi state change đều phát Event.
  - Không gọi trực tiếp khi thông báo.
  - Event immutable, có lineage.
implications:
  - Sai: Planner → Builder (gọi trực tiếp).
  - Đúng: Planner → PLAN_READY → Builder.
anti_patterns:
  - Notify trực tiếp qua method call.
  - Sửa event sau khi publish.
exceptions:
  - Không có.
examples:
  - PLAN_READY, BUILD_FINISHED, TEST_FAILED.
references:
  - P001 Runtime First
  - P014 Observability First
---

# P005 — Event Driven

## Statement

> Không notify trực tiếp.

## Rules

Sai:

```text
Planner
    ↓
Builder
```

Đúng:

```text
Planner
    ↓
PLAN_READY
    ↓
Builder
```

## Implications

- Event immutable.
- Có lineage.
- Replay/simulate/audit được.

## Anti Pattern

❌ Notify trực tiếp qua method call.
