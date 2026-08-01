---
name: document-understanding
description: Đọc và hiểu tài liệu — README, SPEC, Design, Wiki, Markdown, PDF, Excel, Word. Trích xuất Requirement, Business Rule, Flow, Constraint, Decision. Dùng trong /why, /compare-doc, /knowledge-health.
schema_version: "1.0"
---

# Document Understanding — Hiểu Tài Liệu

Skill chuyên đọc tài liệu và trích xuất thông tin có cấu trúc phục vụ trả lời câu hỏi về "lý do" và "quy định" của hệ thống.

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [ĐỊNH DẠNG HỖ TRỢ](#định-dạng-hỗ-trợ)
- [LOẠI THÔNG TIN TRÍCH XUẤT](#loại-thông-tin-trích-xuất)
- [QUY TRÌNH](#quy-trình)
- [OUTPUT CONTRACT](#output-contract)
- [QUY TẮC BẮT BUỘC](#quy-tắc-bắt-buộc)

---

## TỔNG QUAN

Đọc tài liệu dự án để trả lời câu hỏi về yêu cầu nghiệp vụ, quyết định thiết kế, và sự khác biệt giữa tài liệu với code thực tế.

### Command liên quan

| Command | Mô tả |
|---------|-------|
| `/why <component>` | Giải thích lý do tồn tại |
| `/compare-doc <component>` | So sánh code vs design doc |
| `/knowledge-health` | Đánh giá thiếu tài liệu |

### Kiến thức liên quan

- `.opencode/knowledge/` — knowledge base (18 files: patterns, ui, framework, testing)
- `AGENTS.md` — quy ước dự án
- `PRODUCT.md`, `AIAgent-Overview.md`, `Upgrade_System.md` — tài liệu tổng quan
- `JapaneseLearner/README.md` — nếu có

---

## ĐỊNH DẠNG HỖ TRỢ

- **Markdown** — README, SPEC, wiki
- **Text** — plain text docs
- **PDF** — đọc qua tool đọc PDF nếu có
- **Excel / Word** — đọc qua tool chuyển đổi nếu có

---

## LOẠI THÔNG TIN TRÍCH XUẤT

| Loại | Mô tả | Ví dụ |
|------|-------|-------|
| **Requirement** | Yêu cầu chức năng | "Admin có thể CRUD từ vựng" |
| **Business Rule** | Quy tắc nghiệp vụ | "Mỗi từ vựng thuộc đúng 1 type" |
| **Flow** | Luồng xử lý | "User học → chọn quiz → trả lời → tính điểm" |
| **Constraint** | Ràng buộc kỹ thuật | "Port 5173 hardcode cho E2E" |
| **Decision** | Quyết định thiết kế | "Cache-first để giảm localStorage read" |

---

## QUY TRÌNH

### Bước 1: Định vị tài liệu
Dùng `document-index.json` trong Knowledge Index hoặc glob `**/*.md` để tìm tài liệu liên quan.

### Bước 2: Đọc tài liệu
Đọc nội dung, đánh dấu các phần liên quan câu hỏi.

### Bước 3: Trích xuất
Phân loại thông tin theo 5 loại trên. Ghi nguồn `file:line` cho mỗi mục.

### Bước 4: Trả lời
Ghép thông tin trích xuất thành câu trả lời có nguồn tài liệu.

---

## OUTPUT CONTRACT

```yaml
status: "READY | NOT_FOUND"
summary: "Tóm tắt thông tin trích xuất"
target: "Chủ đề được hỏi"
extracted:
  - type: "REQUIREMENT | BUSINESS_RULE | FLOW | CONSTRAINT | DECISION"
    content: "Nội dung thông tin"
    source: "path/to/doc.md:line"
    confidence: "HIGH | MEDIUM | LOW"
documents_scanned:
  - path: "path/to/doc.md"
    relevant: true | false
    notes: "Ghi chú"
issues:
  - severity: "INFO | WARNING"
    description: "Tài liệu thiếu/lỗi thời..."
next_action: "Hành động tiếp theo"
```

---

## QUY TẮC BẮT BUỘC

1. **Nguồn rõ ràng**: Mỗi thông tin trích xuất kèm đường dẫn tài liệu + dòng.
2. **Phân biệt tài liệu vs code**: Khi tài liệu mâu thuẫn code → ghi nhận cả 2, không tự quyết định.
3. **Confidence**: Nếu thông tin mơ hồ → `confidence: LOW`, ghi lý do.
4. **Không bịa tài liệu**: Không trích dẫn file không tồn tại.
