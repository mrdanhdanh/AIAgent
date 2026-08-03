---
name: governance-principles
description: >
  Governance (Sprint 3) — Version, Naming, Compatibility, Deprecation, RFC, ADR.
  Building block cho SPEC-000 Constitution.
agent: general
---

# Governance

> Sprint 3. Quy tắc quản trị — sau Architecture Principles, trước Consolidation.

## G-001 — Versioning

- Semantic Version: MAJOR.MINOR.PATCH.
- MAJOR = breaking, MINOR = feature, PATCH = fix.
- Mọi thực thể version (P009).
- Không overwrite — tạo version mới.

## G-002 — Naming

| Đối tượng | Quy ước | Ví dụ |
|-----------|---------|-------|
| Agent | `xxx-agent` | planner-agent |
| Workflow | `WF-xxxx` | WF-0421 |
| Artifact | `PREFIX-xxxx` | PLAN-001 |
| Capability | `<category>.<specific>` | implementation.code |
| Event type | `UPPER_SNAKE` | WORKFLOW_STARTED |
| Entity id | `lowercase-hyphen` | planner |

## G-003 — Compatibility

| Loại | Định nghĩa |
|------|-----------|
| Forward | code mới chạy dữ liệu cũ |
| Backward | code cũ chạy dữ liệu mới |
| Breaking | cần migration |

- Backward by default (P015).
- Breaking → deprecation + migration.

## G-004 — Deprecation

```text
mark deprecated → deprecation window → remove
```

- Window ≥ 1 minor version.
- Có migration guide.
- Deprecated entity vẫn chạy nhưng cảnh báo.

## G-005 — RFC (đề xuất)

RFC là đề xuất thay đổi — phải chỉ rõ:

- Điều khoản SPEC-000 nào bị ảnh hưởng.
- Lý do + tác động.
- Đề xuất nội dung mới.

## G-006 — ADR (quyết định)

ADR là quyết định kiến trúc + lý do:

- Vấn đề.
- Các lựa chọn.
- Quyết định.
- Lý do (tham chiếu core principles).
- Hệ quả.

Lưu tại `.opencode/architecture/adr/`.

## G-007 — Decision Hierarchy

```text
Constitution (SPEC-000)
    ↓
ADR
    ↓
SPEC
    ↓
Contracts
    ↓
Code
```

- Code khác SPEC → Code sai.
- SPEC khác ADR → SPEC sai.
- ADR khác Constitution → ADR sai.

## Tham chiếu

- P009, P012, P015.
- `docs/specs/SPEC-000/governance.md`.