---
name: search-engine
description: Semantic search trong codebase — tìm đoạn xử lý, nơi dùng symbol, export/import. Kết hợp Knowledge Index + grep. Dùng trong /where, /ask.
schema_version: "1.0"
---

# Search Engine — Tìm Kiếm Codebase

Skill chuyên tìm kiếm thông minh trong codebase — nhanh nhờ index, chính xác nhờ grep trực tiếp.

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [CHIẾN LƯỢC TÌM](#chiến-lược-tìm)
- [CÁC LOẠI TÌM](#các-loại-tìm)
- [QUY TRÌNH](#quy-trình)
- [OUTPUT CONTRACT](#output-contract)
- [QUY TẮC BẮT BUỘC](#quy-tắc-bắt-buộc)

---

## TỔNG QUAN

Tìm kiếm nhanh và chính xác trong codebase — dùng Knowledge Index để định vị, grep để xác nhận.

### Command liên quan

| Command | Mô tả |
|---------|-------|
| `/where <symbol>` | Tìm mọi nơi sử dụng symbol |
| `/ask <câu hỏi>` | Hỏi đáp tự do (search-engine là 1 bước) |

---

## CHIẾN LƯỢC TÌM

**2 lớp:**
1. **Index layer** (nhanh, rẻ): truy vấn `symbol-index.json`, `code-index.json` để biết file nào chứa symbol.
2. **Grep layer** (chính xác): xác nhận và lấy line chính xác.

```powershell
# Tìm symbol
rg -n "SymbolName" JapaneseLearner --glob '!**/bin/**' --glob '!**/obj/**'

# Tìm theo pattern
rg -n "GetAllAsync" JapaneseLearner --glob '*.cs' --glob '*.razor'
```

---

## CÁC LOẠI TÌM

| Loại | Cách tìm | Ví dụ |
|------|----------|-------|
| **Symbol** | Index + grep chính xác | `JapaneseWord`, `CustomerId` |
| **Semantic** | Từ khóa tự nhiên → suy ra symbol/pattern | "đoạn xử lý upload" → `Upload`/`HttpClient` |
| **Pattern** | Regex pattern | "export excel" → `Export`, `Excel`, `Csv` |
| **DB Object** | Tên table/SP | "nơi dùng Package" → `PKG_` |

---

## QUY TRÌNH

### Bước 1: Phân tích intent tìm
Chuyển câu hỏi tự nhiên thành từ khóa/symbol cụ thể.

### Bước 2: Truy vấn index
Đọc `symbol-index.json` / `code-index.json` để có danh sách file ứng viên.

### Bước 3: Grep xác nhận
Chạy grep trên các file ứng viên, lấy `file:line` chính xác.

### Bước 4: Tổng hợp
Nhóm kết quả theo loại (class, page, service, test...).

---

## OUTPUT CONTRACT

```yaml
status: "READY | NOT_FOUND"
summary: "Tóm tắt kết quả tìm"
query: "Câu hỏi/từ khóa gốc"
keywords: ["Từ khóa đã dùng"]
results:
  - file: "path/to/file"
    line: 42
    match: "Nội dung dòng khớp"
    category: "PAGE | SERVICE | MODEL | TEST | CONFIG"
counts:
  by_category:
    PAGE: 3
    SERVICE: 2
    MODEL: 1
index_used: true | false
issues: []
next_action: "Hành động tiếp theo"
```

---

## QUY TẮC BẮT BUỘC

1. **Chính xác**: Kết quả grep phải là file:line thật — không bịa.
2. **Index ≠ nguồn chân lý**: Luôn grep xác nhận sau khi dùng index.
3. **Không giới hạn sai**: Nếu kết quả lớn → nhóm theo category, không cắt ngang.
4. Nếu không tìm thấy → `NOT_FOUND` kèm từ khóa thay thế gợi ý.
