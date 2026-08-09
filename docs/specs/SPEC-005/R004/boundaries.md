---
name: spec-005-r004-boundaries
description: SPEC-005 R004 — Registry Boundaries. 9 RB.
agent: general
---

# R004 — Registry Boundaries

> **SPEC-005**: Registry · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Registry không được vượt ranh giới nào?**

## Hierarchy

```text
Registry Boundary
├── RB001-declaration   (Critical)
├── RB002-storage      (Critical)
├── RB003-validation    (Critical)
├── RB004-resolution     (Critical)
├── RB005-interface     (High)
├── RB006-dependency    (High)
├── RB007-ownership     (Critical)
├── RB008-policy        (High)
└── RB009-governance    (Critical)
```

## Decision

> Nếu một chức năng không xác định được Boundary, chức năng đó không được phép đưa vào Registry.

## Invariants

- Registry không vượt quá Boundary.
- Registry không chứa Business Data.
- Registry chỉ giao tiếp qua Contract (S007).
- Registry không biết Storage implementation.

## Validation

- Có Business Data trong Registry không?
- Registry có tự resolve ngoài S014 không?
- Registry có phụ thuộc Storage cụ thể không?
- Registry có định nghĩa policy riêng không?
- Registry có giao tiếp ngoài Contract không?

## Boundaries (9)

| ID | Boundary | Severity |
|----|----------|----------|
| RB001 | Declaration Boundary | Critical |
| RB002 | Storage Boundary | Critical |
| RB003 | Validation Boundary | Critical |
| RB004 | Resolution Boundary | Critical |
| RB005 | Interface Boundary | High |
| RB006 | Dependency Boundary | High |
| RB007 | Ownership Boundary | Critical |
| RB008 | Policy Boundary | High |
| RB009 | Governance Boundary | Critical |

**Mọi boundary:** `allowed` / `not_manage` / `violation` / `detected_by: Doctor` / `target: 0` / `principles` / `rules`.

## Mapping (Boundary → Principle → Rule)

| Boundary | Principle | Rule |
|----------|-----------|------|
| RB001-declaration | P003 | RULE-001 |
| RB002-storage | P009 | RULE-009 |
| RB003-validation | P011 | RULE-002 |
| RB004-resolution | P007 | RULE-002 |
| RB005-interface | P002 | RULE-003 |
| RB006-dependency | P012 | RULE-010 |
| RB007-ownership | P016 | RULE-008 |
| RB008-policy | P015 | RULE-012 |
| RB009-governance | P016 | RULE-008 |

## Metrics

1 metric — Registry Violations, target = 0.

## Machine-readable

```text
boundaries.yaml
boundary-matrix.yaml
boundary-ownership-matrix.yaml
boundary-registry.yaml
boundaries.schema.json
```

## Tham chiếu

- R001: `../R001-vision.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
