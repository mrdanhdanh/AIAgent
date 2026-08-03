---
id: RULE-004
name: Execution
status: Stable
version: 1.0.0
category: Execution
statement: >
  Execution theo sequence chuẩn: User→Command→Workflow→Phase→Task→Runtime→Capability→Registry→Agent→Artifact→Event→Done.
purpose: >
  Một đường thực thi chuẩn, dự đoán được, dễ theo dõi.
rules:
  - Execution qua đúng thứ tự.
  - Agent chọn qua Capability/Registry.
  - Artifact + Event sinh ra trong luồng.
constraints:
  allowed:
    - User→Command→Workflow→Phase→Task→Runtime→Capability→Registry→Agent→Artifact→Event→Done
  forbidden:
    - Bỏ qua Runtime.
    - Agent tự điều phối Agent khác.
examples:
  - Sequence chuẩn toàn bộ execution
related_principles:
  - P001
  - P007
related_rules:
  - RULE-001
  - RULE-013
verification:
  - doctor: sequence-check
  - runtime: orchestration-check
  - tests: execution-tests
---

# RULE-004 — Execution

## Statement

> Execution theo sequence chuẩn: User→Command→Workflow→Phase→Task→Runtime→Capability→Registry→Agent→Artifact→Event→Done.

## Purpose

Một đường thực thi chuẩn, dự đoán được, dễ theo dõi.

## Rules

- Execution qua đúng thứ tự.
- Agent chọn qua Capability/Registry.
- Artifact + Event sinh ra trong luồng.

## Allowed

- User→Command→Workflow→Phase→Task→Runtime→Capability→Registry→Agent→Artifact→Event→Done

## Forbidden

- Bỏ qua Runtime.
- Agent tự điều phối Agent khác.

## Example

```text
Sequence chuẩn toàn bộ execution
```

## Related Principles

- P001, P007

## Related Rules

- RULE-001, RULE-013

## Verification

- doctor: sequence-check
- runtime: orchestration-check
- tests: execution-tests
