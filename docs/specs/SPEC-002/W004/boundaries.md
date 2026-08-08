---
name: spec-002-w004-boundaries
description: >
  SPEC-002 W004 — Workflow Boundaries. Trả lời: Workflow Engine không được
  vượt ranh giới nào? 9 boundaries — Firewall của Workflow Engine.
  Mirror S004 (SPEC-001).
agent: general
---

# W004 — Workflow Boundaries

> **SPEC-002**: Workflow Engine · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Workflow Engine không được vượt ranh giới nào?**

## Hierarchy

```text
Workflow Boundary
├── WB001-declaration   (Critical)
├── WB002-registry      (Critical)
├── WB003-validation    (Critical)
├── WB004-execution     (Critical)
├── WB005-interface     (High)
├── WB006-dependency    (High)
├── WB007-state         (Critical)
├── WB008-policy        (High)
└── WB009-governance    (Critical)
```

## Decision

> Nếu một chức năng không xác định được Boundary, chức năng đó không được phép đưa vào Workflow Engine.

## Invariants

- Workflow Engine không vượt quá Boundary.
- Workflow Engine không tự chạy — giao cho Runtime (SPEC-001).
- Workflow Engine chỉ giao tiếp qua Contract (S007).
- Workflow Engine chỉ phụ thuộc vào Abstraction.
- Workflow Engine không biết implementation của Agent.
- Workflow Engine không biết implementation của Plugin.

## Validation

- Có code trong Workflow không?
- Workflow Engine có tự chạy step không?
- Workflow Engine có gọi Agent cụ thể không?
- Workflow Engine có phụ thuộc Plugin cụ thể không?
- Workflow Engine có định nghĩa state riêng không?
- Workflow Engine có định nghĩa policy riêng không?
- Workflow Engine có giao tiếp ngoài Contract không?

## Boundaries (9)

| ID | Boundary | Severity | Violation → Impact |
|----|----------|----------|--------------------|
| WB001 | Declaration Boundary | Critical | Nhận code thay vì khai báo → Critical |
| WB002 | Registry Boundary | Critical | Nạp Workflow ngoài Registry (S014) → Critical |
| WB003 | Validation Boundary | Critical | Chạy Workflow không hợp lệ → Critical |
| WB004 | Execution Boundary | Critical | Tự chạy step ngoài Runtime → Critical |
| WB005 | Interface Boundary | High | Gọi trực tiếp Agent → High |
| WB006 | Dependency Boundary | High | Phụ thuộc Plugin cụ thể → High |
| WB007 | State Boundary | Critical | Định nghĩa state riêng (S009) → Critical |
| WB008 | Policy Boundary | High | Định nghĩa policy riêng (S012) → High |
| WB009 | Governance Boundary | Critical | Bypass Governance (S013) → Critical |

**Mọi boundary:** `allowed` / `not_manage` / `violation` / `impact` / `detected_by: Doctor` / `metric` / `target: 0` / `principles` / `rules`.

## Mapping (Boundary → Principle → Rule)

| Boundary | Principle | Rule |
|----------|-----------|------|
| WB001-declaration | P003 | RULE-001 |
| WB002-registry | P003 | RULE-002 |
| WB003-validation | P011 | RULE-002 |
| WB004-execution | P001 | RULE-004 |
| WB005-interface | P002 | RULE-003 |
| WB006-dependency | P012 | RULE-010 |
| WB007-state | P005 | RULE-005 |
| WB008-policy | P015 | RULE-012 |
| WB009-governance | P016 | RULE-008 |

## Metrics

9 metrics — mỗi boundary một metric, target = 0 (Declaration/Registry/Validation/Execution/Interface/Dependency/State/Policy/Governance Violations).

## Machine-readable

```text
boundaries.yaml
boundary-matrix.yaml
boundary-ownership-matrix.yaml
boundary-registry.yaml
declaration-boundary.yaml
execution-boundary.yaml
state-boundary.yaml
policy-boundary.yaml
boundaries.schema.json
```

## Tham chiếu

- W001: `../W001-vision.md`
- W002: `../W002/requirements.md`
- W003: `../W003/responsibilities.md`
- S004: `../../SPEC-001/S004/boundaries.yaml` (mẫu cấu trúc)
- S009: `../../SPEC-001/S009/state-machine.yaml`
- S012: `../../SPEC-001/S012/policies.md`
- S013: `../../SPEC-001/S013/governance.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
