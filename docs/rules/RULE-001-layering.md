---
id: RULE-001
name: Layering
status: Stable
version: 1.0.0
category: Architecture
policy_type: mandatory
severity: critical
compliance: required
enforcement:
  runtime: True
  doctor: True
  validator: True
  dashboard: True
statement: >
  Phân tầng một chiều từ trên xuống. Layer chỉ được gọi layer ngay dưới.
purpose: >
  Đảm bảo phụ thuộc một chiều, không vòng, dễ hiểu và kiểm tra.
rules:
  - Layer chỉ được phụ thuộc layer ngay dưới.
  - Không được vượt tầng.
  - Không circular dependency.
constraints:
  allowed:
    - Presentation→Command→Workflow→Runtime→Capability→Registry→Agent→Skill→Infrastructure
  forbidden:
    - Agent gọi Runtime ngược (Agent→Runtime).
    - Skill gọi Runtime ngược (Skill→Runtime).
    - Bỏ qua tầng trung gian.
examples:
  - User → Command → Workflow → Runtime → Capability → Registry → Agent
related_principles:
  - P001
  - P003
related_rules:
  - RULE-002
  - RULE-004
verification:
  - doctor: layer-scan
  - runtime: layer-guard
  - tests: layering-tests
---

# RULE-001 — Layering

## Statement

> Phân tầng một chiều từ trên xuống. Layer chỉ được gọi layer ngay dưới.

## Purpose

Đảm bảo phụ thuộc một chiều, không vòng, dễ hiểu và kiểm tra.

## Rules

- Layer chỉ được phụ thuộc layer ngay dưới.
- Không được vượt tầng.
- Không circular dependency.

## Allowed

- Presentation→Command→Workflow→Runtime→Capability→Registry→Agent→Skill→Infrastructure

## Forbidden

- Agent gọi Runtime ngược (Agent→Runtime).
- Skill gọi Runtime ngược (Skill→Runtime).
- Bỏ qua tầng trung gian.

## Example

```text
User → Command → Workflow → Runtime → Capability → Registry → Agent
```

## Related Principles

- P001, P003

## Related Rules

- RULE-002, RULE-004

## Verification

- doctor: layer-scan
- runtime: layer-guard
- tests: layering-tests
