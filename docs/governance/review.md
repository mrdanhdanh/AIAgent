---
name: gov-review
description: Cổng Review — đánh giá trước khi hợp nhất.
agent: general
---

# Review

## Mục đích

Không thay đổi nào vào code/docs nếu chưa qua đánh giá.

## Checklist Review

- [ ] Tuân thủ Glossary (thuật ngữ một nghĩa).
- [ ] Không mâu thuẫn SPEC-000 + Rules.
- [ ] Không chứa secret.
- [ ] Validator tương ứng PASS.
- [ ] Naming đúng (G-002).
- [ ] Contract/version đúng (P002, P004).
- [ ] Có test nếu là code.

## Mức Review

| Mức | Áp dụng cho | Ai review |
|-----|-------------|-----------|
| L1 | docs nội bộ, format | AI review |
| L2 | SPEC, rule, glossary | Reviewer + chủ spec |
| L3 | thay đổi core/breaking | Reviewer + Approver |

## Quy tắc

- Review trước, merge sau.
- Lỗi CRITICAL → BLOCKED (không merge).
- WARNING → cho qua nhưng phải ghi TODO.
