---
name: architecture-reader
description: Hiểu kiến trúc hệ thống — Layer, DDD, Clean, CQRS, MVC, MVVM. Xác định module nằm layer nào, phát hiện vi phạm architecture. Dùng trong /ask, /explain.
schema_version: "1.0"
---

# Architecture Reader — Đọc Kiến Trúc

Skill chuyên phân tích kiến trúc tổng thể — xác định layer, pattern, và vi phạm.

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [PATTERN HỖ TRỢ](#pattern-hỗ-trợ)
- [PHÂN TÍCH LAYER](#phân-tích-layer)
- [PHÁT HIỆN VI PHẠM](#phát-hiện-vi-phạm)
- [OUTPUT CONTRACT](#output-contract)
- [QUY TẮC BẮT BUỘC](#quy-tắc-bắt-buộc)

---

## TỔNG QUAN

Xác định vị trí kiến trúc của từng module và phát hiện các vi phạm pattern/layer.

### Command liên quan

| Command | Mô tả |
|---------|-------|
| `/ask <câu hỏi>` | "Module này nằm layer nào?" |
| `/explain <file>` | Giải thích kèm bối cảnh kiến trúc |

---

## PATTERN HỖ TRỢ

| Pattern | Đặc trưng | Dự án JapaneseLearner |
|---------|-----------|----------------------|
| **Layer** | Presentation / Business / Data | Pages (UI) → Services (Business) → Models + LocalStorage (Data) |
| **MVC** | Model-View-Controller | Blazor Razor tương tự MVVM |
| **MVVM** | View-ViewModel-Model | Razor component = View + code-behind logic |
| **DDD** | Domain-driven | Không áp dụng (app đơn giản) |
| **Clean** | Dependency rule hướng vào trong | Một phần: Services inject abstractions |
| **CQRS** | Command/Query separation | Không áp dụng |

---

## PHÂN TÍCH LAYER

```yaml
layers:
  presentation:
    - JapaneseLearner/Pages/  # 13 pages Razor
    - JapaneseLearner/Layout/
  application:
    - JapaneseLearner/Services/  # I*Service + *Service
  domain:
    - JapaneseLearner/Models/  # JapaneseWord, JapaneseChar...
  infrastructure:
    - Blazored.LocalStorage  # persistence
```

**Trả lời:** "`WordService` nằm ở **application layer** (business logic), giao tiếp Presentation (Pages) qua DI và Infrastructure (LocalStorage) qua interface `ILocalStorageService`."

---

## PHÁT HIỆN VI PHẠM

Kiểm tra các vi phạm thường gặp:

| Vi phạm | Cách phát hiện | Ví dụ |
|---------|---------------|-------|
| **Page gọi trực tiếp storage** | Page dùng ILocalStorageService trực tiếp thay vì qua Service | — |
| **Logic nghiệp vụ trong UI** | Code-behind page có business logic phức tạp | — |
| **Model layer reference UI** | Model dùng component namespace | — |
| **DI sai scope** | Registration sai vòng đời | — |
| **Magic strings lặp** | StorageKey hardcode nhiều nơi | "japanese_words" |

---

## OUTPUT CONTRACT

```yaml
status: "READY"
summary: "Tóm tắt phân tích kiến trúc"
target: "Module/file được phân tích"
architecture:
  pattern: "LAYER | MVVM | CLEAN | DDD | MVC | CQRS"
  layer: "PRESENTATION | APPLICATION | DOMAIN | INFRASTRUCTURE | UNKNOWN"
  dependencies:
    - to: "Tên thành phần phụ thuộc"
      direction: "UPWARD | DOWNWARD | SAME_LAYER"
  violations:
    - severity: "MINOR | MAJOR | CRITICAL"
      description: "Mô tả vi phạm"
      evidence: "file:line"
      suggestion: "Cách khắc phục"
recommendations: []
evidence:
  - file: "path/to/file"
    line: 42
issues: []
next_action: "Hành động tiếp theo"
```

---

## QUY TẮC BẮT BUỘC

1. **Dựa trên cấu trúc thực tế**: Đọc folder structure + usings trước khi kết luận pattern.
2. **Vi phạm cần evidence**: Mỗi vi phạm kèm file:line + suggestion.
3. **Không áp đặt pattern**: Nếu project không dùng DDD → nói rõ, không giả vờ.
