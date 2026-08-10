---
name: spec-002-w001-vision
version: "1.0.0"
description: >
  SPEC-002 W001 — Workflow Vision. Trả lời: Workflow Engine tồn tại để làm gì?
  Và Workflow Engine là gì trong AIOS. Không nói implementation, không nói
  class, không nói code.
agent: general
---

# W001 — Workflow Vision

> **SPEC-002**: Workflow Engine · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Workflow Engine tồn tại để làm gì?**

Không nói implementation.

Không nói class.

Không nói code.

## Mission

```text
Workflow Engine là lớp khai báo và điều phối luồng nghiệp vụ trên Runtime Kernel.

Mọi Workflow đều được định nghĩa khai báo (declarative), validate trước khi chạy,
và thực thi như một Execution của Runtime (SPEC-001).

Không có Workflow nào chạy ngoài Runtime.
```

## Vision

```text
Workflow Engine trở thành lớp chuẩn hóa duy nhất để khai báo luồng nghiệp vụ AIOS.

Mọi Agent, Plugin và Extension phối hợp thông qua Workflow chạy trên Runtime
thay vì giao tiếp trực tiếp với nhau.
```

## Position

Workflow Engine là **declaration & orchestration layer** của AIOS.

Workflow Engine **không phải** Runtime.

Workflow Engine **không phải** Agent.

Workflow Engine **không phải** Scheduler.

Workflow Engine là **lớp khai báo luồng nghiệp vụ** trên Runtime Kernel.

## Design Philosophy

Workflow Engine được thiết kế theo các nguyên tắc:

- **Declare, never hardcode.** Workflow khai báo bằng dữ liệu (YAML), không code.
- **Validate before execute.** Mọi Workflow được validate trước khi chạy.
- **Run on Runtime.** Mọi Workflow là Execution của SPEC-001 — không tự chạy.
- **Normalize, never interpret.** Chuẩn hóa cấu trúc trước khi chạy (S010 EF006).
- **Reuse, never redefine.** Dùng State Machine (S009), Policies (S012), Registry (S014) của Runtime.
- **Observable, never hidden.** Mọi Workflow quan sát được qua S011.

## Invariants

1. Mọi Workflow đều chạy như một Execution của Runtime (SPEC-001).
2. Mọi Workflow đều được validate trước khi chạy.
3. Workflow không chứa Business Logic — chỉ khai báo luồng.
4. Workflow không định nghĩa lại State Machine, Policy, Contract của Runtime.
5. Workflow có thể khai báo bước hợp lệ trong phạm vi State Machine (S009).

## Scope

Workflow Engine bao gồm:

- Khai báo Workflow (definition, schema, version).
- Validate Workflow (cấu trúc, tham chiếu, phụ thuộc).
- Chuẩn hóa Workflow (normalization).
- Điều phối Workflow (sequential, parallel, barrier, approval, retry, timeout).
- Đăng ký Workflow trong Registry (S014 workflow-registry).
- Quan sát Workflow (S011 events/metrics/trace/audit).

Workflow Engine không bao gồm:

- Runtime (SPEC-001).
- Agent (SPEC-004).
- Business Logic.

## Relation to SPEC-001

Workflow Engine **dùng** Runtime Kernel:

```text
Workflow Engine (SPEC-002)
    │
    ├── Runtime (SPEC-001) — State Machine, Execution Flow, Policies, Registry
    ├── Constitution (SPEC-000) — nguyên tắc, luật
    └── Khai báo luồng nghiệp vụ
```

Workflow Engine không định nghĩa lại bất kỳ khái niệm nào của Runtime.

## Tham chiếu

- Constitution: `docs/specs/SPEC-000/`
- Runtime Kernel: `../SPEC-001/`
- Workflow Engine hiện hữu: `.opencode/workflow-engine/`
- Workflow definitions: `.opencode/workflow/definitions/`
