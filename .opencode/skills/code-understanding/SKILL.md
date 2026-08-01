---
name: code-understanding
description: Hiểu source code — đọc C#, Razor, VB, SQL, PL/SQL, JS, TS, CSS. Trả lời Class, Method, Call Graph, Dependency, Lifecycle, DI, Interface, Inheritance. Dùng trong /explain, /trace, /where.
schema_version: "1.0"
---

# Code Understanding — Hiểu Source Code

Skill chuyên phân tích và giải thích source code. Nền tảng cho mọi câu trả lời về code.

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [NGÔN NGỮ HỖ TRỢ](#ngôn-ngữ-hỗ-trợ)
- [CÁC LOẠI PHÂN TÍCH](#các-loại-phân-tích)
- [QUY TRÌNH](#quy-trình)
- [OUTPUT CONTRACT](#output-contract)
- [QUY TẮC BẮT BUỘC](#quy-tắc-bắt-buộc)

---

## TỔNG QUAN

Đọc và hiểu source code để trả lời câu hỏi về cấu trúc, hành vi và mối quan hệ giữa các thành phần. Mọi câu trả lời phải có **evidence** (file:line).

### Command liên quan

| Command | Mô tả |
|---------|-------|
| `/explain <file>` | Giải thích từng method trong file |
| `/where <symbol>` | Tìm mọi nơi sử dụng symbol |
| `/trace <flow>` | Truy vết UI→API→Service→DB→Response |

### Kiến thức liên quan

- `.opencode/knowledge-index/` — symbol/code index để định vị nhanh
- `JapaneseLearner/Services/` — service layer (cache-first + LocalStorage)
- `JapaneseLearner/Pages/` — Blazor UI pages

---

## NGÔN NGỮ HỖ TRỢ

- **C#** — class, interface, method, DI, async/await
- **Razor** — component, @page, @inject, lifecycle
- **VB / VB.NET** — legacy Windows forms
- **SQL / PL/SQL** — stored procedure, package, trigger
- **JS / TS** — Angular/React components, services
- **CSS** — styling, design tokens

---

## CÁC LOẠI PHÂN TÍCH

| Loại | Trả lời | Ví dụ |
|------|---------|-------|
| **Class** | Mục đích, trách nhiệm, dependency, constructor | "WordService quản lý từ vựng, cache-first" |
| **Method** | Input, output, logic chính, side-effect | "GetByTypeAsync lọc theo Type, trả danh sách" |
| **Call Graph** | Ai gọi method này, method này gọi ai | "AddAsync được Admin.razor gọi khi thêm từ" |
| **Dependency** | Dependency injection, usings, references | "WordService inject ILocalStorageService" |
| **Lifecycle** | Khởi tạo, OnInitialized, OnParametersSet | "Home.razor load data trong OnInitializedAsync" |
| **DI** | Service đăng ký ở đâu (Program.cs), scope | "AddScoped<IWordService, WordService>()" |
| **Interface** | Interface contract, implementation | "IWordService định nghĩa 5 methods" |
| **Inheritance** | Base class, derived, override | "KanjiDetail extends ComponentBase" |

---

## QUY TRÌNH

### Bước 1: Định vị file
Dùng Knowledge Index (`symbol-index.json`) hoặc grep để tìm file chứa symbol.

### Bước 2: Đọc file
Đọc file gốc — không trả lời từ index nếu cần chi tiết method body.

### Bước 3: Phân tích
- Xác định class/method/interface/dependency
- Xác định DI registration trong Program.cs
- Xác định caller/reference bằng grep

### Bước 4: Trả lời kèm evidence
Mỗi luận điểm kèm `file:line` cụ thể.

---

## OUTPUT CONTRACT

```yaml
status: "READY | NOT_FOUND"
summary: "Tóm tắt phân tích"
target: "Tên class/method/file được phân tích"
analysis:
  type: "CLASS | METHOD | CALL_GRAPH | DEPENDENCY | LIFECYCLE | DI | INTERFACE | INHERITANCE"
  details: "Phân tích chi tiết"
  structure:
    - name: "Tên thành phần"
      kind: "class | method | interface | field"
      location: "file:line"
      description: "Mô tả"
      dependencies: ["Danh sách dependency"]
      callers: ["Ai gọi — kèm file:line"]
      callees: ["Method này gọi — kèm file:line"]
evidence:
  - file: "path/to/file.cs"
    line: 42
    snippet: "Trích đoạn code liên quan"
issues:
  - severity: "INFO | WARNING"
    description: "..."
next_action: "Hành động tiếp theo"
```

---

## QUY TẮC BẮT BUỘC

1. **Evidence-first**: Mọi khẳng định kèm file:line. Không đoán.
2. **Đọc file gốc**: Index chỉ để định vị nhanh — luôn đọc file trước khi kết luận.
3. **DI tracking**: Khi gặp interface, tìm implementation + registration trong Program.cs.
4. **Không sửa file**: Read-only.
5. Nếu không tìm thấy → `status: NOT_FOUND`, gợi ý từ khóa tương tự.
