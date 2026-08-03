---
name: glossary
description: >
  AIOS Glossary (D002) — Domain Model của AIOS. Mỗi thuật ngữ MỘT nghĩa duy nhất.
  Đây không phải từ điển — là mô hình miền: taxonomy + relationships + invariants.
  Danh mục đầy đủ xem CATALOG.md. Quy tắc xem RULES.md.
agent: general
---

# AIOS Glossary

> **D002** — tài liệu quan trọng nhất sau Manifest.
> Glossary là **Domain Model** của AIOS: không chỉ định nghĩa từ, mà mô hình hóa
> thực thể, quan hệ, cardinality, invariants — để Runtime/Doctor/Dashboard dùng được.

## Nội dung

| File | Vai trò |
|------|---------|
| `CATALOG.md` | Danh mục thuật ngữ (16 term, taxonomy, invariants) |
| `RULES.md` | Quy tắc sử dụng & thay đổi thuật ngữ |
| `taxonomy.yaml` | Phân loại thuật ngữ (Core/Execution/Data/...) |
| `relationships.yaml` | Quan hệ + cardinality + ownership matrix |
| `glossary.schema.json` | Schema validate term template |
| `terms/` | Từng thuật ngữ (16 files) |
| `CHANGELOG.md` | Theo dõi thay đổi |

## Nguyên tắc

- Mỗi thuật ngữ **một nghĩa duy nhất**.
- Mọi SPEC/ADR/RFC phải dùng đúng thuật ngữ này.
- Muốn đổi định nghĩa → **ADR + RFC**, không sửa trực tiếp (xem RULES.md).
