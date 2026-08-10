---
name: spec-006-x001-vision
version: "1.0.0"
description: >
  SPEC-006 X001 — Context Vision. Trả lời: Context Engine tồn tại để làm gì?
  Không nói implementation, không nói class, không nói code.
agent: general
---

# X001 — Context Vision

> **SPEC-006**: Context Engine · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Context Engine tồn tại để làm gì?**

Không nói implementation.

Không nói class.

Không nói code.

## Mission

```text
Context Engine là lớp quản lý Execution Context trên Runtime Kernel.

Mọi Execution đều có đúng một Context: tạo khi Execution Created,
cấp cho Agent/Capability, chuyển giữa các step, cô lập tuyệt đối,
và thu hồi khi Execution kết thúc — theo S010 EF008.

Không có Context nào tồn tại ngoài Execution.
```

## Vision

```text
Context Engine trở thành hệ thống Context thống nhất cho toàn bộ AIOS.

Mọi Workflow, Agent và Capability nhận/trả Context qua Context Engine
thay vì quản lý Context riêng.
```

## Position

Context Engine là **context management layer** của AIOS.

Context Engine **không phải** Runtime.

Context Engine **không phải** Database.

Context Engine là **lớp quản lý Execution Context** — transient, isolated, theo EF008.

## Design Philosophy

Context Engine được thiết kế theo các nguyên tắc:

- **Transient only.** Context chỉ tồn tại trong vòng đời Execution.
- **Isolated always.** Context không bao giờ bị chia sẻ (P006/P009).
- **Owned by Execution.** Context thuộc đúng một Execution.
- **Metadata only.** Không chứa Business Data (S011 OB003A).
- **Follow EF008.** Allocate → Populate → Distribute → Mutate → Merge → Collect → Release.
- **Observable, never hidden.** Mọi Context quan sát được qua S011.

## Invariants

1. Mọi Execution có đúng một Context (S008).
2. Context luôn isolated — không chia sẻ (P006/P009).
3. Context thuộc đúng một Execution — không đổi Owner.
4. Context không chứa Business Data.
5. Context được thu hồi khi Execution kết thúc (EF008 Release).

## Scope

Context Engine bao gồm:

- Allocate Context (EF008).
- Populate/Distribute Context cho Agent/Capability.
- Mutate Context trong phạm vi được cấp.
- Merge Context (parallel).
- Collect + Release Context.
- Context Registry (SPEC-005).
- Observability (S011).

Context Engine không bao gồm:

- Runtime (SPEC-001).
- Business Data.
- Persistence của Context.

## Relation to SPEC-001/005

Context Engine **thực thi EF008** (Context Flow):

```text
Context Engine (SPEC-006)
    │
    ├── S010 EF008 — Context Flow (Allocate → Release)
    ├── S008 — ENT Context (transient)
    ├── Registry (SPEC-005) — Context Registry
    ├── Constitution (SPEC-000) — nguyên tắc, luật
    └── Quản lý Execution Context
```

Context Engine không định nghĩa lại bất kỳ khái niệm nào của EF008.

## Tham chiếu

- Constitution: `docs/specs/SPEC-000/`
- Runtime Kernel: `../SPEC-001/` (S010 EF008)
- Registry: `../SPEC-005/`
