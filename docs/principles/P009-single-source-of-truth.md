---
id: P009
name: Single Source of Truth
status: Draft
category: Data
severity: critical
breaking_change: true
enforced_by:
  - doctor
  - validator
implemented_in:
  - SPEC-001
  - SPEC-007
related:
  - P003
  - P006
  - P014
statement: >
  Mỗi dữ liệu chỉ tồn tại một nguồn định nghĩa duy nhất.
rationale: >
  Không copy, không duplicate → không mâu thuẫn, không lỗi đồng bộ.
  State, định nghĩa, metadata đều một nguồn.
rules:
  - Workflow chỉ tồn tại 1 định nghĩa.
  - Không copy, không duplicate.
  - State nằm ở Runtime (P006).
implications:
  - Sửa nguồn → mọi nơi tham chiếu đúng.
  - Không có hai bản chạy khác nhau.
anti_patterns:
  - Copy định nghĩa workflow sang nơi khác.
  - Duplicate state giữa các thành phần.
exceptions:
  - Không có.
examples:
  - Workflow định nghĩa ở 1 nơi, mọi nơi tham chiếu id.
references:
  - P003 Metadata First
  - P006 Stateless Agent
---

# P009 — Single Source of Truth

## Statement

> Workflow chỉ tồn tại 1 định nghĩa. Không copy. Không duplicate.

## Rules

- Mỗi dữ liệu một nguồn.
- Không copy, không duplicate.
- State nằm ở Runtime.

## Implications

- Sửa nguồn → mọi nơi tham chiếu đúng.
- Không có hai bản chạy khác nhau.

## Anti Pattern

❌ Copy định nghĩa / duplicate state.
