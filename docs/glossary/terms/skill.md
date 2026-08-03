---
id: TERM-016
name: Skill
version: "1.0"
since: "1.0"
status: Draft
category: Knowledge
owner: Skill Library
stability: Stable
tags: [knowledge, skill, reusable]
aliases: [Knowledge Pack]
deprecated_aliases: [Playbook]
summary: Thư viện tri thức tái sử dụng; không thực thi; không có state.
definition: >
  Skill là thư viện tri thức có thể tái sử dụng. Skill không thực thi.
  Skill không có state.
purpose: Cung cấp kiến thức/quy trình cho Agent dùng khi thực thi.
entity_type: Definition
normative:
  MUST:
    - Be reusable
    - Be stateless
  MUST NOT:
    - Execute
    - Giữ state
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
depends_on: []
inputs:
  - Không (static)
outputs:
  - Tri thức/quy trình
lifecycle: Draft → Published → Deprecated
states: [Draft, Published, Deprecated]
invariants:
  - Skill không có state.
  - Skill không thực thi.
related:
  - TERM-005
  - TERM-011
  - TERM-007
examples:
  - Blazor Skill → Builder sử dụng
references:
  - P012 Plugin First
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

## Normative

- **MUST** Be reusable.
- **MUST NOT** Execute.

## Responsibilities

- Chứa tri thức tái sử dụng
- Được Agent tham chiếu khi cần

## Invariant

> Skill không có state.
