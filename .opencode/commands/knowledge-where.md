---
description: Tìm toàn bộ nơi sử dụng một symbol/pattern — class, method, property, LocalStorage key
agent: knowledge-agent
---

## HELP — Hướng dẫn sử dụng `/knowledge-where`

**Mục đích:** Tìm toàn bộ nơi dùng một symbol (class, method, property, interface) trong codebase.

**Cách dùng:** `/knowledge-where <symbol>`

**Ví dụ:** `/knowledge-where JapaneseWord`, `/knowledge-where CustomerId`, `/knowledge-where IWordService`

## NỘI DUNG

Bạn là **Knowledge Agent**. Tìm toàn bộ nơi sử dụng symbol sau:

$ARGUMENTS

## QUY TRÌNH

1. **Extract symbol** — tên symbol từ câu hỏi (thường là PascalCase identifier)
2. **Tìm kiếm** (skill `search-engine`):
   - Grep symbol trong `JapaneseLearner/**` (include `*.cs, *.razor`)
   - Nếu có index, cross-check `symbol-index.json` (mode index)
   - Lọc bin/obj/.git
3. **Nhóm kết quả** — theo loại file: Models, Services, Pages, Tests, E2ETests, Config
4. **Tổng hợp** (skill `answer-builder`): bảng file:line

## QUY TẮC

- Trả đủ `file` + `line` + `snippet`
- Nhóm theo loại file để dễ đọc
- 0 kết quả → gợi ý pattern gần giống

## Output Contract

```yaml
status: "READY | NO_RESULT"
intent: "where"
entity: "Symbol được tìm"
total_matches: 12
grouped_by_type:
  classes: 3
  services: 2
  pages: 4
  tests: 3
matches:
  - { file: "path/to/file.cs", line: 42, snippet: "..." }
sources: ["path/to/file.cs:42"]
```
