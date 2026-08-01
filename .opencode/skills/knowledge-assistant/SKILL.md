---
name: knowledge-assistant
description: Knowledge Assistant — điều phối pipeline trả lời mọi câu hỏi về codebase: Intent Analyzer → Knowledge Planner → Code/Doc Skill → Dependency → Search/Impact → Answer Builder. Hỗ trợ /ask, /where, /why, /flow, /impact, /explain, /trace, /compare-doc, /knowledge-health.
schema_version: "1.0"
---

# Knowledge Assistant — Trợ Lý Kiến Thức

Skill tổng hợp điều phối toàn bộ pipeline Knowledge Assistant — trả lời mọi câu hỏi về hệ thống với bằng chứng.

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [KIẾN TRÚC](#kiến-trúc)
- [INTENT ANALYZER](#intent-analyzer)
- [KNOWLEDGE PLANNER](#knowledge-planner)
- [PIPELINE](#pipeline)
- [SỬ DỤNG KNOWLEDGE INDEX](#sử-dụng-knowledge-index)
- [OUTPUT CONTRACT](#output-contract)
- [QUY TẮC BẮT BUỘC](#quy-tắc-bắt-buộc)

---

## TỔNG QUAN

Knowledge Assistant trả lời các câu hỏi như:
- Module này dùng để làm gì?
- API này được gọi từ đâu?
- Màn hình này có workflow thế nào?
- Nếu sửa component này sẽ ảnh hưởng những gì?
- Vì sao lại thiết kế như vậy?
- Có tài liệu nào nói về chức năng này không?
- Component này còn được dùng ở đâu?
- Tìm toàn bộ nơi sử dụng `CustomerId`
- So sánh phiên bản hiện tại với tài liệu thiết kế

### Commands liên quan

| Command | Intent | Skills tham gia |
|---------|--------|-----------------|
| `/ask <câu hỏi>` | GENERAL | Tất cả theo planner |
| `/where <symbol>` | WHERE | search-engine, dependency-analyzer |
| `/why <component>` | WHY | document-understanding, git-history |
| `/flow <luồng>` | FLOW | workflow-reader, search-engine |
| `/impact <component>` | IMPACT | impact-analyzer, dependency-analyzer |
| `/explain <file>` | EXPLAIN | code-understanding |
| `/trace <flow>` | TRACE | dependency-analyzer, code-understanding, database-reader |
| `/compare-doc <component>` | COMPARE | document-understanding, code-understanding |
| `/knowledge-health` | HEALTH | document-understanding, search-engine |

---

## KIẾN TRÚC

```
Assistant
    │
    ▼
Intent Analyzer
    │
    ▼
Knowledge Planner
    │
    ├─────────────┐
    ▼             ▼
 Code Skill  Document Skill
    │             │
    └──────┬──────┘
           ▼
 Dependency Skill
           ▼
 Search Skill / Impact
           ▼
 Answer Builder
           ▼
        User
```

---

## INTENT ANALYZER

Phân loại câu hỏi thành 1 trong 9 intents:

| Intent | Tín hiệu nhận diện | Ví dụ |
|--------|--------------------|-------|
| `EXPLAIN` | Tên file/class + "giải thích/làm gì" | "WordService.cs làm gì?" |
| `WHERE` | "dùng ở đâu / nơi nào / tìm" + symbol | "Tìm nơi dùng CustomerId" |
| `WHY` | "vì sao / tại sao / lý do" | "Vì sao dùng cache-first?" |
| `FLOW` | "workflow / luồng / trình tự" | "Luồng đăng ký người dùng?" |
| `IMPACT` | "ảnh hưởng / tác động / sửa ... thì" | "Sửa X ảnh hưởng gì?" |
| `TRACE` | "trace / truy vết / từ ... đến" | "Trace luồng Login" |
| `COMPARE` | "so sánh / khác / đối chiếu" | "Code vs design doc" |
| `HEALTH` | "health / thiếu / đánh giá" | "Thiếu tài liệu gì?" |
| `GENERAL` | Không khớp intent nào | "Mô tả kiến trúc tổng" |

**Nhiều intent**: chọn intent chính + note intent phụ.

---

## KNOWLEDGE PLANNER

Sau khi xác định intent, lập kế hoạch:

1. **Chọn skills** theo bảng mapping ở trên
2. **Xác định thứ tự**: skills đọc → dependency → impact → answer
3. **Xác định nguồn**: Knowledge Index (nhanh) → file gốc (evidence)
4. **Chunk câu hỏi**: Nếu câu hỏi lớn → tách sub-questions

---

## PIPELINE

### Bước 1: Intent Analysis
Xác định intent + các thực thể (symbol, file, luồng) trong câu hỏi.

### Bước 2: Kiểm tra Knowledge Index
```powershell
# Index có sẵn không?
Test-Path .opencode/knowledge-index/symbol-index.json
```
- Không có → nhắc chạy `/knowledge-index` hoặc fallback grep trực tiếp.

### Bước 3: Triệu hồi skills
Theo intent, tải skill tương ứng từ `.opencode/skills/<skill>/SKILL.md` và thực hiện.

### Bước 4: Thu thập evidence
Mỗi skill trả evidence (file:line). Lưu vào working set.

### Bước 5: Answer Builder
Tải `.opencode/skills/answer-builder/SKILL.md` → ghép câu trả lời.

### Bước 6: Trả lời
Output theo contract bên dưới.

---

## SỬ DỤNG KNOWLEDGE INDEX

Knowledge Index (`/knowledge-index`) giúp trả lời **nhanh**:

| Index | Nội dung | Dùng khi |
|-------|----------|----------|
| `code-index.json` | File → symbols, classes | EXPLAIN, TRACE |
| `symbol-index.json` | Symbol → files, lines | WHERE |
| `api-index.json` | Public methods → callers | IMPACT, TRACE |
| `database-index.json` | Storage keys / DB objects | DATABASE câu hỏi |
| `dependency-graph.json` | Nodes + edges | IMPACT, TRACE, WHERE |
| `document-index.json` | Docs → content | WHY, COMPARE, HEALTH |
| `business-rule-index.json` | Business rules → sources | WHY, COMPARE |

**Index = định vị nhanh. File gốc = bằng chứng.** Luôn đọc file gốc trước khi kết luận.

---

## OUTPUT CONTRACT

```yaml
status: "READY | PARTIAL"
summary: "Tóm tắt câu trả lời"
intent: "EXPLAIN | WHERE | WHY | FLOW | IMPACT | TRACE | COMPARE | HEALTH | GENERAL"
question: "Câu hỏi gốc của user"
answer: |
  <Câu trả lời markdown đầy đủ theo format answer-builder>
answer_type: "EXPLAIN | WHERE | WHY | FLOW | IMPACT | TRACE | COMPARE | HEALTH | GENERAL"
confidence: "HIGH | MEDIUM | LOW"
pipeline:
  skills_used:
    - name: "Tên skill"
      role: "Vai trò trong pipeline"
  index_used: true | false
  sources_read:
    - file: "path/to/file"
      line: 42
sources:
  - file: "path/to/file"
    line: 42
    role: "Mô tả vai trò nguồn"
gaps:
  - "Điểm chưa có evidence"
issues: []
next_action: "Hành động tiếp theo"
```

---

## QUY TẮC BẮT BUỘC

1. **Evidence-first**: Mọi câu trả lời kèm nguồn file:line.
2. **Không suy đoán**: Không biết → nói "không tìm thấy" + gợi ý.
3. **Index là công cụ, không phải nguồn chân lý**: Luôn đọc file gốc.
4. **Intent đúng**: Phân loại sai intent → trả lời sai hướng.
5. **Nhiều intent**: Trả lời intent chính + note các intent phụ.
6. Nếu index lỗi thời → nhắc `/knowledge-index --update`.
