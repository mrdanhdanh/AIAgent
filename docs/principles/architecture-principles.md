---
name: architecture-principles
description: >
  Architecture Principles (Sprint 2) — Layer Model, Dependency Rules, Execution Model,
  Communication Model, Data Model. Vẫn KHÔNG nói implementation.
agent: general
---

# Architecture Principles

> Sprint 2. Quy tắc kiến trúc — sau Core Principles, trước Governance.

## A-001 — Layer Model

5 tầng, chỉ mô hình:

```text
Presentation
    ↓
Extensions
    ↓
Intelligence
    ↓
Runtime
    ↓
Infrastructure
```

| Layer | Chứa |
|-------|------|
| Presentation | Dashboard, CLI, IDE |
| Extensions | Plugins, SDK, Marketplace |
| Intelligence | Simulation, Doctor, Evaluation, Evolution |
| Runtime | Scheduler, State Machine, Capability Resolver |
| Infrastructure | Storage, Registry, Event Bus |

## A-002 — Dependency Rules

Dependency **một chiều từ trên xuống**:

```text
Presentation → Runtime → Infrastructure
```

- Không được ngược.
- Không circular dependency.
- Runtime không phụ thuộc Extension.
- Core không phụ thuộc Plugin.

## A-003 — Execution Model

```text
Request
  ↓
Workflow
  ↓
Runtime
  ↓
Capability Resolver
  ↓
Agent
  ↓
Artifact
  ↓
Done
```

- Execution do Runtime điều phối.
- Agent chọn qua capability.
- Simulation trước (P011).

## A-004 — Communication Model

4 hình thức:

| Hình thức | Khi nào |
|-----------|---------|
| Sync | cần kết quả ngay |
| Async | xử lý lâu |
| Event | state change |
| Query | read model |

Mọi hình thức qua Contract (P002) + Runtime (P001).

## A-005 — Data Model

5 loại:

| Loại | Mô tả |
|------|-------|
| Metadata | thông tin thực thể |
| Configuration | cấu hình hành vi |
| Artifacts | output versioned |
| Memory | working/session/failure |
| Knowledge | lessons/patterns/graph |

- Metadata/Configuration: machine readable.
- Artifacts: immutable + versioned.
- Memory/Knowledge: queryable.

## A-006 — Object Model

```text
Workflow → Phase → Task → Capability → Agent → Artifact → Event
```

Mọi entity: `id · type · version · status · metadata` (P003).

## Tham chiếu

- P001, P002, P003, P006, P011.
- Glossary: runtime.md, workflow.md, artifact.md.