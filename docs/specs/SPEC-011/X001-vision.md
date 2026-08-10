---
name: spec-011-x001-vision
version: "1.0.0"
description: >
  SPEC-011 X001 — Doctor Vision. Trả lời: Doctor tồn tại để làm gì?
  Không nói implementation, không nói class, không nói code.
agent: general
---

# X001 — Doctor Vision

> **SPEC-011**: Doctor · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Doctor tồn tại để làm gì?**

Không nói implementation.

Không nói class.

Không nói code.

## Mission

```text
Doctor là lớp kiểm tra sức khỏe của toàn bộ AIOS.

Doctor scan mọi thành phần — Environment, Agents, Commands, Skills, Knowledge,
Workflow, Contracts, Runtime (simulation), Capability (benchmark) — chẩn đoán
lỗi, chấm điểm Health Score (0-100), tự sửa an toàn, và báo cáo.

Không thành phần nào chạy mà không được Doctor kiểm tra.
```

## Vision

```text
Doctor trở thành hệ thống kiểm tra sức khỏe thống nhất cho toàn bộ AIOS.

Mọi thành phần trước khi dùng đều qua Doctor scan — không thành phần nào
chạy mà không được kiểm tra.
```

## Position

Doctor là **health management layer** của AIOS.

Doctor **không phải** Runtime.

Doctor **không phải** Database.

Doctor là **lớp kiểm tra sức khỏe** — scan, diagnose, score, repair, report.

## Design Philosophy

Doctor được thiết kế theo các nguyên tắc:

- **Scan everything.** Doctor kiểm tra toàn bộ hệ sinh thái, không bỏ sót.
- **Score measurable.** Mọi kết quả chấm điểm 0-100.
- **Repair safe.** Self-repair chỉ sửa doc, không sửa core (S013).
- **Report actionable.** Báo cáo kèm hành động sửa.
- **Observable, never hidden.** Mọi check quan sát được qua S011.
- **Non-invasive.** Doctor không tự quyết định — chỉ phát hiện + đề xuất.

## Invariants

1. Doctor scan toàn bộ hệ sinh thái (Environment/Agents/Commands/Skills/Knowledge/Workflow/Contracts/Runtime/Capability).
2. Doctor chấm điểm Health Score 0-100.
3. Doctor self-repair an toàn — chỉ sửa doc, không sửa core (S013).
4. Doctor không tự quyết định — chỉ phát hiện + đề xuất.
5. Doctor không chứa Business Data (S011 OB003A).
6. Mọi check sinh Event (S011).

## Scope

Doctor bao gồm:

- Scan Environment (môi trường chạy).
- Scan Agents/Commands/Skills/Knowledge.
- Scan Workflow/Contracts.
- Runtime simulation.
- Capability benchmark.
- Health Score (0-100).
- Self-repair an toàn.
- Report (markdown/JSON).

Doctor không bao gồm:

- Runtime (SPEC-001).
- Core Modification.
- Business Data.
- Quyết định chính sách (S013).

## Relation to SPEC-000..010

Doctor **kiểm tra hệ thống**:

```text
Doctor (SPEC-011)
    │
    ├── SPEC-001 — Runtime simulation
    ├── SPEC-002 — Workflow checks
    ├── SPEC-003 — Capability benchmark
    ├── SPEC-004 — Agent checks
    ├── SPEC-005 — Registry checks
    ├── SPEC-006..010 — Context/Artifact/Event/Contract/Plugin checks
    ├── Constitution (SPEC-000) — nguyên tắc, luật
    └── Kiểm tra sức khỏe
```

Doctor không định nghĩa lại bất kỳ hệ thống nào.

## Tham chiếu

- Constitution: `docs/specs/SPEC-000/`
- Runtime Kernel: `../SPEC-001/`
- /doctor command: `.opencode/commands/doctor.md`
