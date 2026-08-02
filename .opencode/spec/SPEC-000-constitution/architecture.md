---
name: spec-000-architecture
description: SPEC-000 Part III — Architecture: Layers, Object Model, Dependency, Communication, Execution, Data Model.
agent: general
---

# Part III — Architecture

Chỉ mô hình — không implementation.

## Chương 6 — Architecture Layers

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

| Layer | Vai trò |
|-------|---------|
| Presentation | Dashboard, CLI, IDE |
| Extensions | Plugins, SDK, Marketplace |
| Intelligence | Simulation, Doctor, Evaluation, Evolution |
| Runtime | Scheduler, State Machine, Capability Resolver |
| Infrastructure | Storage, Registry, Event Bus |

## Chương 7 — Object Model

```text
Workflow
  ↓ (has)
Phase
  ↓ (has)
Task
  ↓ (runs via)
Capability
  ↓ (executed by)
Agent
  ↓ (produces)
Artifact
  ↓ (emits)
Event
```

Mọi entity kế thừa base: `id · type · version · status · metadata`.

## Chương 8 — Dependency Rules

Dependency chỉ đi **một chiều từ trên xuống**:

```text
Presentation → Runtime → Infrastructure
```

- **Không được ngược** (Infrastructure không phụ thuộc Presentation).
- **Không circular dependency.**
- Runtime không phụ thuộc Extension.
- Core không phụ thuộc Plugin.

## Chương 9 — Communication Model

4 hình thức:

| Hình thức | Dùng khi |
|-----------|----------|
| Sync (request/response) | cần kết quả ngay, qua Runtime API |
| Async (task/result) | xử lý lâu, không chờ |
| Event (publish/subscribe) | state change, thông báo |
| Query | truy vấn read model (snapshot) |

Mọi hình thức đều qua Contract (P002) + Runtime (P001).

## Chương 10 — Execution Model

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
- Agent chọn qua capability, không gọi trực tiếp.
- Simulation trước (P011), stateless (P009).

## Chương 11 — Data Model

5 loại dữ liệu:

| Loại | Mô tả |
|------|-------|
| Metadata | thông tin thực thể |
| Configuration | cấu hình hành vi |
| Artifacts | output versioned |
| Memory | working/session/failure |
| Knowledge | lessons/patterns/graph |

- Metadata & Configuration: machine readable.
- Artifacts: immutable + versioned.
- Memory & Knowledge: queryable.