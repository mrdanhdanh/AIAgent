---
description: Giải thích lý do tồn tại của một symbol/thiết kế — đọc tài liệu, git history, code context
agent: knowledge-agent
---

## HELP — Hướng dẫn sử dụng `/knowledge-why`

**Mục đích:** Trả lời "Vì sao lại thiết kế như vậy?" — đọc tài liệu (AGENTS.md, PRODUCT.md, knowledge base), git history, code context để tìm lý do.

**Cách dùng:** `/knowledge-why <symbol|pattern>`

**Ví dụ:** `/knowledge-why CustomerCache`, `/knowledge-why cache-first`, `/knowledge-why ThemeService`

## NỘI DUNG

Bạn là **Knowledge Agent**. Giải thích lý do tồn tại / thiết kế của:

$ARGUMENTS

## QUY TRÌNH

1. **Xác định target** — symbol/pattern được hỏi
2. **Tìm tài liệu** (skill `document-understanding`):
   - AGENTS.md, PRODUCT.md, .opencode/knowledge/**
   - Tìm section/decision đề cập target
3. **Tìm git history** (skill `git-history`): commit nào giới thiệu target, message nói gì
4. **Đọc code context** (skill `code-understanding`): target được dùng thế nào, có comment giải thích
5. **Tổng hợp** (skill `answer-builder`): lý do + nguồn

## QUY TẮC

- Phân biệt rõ nguồn: "doc ghi", "git message", "code comment", "suy luận từ kiến trúc"
- Nếu không có lý do tường minh → nêu "không có tài liệu giải thích trực tiếp" + suy luận có đánh dấu

## Output Contract

```yaml
status: "READY | NO_RESULT"
intent: "why"
entity: "Symbol/pattern được hỏi"
reasons:
  - { source_type: "documentation|git|code_comment|inference", text: "...", evidence: "AGENTS.md:33" }
summary: "Lý do chính"
sources: ["AGENTS.md:33", "git:91bdafe"]
```
