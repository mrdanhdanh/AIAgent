---
name: search-engine
description: Tìm kiếm trong codebase — semantic search + grep. Mode 1: truy vấn Knowledge Index JSON. Mode 2: grep trực tiếp (luôn đúng). Trả matches kèm file, line, snippet. Sử dụng trong /knowledge-where.
schema_version: "1.0"
---

# Search Engine — Skill

## TỔNG QUAN

Skill tìm kiếm symbol/pattern trong codebase. Hai mode:
- **Mode 1 (Index)**: Truy vấn `.opencode/knowledge/knowledge-assistant/index/*.json` — nhanh, phù hợp câu hỏi lặp lại
- **Mode 2 (Grep)**: grep trực tiếp source — luôn đúng với code hiện tại, chậm hơn

**Mặc định dùng Mode 2 cho độ chính xác. Mode 1 là cache tăng tốc.**

## NGUỒN INDEX (nếu có)

| File | Nội dung |
|------|----------|
| `code-index.json` | file → symbols → lines |
| `symbol-index.json` | symbol → file:line |
| `route-index.json` | @page → component |
| `service-index.json` | interface → impl → methods |
| `data-model-index.json` | entity → properties |
| `dependency-graph.json` | Page → Service → Model |
| `document-index.json` | docs → sections → keywords |

## QUY TRÌNH

### Mode 2 (Grep — mặc định)

1. Xác định pattern tìm (symbol, tên class, tên method)
2. Grep toàn bộ `JapaneseLearner/**` (include: `*.cs, *.razor, *.csproj`)
3. Lọc bỏ bin/obj (ripgrep mặc định tôn trọng .gitignore)
4. Gom kết quả theo file + line

### Mode 1 (Index)

1. Kiểm tra index tồn tại (`Test-Path` hoặc glob)
2. Đọc JSON phù hợp, tìm key symbol
3. Cross-check với grep nếu nghi ngờ index cũ

## ĐỊNH DẠNG ĐẦU RA

```yaml
mode: "grep | index"
query: "JapaneseWord"
total_matches: 12
matches:
  - file: "Models/JapaneseWord.cs"
    line: 3
    snippet: "public class JapaneseWord"
  - file: "Services/WordService.cs"
    line: 10
    snippet: "List<JapaneseWord> _cache"
grouped_by_type:
  classes: 3
  sql: 0
  api: 2
  pages: 4
index_status: "not_built | up_to_date | stale"
```

## QUY TẮC

- Luôn trả `file` + `line` + `snippet` đầy đủ
- Nếu 0 kết quả → đề xuất pattern gần giống (contains match)
- Ghi rõ mode đã dùng (grep/index) để user biết độ tin cậy

## XỬ LÝ NGOẠI LỆ

- Index chưa build → tự fallback grep + gợi ý `/knowledge-index`
- Nhiều file trùng tên → trả full path + namespace
- Pattern đặc biệt (regex phức tạp) → ghi rõ cần xác nhận thủ công
