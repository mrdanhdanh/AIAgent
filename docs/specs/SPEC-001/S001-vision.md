---
name: spec-001-s001-vision
description: >
  SPEC-001 S001 — Runtime Vision. Trả lời: Runtime tồn tại để làm gì? Và Runtime
  là gì trong AIOS. Không nói implementation, không nói class, không nói code.
agent: general
---

# S001 — Runtime Vision

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Runtime tồn tại để làm gì?**

Không nói implementation.

Không nói class.

Không nói code.

## Mission

```text
Runtime là trung tâm điều phối của AIOS.

Mọi hoạt động trong AIOS đều phải được Runtime khởi tạo, điều phối,
giám sát và kết thúc.

Không có thành phần nào được phép thực thi bên ngoài Runtime.
```

## Vision

```text
Runtime trở thành một Execution Kernel thống nhất cho toàn bộ AIOS.

Mọi Workflow, Agent, Plugin và Extension đều chạy thông qua Runtime
thay vì giao tiếp trực tiếp với nhau.
```

## Position

Runtime là **Execution Kernel** của AIOS.

Runtime **không phải** Agent.

Runtime **không phải** Workflow Engine.

Runtime **không phải** Scheduler.

Runtime là **hạ tầng điều phối thống nhất** cho mọi Execution.

## Design Philosophy

Runtime được thiết kế theo các nguyên tắc:

- **Orchestrate, never execute business logic.**
- **Configure, never hardcode.**
- **Observe, never assume.**
- **Coordinate, never couple.**
- **Extend, never modify.**

Đây là kim chỉ nam cho mọi quyết định thiết kế sau này.

## Design Goals

| Priority | Goal |
|----------|------|
| Critical | Một Runtime cho một Execution Context |
| Critical | Runtime không chứa Business Logic |
| Critical | Runtime chỉ điều phối |
| Critical | Runtime hoàn toàn Metadata-driven |
| High | Runtime có thể mở rộng qua Capability |
| High | Runtime có thể Replay Execution |
| High | Runtime hỗ trợ Simulation |
| Medium | Runtime có khả năng Self-observation |

## Non Goals

Runtime không chịu trách nhiệm:

- Business Logic
- UI
- Database
- Git
- LLM
- Plugin Implementation
- Knowledge Management

## Runtime Boundaries

Runtime **được phép**:

- Điều phối
- Resolve
- Theo dõi
- Quan sát

Runtime **không được phép**:

- Thực thi Business Logic
- Truy cập Database trực tiếp
- Thay đổi Workflow Definition
- Chứa tri thức nghiệp vụ

## Runtime Responsibilities

Runtime chỉ có các trách nhiệm sau:

- Khởi tạo Execution Context.
- Nạp Workflow Definition.
- Resolve Capability.
- Điều phối Agent.
- Quản lý State.
- Quản lý Context.
- Quản lý Execution Lifecycle.
- Quản lý Resource Lifecycle.
- Sinh Event.
- Thu thập Metrics.
- Sinh Artifact.
- Kết thúc Execution.

> Nếu một chức năng không thuộc danh sách trên thì **không được đưa vào Runtime**.

## Runtime Invariants

Các điều bất biến:

- Runtime luôn là điểm bắt đầu của Execution.
- Runtime không gọi Business Logic trực tiếp.
- Runtime không biết Agent cụ thể.
- Runtime chỉ biết Capability.
- Runtime luôn tạo Event cho mọi State Change.
- Runtime luôn tạo Execution Context trước khi chạy.
- Runtime không giữ dữ liệu sau khi Execution kết thúc (ngoại trừ Artifact được lưu theo chính sách).
- Runtime luôn là chủ sở hữu duy nhất của Execution Context.
- Runtime luôn kết thúc Execution bằng một Terminal State.
- Runtime không được phụ thuộc Agent cụ thể.
- Runtime không được ghi trực tiếp vào Knowledge.

## Out of Scope

Runtime **không định nghĩa**:

- Agent Implementation
- Capability Registry
- Workflow DSL
- Plugin Packaging
- Dashboard

> Những phần này thuộc SPEC khác — tránh chồng chéo.

## Success Criteria

Runtime được coi là hoàn thành khi có thể:

- Chạy một Workflow bất kỳ.
- Resolve Capability qua Registry.
- Điều phối nhiều Agent.
- Sinh đầy đủ Event.
- Sinh Artifact.
- Hỗ trợ Simulation.
- Hỗ trợ Replay.
- Không vi phạm bất kỳ Principle P001–P020 nào.

## Success Metrics

Doctor đo được:

- **Zero direct Agent coupling** — không coupling trực tiếp.
- **100% Event Coverage** — mọi state change có Event.
- **100% Capability Resolution** — mọi Capability resolve thành công.
- **100% Workflow Traceability** — mọi Execution trace được.

## Architectural Promise

Runtime cam kết:

- Không phụ thuộc Business Logic.
- Không biết Agent cụ thể.
- Không phá vỡ Constitution.
- Có thể mở rộng mà không sửa Core.

## Glossary Mapping

| Thuật ngữ | Glossary ID | Định nghĩa ngắn |
|-----------|-------------|-----------------|
| Runtime | TERM-001 | Trung tâm điều phối thực thi |
| Workflow | TERM-002 | Kế hoạch thực thi |
| Phase | TERM-003 | Nhóm Task trong Workflow |
| Task | TERM-004 | Đơn vị thực thi nhỏ nhất |
| Agent | TERM-005 | Execution Unit |
| Capability | TERM-006 | Khả năng; Runtime resolve |
| Command | TERM-007 | Entry point |
| Artifact | TERM-008 | Output immutable |
| Context | TERM-009 | Execution Data |

## Forward References

S001 chỉ nói **Vision**. Chi tiết ở các section sau:

- S002 — Runtime Requirements
- S003 — Runtime Responsibilities
- S004 — Runtime Boundaries
- S005 — Runtime Architecture
- S006 — Components
- S007 — Contracts
- S008 — Data Model
- S009 — State Machine
- S010 — Execution Flow
- S011 — Events

## Tham chiếu chuẩn hóa

### Principles

- P001 Runtime First
- P005 Event Driven
- P007 Capability Driven
- P009 Single Source of Truth
- P013 Simulation Before Execution

### Rules

- RULE-001 Layering
- RULE-004 Execution
- RULE-005 State
- RULE-014 Observability Contract

### Glossary

- TERM-001 Runtime
- TERM-002 Workflow
- TERM-005 Agent
- TERM-006 Capability
- TERM-009 Context

### Constitution

- `docs/specs/SPEC-000/compliance-matrix.yaml` (Runtime → required)
