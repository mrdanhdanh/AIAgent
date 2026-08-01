---
category: "framework"
title: "Knowledge Assistant"
last_updated: "2026-08-01"
schema_version: "1.0"
---

# Knowledge Assistant

Hệ thống AI hiểu toàn bộ codebase JapaneseLearner và trả lời câu hỏi về module, API (service DI), data model, dependency, impact analysis — qua pipeline skill chuyên biệt + tầng Knowledge Index.

## Kiến trúc

```
User Question → /knowledge-* command
    → knowledge-agent (Intent Analyzer)
    → Knowledge Planner (chọn skill)
    → Code/Doc/Data/Git Skill → dependency-analyzer → search-engine → impact-analyzer
    → answer-builder (trả lời có nguồn file:line)
```

## 10 Skills

| Skill | Chức năng |
|-------|-----------|
| `code-understanding` | Đọc C#/Razor — class, method, DI, lifecycle |
| `document-understanding` | Đọc docs — requirement, rule, decision |
| `dependency-analyzer` | Xây call graph Page→Service→Model |
| `workflow-reader` | Mô tả user flow + mermaid |
| `search-engine` | Semantic + grep search (index/grep mode) |
| `architecture-reader` | Phân layer, detect violation |
| `data-model-reader` | Entity schema + LocalStorage keys |
| `git-history` | Ai sửa / khi nào / commit nào |
| `impact-analyzer` | Ảnh hưởng dây chuyền khi sửa X |
| `answer-builder` | Tổng hợp trả lời có nguồn |

## 11 Commands

| Command | Mô tả |
|---------|-------|
| `/knowledge` | Help + routing |
| `/knowledge-ask` | Hỏi module/skill hoạt động thế nào |
| `/knowledge-where` | Tìm nơi dùng symbol |
| `/knowledge-why` | Lý do thiết kế |
| `/knowledge-flow` | Mô tả workflow |
| `/knowledge-impact` | Phân tích ảnh hưởng |
| `/knowledge-explain` | Giải thích file |
| `/knowledge-trace` | Trace luồng |
| `/knowledge-compare-doc` | So sánh code vs docs |
| `/knowledge-health` | Đánh giá kiến thức codebase |
| `/knowledge-index` | Build/update Knowledge Index |

## Knowledge Index

- Script: `.opencode/scripts/knowledge-index.ps1`
- Output: `index/` — route-index.json, symbol-index.json, service-index.json, data-model-index.json, dependency-graph.json, document-index.json
- Khi source thay đổi: chạy `/knowledge-index --update`

## Stack Mapping (adapt)

| Yêu cầu gốc (Oracle/Angular) | Dự án thực tế |
|-------------------------------|----------------|
| Database/SP | Models + Services cache-first + LocalStorage |
| API | Service DI (IWordService → WordService) |
| Screen Angular | .razor Pages |
| DB field | C# property |

## Xem thêm

- Agent: `.opencode/agents/knowledge-agent.md`
- Commands: `.opencode/commands/knowledge*.md`
- Skills: `.opencode/skills/knowledge/*/SKILL.md`
