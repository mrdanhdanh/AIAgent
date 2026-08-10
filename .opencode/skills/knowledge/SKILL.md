---
name: knowledge
description: Namespace container — nhóm 10 sub-skills đọc hiểu codebase (answer-builder, architecture-reader, code-understanding, data-model-reader, dependency-analyzer, document-understanding, git-history, impact-analyzer, search-engine, workflow-reader). KHÔNG tự chạy pipeline — điều phối qua /knowledge-assistant.
schema_version: "1.0"
---

# Knowledge — Namespace Container

Container nhóm các sub-skills phục vụ Knowledge Assistant (`/knowledge-*` commands).
Không có logic riêng — pipeline được điều phối bởi `knowledge-assistant` skill.

## Sub-skills

| Skill | Mô tả |
|-------|-------|
| `answer-builder` | Ghép evidence thành câu trả lời cuối (markdown có nguồn) |
| `architecture-reader` | Hiểu kiến trúc dự án, phát hiện vi phạm layer |
| `code-understanding` | Đọc class/method/call graph C# + Razor |
| `data-model-reader` | Đọc data model — entities, LocalStorage keys, cache-first |
| `dependency-analyzer` | Build call graph / dependency graph Page → Service → Model |
| `document-understanding` | Đọc tài liệu dự án — requirement, business rule, flow |
| `git-history` | Phân tích lịch sử git (git log / git blame) |
| `impact-analyzer` | Phân tích ảnh hưởng dây chuyền khi sửa symbol/file |
| `search-engine` | Tìm kiếm codebase — knowledge index JSON + grep trực tiếp |
| `workflow-reader` | Đọc luồng hoạt động, sinh mermaid sequence diagram |

## Nguyên tắc

1. Không suy đoán — mọi câu trả lời kèm nguồn `file:line`.
2. Index = định vị nhanh; file gốc = bằng chứng — luôn đọc file gốc trước khi kết luận.
3. Không biết → nói rõ, không bịa.

## Tham chiếu

- Orchestrator: `.opencode/skills/knowledge-assistant/SKILL.md`
- Chỉ mục: `.opencode/knowledge-index/README.md`
