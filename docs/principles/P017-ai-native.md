---
id: P017
name: AI Native
status: Draft
category: AI
severity: high
breaking_change: true
enforced_by:
  - validator
implemented_in:
  - SPEC-000
related:
  - P003
  - P020
statement: >
  Mọi thứ đều phải Machine Readable và Human Readable.
rationale: >
  AI đọc được thì AI mới vận hành được. Không được chỉ có Markdown văn xuôi.
  Machine-readable (YAML/JSON/schema) + human-readable (docs).
rules:
  - Mọi định nghĩa có dạng machine-readable.
  - Kèm giải thích human-readable.
  - Không chỉ có Markdown.
implications:
  - SPEC có spec.yaml + README.md.
  - Principle có frontmatter YAML + body markdown.
anti_patterns:
  - Chỉ tài liệu Markdown văn xuôi.
  - Thông tin chỉ trong đầu người / chỉ trong code.
exceptions:
  - Không có.
examples:
  - AIOS_MANIFEST.yaml + docs giải thích.
references:
  - P003 Metadata First
  - P020 Constitution First
---

# P017 — AI Native

## Statement

> Mọi thứ đều phải Machine Readable và Human Readable.

## Rules

- Machine Readable.
- Human Readable.
- Không được chỉ có Markdown.

## Implications

- YAML/JSON/schema cho máy.
- Docs cho người.
- AI vận hành được.

## Anti Pattern

❌ Chỉ Markdown văn xuôi, máy không đọc được.
