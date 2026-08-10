---
name: spec-010-x001-vision
version: "1.0.0"
description: >
  SPEC-010 X001 — Plugin Vision. Trả lời: Plugin Framework tồn tại để làm gì?
  Không nói implementation, không nói class, không nói code.
agent: general
---

# X001 — Plugin Vision

> **SPEC-010**: Plugin Framework · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Plugin Framework tồn tại để làm gì?**

Không nói implementation.

Không nói class.

Không nói code.

## Mission

```text
Plugin Framework là lớp quản lý Plugin trên Runtime Kernel.

Mọi extension của AIOS đều thành Plugin: install khi có manifest hợp lệ,
validate schema + permission, enable để export capability/agent/skill/widget,
disable khi cần tắt, và uninstall khi hết dùng — theo TERM-015.

Không Plugin nào sửa Core.
```

## Vision

```text
Plugin Framework trở thành hệ thống Plugin thống nhất cho toàn bộ AIOS.

Mọi capability, agent, skill, widget mở rộng đều qua Plugin Framework
thay vì sửa Core.
```

## Position

Plugin Framework là **plugin management layer** của AIOS.

Plugin Framework **không phải** Runtime.

Plugin Framework **không phải** Core.

Plugin Framework là **lớp quản lý Plugin** — extension, manifest-based, không sửa Core.

## Design Philosophy

Plugin Framework được thiết kế theo các nguyên tắc:

- **Extension only.** Plugin chỉ mở rộng, không sửa Core (TERM-015).
- **Manifest first.** Mọi Plugin có manifest khai báo permission (TERM-015).
- **Sandboxed.** Plugin không truy cập ngoài permission (TERM-015).
- **Contract-based.** Plugin giao tiếp qua Contract (SPEC-009).
- **Observable, never hidden.** Mọi Plugin quan sát được qua S011.
- **Reversible.** Enable/Disable/Uninstall không phá vỡ Core.

## Invariants

1. Plugin là extension — không sửa Core (TERM-015).
2. Plugin khai báo permission trong manifest (TERM-015).
3. Plugin không truy cập ngoài permission (TERM-015).
4. Plugin giao tiếp qua Contract (SPEC-009).
5. Plugin không chứa Business Data (S011 OB003A).
6. Plugin export qua Registry (SPEC-005).

## Scope

Plugin Framework bao gồm:

- Install Plugin (manifest).
- Validate Plugin (schema + permission).
- Enable/Disable Plugin.
- Uninstall Plugin.
- Export capability/agent/skill/widget.
- Plugin Registry (SPEC-005).
- Observability (S011).

Plugin Framework không bao gồm:

- Runtime (SPEC-001).
- Core Modification.
- Business Data.
- Plugin Implementation Logic (Capability System lo).

## Relation to SPEC-001/003/005/009

Plugin Framework **thực thi TERM-015**:

```text
Plugin Framework (SPEC-010)
    │
    ├── S014 — Plugin Registry (SPEC-001)
    ├── SPEC-003 — Exported Capability
    ├── SPEC-009 — Plugin Contract
    ├── Registry (SPEC-005) — Plugin Registry
    ├── Constitution (SPEC-000) — nguyên tắc, luật
    └── Quản lý Plugin
```

Plugin Framework không định nghĩa lại bất kỳ khái niệm nào của TERM-015.

## Tham chiếu

- Constitution: `docs/specs/SPEC-000/`
- Runtime Kernel: `../SPEC-001/` (S014 Plugin Registry)
- Capability: `../SPEC-003/`
- Registry: `../SPEC-005/`
- Contract System: `../SPEC-009/`
- Glossary TERM-015: `docs/glossary/terms/plugin.md`
