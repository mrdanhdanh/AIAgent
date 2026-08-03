---
id: knowledge
name: Knowledge
status: Draft
category: knowledge
summary: Tri thức chuẩn hóa, được Doctor và Agent sử dụng.
definition: >
  Knowledge là tri thức chuẩn hóa.
  Knowledge được Doctor và Agent sử dụng.
purpose: Lưu trữ bài học/pattern đã chuẩn hóa để tái sử dụng.
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
inputs:
  - Lesson từ Memory
outputs:
  - Tri thức chuẩn hóa
lifecycle: Collected → Verified → Published
related:
  - memory
  - agent
  - doctor
examples:
  - Lessons/patterns từ failure records
references:
  - P008 Observable
  - P012 Single Source of Truth
---

# Knowledge

Knowledge là tri thức chuẩn hóa.

Được Doctor và Agent sử dụng.

## Responsibilities

- Lưu lessons/patterns
- Cung cấp tri thức cho Doctor và Agent

## Not Responsible

- Lưu raw memory (thuộc Memory)
- Thực thi

## Owner

Knowledge Base

## Used By

- Doctor
- Agent
- Learning Agent

## Input

- Lesson từ Memory

## Output

- Tri thức chuẩn hóa
