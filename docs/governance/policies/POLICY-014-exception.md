---
id: POLICY-014
name: Exception
status: Stable
version: 1.0.0
category: Decision
scope:
  applies_to:
    - Policy
    - Rule
    - SPEC
  excludes:
    - Example
    - Playground
statement: >
  Không phải mọi Rule áp dụng 100%. Ngoại lệ phải theo quy trình, có expiration.
purpose: >
  Cho phép ngoại lệ có kiểm soát khi không thể tuân thủ 100%.
rules:
  - Exception requires approval.
  - Exception requires expiration_date.
  - Exception requires rationale.
  - Review after 30d.
allowed:
  - Exception được cấp theo quy trình
forbidden:
  - Ngoại lệ không hạn.
  - Ngoại lệ không rationale.
related_principles:
  - P018
  - P015
examples:
  - Exception: cứng nhắc quy tắc cho một trường hợp đặc biệt
---

# POLICY-014 — Exception

## Statement

> Không phải mọi Rule áp dụng 100%. Ngoại lệ phải theo quy trình, có expiration.

## Purpose

Cho phép ngoại lệ có kiểm soát khi không thể tuân thủ 100%.

## Rules

- Exception requires approval.
- Exception requires expiration_date.
- Exception requires rationale.
- Review after 30d.

## Allowed

- Exception được cấp theo quy trình

## Forbidden

- Ngoại lệ không hạn.
- Ngoại lệ không rationale.

## Example

```text
exceptions:
  requires:
    - approval
    - expiration_date
    - rationale
  review_after: 30d
```

## Related Principles

- P018, P015
