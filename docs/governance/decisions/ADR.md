---
name: decision-adr
description: >
  ADR — Architecture Decision Record. Ghi quyết định kiến trúc + lý do.
  Dùng khi: thay đổi không breaking, cần ghi lại quyết định.
agent: general
---

# ADR — Architecture Decision Record

## Mục đích

Ghi lại quyết định kiến trúc quan trọng và **lý do**, để sau này hiểu tại sao chọn A không chọn B.

## Khi nào dùng ADR

Dùng **ADR** khi thay đổi **không breaking** nhưng quan trọng về kiến trúc:

- Quyết định ảnh hưởng nhiều module.
- Chọn tech stack / library.
- Đổi rule trong `docs/rules/`.
- Thay đổi nội bộ không phá compatibility.

## Quy trình

```text
Need Change
      │
Breaking?
      │
 ┌────┴────┐
 │         │
No        Yes
 │         │
ADR      RFC
```

## Quy tắc

- ADR bất biến sau Accepted — sửa → ADR mới.
- Bắt buộc trích dẫn principle/rule liên quan.
- Mỗi ADR một file: `docs/adr/ADR-###.md`.

## Template

Xem `docs/governance/templates/ADR-template.md`.
