---
id: POLICY-010
name: Quality
status: Stable
version: 1.0.0
category: Quality
scope:
  applies_to:
    - Deliverable
    - SPEC
    - Plugin
  excludes:
    - Example
    - Playground
statement: >
  Mỗi Deliverable phải đạt: Validation Pass, Doctor Pass, Schema Pass, Cross Reference Pass.
purpose: >
  Chất lượng đo được, gate trước khi hợp nhất.
rules:
  - Validation Pass.
  - Doctor Pass.
  - Schema Pass.
  - Cross Reference Pass.
allowed:
  - Validation + Doctor + Schema + Cross Reference
forbidden:
  - Deliverable không qua gate.
related_principles:
  - P014
  - P015
examples:
  - Validation Pass + Doctor Pass + Schema Pass + Cross Reference Pass
---

# POLICY-010 — Quality

## Statement

> Mỗi Deliverable phải đạt: Validation Pass, Doctor Pass, Schema Pass, Cross Reference Pass.

## Purpose

Chất lượng đo được, gate trước khi hợp nhất.

## Rules

- Validation Pass.
- Doctor Pass.
- Schema Pass.
- Cross Reference Pass.

## Allowed

- Validation + Doctor + Schema + Cross Reference

## Forbidden

- Deliverable không qua gate.

## Example

```text
Validation Pass + Doctor Pass + Schema Pass + Cross Reference Pass
```

## Related Principles

- P014, P015
