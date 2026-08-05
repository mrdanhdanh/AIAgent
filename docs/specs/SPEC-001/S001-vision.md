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

## Design Constraints

Runtime **phải** (ràng buộc bắt buộc, khác với Goals):

- Stateless giữa các Execution.
- Metadata-driven.
- Platform-independent.
- Deterministic.
- Observable.
- Extensible.

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
- Sửa Artifact đã tạo (P010 Immutable Artifact)
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
- Allocate Execution Resources.
- Release Execution Resources.
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
- Runtime chỉ tồn tại trong phạm vi một Execution.
- Runtime không chia sẻ Context giữa hai Execution.

## Out of Scope

Runtime **không định nghĩa**:

- Agent Implementation
- Capability Registry
- Workflow DSL
- Plugin Packaging
- Dashboard

> Những phần này thuộc SPEC khác — tránh chồng chéo.

## Success Criteria

Runtime được xem là **đạt Vision** khi:

- Mọi Execution đều đi qua Runtime.
- Runtime là Execution Coordinator duy nhất.
- Runtime không vi phạm Constitution (SPEC-000).
- Runtime có thể mở rộng mà không sửa Core.

> Các test cụ thể (chạy Workflow, resolve Capability, điều phối Agent, sinh Event/Artifact, Simulation, Replay) được định nghĩa tại **S020 — Acceptance Criteria**.

## Success Metrics (KPI)

```yaml
success_metrics:
  execution_through_runtime: 100%
  event_coverage: 100%
  capability_resolution: 100%
  direct_agent_coupling: 0
  constitution_violations: 0
```

Doctor đo các KPI này.

## Architectural Promise

Runtime cam kết:

- Không phụ thuộc Business Logic.
- Không biết Agent cụ thể.
- Không phá vỡ Constitution.
- Có thể mở rộng mà không sửa Core.
- Luôn có thể được thay thế implementation mà không ảnh hưởng Contract.

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
- S012 — Errors
- S013 — Configuration
- S014 — Extension Points
- S015 — Security
- S016 — Performance
- S017 — Observability
- S018 — Testing
- S019 — Compatibility
- S020 — Acceptance Criteria

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
