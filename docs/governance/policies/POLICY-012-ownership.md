---
id: POLICY-012
name: Ownership
status: Stable
version: 1.0.0
category: Decision
statement: >
  Mỗi Entity phải có Owner. Không Owner thì không Approved.
purpose: >
  Trách nhiệm rõ ràng.
rules:
  - Mỗi Entity có owner.
  - Owner là team.
  - Reviewer là Architecture Board.
  - Không owner → không approved.
allowed:
  - owner: { team, reviewer }
forbidden:
  - Entity không owner.
related_principles:
  - P016
  - P003
examples:
  - owner: { team: Runtime, reviewer: Architecture Board }
---

# POLICY-012 — Ownership

## Statement

> Mỗi Entity phải có Owner. Không Owner thì không Approved.

## Purpose

Trách nhiệm rõ ràng.

## Rules

- Mỗi Entity có owner.
- Owner là team.
- Reviewer là Architecture Board.
- Không owner → không approved.

## Allowed

- owner: { team, reviewer }

## Forbidden

- Entity không owner.

## Example

```text
owner: { team: Runtime, reviewer: Architecture Board }
```

## Related Principles

- P016, P003
