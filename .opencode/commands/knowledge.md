---
description: Help + routing cho Knowledge Assistant — liệt kê 10 commands, intent mapping, ví dụ sử dụng
agent: knowledge-agent
---

## HELP — Hướng dẫn sử dụng `/knowledge`

**Mục đích:** Hiển thị menu Knowledge Assistant + routing hướng dẫn user chọn command phù hợp.

**Cách dùng:** `/knowledge` hoặc `/knowledge help <chủ đề>`

## NỘI DUNG

Bạn là **Knowledge Agent**. Hiển thị menu Knowledge Assistant cho user:

```
┌────────────────────────────────────────────────┐
│  Knowledge Assistant — Hiểu toàn bộ codebase   │
├────────────────────────────────────────────────┤
│  /knowledge-ask <câu hỏi>     Hỏi module hoạt động thế nào │
│  /knowledge-where <symbol>    Tìm nơi dùng symbol          │
│  /knowledge-why <symbol>      Lý do thiết kế               │
│  /knowledge-flow <chức năng>  Mô tả workflow               │
│  /knowledge-impact <symbol>   Phân tích ảnh hưởng          │
│  /knowledge-explain <file>    Giải thích từng method       │
│  /knowledge-trace <chức năng> Trace luồng UI→Service→Data  │
│  /knowledge-compare-doc <file> So sánh code vs design      │
│  /knowledge-health            Đánh giá kiến thức codebase  │
│  /knowledge-index [--update]  Xây dựng Knowledge Index     │
└────────────────────────────────────────────────┘
```

Nếu user đưa câu hỏi tự nhiên (không theo command), hãy map sang intent phù hợp:

| Câu hỏi của user | Gợi ý command |
|------------------|---------------|
| "Module X dùng để làm gì?" | `/knowledge-ask` |
| "API này được gọi từ đâu?" | `/knowledge-trace` |
| "Tìm toàn bộ nơi dùng X" | `/knowledge-where` |
| "Sửa X ảnh hưởng gì?" | `/knowledge-impact` |
| "Vì sao thiết kế như vậy?" | `/knowledge-why` |
| "Component này còn dùng ở đâu?" | `/knowledge-where` |
| "Workflow màn hình này thế nào?" | `/knowledge-flow` |

## Output Contract

```yaml
status: "READY"
menu_shown: true
suggested_command: "Tên command gợi ý cho câu hỏi của user"
```
