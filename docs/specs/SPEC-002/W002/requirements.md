---
name: spec-002-w002-requirements
description: >
  SPEC-002 W002 — Workflow Requirements. Trả lời: Workflow Engine cần làm gì?
  16 FR, 12 NFR, 6 constraints, 6 acceptance criteria.
  Mirror S002 (SPEC-001).
agent: general
---

# W002 — Workflow Requirements

> **SPEC-002**: Workflow Engine · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Workflow Engine cần làm gì?**

## Functional Requirements (16)

| ID | Title | Priority | Category |
|----|-------|----------|----------|
| WFR-001 | Define Workflow | Critical | Core |
| WFR-002 | Load Workflow | Critical | Core |
| WFR-003 | Validate Workflow | Critical | Validation |
| WFR-004 | Normalize Workflow | High | Core |
| WFR-005 | Resolve Steps | Critical | Execution |
| WFR-006 | Execute Sequential | Critical | Execution |
| WFR-007 | Execute Parallel | High | Execution |
| WFR-008 | Support Barrier | High | Execution |
| WFR-009 | Support Approval Gate | Medium | Governance |
| WFR-010 | Support Retry | High | Execution |
| WFR-011 | Support Timeout | High | Execution |
| WFR-012 | Support Compensation | Medium | Execution |
| WFR-013 | Support Conditional Branch | High | Execution |
| WFR-014 | Pass Context | Critical | Data |
| WFR-015 | Register Workflow | High | Data |
| WFR-016 | Publish Workflow Events | High | Observability |

## Non-Functional Requirements (12)

| ID | Title | Priority | Category |
|----|-------|----------|----------|
| WNFR-001 | Deterministic Execution | Critical | Execution |
| WNFR-002 | Declarative Only | Critical | Core |
| WNFR-003 | Validate Before Execute | Critical | Validation |
| WNFR-004 | Observable | High | Observability |
| WNFR-005 | Versioned | High | Data |
| WNFR-006 | Compatible | High | Data |
| WNFR-007 | Recoverable | High | Core |
| WNFR-008 | Testable | High | Core |
| WNFR-009 | Performant | High | Observability |
| WNFR-010 | Governed | Critical | Governance |
| WNFR-011 | Reusable | Medium | Data |
| WNFR-012 | Traceable | High | Observability |

## Constraints (6)

| ID | Constraint | Type |
|----|------------|------|
| WC-001 | No Business Logic | Architectural |
| WC-002 | No Code in Workflow | Architectural |
| WC-003 | No Direct Agent Call | Architectural |
| WC-004 | No Redefine State Machine (S009) | Architectural |
| WC-005 | No Redefine Policy (S012) | Governance |
| WC-006 | Validate Before Execute | Governance |

## Assumptions

- WA-001: Workflow hợp lệ (đã validate).
- WA-002: Registry khả dụng (S014).
- WA-003: Contract hợp lệ (S007).
- WA-004: Runtime khả dụng (SPEC-001).

> Nếu giả định sai, Workflow Engine chỉ báo lỗi, không tự sửa.

## Quality Attributes

| Attribute | Target | Ghi chú |
|-----------|--------|---------|
| Determinism | 100% | Cùng workflow + input → cùng output |
| Reliability | 99.9% | Không sập khi step lỗi |
| Availability | 99.9% | |
| Extensibility | 100% | Qua Workflow khai báo |
| Traceability | 100% | Mọi step truy vết được |
| Observability | 100% | Mọi workflow quan sát được |
| Maintainability | — | Thay đổi luồng không sửa Core |

## Acceptance Criteria (6)

| ID | Criterion | Related | Verified by |
|----|-----------|---------|-------------|
| WAR-001 | Chạy được Workflow hợp lệ (sequential + parallel) | WFR-001/006/007 | Workflow Tests, Doctor |
| WAR-002 | Từ chối Workflow không hợp lệ | WFR-003 | Workflow Tests, Doctor |
| WAR-003 | Phát Event đầy đủ cho mọi step | WFR-016 | Doctor |
| WAR-004 | Dừng an toàn khi step lỗi (retry/timeout/compensation) | WFR-010/011/012 | Workflow Tests, Doctor |
| WAR-005 | Workflow không chứa code, không gọi trực tiếp Agent | WC-002/003 | Doctor |
| WAR-006 | Không vi phạm Constitution | WNFR-010 | Doctor |

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

- W001: `../W001-vision.md`
- S002: `../../SPEC-001/S002/requirements.yaml` (mẫu cấu trúc)
- S009: `../../SPEC-001/S009/state-machine.yaml`
- S010: `../../SPEC-001/S010/execution-flow.md`
- S011: `../../SPEC-001/S011/observability.md`
- S012: `../../SPEC-001/S012/policies.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
