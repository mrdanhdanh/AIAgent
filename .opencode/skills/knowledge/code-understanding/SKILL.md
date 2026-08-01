---
name: code-understanding
description: Hiểu source code C#/Razor — đọc class, method, call graph, dependency, lifecycle, DI, interface, inheritance. Trả về class summary, method list, DI graph. Sử dụng trong /knowledge-ask, /knowledge-explain.
schema_version: "1.0"
---

# Code Understanding — Skill

## TỔNG QUAN

Skill đọc và phân tích source code C#/Razor của dự án JapaneseLearner (Blazor WASM). Trả lời: Class này dùng để làm gì? Method này có chức năng gì? DI graph thế nào?

## STACK MAPPING

| Yêu cầu gốc | Dự án thực tế |
|---|---|
| C# / Angular / VB | C# (Blazor WASM), .razor components |
| API / Service layer | Services/ + Interfaces (Service-Interface DI) |
| Screen | .razor Pages (@page directive) |

## QUY TRÌNH

1. **Locate** — glob/grep tìm file (thường theo tên class)
2. **Read** — đọc toàn bộ file, chú ý: class declaration, fields, constructor (DI), methods, base class, interfaces
3. **Analyze**:
   - `@inject` trong .razor → DI dependencies
   - Constructor injection trong .cs → DI dependencies
   - `: InterfaceName` → implements
   - `: BaseClass` → inheritance
   - `OnInitializedAsync` / `OnAfterRenderAsync` → lifecycle Blazor
4. **Summarize** — mỗi method: tên, mục đích (1 dòng), input/output

## ĐỊNH DẠNG ĐẦU RA

```yaml
class_summary: "Mô tả ngắn class"
type: "class | interface | component"
file: "path/to/file.cs"
methods:
  - name: "GetAllAsync"
    purpose: "Lấy toàn bộ từ vựng, có progress"
    signature: "Task<List<JapaneseWord>> GetAllAsync(IProgress<int>? progress)"
    lines: "12-30"
di_dependencies:
  - interface: "ILocalStorageService"
    implementation: "Blazored.LocalStorage"
    injected_in: "constructor"
lifecycle_notes: "OnInitializedAsync load data tri-state"
inheritance: "không có"
interfaces: ["IWordService"]
```

## QUY TẮC

- Mọi phát biểu phải có `file` + `line` (hoặc lines)
- Không suy đoán — chỉ mô tả những gì đọc được
- Method mô tả ngắn gọn, chính xác

## XỬ LÝ NGOẠI LỆ

- File không tìm thấy → trả `class_summary: "Không tìm thấy"` + gợi ý glob pattern
- Class quá lớn (>500 dòng) → ưu tiên public methods, ghi chú "có private helpers bị bỏ qua"
