---
name: spec-013-x001-vision
version: "1.0.0"
description: >
  SPEC-013 X001 — Evolution Vision. Trả lời: Evolution Engine tồn tại để làm gì?
  Không nói implementation, không nói class, không nói code.
agent: general
---

# X001 — Evolution Vision

> **SPEC-013**: Evolution Engine · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Evolution Engine tồn tại để làm gì?**

Không nói implementation.

Không nói class.

Không nói code.

## Mission

```text
Evolution Engine là lớp tiến hóa hệ thống trên Runtime Kernel.

Mọi thay đổi trong AIOS đều qua Evolution: so sánh (diff) phiên bản,
kiểm tra backward compatibility, tạo migration plan, self-heal an toàn,
chấm Health Score, và evolve — theo P013.

Không thay đổi nào phá vỡ hệ thống.
```

## Vision

```text
Evolution Engine trở thành hệ thống tiến hóa thống nhất cho toàn bộ AIOS.

Mọi Workflow, Agent, Capability, Contract tiến hóa qua Evolution Engine
thay vì thay đổi trực tiếp.
```

## Position

Evolution Engine là **evolution management layer** của AIOS.

Evolution Engine **không phải** Runtime.

Evolution Engine **không phải** Production.

Evolution Engine là **lớp quản lý tiến hóa** — diff, compatibility, migration, self-heal, score.

## Design Philosophy

Evolution Engine được thiết kế theo các nguyên tắc:

- **Safe evolution.** Thay đổi không phá vỡ hệ thống (P013).
- **Backward compatible.** Mọi thay đổi giữ tương thích ngược.
- **Migration planned.** Thay đổi có migration plan.
- **Self-heal doc-only.** Self-heal chỉ sửa doc, không sửa core.
- **Observable, never hidden.** Mọi evolution quan sát được qua S011.
- **Measurable.** Mọi thay đổi chấm điểm (Health Score).

## Invariants

1. Evolution không phá vỡ hệ thống (P013).
2. Mọi thay đổi giữ backward compatibility.
3. Mọi thay đổi có migration plan.
4. Self-heal chỉ sửa doc, không sửa core.
5. Evolution không chứa Business Data (S011 OB003A).
6. Mọi evolution sinh Event (S011).

## Scope

Evolution Engine bao gồm:

- Semantic Diff (phiên bản cũ/mới).
- Compatibility Check.
- Migration Plan.
- Knowledge Migration.
- Self-Heal (doc-only).
- Health Score (0-100).
- Capability Benchmark.
- Stress Test (qua Simulation).
- Evolution Report.

Evolution Engine không bao gồm:

- Runtime (SPEC-001).
- Core Modification.
- Business Data.
- Quyết định chính sách (S013).

## Relation to SPEC-000..012

Evolution Engine **tiến hóa hệ thống**:

```text
Evolution Engine (SPEC-013)
    │
    ├── SPEC-001 — Runtime (compatibility)
    ├── SPEC-002 — Workflow (diff/migration)
    ├── SPEC-003 — Capability benchmark
    ├── SPEC-005 — Registry (versioning)
    ├── SPEC-011 — Doctor (health score)
    ├── SPEC-012 — Simulation (stress test)
    ├── Constitution (SPEC-000) — nguyên tắc, luật
    └── Tiến hóa hệ thống
```

Evolution Engine không định nghĩa lại bất kỳ hệ thống nào.

## Tham chiếu

- Constitution: `docs/specs/SPEC-000/`
- Runtime Kernel: `../SPEC-001/`
- Workflow: `../SPEC-002/`
- Registry: `../SPEC-005/`
- Doctor: `../SPEC-011/`
- Simulation: `../SPEC-012/`
- /team-syncdocs: `.opencode/scripts/evolution/`
