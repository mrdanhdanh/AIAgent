---
id: P008
name: Single Responsibility
status: Draft
category: Architecture
severity: high
breaking_change: true
enforced_by:
  - doctor
implemented_in:
  - SPEC-004
related:
  - P001
  - P007
statement: >
  Một Agent chỉ làm một việc.
rationale: >
  Một Agent một trách nhiệm → dễ kiểm thử, dễ thay thế, dễ resolve theo capability.
  Chồng trách nhiệm làm Agent phình to, khó kiểm soát.
rules:
  - Mỗi Agent implement một capability cốt lõi.
  - Agent không làm việc ngoài capability của mình.
implications:
  - Planner không được code/review/test.
  - Builder không được review/test.
anti_patterns:
  - Agent vừa code vừa review vừa test.
  - Một Agent đảm nhiệm nhiều capability không liên quan.
exceptions:
  - Không có.
examples:
  - Planner: lập kế hoạch. Builder: code. Reviewer: review.
references:
  - P001 Runtime First
  - P007 Capability Driven
---

# P008 — Single Responsibility

## Statement

> Một Agent chỉ làm một việc.

## Rules

- Mỗi Agent implement một capability cốt lõi.
- Agent không làm việc ngoài capability.

## Implications

Planner không được:

- code
- review
- test

## Anti Pattern

❌ Agent vừa code vừa review vừa test.
