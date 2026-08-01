---
name: data-model-reader
description: Đọc và mô tả data model — entities trong Models/, LocalStorage keys, persistence pattern cache-first. Trả entity schema, nullable fields, nơi dữ liệu được dùng. Adapt từ database-reader (dự án không có Oracle). Sử dụng trong /knowledge-ask (data).
schema_version: "1.0"
---

# Data Model Reader — Skill

## TỔNG QUAN

Skill đọc data layer của JapaneseLearner. Dự án **không có database Oracle** — dữ liệu lưu bằng cache-first pattern: in-memory cache + Blazored.LocalStorage, seed data on first load.

## STACK MAPPING

| database-reader (gốc) | data-model-reader (thực tế) |
|------------------------|------------------------------|
| Table / View | Entity class trong Models/ |
| Package / Procedure | Service methods (GetAllAsync, AddAsync...) |
| Trigger / Index / FK | LocalStorage keys, persistence logic |
| "Bảng này dùng ở đâu" | "Entity này dùng ở đâu" (Services + Pages) |
| "Field nullable không" | "Property có default/required không" |

## CẤU TRÚC DỮ LIỆU (JapaneseLearner)

| Entity | File | Properties |
|--------|------|-----------|
| JapaneseChar | Models/JapaneseChar.cs | Id, Character, Romaji, Type (Hiragana/Katakana) |
| JapaneseWord | Models/JapaneseWord.cs | Id, Characters, Romaji, Meaning (VN), Type, Level |
| JapaneseKanji | Models/JapaneseKanji.cs | Id, Character, Onyomi, Kunyomi, Meaning... |
| JapaneseGrammar | Models/JapaneseGrammar.cs | Id, Pattern, Explanation, Examples... |

**LocalStorage keys đã biết:** `japanese-learner-dark-mode` (ThemeService.cs:9)

## QUY TRÌNH

1. **Đọc Models/** — mỗi entity: properties, default values, nullable
2. **Tìm persistence** — grep `GetItemAsync|SetItemAsync|StorageKey` trong Services/
3. **Tìm usage** — grep entity name trong Services + Pages
4. **Output** entity schema + storage keys + usage map

## ĐỊNH DẠNG ĐẦU RA

```yaml
entities:
  - name: "JapaneseWord"
    file: "Models/JapaneseWord.cs"
    properties:
      - { name: "Id", type: "int", nullable: false, note: "PK" }
      - { name: "Characters", type: "string", nullable: false, default: "\"\"" }
      - { name: "Meaning", type: "string", nullable: false, note: "Tiếng Việt" }
      - { name: "Level", type: "string", default: "N5", note: "Display-only, không dùng trong quiz" }
    used_in:
      - { file: "Services/WordService.cs", purpose: "cache + persist" }
      - { file: "Pages/WordStudy.razor", purpose: "flashcard render" }
storage_keys:
  - { key: "japanese-learner-dark-mode", type: "bool", source: "Services/ThemeService.cs:9" }
persistence_pattern: "cache-first: in-memory List<T> + Blazored.LocalStorage, write-through on mutation"
```

## QUY TẮC

- Mô tả đúng type + default + nullable từ code thật
- Ghi chú đặc biệt: Meaning là tiếng Việt; Level display-only (AGENTS.md:69)
- Không bịa quan hệ DB (dự án không có DB)

## XỬ LÝ NGOẠI LỆ

- Entity chưa có trong Models/ → "Không tồn tại" + gợi ý
- Property optional (không có default) → ghi `nullable: true`
- Storage key không tìm thấy → ghi "persist qua pattern chung, key không hardcode"
