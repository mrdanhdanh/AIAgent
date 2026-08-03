---
id: P001
name: Runtime First
status: Draft
category: Runtime
severity: critical
breaking_change: true
enforced_by:
  - doctor
  - runtime
  - validator
implemented_in:
  - SPEC-001
  - SPEC-002
related:
  - P002
  - P005
  - P007
statement: >
  Runtime là trung tâm của AIOS. Mọi hoạt động đều phải được Runtime điều phối.
rationale: >
  Tách điều phối khỏi logic agent → agent đơn giản, thay thế được, scale được.
  Chỉ Runtime biết toàn cục; agent chỉ biết việc của mình.
rules:
  - Agent không gọi Agent.
  - Workflow không gọi Agent.
  - Plugin không gọi Agent.
  - Command không gọi Agent.
  - Chỉ Runtime được phép thực thi Agent.
implications:
  - Sai: Planner → Builder (gọi trực tiếp).
  - Đúng: Planner → Runtime → Builder.
  - Context/Artifact/Event truy cập qua Runtime API.
  - Không bypass Runtime.
anti_patterns:
  - Agent A gọi Agent B trực tiếp.
  - Agent tự đọc/sửa Workflow.
  - Agent tự sửa Runtime state.
exceptions:
  - Không có (bất biến tuyệt đối).
examples:
  - Planner sinh PLAN_READY → Runtime resolve Builder → Builder thực thi.
references:
  - P005 Event Driven
  - P007 Capability Driven
---

# P001 — Runtime First

## Statement

> Runtime là trung tâm của AIOS.
>
> Mọi hoạt động đều phải được Runtime điều phối.

## Rules

```text
Agent không gọi Agent.

Workflow không gọi Agent.

Plugin không gọi Agent.

Command không gọi Agent.

Chỉ Runtime được phép thực thi Agent.
```

## Implications

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
Runtime
    ↓
Builder
```

## Anti Pattern

❌

```text
Agent A
    ↓
Agent B
```

## Exceptions

Không có (bất biến tuyệt đối).
