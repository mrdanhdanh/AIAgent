---
id: skill
name: Skill
status: Draft
category: knowledge
summary: Thư viện tri thức tái sử dụng; không thực thi; không có state.
definition: >
  Skill là thư viện tri thức có thể tái sử dụng. Skill không thực thi.
  Skill không có state.
purpose: Cung cấp kiến thức/quy trình cho Agent dùng khi thực thi.
responsibilities:
  - Chứa tri thức tái sử dụng
  - Được Agent tham chiếu khi cần
does_not_responsible:
  - Thực thi
  - Giữ state
owned_by: Skill Library
used_by:
  - Agent
  - Command
inputs:
  - Không (static)
outputs:
  - Tri thức/quy trình
lifecycle: Draft → Published → Deprecated
related:
  - agent
  - knowledge
  - command
examples:
  - Blazor Skill → Builder sử dụng
references:
  - P010 Plugin First
---

# Skill

Skill là thư viện tri thức có thể tái sử dụng.

Skill không thực thi.

Ví dụ:

```text
Blazor Skill
    ↓
Builder sử dụng
```

Skill không có state.

## Responsibilities

- Chứa tri thức tái sử dụng
- Được Agent tham chiếu khi cần

## Not Responsible

- Thực thi
- Giữ state

## Owner

Skill Library

## Used By

- Agent
- Command

## Input

- Không (static)

## Output

- Tri thức/quy trình
