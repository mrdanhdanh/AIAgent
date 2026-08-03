---
name: spec-000-governance
description: SPEC-000 Part IV — Governance: Versioning, Compatibility, Naming, Documentation, Decision Hierarchy.
agent: general
---

# Part IV — Governance

## Chương 12 — Versioning

- **Semantic Version**: MAJOR.MINOR.PATCH.
- MAJOR = breaking, MINOR = feature, PATCH = fix.
- Mọi thực thể version (P004): agent, artifact, prompt, capability, workflow.
- Không overwrite — tạo version mới.
- **Deprecation**: đánh dấu deprecated → giữ window → gỡ.
- **Migration**: hướng dẫn chuyển version.

## Chương 13 — Compatibility

| Loại | Định nghĩa |
|------|-----------|
| Forward | code mới chạy với dữ liệu cũ |
| Backward | code cũ chạy với dữ liệu mới |
| Breaking change | không tương thích, cần migration |

- Backward by default (P015).
- Breaking → deprecation window + migration guide.

```text
Runtime v4 → Agent v3 → Compatible
Runtime v4 → Agent v2 → Compatible
Runtime v4 → Agent v1 → Reject (cần migration)
```

## Chương 14 — Naming

| Đối tượng | Quy ước | Ví dụ |
|-----------|---------|-------|
| Agent | `xxx-agent` | `planner-agent` |
| Workflow | `WF-xxxx` | `WF-0421` |
| Artifact | `PREFIX-xxxx` | `PLAN-001`, `ART-001` |
| Capability | `<category>.<specific>` | `implementation.code` |
| Event type | `UPPER_SNAKE` | `WORKFLOW_STARTED` |
| Entity id | `lowercase-hyphen` | `planner` |

## Chương 15 — Documentation

Chuẩn hóa các loại tài liệu:

| Loại | Vai trò |
|------|---------|
| README | giới thiệu |
| SPEC | đặc tả chi tiết (SPEC-001..020) |
| ADR | quyết định kiến trúc + lý do |
| RFC | đề xuất thay đổi |
| CHANGELOG | lịch sử thay đổi |

Quy ước viết: UTF-8 no-BOM, 2-space, frontmatter (name/description/agent).

## Chương 16 — Decision Hierarchy

Thứ tự ưu tiên khi xung đột:

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

Luật:
- **Nếu Code khác SPEC → Code sai.**
- **Nếu SPEC khác ADR → SPEC sai.**
- **Nếu ADR khác Constitution → ADR sai.**

Mọi thay đổi đi từ trên xuống; không sửa ngầm tầng dưới.