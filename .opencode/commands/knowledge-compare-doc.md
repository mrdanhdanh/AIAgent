---
description: So sánh code hiện tại với tài liệu thiết kế — phát hiện lệch lạc giữa code và docs
agent: knowledge-agent
---

## HELP — Hướng dẫn sử dụng `/knowledge-compare-doc`

**Mục đích:** So sánh code hiện tại với tài liệu thiết kế — phát hiện nơi code lệch so với doc (thiếu, thừa, thay đổi).

**Cách dùng:** `/knowledge-compare-doc <file|module>`

**Ví dụ:** `/knowledge-compare-doc WordService`, `/knowledge-compare-doc Admin`, `/knowledge-compare-doc Home`

## NỘI DUNG

Bạn là **Knowledge Agent**. So sánh code và tài liệu thiết kế của:

$ARGUMENTS

## QUY TRÌNH

1. **Xác định target** — module/file cần so sánh
2. **Đọc tài liệu** (skill `document-understanding`): AGENTS.md, PRODUCT.md, .opencode/knowledge/** — trích mô tả thiết kế
3. **Đọc code** (skill `code-understanding`): thực tế triển khai
4. **Đối chiếu** — điểm khớp, điểm lệch:
   - Code có nhưng doc không mô tả
   - Doc mô tả nhưng code không có
   - Code khác mô tả (behavior/field/route)
5. **Tổng hợp** (skill `answer-builder`) — bảng so sánh

## QUY TẮC

- Bảng so sánh: Mục | Doc ghi | Code thực tế | Trạng thái (MATCH/DIFF/MISSING)
- Phân biệt rõ "doc cũ/thiếu" vs "code sai"
- Không phán quyết — chỉ báo cáo lệch lạc

## Output Contract

```yaml
status: "READY | NO_RESULT"
intent: "compare-doc"
entity: "Module/file"
comparisons:
  - { item: "Routes", doc: "/words", code: "/words", status: "MATCH", doc_source: "AGENTS.md:22", code_source: "Pages/WordStudy.razor:1" }
  - { item: "Level field", doc: "Dùng trong quiz", code: "display-only", status: "DIFF", doc_source: "AGENTS.md:69", code_source: "Models/JapaneseWord.cs:10" }
summary: "N điểm MATCH, M điểm DIFF, K điểm MISSING"
sources: ["AGENTS.md:22", "Pages/WordStudy.razor:1"]
```

## Flags:

| Flag | Y nghia |
|------|---------|
| `--full` | So sanh toan bo |
| `--section <name>` | Chi so sanh section |

