---
id: POLICY-011
name: Traceability
status: Stable
version: 1.0.0
category: Decision
scope:
  applies_to:
    - SPEC
    - Implementation
    - Test
    - Artifact
  excludes:
    - Example
    - Playground
statement: >
  Mọi thành phần phải truy vết được: Requirement→SPEC→Implementation→Test→Artifact.
purpose: >
  Doctor và Dashboard truy vết nguồn gốc.
rules:
  - Requirement→SPEC.
  - SPEC→Implementation.
  - Implementation→Test.
  - Test→Artifact.
allowed:
  - Requirement→SPEC→Implementation→Test→Artifact
forbidden:
  - Thành phần không truy vết.
related_principles:
  - P008
  - P003
examples:
  - Requirement → SPEC → Implementation → Test → Artifact
---

# POLICY-011 — Traceability

## Statement

> Mọi thành phần phải truy vết được: Requirement→SPEC→Implementation→Test→Artifact.

## Purpose

Doctor và Dashboard truy vết nguồn gốc.

## Rules

- Requirement→SPEC.
- SPEC→Implementation.
- Implementation→Test.
- Test→Artifact.

## Allowed

- Requirement→SPEC→Implementation→Test→Artifact

## Forbidden

- Thành phần không truy vết.

## Example

```text
Requirement → SPEC → Implementation → Test → Artifact
```

## Related Principles

- P008, P003
