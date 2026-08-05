---
id: POLICY-003
name: Compatibility
status: Stable
version: 1.0.0
category: Compatibility
scope:
  applies_to:
    - Runtime
    - Workflow
    - Plugin
    - SPEC
    - Contract
  excludes:
    - Example
    - Playground
statement: >
  backward required, forward preferred. Breaking change requires RFC.
purpose: >
  Không phá consumer; nền tảng Evolution Engine.
rules:
  - backward: required.
  - forward: preferred.
  - breaking_change: requires_rfc.
allowed:
  - Thay đổi backward compatible
forbidden:
  - Breaking change không RFC.
related_principles:
  - P018
  - P015
  - P002
examples:
  - compatibility: { backward: required, forward: preferred, breaking_change: { requires_rfc: true } }
---

# POLICY-003 — Compatibility

## Statement

> backward required, forward preferred. Breaking change requires RFC.

## Purpose

Không phá consumer; nền tảng Evolution Engine.

## Rules

- backward: required.
- forward: preferred.
- breaking_change: requires_rfc.

## Allowed

- Thay đổi backward compatible

## Forbidden

- Breaking change không RFC.

## Example

```text
compatibility: { backward: required, forward: preferred, breaking_change: { requires_rfc: true } }
```

## Related Principles

- P018, P015
