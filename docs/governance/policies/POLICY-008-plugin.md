---
id: POLICY-008
name: Plugin
status: Stable
version: 1.0.0
category: Plugin
statement: >
  Plugin: Install→Validate→Enable→Disable→Remove. Không sửa Core.
purpose: >
  Plugin an toàn, có vòng đời, không đụng Core.
rules:
  - Install→Validate→Enable.
  - Disable khi lỗi.
  - Remove.
  - Không sửa Core.
allowed:
  - Install→Validate→Enable→Disable→Remove
forbidden:
  - Plugin sửa Core.
related_principles:
  - P012
  - P019
examples:
  - Install → Validate → Enable → Disable → Remove
---

# POLICY-008 — Plugin

## Statement

> Plugin: Install→Validate→Enable→Disable→Remove. Không sửa Core.

## Purpose

Plugin an toàn, có vòng đời, không đụng Core.

## Rules

- Install→Validate→Enable.
- Disable khi lỗi.
- Remove.
- Không sửa Core.

## Allowed

- Install→Validate→Enable→Disable→Remove

## Forbidden

- Plugin sửa Core.

## Example

```text
Install → Validate → Enable → Disable → Remove
```

## Related Principles

- P012, P019
