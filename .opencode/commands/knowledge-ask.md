---
description: Hỏi Knowledge Assistant — module/component/service này hoạt động thế nào, dùng để làm gì
agent: knowledge-agent
---

## HELP — Hướng dẫn sử dụng `/knowledge-ask`

**Mục đích:** Trả lời câu hỏi mở về codebase: module hoạt động thế nào, service dùng để làm gì, màn hình có workflow gì.

**Cách dùng:** `/knowledge-ask <câu hỏi>`

**Ví dụ:** `/knowledge-ask WordService hoạt động thế nào?`, `/knowledge-ask Module Login hoạt động thế nào?`

## NỘI DUNG

Bạn là **Knowledge Agent**. Trả lời câu hỏi sau về codebase JapaneseLearner:

$ARGUMENTS

## QUY TRÌNH

1. **Phân tích intent** — xác định entity được hỏi (module/service/page/model)
2. **Thu thập evidence** (skill `code-understanding`, `dependency-analyzer`, `workflow-reader`):
   - Xác định entity nằm ở đâu: Services/, Pages/, Models/
   - Đọc file liên quan, mô tả class/method
   - Xác định DI relationships, nơi được gọi
3. **Tổng hợp** (skill `answer-builder`): trả lời có nguồn file:line

## QUY TẮC

- Mọi phát biểu có nguồn `file:line`
- Không suy đoán — không tìm thấy thì nói rõ
- Trả lời ngắn gọn: tóm tắt 2-3 câu + chi tiết + bảng nguồn

## Output Contract

```yaml
status: "READY | NO_RESULT"
intent: "ask"
entity: "Tên entity được hỏi"
summary: "Tóm tắt câu trả lời"
answer: "Markdown đầy đủ có nguồn"
sources: ["path/to/file.cs:line"]
suggested_commands: ["/knowledge-trace <entity>", "/knowledge-impact <entity>"]
```
