---
name: spec-000-governance
description: SPEC-000 Part V — Governance: Terminology, Naming, Documentation, Decision Process, Future Evolution.
agent: general
---

# Part V — Governance

## Chương 16 — Terminology

Glossary thống nhất (đầy đủ chi tiết tại `terminology.md`):

| Thuật ngữ | Định nghĩa |
|-----------|-----------|
| AIOS | nền tảng điều hành cho AI Agent |
| Agent | thực thể thực thi capability; stateless |
| Capability | khả năng hệ thống, không phụ thuộc agent |
| Workflow | chuỗi phase có trạng thái |
| Runtime | trung tâm điều phối |
| Context | package dữ liệu cho agent |
| Artifact | output versioned |
| Event | thông báo bất biến, có lineage |
| Contract | hợp đồng giao tiếp |

## Chương 17 — Naming Convention

- Entity/event type: **UPPER_SNAKE** (WORKFLOW_STARTED, PLAN_COMPLETED).
- id: **lowercase-hyphen** (planner, implementation.code).
- Capability id: `<category>.<specific>`.
- Artifact id: `PREFIX-NNN` (PLAN-001).
- Thư mục SPEC: `SPEC-000-core-principles` (spec-{id}-{slug}).

## Chương 18 — Documentation Standard

Mọi tài liệu theo quy ước:

- UTF-8 no-BOM, 2-space, không tab.
- Frontmatter (name, description, agent).
- Markdown chuẩn CommonMark.
- SPEC files: README/terminology/object-model/lifecycle/state-machine/api/contracts/schemas/events/compatibility/examples/tests/changelog.

## Chương 19 — Decision Process

Quyết định kiến trúc qua **ADR** (Architecture Decision Record):

```text
RFC (đề xuất)
  → ADR (quyết định + lý do)
  → SPEC (cập nhật nếu cần)
  → Implementation
```

- ADR lưu tại `.opencode/architecture/adr/`.
- Mọi quyết định quan trọng cần ADR.
- ADR tham chiếu Core Principles.

## Chương 20 — Future Evolution

- AIOS v5 đóng băng kiến trúc (`AIOS_V5_FREEZE.md`).
- Không thêm module mới trừ khi cần.
- Mở rộng qua plugin/SDK.
- Core chỉ đổi khi kiến trúc lớn.
- Mọi thay đổi → cập nhật SPEC → tái sinh code nhất quán.