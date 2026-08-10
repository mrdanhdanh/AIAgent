---
name: spec-008-x001-vision
version: "1.0.0"
description: >
  SPEC-008 X001 — Event Vision. Trả lời: Event Bus tồn tại để làm gì?
  Không nói implementation, không nói class, không nói code.
agent: general
---

# X001 — Event Vision

> **SPEC-008**: Event Bus · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Event Bus tồn tại để làm gì?**

Không nói implementation.

Không nói class.

Không nói code.

## Mission

```text
Event Bus là lớp quản lý Event trên Runtime Kernel.

Mọi state change trong AIOS đều thành Event: publish khi state đổi,
route đến subscriber, deliver đúng một lần, replay để simulate/audit,
và archive khi hết hạn — theo RULE-007.

Không có state change nào không phát Event.
```

## Vision

```text
Event Bus trở thành hệ thống Event thống nhất cho toàn bộ AIOS.

Mọi Workflow, Agent, Capability, Artifact phát/nhận Event qua Event Bus
thay vì xử lý Event riêng.
```

## Position

Event Bus là **event management layer** của AIOS.

Event Bus **không phải** Runtime.

Event Bus **không phải** Database.

Event Bus là **lớp quản lý Event** — immutable, có lineage, append-only.

## Design Philosophy

Event Bus được thiết kế theo các nguyên tắc:

- **Immutable only.** Event sinh ra không sửa — sửa = không cho phép (P010/RULE-007).
- **Append-only.** Event chỉ được append, không bao giờ xóa (P005).
- **Lineage always.** Mọi Event có lineage (event chain) (RULE-007).
- **Publish qua Bus.** Event chỉ phát qua Event Bus (TERM-012).
- **Observable, never hidden.** Mọi Event quan sát được qua S011.
- **Replayable.** Event log phục vụ replay/simulate/audit (RULE-007).

## Invariants

1. Mọi state change phải phát Event (RULE-007).
2. Event luôn immutable — không mutable (P010).
3. Event có lineage — không mất chain (RULE-007).
4. Event chỉ được append — không overwrite, không xóa (P005).
5. Event không chứa Business Data (S011 OB003A).
6. Event được publish qua Event Bus (TERM-012).

## Scope

Event Bus bao gồm:

- Publish Event (mọi state change).
- Route Event đến subscriber (topic/subscription).
- Deliver Event (guarantee, ordering).
- Subscribe/Unsubscribe.
- Replay Event (simulate/audit).
- Archive Event (retention).
- Event Registry (SPEC-005).
- Observability (S011).

Event Bus không bao gồm:

- Runtime (SPEC-001).
- Business Data.
- Event Content Processing (business logic).
- Command Execution.

## Relation to SPEC-001/005/007

Event Bus **thực thi S011 Event Model**:

```text
Event Bus (SPEC-008)
    │
    ├── S011 — Event Model (fields, types, severity)
    ├── S009 — State Events (mọi transition sinh Event)
    ├── Registry (SPEC-005) — Event Registry
    ├── SPEC-007 — Artifact events
    ├── Constitution (SPEC-000) — nguyên tắc, luật
    └── Quản lý Event
```

Event Bus không định nghĩa lại bất kỳ khái niệm nào của S011.

## Tham chiếu

- Constitution: `docs/specs/SPEC-000/`
- Runtime Kernel: `../SPEC-001/` (S011 Event Model)
- Registry: `../SPEC-005/`
- Artifact Manager: `../SPEC-007/`
- Rule RULE-007: `docs/rules/RULE-007-event.md`
- Glossary TERM-012: `docs/glossary/terms/event.md`
