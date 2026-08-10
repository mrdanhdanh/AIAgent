---
name: spec-016-x001-vision
version: "1.0.0"
description: >
  SPEC-016 X001 — CLI Vision. Trả lời: CLI & Commands tồn tại để làm gì?
  Không nói implementation, không nói class, không nói code.
agent: general
---

# X001 — CLI Vision

> **SPEC-016**: CLI & Commands · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **CLI & Commands tồn tại để làm gì?**

Không nói implementation.

Không nói class.

Không nói code.

## Mission

```text
CLI & Commands là entry point của AIOS.

Mọi người dùng khởi động AIOS qua CLI: gõ command, khai báo flag,
dùng alias, xem help, hoàn thành lệnh (completion), và tích hợp shell —
command chỉ khởi động Runtime và trigger workflow (TERM-007).

Không command nào làm việc trực tiếp.
```

## Vision

```text
CLI & Commands trở thành entry point thống nhất cho toàn bộ AIOS.

Mọi hoạt động AIOS được khởi động qua CLI — không command nào
xử lý nghiệp vụ trực tiếp.
```

## Position

CLI & Commands là **entry point layer** của AIOS.

CLI **không phải** Runtime.

CLI **không phải** Core.

CLI là **lớp khởi động** — command, flag, alias, help, completion, shell integration.

## Design Philosophy

CLI & Commands được thiết kế theo các nguyên tắc:

- **Entry only.** Command chỉ khởi động Runtime — không làm việc (TERM-007).
- **Trigger workflow.** Command trigger workflow (SPEC-002).
- **Help always.** Mọi command có help.
- **Alias friendly.** Mọi command có alias ngắn.
- **Observable, never hidden.** Mọi CLI call quan sát được qua S011.
- **Safe.** CLI không chứa Business Data (S011 OB003A).

## Invariants

1. Command là entry point — chỉ khởi động Runtime, không làm việc (TERM-007).
2. Command trigger workflow (SPEC-002).
3. Mọi command có help + alias.
4. CLI truy cập AIOS qua SDK (SPEC-015).
5. CLI không chứa Business Data (S011 OB003A).
6. Mọi CLI call sinh Event (S011).

## Scope

CLI & Commands bao gồm:

- Command (entry point).
- Flag (khai báo).
- Alias (ngắn gọn).
- Help (hướng dẫn).
- Completion (shell).
- Shell Integration.
- CLI Registry (SPEC-005).
- Observability (S011).

CLI & Commands không bao gồm:

- Runtime (SPEC-001).
- Task Execution.
- Business Data.
- Quyết định chính sách (S013).

## Relation to SPEC-000..015

CLI **khởi động AIOS qua SDK**:

```text
CLI & Commands (SPEC-016)
    │
    ├── TERM-007 — Command = entry point
    ├── SPEC-002 — Workflow trigger
    ├── SPEC-015 — SDK truy cập
    ├── Registry (SPEC-005) — CLI Registry
    ├── Constitution (SPEC-000) — nguyên tắc, luật
    └── Khởi động AIOS
```

CLI không định nghĩa lại bất kỳ hệ thống nào.

## Tham chiếu

- Constitution: `docs/specs/SPEC-000/`
- Runtime Kernel: `../SPEC-001/`
- Registry: `../SPEC-005/`
- SDK: `../SPEC-015/`
- Glossary TERM-007: `docs/glossary/terms/command.md`
