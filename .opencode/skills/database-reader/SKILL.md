---
name: database-reader
description: Đọc và phân tích database — Table, View, Package, Procedure, Trigger, Index, FK. Trả lời bảng dùng ở đâu, procedure gọi bởi ai, field nullable. Dùng trong /where, /impact, /trace.
schema_version: "1.0"
---

# Database Reader — Đọc Database

Skill chuyên phân tích database schema và usage — hỗ trợ Oracle/PL-SQL và cả lưu trữ client-side (LocalStorage).

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [ĐỐI TƯỢNG HỖ TRỢ](#đối-tượng-hỗ-trợ)
- [PHÂN TÍCH USAGE](#phân-tích-usage)
- [ADAPT CHO DỰ ÁN HIỆN TẠI](#adapt-cho-dự-án-hiện-tại)
- [OUTPUT CONTRACT](#output-contract)
- [QUY TẮC BẮT BUỘC](#quy-tắc-bắt-buộc)

---

## TỔNG QUAN

Phân tích các đối tượng database — trả lời "bảng này dùng ở đâu", "procedure gọi bởi ai", "field này nullable không".

### Command liên quan

| Command | Mô tả |
|---------|-------|
| `/where <db-object>` | Tìm nơi dùng table/procedure |
| `/impact <db-object>` | Ảnh hưởng khi sửa SP |
| `/trace <flow>` | Truy vết xuống tầng DB |

---

## ĐỐI TƯỢNG HỖ TRỢ

| Đối tượng | Mô tả | Câu hỏi trả lời |
|-----------|-------|-----------------|
| **Table** | Bảng dữ liệu | Bảng dùng ở đâu? Khóa chính? |
| **View** | View tổng hợp | View này phụ thuộc bảng nào? |
| **Package** | Oracle package | Package gọi bởi ai? |
| **Procedure** | Stored procedure | SP gọi ở đâu? Sửa ảnh hưởng gì? |
| **Trigger** | Trigger tự động | Trigger chạy khi nào? |
| **Index** | Chỉ mục | Index trên cột nào? |
| **FK** | Khóa ngoại | Bảng con nào tham chiếu? |

---

## PHÂN TÍCH USAGE

```sql
-- Ví dụ Oracle: tìm nơi gọi SP
SELECT * FROM user_source WHERE UPPER(text) LIKE '%SP_GET_CUSTOMER%';
```

Trong C#/Blazor:
```powershell
# Tìm nơi gọi procedure/table trong code
rg -n "SP_GET_CUSTOMER|CUSTOMER_TABLE" --glob '*.cs' --glob '*.sql' --glob '*.razor'
```

---

## ADAPT CHO DỰ ÁN HIỆN TẠI

JapaneseLearner **không dùng database server** — dùng **Blazored.LocalStorage** (client-side). Skill này adapt:

| Câu hỏi Oracle | Câu hỏi tương đương LocalStorage |
|----------------|----------------------------------|
| Bảng này dùng ở đâu? | StorageKey này dùng ở service nào? |
| Procedure gọi bởi ai? | Service method gọi bởi page nào? |
| Field nullable? | Model property có nullable không? |
| FK? | Model relation (word↔type)? |

**Storage keys hiện tại:**
- `japanese_words` → WordService
- `japanese_chars` → CharService (giả định)
- `japanese_kanji` → KanjiService (giả định)
- `japanese_grammar` → GrammarService (giả định)
- `theme` → ThemeService

> Kiểm tra chính xác trong code bằng grep `StorageKey`.

---

## OUTPUT CONTRACT

```yaml
status: "READY | NOT_FOUND"
summary: "Tóm tắt phân tích database"
target: "Đối tượng database / storage key"
object_type: "TABLE | VIEW | PACKAGE | PROCEDURE | TRIGGER | INDEX | FK | STORAGE_KEY"
storage_engine: "ORACLE | SQL_SERVER | LOCALSTORAGE | NONE"
structure:
  columns: []  # [{name, type, nullable, pk, fk}]
  relationships: []  # [{from, to, type}]
usage:
  - file: "path/to/file"
    line: 42
    context: "Mô tả cách dùng"
  - called_by: "Danh sách caller"
impact_if_modified: []
issues: []
next_action: "Hành động tiếp theo"
```

---

## QUY TẮC BẮT BUỘC

1. **Đúng engine**: Xác định storage engine thực tế trước khi phân tích.
2. **Nếu không có DB**: Báo rõ project dùng LocalStorage + liệt kê storage keys.
3. **Evidence file:line** cho mỗi usage.
4. Không bịa cấu trúc bảng không tồn tại.
