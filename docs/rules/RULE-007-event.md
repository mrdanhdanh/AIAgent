---
id: RULE-007
name: Event
status: Stable
version: 1.0.0
category: Event
statement: >
  Mọi thay đổi phải phát Event. Event immutable.
purpose: >
  Replay, simulate, audit qua Event log.
rules:
  - Mọi state change phát Event.
  - Event immutable.
  - Event có lineage.
constraints:
  allowed:
    - Workflow Started
    - Workflow Completed
    - Task Failed
    - Artifact Created
    - Simulation Finished
    - Doctor Finished
  forbidden:
    - Thay đổi không phát Event.
    - Sửa Event sau publish.
examples:
  - Task Failed → Event phát ra
related_principles:
  - P005
  - P014
related_rules:
  - RULE-003
  - RULE-004
verification:
  - doctor: event-coverage
  - runtime: event-emission
  - tests: event-tests
---

# RULE-007 — Event

## Statement

> Mọi thay đổi phải phát Event. Event immutable.

## Purpose

Replay, simulate, audit qua Event log.

## Rules

- Mọi state change phát Event.
- Event immutable.
- Event có lineage.

## Allowed

- Workflow Started
- Workflow Completed
- Task Failed
- Artifact Created
- Simulation Finished
- Doctor Finished

## Forbidden

- Thay đổi không phát Event.
- Sửa Event sau publish.

## Example

```text
Task Failed → Event phát ra
```

## Related Principles

- P005, P014

## Related Rules

- RULE-003, RULE-004

## Verification

- doctor: event-coverage
- runtime: event-emission
- tests: event-tests
