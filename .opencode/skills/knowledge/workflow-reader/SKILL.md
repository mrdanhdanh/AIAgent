---
name: workflow-reader
description: Đọc và mô tả luồng hoạt động — user flow, business flow, API flow từ code + docs. Sinh mermaid sequence diagram. Sử dụng trong /knowledge-flow.
schema_version: "1.0"
---

# Workflow Reader — Skill

## TỔNG QUAN

Skill mô tả luồng hoạt động (workflow) của một chức năng trong JapaneseLearner: từ khi user tương tác UI → service xử lý → lưu/đọc dữ liệu → render kết quả.

## CÁC LOẠI FLOW

| Loại | Mô tả | Ví dụ |
|------|-------|-------|
| User Flow | Các bước user thao tác trên UI | Vào /alphabet → thấy flashcard → nhập romaji → đúng/sai |
| Business Flow | Logic nghiệp vụ | Tạo từ mới: nhập thông tin → validate → lưu LocalStorage |
| Data Flow | Dữ liệu di chuyển | Page gọi Service.GetAllAsync → cache → render |

## NGUỒN ĐỌC

- `.razor` files: logic OnInitializedAsync, button handlers, tri-state rendering
- `Services/*.cs`: business logic, caching, persistence
- `Models/*.cs`: cấu trúc dữ liệu

## QUY TRÌNH

1. **Locate entry** — tìm @page directive + component tương ứng
2. **Đọc lifecycle** — OnInitializedAsync, event handlers (@onclick, @oninput)
3. **Đọc service methods** — method nào được gọi, trả về gì
4. **Sinh flow** — liệt kê bước theo thứ tự + mermaid sequence diagram

## ĐỊNH DẠNG ĐẦU RA

```yaml
flow_name: "Học từ vựng qua flashcard"
entry_point: "/words"
user_flow:
  - step: 1
    action: "User mở /words"
    component: "WordStudy.razor"
  - step: 2
    action: "OnInitializedAsync gọi IWordService.GetAllAsync()"
    component: "WordStudy.razor"
  - step: 3
    action: "Hiển thị Loading → Empty → Data (tri-state)"
    component: "WordStudy.razor"
mermaid: |
  sequenceDiagram
    participant User
    participant Page as WordStudy.razor
    participant Service as WordService
    participant Store as LocalStorage
    User->>Page: mở /words
    Page->>Service: GetAllAsync()
    Service->>Store: đọc cache
    Service-->>Page: List&lt;JapaneseWord&gt;
    Page-->>User: render flashcards
```

## QUY TẮC

- Mỗi bước flow phải có nguồn (file + dòng code)
- Mermaid phải parse được (dùng mermaid.live để verify nếu cần)
- Ưu tiên mô tả luồng chính (happy path), ghi chú branch phụ

## XỬ LÝ NGOẠI LỆ

- Flow phức tạp (nhiều branch) → tách happy path + error path
- Page không có logic (pure render) → flow ngắn, chỉ mô tả render
