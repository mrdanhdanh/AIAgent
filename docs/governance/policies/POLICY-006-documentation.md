---
id: POLICY-006
name: Documentation
status: Stable
version: 1.0.0
category: Documentation
scope:
  applies_to:
    - SPEC
    - Rule
    - Policy
    - Glossary
    - Manifest
  excludes:
    - Example
    - Playground
statement: >
  Mọi Entity phải có Human Readable + Machine Readable.
purpose: >
  AI vận hành được + con người hiểu được.
rules:
  - Human Readable (README.md).
  - Machine Readable (yaml).
  - Schema (schema.json).
allowed:
  - README.md + yaml + schema.json
forbidden:
  - Chỉ Markdown văn xuôi.
related_principles:
  - P017
  - P003
examples:
  - README.md + yaml + schema.json
---

# POLICY-006 — Documentation

## Statement

> Mọi Entity phải có Human Readable + Machine Readable.

## Purpose

AI vận hành được + con người hiểu được.

## Rules

- Human Readable (README.md).
- Machine Readable (yaml).
- Schema (schema.json).

## Allowed

- README.md + yaml + schema.json

## Forbidden

- Chỉ Markdown văn xuôi.

## Example

```text
README.md + yaml + schema.json
```

## Related Principles

- P017, P003
