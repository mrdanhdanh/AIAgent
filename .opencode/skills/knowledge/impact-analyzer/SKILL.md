---
name: impact-analyzer
description: Phân tích ảnh hưởng dây chuyền khi sửa một symbol/file — liệt kê affected screens, services, models, tests kèm mức độ. Quan trọng nhất trong Knowledge Assistant. Sử dụng trong /knowledge-impact.
schema_version: "1.0"
---

# Impact Analyzer — Skill

## TỔNG QUAN

Skill quan trọng nhất: phân tích "Nếu sửa X thì ảnh hưởng những gì?" — dựa trên dependency graph, liệt kê affected files + mức độ ảnh hưởng.

## VÍ DỤ (JapaneseLearner)

```
Sửa WordService
    ↓
  ảnh hưởng
    ├── 2 Pages: WordStudy.razor, WordQuiz.razor (gọi qua IWordService)
    ├── 1 Interface: IWordService (nếu đổi signature)
    ├── 1 Model: JapaneseWord (nếu đổi property)
    ├── 2 Tests: WordServiceTests, WordStudyTests, WordQuizTests
    └── 1 Admin tab: Admin.razor (CRUD words)
```

## QUY TRÌNH

1. **Xác định target** — symbol/file user muốn sửa
2. **Tìm dependents** (ai phụ thuộc target):
   - grep `@inject <IInterface>` trong Pages/
   - grep `<Interface/Class>` trong Services/
   - grep `<Entity>` trong Models/Services/Pages
   - grep trong Tests/ + E2ETests/
3. **Phân loại mức độ**:
   - **HIGH**: breaking change signature → mọi caller fail compile
   - **MEDIUM**: thay đổi behavior → caller hoạt động khác
   - **LOW**: thay đổi nội bộ → caller không đổi
4. **Nhóm theo type**: screens / services / models / tests / config
5. **Output** affected[] đầy đủ

## ĐỊNH DẠNG ĐẦU RA

```yaml
target: "WordService"
impact_summary: "Sửa WordService ảnh hưởng 5 files (2 pages, 1 interface, 2 tests)"
affected:
  - { type: "screen", file: "Pages/WordStudy.razor", impact_level: "HIGH", reason: "gọi GetAllAsync qua @inject" }
  - { type: "screen", file: "Pages/WordQuiz.razor", impact_level: "MEDIUM", reason: "gọi GetByTypeAsync" }
  - { type: "service", file: "Services/IWordService.cs", impact_level: "HIGH", reason: "nếu đổi signature" }
  - { type: "test", file: "JapaneseLearner.Tests/WordServiceTests.cs", impact_level: "MEDIUM", reason: "test service" }
  - { type: "config", file: "Program.cs", impact_level: "LOW", reason: "DI registration nếu đổi class" }
dependency_path: "WordService → IWordService → WordStudy.razor/WordQuiz.razor"
recommendation: "Ước tính: 2 screens + 2 tests cần cập nhật nếu sửa signature GetAllAsync"
```

## QUY TẮC

- Mọi affected file phải có `reason` (dựa trên evidence)
- Phân biệt rõ HIGH/MEDIUM/LOW với lý do cụ thể
- Tự động gợi ý recommendation về số file cần sửa

## XỬ LÝ NGOẠI LỆ

- Target không tồn tại → "Không tìm thấy symbol" + gợi ý
- Dependency quá rộng (ảnh hưởng nhiều module) → nhóm ưu tiên, ghi chú
- File trong Tests/E2ETests → đánh dấu riêng để biết cần cập nhật test
