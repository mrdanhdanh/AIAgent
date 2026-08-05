---
id: TERM-011
name: Knowledge
version: "1.0"
since: "1.0"
status: Approved
category: Knowledge
owner: Knowledge Base
stability: Stable
tags: [knowledge, learning, graph]
aliases: [Knowledge Base]
deprecated_aliases: [Reference]
summary: Tri thức chuẩn hóa, được Doctor và Agent sử dụng.
definition: >
  Knowledge là tri thức chuẩn hóa.
  Knowledge được Doctor và Agent sử dụng.
purpose: Lưu trữ bài học/pattern đã chuẩn hóa để tái sử dụng.
entity_type: Data
normative:
  MUST:
    - Be normalized (chuẩn hóa)
    - Be usable bởi Doctor và Agent
  MUST NOT:
    - Chứa raw memory (thuộc Memory)
responsibilities:
  - Lưu lessons/patterns
  - Cung cấp tri thức cho Doctor và Agent
does_not_responsible:
  - Lưu raw memory (thuộc Memory)
  - Thực thi
owned_by: Knowledge Base
used_by:
  - Doctor
  - Agent
  - Learning Agent
depends_on:
  - TERM-010 Memory
inputs:
  - Lesson từ Memory
outputs:
  - Tri thức chuẩn hóa
lifecycle: Collected → Verified → Published
states: [Collected, Verified, Published]
invariants:
  - Knowledge là tri thức chuẩn hóa.
related:
  - TERM-010
  - TERM-005
examples:
  - Lessons/patterns từ failure records
references:
  - P014 Observability First
  - P009 Single Source of Truth
---

# Knowledge

Knowledge là tri thức chuẩn hóa.

Được Doctor và Agent sử dụng.

## Normative

- **MUST** Be normalized.
- **MUST NOT** Chứa raw memory.

## Responsibilities

- Lưu lessons/patterns
- Cung cấp tri thức cho Doctor và Agent

## Invariant

> Knowledge là tri thức chuẩn hóa.
