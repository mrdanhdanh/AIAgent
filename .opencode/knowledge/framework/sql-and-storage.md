---
name: sql-and-storage
description: >
  SQL và storage basics cho AIOS dev — truy vấn, storage options, data flow.
  Áp dụng khi phân tích database hoặc viết code liên quan dữ liệu.
tags: [sql, database, storage, data, query]
---

# SQL & Storage

## SQL Basics

- **SELECT**: đọc dữ liệu — chọn cột + WHERE + ORDER BY.
- **INSERT**: thêm dòng mới.
- **UPDATE**: sửa dòng hiện có — luôn có WHERE.
- **DELETE**: xóa dòng — luôn có WHERE (tránh xóa hết).
- **JOIN**: kết hợp bảng theo khóa.

## Storage Options

| Loại | Dùng khi | Ví dụ |
|------|----------|------|
| Relational DB | dữ liệu có quan hệ | SQL Server, SQLite, PostgreSQL |
| Document DB | dữ liệu dạng document | MongoDB |
| Key-Value | cache/session | Redis |
| File/Blob | file lớn | Azure Blob, file system |

## Data Flow trong AIOS

```text
Context (transient) -> Agent -> Artifact (immutable)
```

- **Context**: dữ liệu thực thi tạm — không persist (P009).
- **Artifact**: output immutable — có checksum (P010).
- **Memory/Knowledge**: tri thức dài hạn — chuẩn hóa.

## Entity & Model

- **Entity**: đối tượng có identity — id riêng.
- **Value object**: đối tượng không identity — so sánh theo giá trị.
- **Model**: biểu diễn dữ liệu cho use-case cụ thể (ViewModel, DTO).

## Checklist

- [ ] Biết storage nào cho dữ liệu nào
- [ ] Query có index hỗ trợ
- [ ] Không lộ SQL trong UI
- [ ] Data model là nguồn schema
