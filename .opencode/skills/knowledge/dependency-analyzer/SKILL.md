---
name: dependency-analyzer
description: Xây dựng call graph / dependency graph — Page → Service → Model → LocalStorage. Phát hiện DI relationships, reference graph, service graph. Sử dụng trong /knowledge-trace, /knowledge-impact.
schema_version: "1.0"
---

# Dependency Analyzer — Skill

## TỔNG QUAN

Skill xây dựng đồ thị phụ thuộc (dependency graph) cho dự án JapaneseLearner. Xác định ai gọi ai: .razor Page → Service (qua @inject) → Interface → Implementation → Model → LocalStorage.

## GRAPH TYPICAL (JapaneseLearner)

```
WordStudy.razor ──@inject──> IWordService (interface)
    │                              │
    ▼                              ▼
WordQuiz.razor               WordService (impl)
                                 │
                                 ▼
                            JapaneseWord (Model)
                                 │
                                 ▼
                    Blazored.LocalStorage (persist)
```

## PATTERN NHẬN DIỆN

| Pattern | Ý nghĩa | Regex/evidence |
|---------|---------|----------------|
| `@inject IWordService WordService` | Page phụ thuộc service | grep trong .razor |
| `builder.Services.AddScoped<IWordService, WordService>()` | Đăng ký DI | Program.cs |
| `public class WordService : IWordService` | Impl implements interface | .cs |
| `using JapaneseLearner.Services` | Namespace reference | .cs/.razor |
| `_storage.GetItemAsync<T>` | LocalStorage phụ thuộc | Services/*.cs |

## QUY TRÌNH

1. **Tìm DI registrations** — grep `AddScoped|AddSingleton|AddTransient` trong Program.cs
2. **Tìm @inject** — grep `@inject` trong Pages/*.razor
3. **Tìm constructor injection** — grep `public \w+Service\(` trong Services/*.cs
4. **Build graph** — map Page → Service → Model
5. **Output nodes + edges** với evidence

## ĐỊNH DẠNG ĐẦU RA

```yaml
graph_type: "service_graph"
graph_nodes:
  - { id: "WordStudy.razor", type: "page", path: "Pages/WordStudy.razor" }
  - { id: "IWordService", type: "interface", path: "Services/IWordService.cs" }
  - { id: "WordService", type: "service", path: "Services/WordService.cs" }
graph_edges:
  - { from: "WordStudy.razor", to: "IWordService", type: "inject", evidence_file: "Pages/WordStudy.razor", evidence_line: 2 }
  - { from: "WordService", to: "IWordService", type: "implements", evidence_file: "Services/WordService.cs", evidence_line: 5 }
  - { from: "WordService", to: "JapaneseWord", type: "data", evidence_file: "Services/WordService.cs", evidence_line: 15 }
  - { from: "WordService", to: "ILocalStorageService", type: "service", evidence_file: "Services/WordService.cs", evidence_line: 8 }
```

## QUY TẮC

- Mọi edge phải có evidence (file + line)
- Phân loại rõ `type`: inject | implements | data | service | using
- Không suy đoán quan hệ — chỉ từ evidence code thật

## XỬ LÝ NGOẠI LỆ

- Service không đăng ký DI → ghi chú "service tồn tại nhưng không trong Program.cs"
- Page dùng service không @inject (singleton pattern khác) → ghi rõ cách truy cập
