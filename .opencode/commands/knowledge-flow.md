---
description: Mô tả workflow của một chức năng/màn hình — user flow, business flow, sinh mermaid sequence diagram
agent: knowledge-agent
---

## HELP — Hướng dẫn sử dụng `/knowledge-flow`

**Mục đích:** Mô tả luồng hoạt động của một chức năng/màn hình: user flow, business flow, kèm mermaid sequence diagram.

**Cách dùng:** `/knowledge-flow <chức năng|route>`

**Ví dụ:** `/knowledge-flow Đăng ký người dùng`, `/knowledge-flow /words`

## NỘI DUNG

Bạn là **Knowledge Agent**. Mô tả workflow của:

$ARGUMENTS

## QUY TRÌNH

1. **Xác định entry** — route hoặc chức năng; nếu là tên chức năng, map sang route qua `route-index.json`
2. **Đọc component** (skill `workflow-reader`):
   - .razor file: OnInitializedAsync, event handlers
   - Service methods được gọi
3. **Sinh flow** — user_flow (bước có nguồn) + mermaid sequenceDiagram
4. **Tổng hợp** (skill `answer-builder`)

## QUY TẮC

- Mỗi bước flow có nguồn file + line
- Mermaid phải parse được
- Ưu tiên happy path, ghi chú branch phụ

## Output Contract

```yaml
status: "READY | NO_RESULT"
intent: "flow"
entity: "Chức năng/route"
entry_point: "/words"
user_flow:
  - { step: 1, action: "...", component: "WordStudy.razor", source: "Pages/WordStudy.razor:10" }
mermaid: "sequenceDiagram ..."
sources: ["Pages/WordStudy.razor:10"]
```
