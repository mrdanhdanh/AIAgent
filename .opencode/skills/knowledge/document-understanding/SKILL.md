---
name: document-understanding
description: Đọc tài liệu dự án (.md, README, SPEC, PRODUCT, knowledge base) — trích xuất requirement, business rule, flow, constraint, decision. Sử dụng trong /knowledge-why, /knowledge-compare-doc.
schema_version: "1.0"
---

# Document Understanding — Skill

## TỔNG QUAN

Skill đọc và trích xuất thông tin từ tài liệu Markdown của dự án: AGENTS.md, PRODUCT.md, AIAgent-Overview.md, Upgrade_System.md, `.opencode/knowledge/**`, `.opencode/SYSTEM_MAP.md`, workflow reports.

## NGUỒN TÀI LIỆU CHÍNH

| File | Nội dung |
|------|----------|
| `AGENTS.md` | Project structure, build/run, routes, architecture notes, commands |
| `PRODUCT.md` | Tổng quan sản phẩm |
| `.opencode/knowledge/README.md` | Knowledge base index |
| `.opencode/knowledge/**/*.md` | Lessons, patterns, framework, testing docs |
| `workflow/**/final_report.md` | Báo cáo workflow cũ |

## QUY TRÌNH

1. **Locate** — glob `*.md` theo category, tìm doc liên quan đến entity
2. **Read** — đọc file, chú ý headings (## / ###), bảng, code block
3. **Extract**:
   - Requirement: câu mô tả chức năng bắt buộc (thường có "phải", "cần", "must")
   - Business Rule: quy tắc nghiệp vụ (điều kiện, ràng buộc)
   - Flow: mô tả luồng hoạt động (bước 1, 2, 3)
   - Constraint: giới hạn (không được, bắt buộc)
   - Decision: quyết định thiết kế + lý do (thường ghi "vì", "do đó")
4. **Cite** — ghi rõ file + section

## ĐỊNH DẠNG ĐẦU RA

```yaml
document: "AGENTS.md"
requirements:
  - { text: "E2E tests hardcode port 5173 trong AppFixture.cs", source: "AGENTS.md:52" }
business_rules:
  - { text: "Vocabulary meanings là tiếng Việt", source: "AGENTS.md:69" }
flows:
  - { name: "Deploy GitHub Pages", steps: ["push master → publish → gh-pages"], source: "AGENTS.md:76" }
constraints:
  - { text: "Không có .sln file", source: "AGENTS.md:8" }
decisions:
  - { text: "Cache-first storage: in-memory + LocalStorage", reason: "Không có server backend", source: "AGENTS.md:33" }
```

## QUY TẮC

- Trích dẫn chính xác `source` (file:line hoặc file:section)
- KHÔNG bịa thông tin — doc không có thì không trả
- Phân biệt rõ: "doc ghi" vs "code thực tế" (quan trọng cho /compare-doc)

## XỬ LÝ NGOẠI LỆ

- Doc không tồn tại → trả `document: "Không tìm thấy"` + danh sách doc có
- Doc mâu thuẫn với code → ghi rõ cả 2 bên, không tự phán quyết
