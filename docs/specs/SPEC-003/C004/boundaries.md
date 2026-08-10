---
name: spec-003-c004-boundaries
description: >
  SPEC-003 C004 — Capability Boundaries. Trả lời: Capability System không
  được vượt ranh giới nào? 9 boundaries — Firewall của Capability System.
  Mirror W004 (SPEC-002).
agent: general
---

# C004 — Capability Boundaries

> **SPEC-003**: Capability System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Capability System không được vượt ranh giới nào?**

## Hierarchy

```text
Capability Boundary
├── CB001-declaration   (Critical)
├── CB002-registry      (Critical)
├── CB003-validation    (Critical)
├── CB004-resolution    (Critical)
├── CB005-interface     (High)
├── CB006-dependency    (High)
├── CB007-mapping       (Critical)
├── CB008-policy        (High)
└── CB009-governance    (Critical)
```

## Decision

> Nếu một chức năng không xác định được Boundary, chức năng đó không được phép đưa vào Capability System.

## Invariants

- Capability System không vượt quá Boundary.
- Capability System không tự resolve — giao cho Runtime (EF007).
- Capability System chỉ giao tiếp qua Contract (S007).
- Capability System chỉ phụ thuộc vào Abstraction.
- Capability System không biết implementation của Agent.
- Capability System không biết implementation của Plugin.

## Validation

- Có code trong Capability không?
- Capability System có tự resolve không?
- Capability System có gọi Agent cụ thể không?
- Capability System có phụ thuộc Plugin cụ thể không?
- Capability System có hardcode mapping không?
- Capability System có định nghĩa policy riêng không?
- Capability System có giao tiếp ngoài Contract không?

## Boundaries (9)

| ID | Boundary | Severity | Violation → Impact |
|----|----------|----------|--------------------|
| CB001 | Declaration Boundary | Critical | Nhận code thay vì khai báo → Critical |
| CB002 | Registry Boundary | Critical | Dùng capability ngoài Registry (S014) → Critical |
| CB003 | Validation Boundary | Critical | Dùng capability không hợp lệ → Critical |
| CB004 | Resolution Boundary | Critical | Tự resolve ngoài Runtime (EF007) → Critical |
| CB005 | Interface Boundary | High | Gọi trực tiếp Agent → High |
| CB006 | Dependency Boundary | High | Phụ thuộc Plugin cụ thể → High |
| CB007 | Mapping Boundary | Critical | Hardcode mapping Agent → Critical |
| CB008 | Policy Boundary | High | Định nghĩa policy riêng (S012) → High |
| CB009 | Governance Boundary | Critical | Bypass Governance (S013) → Critical |

**Mọi boundary:** `allowed` / `not_manage` / `violation` / `impact` / `detected_by: Doctor` / `metric` / `target: 0` / `principles` / `rules`.

## Mapping (Boundary → Principle → Rule)

| Boundary | Principle | Rule |
|----------|-----------|------|
| CB001-declaration | P003 | RULE-001 |
| CB002-registry | P003 | RULE-002 |
| CB003-validation | P011 | RULE-002 |
| CB004-resolution | P007 | RULE-002 |
| CB005-interface | P002 | RULE-003 |
| CB006-dependency | P012 | RULE-010 |
| CB007-mapping | P003 | RULE-002 |
| CB008-policy | P015 | RULE-012 |
| CB009-governance | P016 | RULE-008 |

## Metrics

9 metrics — mỗi boundary một metric, target = 0 (Declaration/Registry/Validation/Resolution/Interface/Dependency/Mapping/Policy/Governance Violations).

## Machine-readable

```text
boundaries.yaml
boundary-matrix.yaml
boundary-ownership-matrix.yaml
boundary-registry.yaml
declaration-boundary.yaml
resolution-boundary.yaml
mapping-boundary.yaml
policy-boundary.yaml
boundaries.schema.json
```

## Tham chiếu

- C001: `../C001-vision.md`
- C002: `../C002/requirements.md`
- C003: `../C003/responsibilities.md`
- W004: `../../SPEC-002/W004/boundaries.yaml` (mẫu cấu trúc)
- S010 EF007: `../../SPEC-001/S010/execution-flow.md`
- S012: `../../SPEC-001/S012/policies.md`
- S013: `../../SPEC-001/S013/governance.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
