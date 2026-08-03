---
id: P016
name: Human Approval
status: Draft
category: Governance
severity: critical
breaking_change: true
enforced_by:
  - policy
  - runtime
implemented_in:
  - SPEC-015
related:
  - P013
  - P020
statement: >
  AI không được Merge, Release, Delete nếu chưa qua Policy.
rationale: >
  Hành động không thể đảo ngược hoặc ảnh hưởng rộng phải có người duyệt.
  Policy định nghĩa mức nào cần human approval.
rules:
  - Merge/Release/Delete phải qua Policy.
  - Mức rủi ro cao → human approval.
  - Không bypass approval.
implications:
  - AI tự quyết việc nội bộ; việc rủi ro cần người duyệt.
  - Mọi approval ghi lại để audit (P014).
anti_patterns:
  - AI tự merge/release/delete.
  - Bypass approval gate.
exceptions:
  - Theo mức rủi ro định nghĩa trong Policy.
examples:
  - Release v2.0 → cần human approval.
references:
  - P013 Simulation Before Execution
  - P020 Constitution First
---

# P016 — Human Approval

## Statement

> AI không được Merge, Release, Delete nếu chưa qua Policy.

## Rules

- Merge → Policy.
- Release → Policy.
- Delete → Policy.
- Rủi ro cao → human approval.

## Implications

- Việc nội bộ AI tự quyết.
- Việc rủi ro cần người duyệt.
- Mọi approval ghi lại để audit.

## Anti Pattern

❌ AI tự merge/release/delete.
