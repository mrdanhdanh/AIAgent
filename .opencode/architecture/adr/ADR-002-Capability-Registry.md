---
name: adr-002-capability-registry
description: ADR-002 — Quyết định kiến trúc Capability Registry: nguồn sự thật tập trung, validate chặt.
agent: general
---

# ADR-002 — Capability Registry

## Status

Accepted (Phase 0.2, khóa kiến trúc)

## Problem

Runtime cần biết "capability nào có agent/skill nào đảm nhận" mà không đọc rải rác từng file .md. Thiếu nguồn sự thật tập trung → route sai, coverage mù, agent bỏ trống capability.

## Options

1. **Không registry** — parse từng file agent/skill khi cần.
2. **Registry YAML tập trung** — `capability/agent/skill/command/contract-registry.yaml` + validator.
3. **Registry code (C#/script)** — sinh registry bằng code.

## Decision

Chọn **Option 2 — Registry YAML tập trung + validator**: `.opencode/registry/` (11 file), `capability-validator.ps1` validate CR-001..009, yêu cầu status + version + contract cho mọi entry.

Kết quả: capabilities=38, agents=18, skills=29, commands=54, validator PASS exit 0. Báo cáo coverage `.opencode/reports/CAPABILITY_COVERAGE.md`.

## Consequences

**Tích cực**
- Capability First (nguyên tắc #3) khả thi: resolver chỉ hỏi registry.
- Validator bắt lỗi: trùng id, thiếu field, orphan skill, capability không provider.
- 5 orphan warning chủ ý (architecture.impact, review.architecture, security.audit, documentation.write, documentation.review) — chấp nhận, cover bằng skill.

**Tiêu cực / rủi ro**
- Registry có thể lệch với disk → validator bắt, phải sync khi thêm agent/skill.

## Tham chiếu

- `COMPONENTS.md` (Capability Registry), `DATA_MODEL.md` (Capability), `NAMING_CONVENTIONS.md`, `CONTRACTS.md`.