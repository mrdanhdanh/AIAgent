---
id: TERM-010
name: Memory
version: "1.0"
since: "1.0"
status: Draft
category: Data
owner: Memory Store
stability: Stable
tags: [data, memory, learning]
aliases: [Short-term Store]
deprecated_aliases: [Cache]
summary: Bộ nhớ tồn tại sau Runtime — working/session/failure.
definition: >
  Memory tồn tại sau Runtime (vượt qua một lần chạy).
  Memory chứa working/session/failure để học hỏi.
purpose: Lưu trữ trải nghiệm để cải thiện lần chạy sau.
entity_type: Data
normative:
  MUST:
    - Persist sau runtime
    - Lưu failure records
  MUST NOT:
    - Chứa tri thức chuẩn hóa (thuộc Knowledge)
responsibilities:
  - Lưu working memory
  - Lưu session memory
  - Lưu failure records
does_not_responsible:
  - Tri thức chuẩn hóa (thuộc Knowledge)
  - Chạy logic
owned_by: Memory Store
used_by:
  - Learning Agent
  - Doctor
depends_on:
  - TERM-001 Runtime
inputs:
  - Failure
  - Session data
outputs:
  - Lesson → Knowledge
lifecycle: Created → Updated → Retired
states: [Created, Updated, Retired]
invariants:
  - Memory tồn tại sau Runtime.
  - Memory không phải Context.
related:
  - TERM-009
  - TERM-011
examples:
  - Failure → Lesson → Knowledge
references:
  - P014 Observability First
---

# Memory

Memory tồn tại sau Runtime.

Ví dụ:

```text
Failure
    ↓
Lesson
    ↓
Knowledge
```

## Normative

- **MUST** Persist sau runtime.
- **MUST NOT** Chứa tri thức chuẩn hóa.

## Responsibilities

- Lưu working memory
- Lưu session memory
- Lưu failure records

## Invariant

> Memory tồn tại sau Runtime.
