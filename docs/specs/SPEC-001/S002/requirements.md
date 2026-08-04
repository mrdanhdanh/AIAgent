---
name: spec-001-s002-requirements
description: >
  SPEC-001 S002 — Runtime Requirements. Trả lời: Runtime phải làm được những gì?
  Không nói làm thế nào, không nói class, không nói component, không nói implementation.
agent: general
---

# S002 — Runtime Requirements

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: ✅ Frozen (2026-08-04)
> Không bổ sung requirement mới. Yêu cầu mới → RFC/ADR → version 1.1.0.

## Câu hỏi duy nhất

> **Runtime phải làm được những gì?**

Không nói làm như thế nào.

Không nói class.

Không nói component.

Không nói implementation.

## R001 — Functional Requirements (20)

| ID | Requirement | Priority | Category |
|----|-------------|----------|----------|
| FR-001 | Runtime khởi tạo Execution | Critical | Core |
| FR-002 | Runtime nạp Workflow | Critical | Core |
| FR-003 | Runtime resolve Capability | Critical | Core |
| FR-004 | Runtime điều phối Agent | Critical | Execution |
| FR-005 | Runtime quản lý Context | Critical | State |
| FR-006 | Runtime quản lý State | Critical | State |
| FR-007 | Runtime phát Event | High | Events |
| FR-008 | Runtime sinh Artifact | High | Data |
| FR-009 | Runtime thu Metrics | High | Observability |
| FR-010 | Runtime hỗ trợ Simulation | Medium | Execution |
| FR-011 | Runtime hỗ trợ Replay | Medium | Execution |
| FR-012 | Runtime hỗ trợ Cancellation | Medium | Execution |
| FR-013 | Runtime validate Workflow | Critical | Core |
| FR-014 | Runtime validate Contract | Critical | Core |
| FR-015 | Runtime manage Execution Lifecycle | Critical | Execution |
| FR-016 | Runtime isolate Execution | High | Execution |
| FR-017 | Runtime support Timeout | High | Execution |
| FR-018 | Runtime support Retry Policy | High | Execution |
| FR-019 | Runtime support Approval Gate | Medium | Governance |
| FR-020 | Runtime publish Execution Result | High | Data |

## R002 — Non-functional Requirements (15)

| ID | Requirement | Priority |
|----|-------------|----------|
| NFR-001 | Deterministic Execution | Critical |
| NFR-002 | Stateless giữa các Execution | Critical |
| NFR-003 | Metadata Driven | Critical |
| NFR-004 | Extensible | High |
| NFR-005 | Observable | High |
| NFR-006 | Testable | High |
| NFR-007 | Versioned | High |
| NFR-008 | Recoverable | High |
| NFR-009 | Security | Critical |
| NFR-010 | Auditability | High |
| NFR-011 | Compatibility | High |
| NFR-012 | Configurability | High |
| NFR-013 | Portability | Medium |
| NFR-014 | Performance | High |
| NFR-015 | Fault Isolation | Critical |

## R003 — Constraints (phân loại)

### Architectural Constraints

- C-001 Không chứa Business Logic
- C-002 Không gọi Agent trực tiếp
- C-003 Chỉ resolve Capability

### Operational Constraints

- C-004 Không lưu Context sau Execution
- C-005 Không sửa Artifact

### Governance Constraints

- C-006 Không bỏ qua Contract
- C-007 Không bỏ Event

### Security Constraints

- C-008 Không ghi vào Knowledge
- C-009 Least Privilege

## R004 — Assumptions

Runtime giả định:

- A-001 Workflow hợp lệ
- A-002 Registry khả dụng
- A-003 Contract hợp lệ
- A-004 Plugin đã validate
- A-005 Agent implement đúng Capability

> Nếu giả định sai thì Runtime chỉ báo lỗi, không tự sửa.

## R005 — Dependencies (2 loại)

### Logical Dependencies

- Constitution
- Workflow Definition
- Registry

### Runtime Services

- Event Store
- Artifact Store
- Metrics Collector

> Đây là phụ thuộc logic, chưa phải module.

## R006 — External Interfaces (có chiều)

| Interface | Direction |
|-----------|-----------|
| Workflow | Input |
| Registry | Input |
| Context | Read/Write |
| Event | Publish |
| Artifact | Publish |
| Metrics | Publish |

> Không giao tiếp trực tiếp với Database, Git hay LLM.

## R007 — Quality Attributes (định lượng)

| Attribute | Target |
|-----------|--------|
| Reliability | 99.9% |
| Availability | 99.9% |
| Scalability | N Executions song song |
| Extensibility | 100% qua Capability |
| Determinism | 100% |
| Traceability | 100% |
| Observability | 100% |
| Maintainability | Thay đổi không sửa Core |

> Các mục này dẫn dắt quyết định thiết kế ở S005.

## R008 — Acceptance Requirements (có traceability)

- AR-001 Runtime phải chạy được Workflow hợp lệ.
- AR-002 Runtime phải từ chối Workflow không hợp lệ.
- AR-003 Runtime phải sinh Event đầy đủ.
- AR-004 Runtime phải sinh Artifact.
- AR-005 Runtime phải dừng an toàn khi Agent lỗi.
- AR-006 Runtime không được vi phạm Constitution.

## Tham chiếu

- `requirements.yaml` — nguồn dữ liệu chuẩn (20 FR / 15 NFR / 9 C / 6 AR, mỗi req có metadata: title/priority/status/owner/source/verification/category).
- `requirements-index.yaml` — registry nhanh mọi requirement.
- `requirement-traceability.yaml` — FR → P → RULE → SPEC → TEST → DOCTOR.
- `requirement-categories.yaml` — Core/Execution/State/Data/Events/Observability/Governance.
- `requirement-lifecycle.yaml` — Draft→Approved→Implemented→Verified→Stable.
- `requirement-priority.yaml` — Critical+Mandatory / High+Recommended / Medium+Optional.
- `requirement-metrics.yaml` — số liệu cho Dashboard.
- `requirements.schema.json` — validate cấu trúc.
- Constitution: `docs/specs/SPEC-000/`
