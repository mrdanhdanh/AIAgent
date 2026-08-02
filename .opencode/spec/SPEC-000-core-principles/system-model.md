---
name: spec-000-system-model
description: SPEC-000 Part III — System Model: Object Model, Execution Model, Communication Model, Data Model.
agent: general
---

# Part III — System Model

## Chương 8 — Object Model

Chỉ định nghĩa thực thể — không nói class, không nói implementation.

```text
Workflow
   ↓ (has)
Phase
   ↓ (has)
Task
   ↓ (runs)
Agent
   ↓ (supports)
Capability
   ↓ (produces)
Artifact
   ↓ (emits)
Event
```

| Entity | Vai trò |
|--------|---------|
| Workflow | chuỗi phase có trạng thái |
| Phase | bước trong workflow |
| Task | đơn vị công việc |
| Agent | thực thi capability; stateless |
| Capability | khả năng, không phụ thuộc agent |
| Artifact | output có version/checksum/lineage |
| Event | thông báo bất biến |

Mọi entity kế thừa base: `id · type · version · status · metadata`.

## Chương 9 — Execution Model

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
Artifacts
  ↓
Events
  ↓
Done
```

Nguyên tắc:
- Execution do **Runtime** điều phối.
- Agent được chọn qua **capability**, không gọi trực tiếp.
- Agent nhận context, trả artifact, phát event.
- Stateless (P-006), simulation trước (P-010).

## Chương 10 — Communication Model

Luật:

```text
Module
  ↓
Event
  ↓
Runtime
  ↓
Module
```

- **Không module nào gọi nhau trực tiếp.**
- Giao tiếp qua Event Bus + Contract.
- Synchronous (khi cần) qua Runtime API; async qua events.

## Chương 11 — Data Model

Định nghĩa 5 loại dữ liệu — không nói JSON/schema cụ thể:

| Loại | Mô tả |
|------|-------|
| Metadata | thông tin thực thể (id/type/version/status) |
| Configuration | cấu hình hành vi (policy, budget, rules) |
| Artifacts | output có version (content) |
| Knowledge | lessons, patterns, graph |
| Memory | working/session/failure records |

- Metadata & Configuration: **machine readable** (P-014).
- Artifacts: **versioned + checksum** (P-003).
- Knowledge & Memory: **queryable** qua graph/index.