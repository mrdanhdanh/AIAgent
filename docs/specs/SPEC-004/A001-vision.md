---
name: spec-004-a001-vision
version: "1.0.0"
description: >
  SPEC-004 A001 — Agent Vision. Trả lời: Agent System tồn tại để làm gì?
  Và Agent System là gì trong AIOS. Không nói implementation, không nói
  class, không nói code.
agent: general
---

# A001 — Agent Vision

> **SPEC-004**: Agent System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Agent System tồn tại để làm gì?**

Không nói implementation.

Không nói class.

Không nói code.

## Mission

```text
Agent System là lớp khai báo, đăng ký và điều phối Agents trên Runtime Kernel.

Mọi Agent đều được khai báo bằng metadata, đăng ký trong Registry (S014
agent-registry), expose capability qua Capability System (SPEC-003),
và chạy qua Runtime (SPEC-001).

Không có Agent nào chạy ngoài Runtime.
```

## Vision

```text
Agent System trở thành lớp chuẩn hóa duy nhất để khai báo và điều phối Agent AIOS.

Mọi Agent tham gia Workflow (SPEC-002) qua capability đã resolve
thay vì giao tiếp trực tiếp với nhau.
```

## Position

Agent System là **declaration & orchestration layer** của AIOS.

Agent System **không phải** Runtime.

Agent System **không phải** Agent.

Agent System **không phải** Capability System.

Agent System là **lớp khai báo và điều phối Agents** trên Runtime Kernel.

## Design Philosophy

Agent System được thiết kế theo các nguyên tắc:

- **Declare, never hardcode.** Agent khai báo bằng metadata, không code.
- **Register before run.** Mọi agent đăng ký trong Registry (S014) trước khi chạy.
- **Capability-bound.** Agent expose năng lực qua Capability System (SPEC-003).
- **Run through Runtime.** Mọi agent chạy qua Runtime (SPEC-001) — không tự chạy.
- **Orchestrate through Workflow.** Workflow (SPEC-002) điều phối agent qua capability.
- **Observable, never hidden.** Mọi agent quan sát được qua S011.

## Invariants

1. Mọi Agent đều đăng ký trong Registry (S014 agent-registry).
2. Mọi Agent expose capability qua Capability System (SPEC-003).
3. Mọi Agent chạy qua Runtime (SPEC-001) — không tự chạy.
4. Agent System không định nghĩa lại Runtime, Capability, Workflow.
5. Mọi Agent/Plugin khai báo năng lực qua Capability System — không hardcode.

## Scope

Agent System bao gồm:

- Khai báo Agent (declaration, schema, version).
- Đăng ký Agent trong Registry (S014 agent-registry).
- Gắn Agent với Capability (SPEC-003 capability mapping).
- Điều phối Agent qua Workflow (SPEC-002).
- Khai báo tham số Policy cho Agent (S012 binding).
- Quan sát Agent (S011 events/metrics/trace/audit).

Agent System không bao gồm:

- Runtime (SPEC-001).
- Workflow Engine (SPEC-002).
- Capability System (SPEC-003).
- Business Logic.

## Relation to SPEC-001/002/003

Agent System **dùng** Runtime Kernel, Workflow Engine và Capability System:

```text
Agent System (SPEC-004)
    │
    ├── Runtime (SPEC-001) — Execution, Registry (S014), Policies (S012)
    ├── Workflow Engine (SPEC-002) — điều phối Agent
    ├── Capability System (SPEC-003) — agent expose capability
    ├── Constitution (SPEC-000) — nguyên tắc, luật
    └── Khai báo và điều phối Agents
```

Agent System không định nghĩa lại bất kỳ khái niệm nào của Runtime/Workflow/Capability.

## Tham chiếu

- Constitution: `docs/specs/SPEC-000/`
- Runtime Kernel: `../SPEC-001/`
- Workflow Engine: `../SPEC-002/`
- Capability System: `../SPEC-003/`
