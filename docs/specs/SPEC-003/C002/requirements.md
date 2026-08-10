---
name: spec-003-c002-requirements
description: >
  SPEC-003 C002 — Capability Requirements. Trả lời: Capability System cần làm
  gì? 16 FR, 12 NFR, 6 constraints, 6 acceptance criteria.
  Mirror W002 (SPEC-002).
agent: general
---

# C002 — Capability Requirements

> **SPEC-003**: Capability System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Capability System cần làm gì?**

## Functional Requirements (16)

| ID | Title | Priority | Category |
|----|-------|----------|----------|
| CFR-001 | Declare Capability | Critical | Core |
| CFR-002 | Register Capability | Critical | Core |
| CFR-003 | Resolve Capability | Critical | Execution |
| CFR-004 | Map Agent | Critical | Core |
| CFR-005 | Map Plugin | High | Core |
| CFR-006 | Validate Capability | Critical | Validation |
| CFR-007 | Version Capability | High | Data |
| CFR-008 | Bind Policy | High | Governance |
| CFR-009 | Check Compatibility | High | Validation |
| CFR-010 | Enforce Permission | Critical | Governance |
| CFR-011 | Track Usage | High | Observability |
| CFR-012 | Publish Capability Events | High | Observability |
| CFR-013 | Support Discovery | High | Data |
| CFR-014 | Support Deprecation | Medium | Data |
| CFR-015 | Support Capability Groups | Medium | Core |
| CFR-016 | Support Fallback | Medium | Execution |

## Non-Functional Requirements (12)

| ID | Title | Priority | Category |
|----|-------|----------|----------|
| CNFR-001 | Deterministic Resolution | Critical | Execution |
| CNFR-002 | Metadata Driven | Critical | Core |
| CNFR-003 | Registry First | Critical | Core |
| CNFR-004 | Observable | High | Observability |
| CNFR-005 | Versioned | High | Data |
| CNFR-006 | Compatible | High | Data |
| CNFR-007 | Recoverable | High | Core |
| CNFR-008 | Testable | High | Core |
| CNFR-009 | Performant | High | Observability |
| CNFR-010 | Governed | Critical | Governance |
| CNFR-011 | Reusable | Medium | Data |
| CNFR-012 | Traceable | High | Observability |

## Constraints (6)

| ID | Constraint | Type |
|----|------------|------|
| CC-001 | No Business Logic | Architectural |
| CC-002 | No Hardcoded Capability | Architectural |
| CC-003 | No Direct Agent Call | Architectural |
| CC-004 | No Redefine Registry (S014) | Architectural |
| CC-005 | No Redefine Policy (S012) | Governance |
| CC-006 | Register Before Resolve | Governance |

## Assumptions

- CA-001: Capability hợp lệ (đã validate).
- CA-002: Registry khả dụng (S014).
- CA-003: Contract hợp lệ (S007).
- CA-004: Runtime khả dụng (SPEC-001).

> Nếu giả định sai, Capability System chỉ báo lỗi, không tự sửa.

## Quality Attributes

| Attribute | Target | Ghi chú |
|-----------|--------|---------|
| Determinism | 100% | Cùng capability request → cùng resolution |
| Reliability | 99.9% | Không sập khi resolution lỗi |
| Availability | 99.9% | |
| Extensibility | 100% | Qua khai báo năng lực |
| Traceability | 100% | Mọi resolution truy vết được |
| Observability | 100% | Mọi resolution quan sát được |
| Maintainability | — | Thêm năng lực không sửa Core |

## Acceptance Criteria (6)

| ID | Criterion | Related | Verified by |
|----|-----------|---------|-------------|
| CAR-001 | Đăng ký và resolve được capability hợp lệ | CFR-001/002/003 | Capability Tests, Doctor |
| CAR-002 | Từ chối khai báo không hợp lệ | CFR-006 | Capability Tests, Doctor |
| CAR-003 | Phát Event đầy đủ cho mọi resolution | CFR-012 | Doctor |
| CAR-004 | Dừng an toàn khi resolution thất bại (lỗi chuẩn S014) | CFR-016, CNFR-007 | Capability Tests, Doctor |
| CAR-005 | Không capability nào hardcode — mọi năng lực qua Registry | CC-002 | Doctor |
| CAR-006 | Không vi phạm Constitution | CNFR-010 | Doctor |

## Machine-readable

```text
requirements.yaml
requirement-categories.yaml
requirement-lifecycle.yaml
requirement-priority.yaml
requirement-traceability.yaml
requirement-metrics.yaml
requirements-index.yaml
requirements.schema.json
CHANGELOG.md
```

## Tham chiếu

- C001: `../C001-vision.md`
- W002: `../../SPEC-002/W002/requirements.yaml` (mẫu cấu trúc)
- S007: `../../SPEC-001/S007/contracts.md`
- S010 EF007: `../../SPEC-001/S010/execution-flow.md`
- S012: `../../SPEC-001/S012/policies.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
