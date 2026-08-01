---
description: Trace luồng hoạt động end-to-end — UI → Service → Model → LocalStorage, sinh chuỗi trace dạng cây
agent: knowledge-agent
---

## HELP — Hướng dẫn sử dụng `/knowledge-trace`

**Mục đích:** Trace luồng hoạt động từ đầu đến cuối: UI (.razor) → Service (DI) → Model → LocalStorage → Response/UI. Sinh chuỗi trace dạng cây.

**Cách dùng:** `/knowledge-trace <chức năng|route|symbol>`

**Ví dụ:** `/knowledge-trace Login`, `/knowledge-trace /words`, `/knowledge-trace GetAllAsync`

## NỘI DUNG

Bạn là **Knowledge Agent**. Trace luồng hoạt động của:

$ARGUMENTS

## QUY TRÌNH

1. **Xác định entry** — route/symbol; map qua `route-index.json` nếu cần
2. **Dựng chuỗi trace** (skill `dependency-analyzer` + `search-engine`):
   - Page .razor → @inject interface
   - Interface → implementation (Program.cs AddScoped)
   - Implementation → Model (data)
   - Implementation → LocalStorage (persist)
3. **Sinh trace tree** — dạng cây UI → API(service) → Service → Model → Storage → Response
4. **Tổng hợp** (skill `answer-builder`)

## QUY TẮC

- Mỗi hop trong chuỗi trace có nguồn file:line
- Dùng dạng cây rõ ràng
- Ghi chú nơi nào cache (in-memory) vs persist (LocalStorage)

## Output Contract

```yaml
status: "READY | NO_RESULT"
intent: "trace"
entity: "Chức năng/route"
trace_chain:
  - { layer: "UI", component: "WordStudy.razor", evidence: "Pages/WordStudy.razor:2" }
  - { layer: "Service", component: "IWordService", evidence: "Services/IWordService.cs:5" }
  - { layer: "Implementation", component: "WordService", evidence: "Services/WordService.cs:7" }
  - { layer: "Model", component: "JapaneseWord", evidence: "Models/JapaneseWord.cs:3" }
  - { layer: "Storage", component: "Blazored.LocalStorage", evidence: "Services/WordService.cs:8" }
cache_notes: "Cache-first: in-memory + LocalStorage persist"
sources: ["Pages/WordStudy.razor:2"]
```
