---
name: spec-007-x001-vision
version: "1.0.0"
description: >
  SPEC-007 X001 — Artifact Vision. Trả lời: Artifact Manager tồn tại để làm gì?
  Không nói implementation, không nói class, không nói code.
agent: general
---

# X001 — Artifact Vision

> **SPEC-007**: Artifact Manager · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Artifact Manager tồn tại để làm gì?**

Không nói implementation.

Không nói class.

Không nói code.

## Mission

```text
Artifact Manager là lớp quản lý Artifact trên Runtime Kernel.

Mọi output của Task/Agent đều thành Artifact: tạo khi Execution sinh output,
validate + checksum, publish immutable, version khi sửa, index để tìm kiếm,
consume bởi Agent/Doctor/Dashboard, và archive khi hết hạn — theo S008 ENT-008.

Không có Artifact nào bị overwrite.
```

## Vision

```text
Artifact Manager trở thành hệ thống Artifact thống nhất cho toàn bộ AIOS.

Mọi Workflow, Agent và Capability gửi/nhận Artifact qua Artifact Manager
thay vì lưu output riêng.
```

## Position

Artifact Manager là **artifact management layer** của AIOS.

Artifact Manager **không phải** Runtime.

Artifact Manager **không phải** Database.

Artifact Manager là **lớp quản lý Artifact** — immutable, versioned, có checksum.

## Design Philosophy

Artifact Manager được thiết kế theo các nguyên tắc:

- **Immutable only.** Artifact sinh ra không sửa — sửa = version mới (P010).
- **Checksum always.** Mọi Artifact có checksum, không đổi checksum (P010).
- **Versioned.** Mọi Artifact có version (P004).
- **No overwrite.** Không bao giờ overwrite (TERM-008).
- **Observable, never hidden.** Mọi Artifact quan sát được qua S011 (RULE-014).
- **Owned by Execution.** Artifact thuộc đúng một Execution (S008).

## Invariants

1. Artifact luôn immutable — không mutable (P010, RULE-005).
2. Artifact có checksum — không đổi checksum (P010).
3. Artifact không bao giờ bị overwrite (TERM-008).
4. Artifact thuộc đúng một Execution — không đổi Owner (S008).
5. Artifact không chứa Business Data (S011 OB003A).
6. Artifact được archive khi hết hạn (governance lifecycle).

## Scope

Artifact Manager bao gồm:

- Create Artifact (output của Task/Agent).
- Validate + checksum Artifact.
- Publish Artifact (immutable).
- Version Artifact (sửa = version mới).
- Index Artifact (tìm kiếm).
- Consume Artifact (Agent/Doctor/Dashboard).
- Archive Artifact (retention).
- Artifact Registry (SPEC-005).
- Observability (S011).

Artifact Manager không bao gồm:

- Runtime (SPEC-001).
- Business Data.
- Context (SPEC-006).
- Memory/Knowledge (thuộc bộ nhớ dài hạn khác).

## Relation to SPEC-001/005

Artifact Manager **thực thi ENT-008** (Artifact):

```text
Artifact Manager (SPEC-007)
    │
    ├── S008 — ENT-008 Artifact (persistent metadata)
    ├── S010 — Execution Flow (Artifact sinh ra trong luồng)
    ├── S011 — Events + Metrics (RULE-014)
    ├── Registry (SPEC-005) — Artifact Registry
    ├── Constitution (SPEC-000) — nguyên tắc, luật
    └── Quản lý Artifact
```

Artifact Manager không định nghĩa lại bất kỳ khái niệm nào của ENT-008.

## Tham chiếu

- Constitution: `docs/specs/SPEC-000/`
- Runtime Kernel: `../SPEC-001/` (S008 ENT-008)
- Registry: `../SPEC-005/`
- Principle P010: `docs/principles/P010-immutable-artifact.md`
- Glossary TERM-008: `docs/glossary/terms/artifact.md`
