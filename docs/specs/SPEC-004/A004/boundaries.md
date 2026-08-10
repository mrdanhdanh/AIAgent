---
name: spec-004-a004-boundaries
description: >
  SPEC-004 A004 — Agent Boundaries. Trả lời: Agent System không được vượt
  ranh giới nào? 9 boundaries — Firewall của Agent System.
  Mirror C004 (SPEC-003).
agent: general
---

# A004 — Agent Boundaries

> **SPEC-004**: Agent System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Agent System không được vượt ranh giới nào?**

## Hierarchy

```text
Agent Boundary
├── AB001-declaration   (Critical)
├── AB002-registry      (Critical)
├── AB003-validation    (Critical)
├── AB004-execution     (Critical)
├── AB005-interface     (High)
├── AB006-dependency    (High)
├── AB007-capability    (Critical)
├── AB008-policy        (High)
└── AB009-governance    (Critical)
```

## Decision

> Nếu một chức năng không xác định được Boundary, chức năng đó không được phép đưa vào Agent System.

## Invariants

- Agent System không vượt quá Boundary.
- Agent System không tự chạy Agent — giao cho Runtime (SPEC-001).
- Agent System chỉ giao tiếp qua Contract (S007).
- Agent System chỉ phụ thuộc vào Abstraction.
- Agent System không biết implementation của Agent.
- Agent System không biết implementation của Plugin.

## Validation

- Có code trong Agent không?
- Agent System có tự chạy Agent không?
- Agent System có gọi Agent cụ thể trực tiếp không?
- Agent System có phụ thuộc Plugin cụ thể không?
- Agent System có hardcode capability mapping không?
- Agent System có định nghĩa policy riêng không?
- Agent System có giao tiếp ngoài Contract không?

## Boundaries (9)

| ID | Boundary | Severity | Violation → Impact |
|----|----------|----------|--------------------|
| AB001 | Declaration Boundary | Critical | Nhận code thay vì khai báo → Critical |
| AB002 | Registry Boundary | Critical | Dùng Agent ngoài Registry (S014) → Critical |
| AB003 | Validation Boundary | Critical | Chạy Agent không hợp lệ → Critical |
| AB004 | Execution Boundary | Critical | Tự chạy Agent ngoài Runtime (SPEC-001) → Critical |
| AB005 | Interface Boundary | High | Gọi trực tiếp Agent → High |
| AB006 | Dependency Boundary | High | Phụ thuộc Plugin cụ thể → High |
| AB007 | Capability Boundary | Critical | Hardcode capability mapping → Critical |
| AB008 | Policy Boundary | High | Định nghĩa policy riêng (S012) → High |
| AB009 | Governance Boundary | Critical | Bypass Governance (S013) → Critical |

**Mọi boundary:** `allowed` / `not_manage` / `violation` / `impact` / `detected_by: Doctor` / `metric` / `target: 0` / `principles` / `rules`.

## Mapping (Boundary → Principle → Rule)

| Boundary | Principle | Rule |
|----------|-----------|------|
| AB001-declaration | P003 | RULE-001 |
| AB002-registry | P003 | RULE-002 |
| AB003-validation | P011 | RULE-002 |
| AB004-execution | P001 | RULE-004 |
| AB005-interface | P002 | RULE-003 |
| AB006-dependency | P012 | RULE-010 |
| AB007-capability | P003 | RULE-002 |
| AB008-policy | P015 | RULE-012 |
| AB009-governance | P016 | RULE-008 |

## Metrics

9 metrics — mỗi boundary một metric, target = 0 (Declaration/Registry/Validation/Execution/Interface/Dependency/Capability/Policy/Governance Violations).

## Machine-readable

```text
boundaries.yaml
boundary-matrix.yaml
boundary-ownership-matrix.yaml
boundary-registry.yaml
declaration-boundary.yaml
execution-boundary.yaml
capability-boundary.yaml
policy-boundary.yaml
boundaries.schema.json
```

## Tham chiếu

- A001: `../A001-vision.md`
- A002: `../A002/requirements.md`
- A003: `../A003/responsibilities.md`
- C004: `../../SPEC-003/C004/boundaries.yaml` (mẫu cấu trúc)
- S012: `../../SPEC-001/S012/policies.md`
- S013: `../../SPEC-001/S013/governance.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
