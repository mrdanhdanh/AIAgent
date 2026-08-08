---
name: spec-003-c001-vision
version: "1.0.0"
description: >
  SPEC-003 C001 — Capability Vision. Trả lời: Capability System tồn tại để
  làm gì? Và Capability System là gì trong AIOS. Không nói implementation,
  không nói class, không nói code.
agent: general
---

# C001 — Capability Vision

> **SPEC-003**: Capability System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Capability System tồn tại để làm gì?**

Không nói implementation.

Không nói class.

Không nói code.

## Mission

```text
Capability System là lớp khai báo, đăng ký và phân giải năng lực
(capability) cho Agents và Plugins trên Runtime Kernel.

Mọi năng lực đều được khai báo bằng metadata, đăng ký trong Registry (S014),
và phân giải qua Runtime (S010 EF007).

Không có năng lực nào được hardcode.
```

## Vision

```text
Capability System trở thành lớp chuẩn hóa duy nhất để khai báo năng lực AIOS.

Mọi Agent, Plugin và Extension expose năng lực qua Capability System
thay vì giao tiếp trực tiếp với nhau.
```

## Position

Capability System là **declaration & resolution layer** của AIOS.

Capability System **không phải** Runtime.

Capability System **không phải** Agent.

Capability System **không phải** Registry.

Capability System là **lớp khai báo và phân giải năng lực** trên Runtime Kernel.

## Design Philosophy

Capability System được thiết kế theo các nguyên tắc:

- **Declare, never hardcode.** Năng lực khai báo bằng metadata, không code.
- **Register before resolve.** Mọi capability đăng ký trong Registry (S014) trước khi dùng.
- **Resolve through Runtime.** Phân giải qua S010 EF007 — không tự resolve.
- **Contract-bound.** Mọi capability expose qua Contract (S007/W007).
- **Reuse, never redefine.** Dùng Registry (S014), Policy (S012), Governance (S013) của Runtime.
- **Observable, never hidden.** Mọi resolution quan sát được qua S011.

## Invariants

1. Mọi capability đều đăng ký trong Registry (S014 capability-registry).
2. Mọi resolution đều đi qua Runtime (S010 EF007).
3. Capability không chứa Business Logic.
4. Capability không định nghĩa lại Policy, Contract, State Machine của Runtime.
5. Mọi Agent/Plugin khai báo năng lực qua Capability System — không hardcode.

## Scope

Capability System bao gồm:

- Khai báo Capability (declaration, schema, version).
- Đăng ký Capability trong Registry (S014 capability-registry).
- Phân giải Capability (S010 EF007 — resolution pipeline).
- Gắn Capability với Agent/Plugin (capability mapping).
- Khai báo tham số Policy cho Capability (S012 binding).
- Quan sát Capability (S011 events/metrics/trace/audit).

Capability System không bao gồm:

- Runtime (SPEC-001).
- Workflow Engine (SPEC-002).
- Agent (SPEC-004).
- Business Logic.

## Relation to SPEC-001/002

Capability System **dùng** Runtime Kernel và Workflow Engine:

```text
Capability System (SPEC-003)
    │
    ├── Runtime (SPEC-001) — Resolution (EF007), Registry (S014), Policies (S012)
    ├── Workflow Engine (SPEC-002) — step = capability
    ├── Constitution (SPEC-000) — nguyên tắc, luật
    └── Khai báo năng lực Agents/Plugins
```

Capability System không định nghĩa lại bất kỳ khái niệm nào của Runtime/Workflow.

## Tham chiếu

- Constitution: `docs/specs/SPEC-000/`
- Runtime Kernel: `../SPEC-001/`
- Workflow Engine: `../SPEC-002/`
