---
name: gov-approval
description: Chuỗi phê duyệt theo mức độ rủi ro.
agent: general
---

# Approval

## Mục đích

Mỗi thay đổi có mức rủi ro tương ứng chuỗi phê duyệt.

## Mức Approval

| Mức | Rủi ro | Ai approve | Ví dụ |
|-----|--------|-----------|-------|
| A1 | Thấp | AI tự quyết | format docs, sửa lỗi nhỏ |
| A2 | Trung bình | Reviewer | thêm SPEC chi tiết, rule mới |
| A3 | Cao | Approver (người) | breaking change, thay đổi core |
| A4 | Tối đa | Human only | đổi principle bất biến, đổi license |

## Nguyên tắc

- **Principle bất biến (P001–P015) không thể đổi ở mức A1/A2** — phải RFC + ADR + A3/A4.
- Không bypass approval.
- Mọi approval ghi lại (ai, khi nào, quyết định gì) để audit (P008).

## Flow

```text
Thay đổi → xác định mức rủi ro → review → approval tương ứng → merge
```
