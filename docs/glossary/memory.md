---
id: memory
name: Memory
status: Draft
category: data
summary: Bộ nhớ tồn tại sau Runtime — working/session/failure.
definition: >
  Memory tồn tại sau Runtime (vượt qua một lần chạy).
  Memory chứa working/session/failure để học hỏi.
purpose: Lưu trữ trải nghiệm để cải thiện lần chạy sau.
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
inputs:
  - Failure
  - Session data
outputs:
  - Lesson → Knowledge
lifecycle: Created → Updated → Retired
related:
  - context
  - knowledge
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

## Responsibilities

- Lưu working memory
- Lưu session memory
- Lưu failure records

## Not Responsible

- Tri thức chuẩn hóa (thuộc Knowledge)
- Chạy logic

## Owner

Memory Store

## Used By

- Learning Agent
- Doctor

## Input

- Failure
- Session data

## Output

- Lesson → Knowledge
