---
name: spec-001-s002-requirements
description: >
  SPEC-001 S002 — Runtime Requirements. Trả lời: Runtime phải làm được những gì?
  Không nói làm thế nào, không nói class, không nói component, không nói implementation.
agent: general
---

# S002 — Runtime Requirements

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Runtime phải làm được những gì?**

Không nói làm như thế nào.

Không nói class.

Không nói component.

Không nói implementation.

## R001 — Functional Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-001 | Runtime khởi tạo Execution | Critical |
| FR-002 | Runtime nạp Workflow | Critical |
| FR-003 | Runtime resolve Capability | Critical |
| FR-004 | Runtime điều phối Agent | Critical |
| FR-005 | Runtime quản lý Context | Critical |
| FR-006 | Runtime quản lý State | Critical |
| FR-007 | Runtime phát Event | High |
| FR-008 | Runtime sinh Artifact | High |
| FR-009 | Runtime thu Metrics | High |
| FR-010 | Runtime hỗ trợ Simulation | Medium |
| FR-011 | Runtime hỗ trợ Replay | Medium |
| FR-012 | Runtime hỗ trợ Cancellation | Medium |

## R002 — Non-functional Requirements

| ID | Requirement |
|----|-------------|
| NFR-001 | Deterministic Execution |
| NFR-002 | Stateless giữa các Execution |
| NFR-003 | Metadata Driven |
| NFR-004 | Extensible |
| NFR-005 | Observable |
| NFR-006 | Testable |
| NFR-007 | Versioned |
| NFR-008 | Recoverable |

## R003 — Constraints

Runtime bị ràng buộc bởi Constitution:

- C-001 Không chứa Business Logic
- C-002 Không gọi Agent trực tiếp
- C-003 Chỉ resolve Capability
- C-004 Không lưu Context sau Execution
- C-005 Không sửa Artifact
- C-006 Không bỏ qua Contract
- C-007 Không bỏ Event

## R004 — Assumptions

Runtime giả định:

- A-001 Workflow hợp lệ
- A-002 Registry khả dụng
- A-003 Contract hợp lệ
- A-004 Plugin đã validate
- A-005 Agent implement đúng Capability

> Nếu giả định sai thì Runtime chỉ báo lỗi, không tự sửa.

## R005 — Dependencies

Runtime phụ thuộc vào **khái niệm**, không phụ thuộc implementation:

```text
Glossary
    ↓
Contract
    ↓
Workflow Definition
    ↓
Capability Registry
    ↓
Event Schema
```

> Lưu ý: đây là phụ thuộc logic, chưa phải module.

## R006 — External Interfaces

Runtime chỉ giao tiếp với:

- Workflow Definition
- Registry
- Context
- Event Store
- Artifact Store
- Metrics Collector

> Không giao tiếp trực tiếp với Database, Git hay LLM.

## R007 — Quality Attributes

| Attribute | Target |
|-----------|--------|
| Reliability | Rất cao |
| Availability | Cao |
| Scalability | Cao |
| Extensibility | Rất cao |
| Determinism | 100% |
| Traceability | 100% |
| Observability | 100% |
| Maintainability | Cao |

> Các mục này dẫn dắt quyết định thiết kế ở S005.

## R008 — Acceptance Requirements

- AR-001 Runtime phải chạy được Workflow hợp lệ.
- AR-002 Runtime phải từ chối Workflow không hợp lệ.
- AR-003 Runtime phải sinh Event đầy đủ.
- AR-004 Runtime phải sinh Artifact.
- AR-005 Runtime phải dừng an toàn khi Agent lỗi.
- AR-006 Runtime không được vi phạm Constitution.

> Nền tảng cho Testing và Doctor.

## Tham chiếu

- `requirements.yaml` — nguồn dữ liệu chuẩn (Runtime/Doctor/Dashboard đọc).
- `requirements.schema.json` — validate cấu trúc.
- `requirement-traceability.yaml` — Requirement → Principle → Rule → Test → Implementation.
- `requirement-priority.yaml` — mức ưu tiên cho kế hoạch.
- Constitution: `docs/specs/SPEC-000/`
