---
id: P010
name: Immutable Artifact
status: Draft
category: Data
severity: critical
breaking_change: true
enforced_by:
  - doctor
  - artifact_store
implemented_in:
  - SPEC-007
related:
  - P004
  - P015
statement: >
  Artifact sinh ra không sửa. Nếu sửa → version mới.
rationale: >
  Immutable → toàn vẹn, reproducible, audit được.
  Artifact là bằng chứng của một lần thực thi.
rules:
  - Không sửa artifact sau khi sinh.
  - Thay đổi → tạo version mới.
  - Artifact có checksum.
implications:
  - plan.md v1 không bị thay bởi plan.md v2.
  - Audit dựa trên artifact gốc.
anti_patterns:
  - Ghi đè artifact cũ.
  - Sửa nội dung artifact sau publish.
exceptions:
  - Không có.
examples:
  - Artifact v1, v2, v3 cùng tồn tại.
references:
  - P004 Everything is Versioned
  - P015 Fail Safe
---

# P010 — Immutable Artifact

## Statement

> Artifact sinh ra → không sửa. Nếu sửa → version mới.

## Rules

```text
Artifact sinh ra
    ↓
không sửa
```

Nếu sửa:

```text
↓
version mới
```

## Implications

- Toàn vẹn + reproducible.
- Audit dựa trên artifact gốc.

## Anti Pattern

❌ Ghi đè / sửa artifact sau publish.
