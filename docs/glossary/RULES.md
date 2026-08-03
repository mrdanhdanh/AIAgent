---
name: glossary-rules
description: >
  Glossary Rules — luật sử dụng và thay đổi thuật ngữ AIOS.
  Bắt buộc cho mọi SPEC/ADR/RFC/Code.
agent: general
---

# Glossary Rules

Quy tắc bắt buộc khi sử dụng thuật ngữ AIOS.

## Rule 1 — Một thuật ngữ chỉ có một định nghĩa

Mỗi thuật ngữ trong Glossary có đúng **một** nghĩa. Không có nghĩa thứ hai theo ngữ cảnh.

## Rule 2 — Không dùng từ đồng nghĩa

Trong SPEC/ADR/RFC/Code, **không dùng từ khác** cho cùng khái niệm.

Ví dụ: nếu đã dùng `Task` thì **không** dùng `Job`, `Mission`, `Action` để chỉ cùng một thứ.

## Rule 3 — Mọi SPEC phải tham chiếu Glossary

Mọi SPEC **bắt buộc** tham chiếu Glossary, không tự định nghĩa lại thuật ngữ. Nếu cần khái niệm mới → thêm vào Glossary trước, rồi mới dùng trong SPEC.

## Rule 4 — Thay đổi định nghĩa phải qua ADR + RFC

Muốn thay đổi/loại bỏ định nghĩa → **không sửa trực tiếp**. Phải:

1. Viết **RFC** (đề xuất thay đổi, nêu ảnh hưởng).
2. Qua **Review + Approve**.
3. Ghi **ADR** (quyết định + lý do).
4. Mới cập nhật Glossary.
