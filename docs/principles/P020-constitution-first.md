---
id: P020
name: Constitution First
status: Draft
category: Governance
severity: critical
breaking_change: true
enforced_by:
  - doctor
  - validator
implemented_in:
  - SPEC-000
related:
  - P001
  - P002
  - P016
statement: >
  Thứ tự ưu tiên: Constitution > ADR > SPEC > Contract > Implementation > Configuration.
rationale: >
  Nếu code trái SPEC → Code sai. Nếu SPEC trái Constitution → SPEC sai.
  Mọi tài liệu phải tuân theo tầng trên.
rules:
  - Mọi SPEC tham chiếu Constitution.
  - ADR giải thích quyết định dựa trên principle.
  - Code không mâu thuẫn SPEC.
implications:
  - Constitution là tầng tối cao.
  - Không diễn giải lại Constitution.
anti_patterns:
  - SPEC tự định nghĩa lại thuật ngữ.
  - Code vi phạm SPEC.
  - Mâu thuẫn tầng dưới vs tầng trên.
exceptions:
  - Không có.
examples:
  - Code trái SPEC → Code sai. SPEC trái Constitution → SPEC sai.
references:
  - P001 Runtime First
  - P002 Contract First
  - P016 Human Approval
---

# P020 — Constitution First

## Statement

> Thứ tự ưu tiên:
>
> Constitution → ADR → SPEC → Contract → Implementation → Configuration

## Rules

- Nếu code trái SPEC → Code sai.
- Nếu SPEC trái Constitution → SPEC sai.
- Nếu ADR trái Constitution → ADR sai.

## Implications

- Constitution là tầng tối cao.
- Không diễn giải lại.

## Anti Pattern

❌ SPEC tự định nghĩa lại thuật ngữ / Code mâu thuẫn SPEC.
