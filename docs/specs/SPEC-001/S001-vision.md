---
name: spec-001-s001-vision
description: >
  SPEC-001 S001 — Runtime Vision. Trả lời: Runtime tồn tại để làm gì?
  Không nói implementation, không nói class, không nói code.
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

## Design Goals

1. Một Runtime cho một Execution Context.
2. Runtime không chứa Business Logic.
3. Runtime chỉ điều phối.
4. Runtime hoàn toàn Metadata-driven.
5. Runtime có thể mở rộng qua Capability.
6. Runtime có thể Replay Execution.
7. Runtime hỗ trợ Simulation.
8. Runtime có khả năng Self-observation.

## Non Goals

Runtime không chịu trách nhiệm:

- Business Logic
- UI
- Database
- Git
- LLM
- Plugin Implementation
- Knowledge Management

## Runtime Responsibilities

Runtime chỉ có các trách nhiệm sau:

- Khởi tạo Execution Context.
- Nạp Workflow Definition.
- Resolve Capability.
- Điều phối Agent.
- Quản lý State.
- Quản lý Context.
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

## Tham chiếu

- P001 Runtime First (Constitution)
- Glossary: Runtime (TERM-001), Execution Context (TERM-009)
- RULE-001 Layering, RULE-004 Execution
- `docs/specs/SPEC-000/compliance-matrix.yaml`
