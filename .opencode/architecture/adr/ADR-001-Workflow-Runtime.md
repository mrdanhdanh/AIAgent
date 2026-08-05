---
name: adr-001-workflow-runtime
description: ADR-001 — Quyết định kiến trúc Workflow Runtime: data-driven, không hardcode.
agent: general
---

# ADR-001 — Workflow Runtime

## Status

Accepted (Phase 0.2, khóa kiến trúc)

## Problem

Cần cơ chế chạy workflow nhiều phase (13 bước team) mà không hardcode thứ tự trong code. Workflow v3 dùng body 13 bước trong SKILL.md — khó mở rộng, khó test, khó mô phỏng.

## Options

1. **Engine cứng (hardcoded)** — code chứa toàn bộ 13 bước, gọi agent theo tên.
2. **Data-driven YAML definitions + engine** — workflow là dữ liệu YAML, engine đọc/validate/chạy.
3. **Script per workflow** — mỗi workflow một script riêng.

## Decision

Chọn **Option 2 — Workflow Runtime data-driven**: definitions YAML (`workflow.schema.yaml` v1.0), 8 module engine, runtime context trong `WF-*` (engine tạo, không sửa tay).

Đã có: `.opencode/workflow-engine/` (engine, loader, validator, executor, phase-runner, state-machine, recovery), `.opencode/workflow/definitions/*.yaml` (5 workflow).

## Consequences

**Tích cực**
- Thêm workflow mới = thêm YAML, không sửa code.
- Validator (workflow-validator.ps1) PASS 5/5.
- Tương thích v3 (13 bước giữ làm reference).

**Tiêu cực / rủi ro**
- Đòi hỏi schema chặt (đã có).
- Runtime WF-* phải quản lý gọn, không commit tùy ý.

## Tham chiếu

- `ARCHITECTURE.md`, `DATA_MODEL.md` (Workflow/Phase), `STATE_MACHINE.md`.