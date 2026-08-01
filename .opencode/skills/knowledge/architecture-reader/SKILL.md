---
name: architecture-reader
description: Hiểu kiến trúc dự án — layer (Pages/UI, Services/Application, Models/Domain), phát hiện vi phạm architecture, mô tả module thuộc layer nào. Sử dụng trong /knowledge-ask (kiến trúc).
schema_version: "1.0"
---

# Architecture Reader — Skill

## TỔNG QUAN

Skill phân tích kiến trúc tổng thể JapaneseLearner (Blazor WASM 3-layer), xác định module thuộc layer nào, phát hiện vi phạm phân lớp.

## KIẾN TRÚC DỰ ÁN

```
┌─────────────────────────────────┐
│ Presentation Layer (Pages/)     │  13 .razor pages + Layout/
│  - UI, @inject services, nav    │
├─────────────────────────────────┤
│ Application Layer (Services/)   │  5 service-interface pairs
│  - Business logic, cache, DI    │  Cache-first + LocalStorage
├─────────────────────────────────┤
│ Domain Layer (Models/)          │  4 entities
│  - Plain C# POCO classes        │
└─────────────────────────────────┘
         Entry: Program.cs (DI registry)
```

## KIỂM TRA VI PHẠM (rules)

| Rule | Vi phạm nếu |
|------|-------------|
| Pages không chứa business logic | Page có vòng lặp tính toán nghiệp vụ phức tạp (>5 dòng xử lý) |
| Pages không gọi Models trực tiếp (ngoài render) | Page new Model không qua Service |
| Services không phụ thuộc Page/UI | Service có tham chiếu Blazor component |
| Models là POCO thuần | Model có logic nghiệp vụ hoặc phụ thuộc Service |
| DI qua interface | Class gọi service concrete không qua interface |

## QUY TRÌNH

1. **Map structure** — glob Pages/, Services/, Models/, đọc Program.cs
2. **Phân loại** — mỗi module → layer
3. **Scan violations** — grep pattern vi phạm (@inject trong .cs, new Model trong Page, etc.)
4. **Output** layer map + violations

## ĐỊNH DẠNG ĐẦU RA

```yaml
architecture: "3-layer (Presentation / Application / Domain)"
layer_map:
  - { module: "WordStudy.razor", layer: "presentation", path: "Pages/WordStudy.razor" }
  - { module: "WordService", layer: "application", path: "Services/WordService.cs" }
  - { module: "JapaneseWord", layer: "domain", path: "Models/JapaneseWord.cs" }
violations:
  - { severity: "LOW", description: "...", file: "Pages/X.razor", line: 20 }
architecture_notes: "Cache-first pattern: Services giữ in-memory + persist LocalStorage"
```

## QUY TẮC

- Chỉ báo violation khi có evidence code thật
- Mô tả architecture dựa trên thực tế, không theo tài liệu lý thuyết
- Ghi rõ nếu dự án có deviation so với 3-layer chuẩn

## XỬ LÝ NGOẠI LỆ

- Dự án nhỏ không có layer rõ → ghi "kiến trúc phẳng" thay vì ép phân layer
- Component mới (Admin) có logic phức tạp → ghi chú nơi logic nằm
