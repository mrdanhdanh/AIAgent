---
name: spec-009-x001-vision
version: "1.0.0"
description: >
  SPEC-009 X001 — Contract Vision. Trả lời: Contract System tồn tại để làm gì?
  Không nói implementation, không nói class, không nói code.
agent: general
---

# X001 — Contract Vision

> **SPEC-009**: Contract System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Contract System tồn tại để làm gì?**

Không nói implementation.

Không nói class.

Không nói code.

## Mission

```text
Contract System là lớp quản lý Contract trên Runtime Kernel.

Mọi giao tiếp giữa hai thành phần đều qua Contract: declare khi tạo
interface, validate schema, version khi thay đổi, resolve cho caller,
verify trước khi dùng, và retire khi hết hạn — theo S007 Contract Model.

Không thành phần nào gọi trực tiếp thành phần khác.
```

## Vision

```text
Contract System trở thành hệ thống Contract thống nhất cho toàn bộ AIOS.

Mọi Runtime, Agent, Capability, Plugin giao tiếp qua Contract System
thay vì gọi trực tiếp.
```

## Position

Contract System là **contract management layer** của AIOS.

Contract System **không phải** Runtime.

Contract System **không phải** Database.

Contract System là **lớp quản lý Contract** — versioned, backward compatible, không implementation.

## Design Philosophy

Contract System được thiết kế theo các nguyên tắc:

- **Interface only.** Contract chỉ định nghĩa input/output (TERM-014).
- **No implementation.** Contract không chứa code (TERM-014).
- **Versioned always.** Mọi Contract có version (P004).
- **Backward compatible.** Thay đổi không phá vỡ caller (XNF-006).
- **Observable, never hidden.** Mọi Contract quan sát được qua S011.
- **Verified.** Contract được verify trước khi dùng.

## Invariants

1. Contract định nghĩa input/output — không chứa implementation (TERM-014).
2. Contract luôn versioned (P004).
3. Contract backward compatible (XNF-006).
4. Không gọi trực tiếp — qua Contract (TERM-014).
5. Contract không chứa Business Data (S011 OB003A).
6. Contract được verify trước khi resolve.

## Scope

Contract System bao gồm:

- Declare Contract (interface).
- Validate Contract (schema).
- Version Contract (thay đổi = version mới).
- Resolve Contract (cho caller).
- Verify Contract (trước khi dùng).
- Retire Contract (hết hạn).
- Contract Registry (SPEC-005).
- Observability (S011).

Contract System không bao gồm:

- Runtime (SPEC-001).
- Implementation của Contract.
- Business Data.
- Command Execution.

## Relation to SPEC-001/005

Contract System **thực thi S007 Contract Model**:

```text
Contract System (SPEC-009)
    │
    ├── S007 — Contract Model (types, compatibility)
    ├── S009 — State Events (mọi transition sinh Event)
    ├── Registry (SPEC-005) — Contract Registry
    ├── Constitution (SPEC-000) — nguyên tắc, luật
    └── Quản lý Contract
```

Contract System không định nghĩa lại bất kỳ khái niệm nào của S007.

## Tham chiếu

- Constitution: `docs/specs/SPEC-000/`
- Runtime Kernel: `../SPEC-001/` (S007 Contract Model)
- Registry: `../SPEC-005/`
- Glossary TERM-014: `docs/glossary/terms/contract.md`
