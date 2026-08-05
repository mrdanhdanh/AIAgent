---
id: POLICY-004
name: Deprecation
status: Stable
version: 1.0.0
category: Lifecycle
scope:
  applies_to:
    - Entity
    - Workflow
    - Plugin
    - Artifact
    - SPEC
  excludes:
    - Example
    - Playground
statement: >
  Không xóa trực tiếp: Stable→Deprecated→Archived→Removed.
purpose: >
  Thay đổi có đường lui, không phá vỡ đột ngột.
rules:
  - Stable→Deprecated→Archived→Removed.
  - Deprecated phải có replacement.
  - Deprecation window rõ ràng.
allowed:
  - Stable→Deprecated→Archived→Removed
forbidden:
  - Xóa trực tiếp không deprecation.
related_principles:
  - P018
  - P010
examples:
  - Stable → Deprecated → Archived → Removed
---

# POLICY-004 — Deprecation

## Statement

> Không xóa trực tiếp: Stable→Deprecated→Archived→Removed.

## Purpose

Thay đổi có đường lui, không phá vỡ đột ngột.

## Rules

- Stable→Deprecated→Archived→Removed.
- Deprecated phải có replacement.
- Deprecation window rõ ràng.

## Allowed

- Stable→Deprecated→Archived→Removed

## Forbidden

- Xóa trực tiếp không deprecation.

## Example

```text
Stable → Deprecated → Archived → Removed
```

## Related Principles

- P018
