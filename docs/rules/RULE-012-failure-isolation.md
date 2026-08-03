---
id: RULE-012
name: Failure Isolation
status: Stable
version: 1.0.0
category: Reliability
statement: >
  Một Agent lỗi không được làm sập Runtime. Runtime catch → Event → Rollback/Retry.
purpose: >
  Nền tảng cho Failure Agent và Root Cause Agent.
rules:
  - Agent failure → Runtime catch.
  - Phát Event.
  - Rollback hoặc Retry.
constraints:
  allowed:
    - Agent Failure → Runtime Catch → Event → Rollback/Retry
  forbidden:
    - Agent lỗi làm sập Runtime.
examples:
  - Agent Failure → Runtime Catch → Event → Rollback/Retry
related_principles:
  - P015
  - P005
related_rules:
  - RULE-008
  - RULE-004
verification:
  - doctor: error-handling-check
  - runtime: rollback-check
  - tests: failure-isolation-tests
---

# RULE-012 — Failure Isolation

## Statement

> Một Agent lỗi không được làm sập Runtime. Runtime catch → Event → Rollback/Retry.

## Purpose

Nền tảng cho Failure Agent và Root Cause Agent.

## Rules

- Agent failure → Runtime catch.
- Phát Event.
- Rollback hoặc Retry.

## Allowed

- Agent Failure → Runtime Catch → Event → Rollback/Retry

## Forbidden

- Agent lỗi làm sập Runtime.

## Example

```text
Agent Failure → Runtime Catch → Event → Rollback/Retry
```

## Related Principles

- P015, P005

## Related Rules

- RULE-008, RULE-004

## Verification

- doctor: error-handling-check
- runtime: rollback-check
- tests: failure-isolation-tests
