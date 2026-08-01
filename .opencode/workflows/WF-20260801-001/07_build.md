---
workflow_id: "WF-20260801-001"
step: 7
step_name: "build"
agent: "builder"
schema_version: "3.2"
timestamp: "2026-08-01T17:55:00Z"
---

# Bước 7: Build — Knowledge Assistant

```yaml
status: "PASS"
summary: >
  Toàn bộ 23 steps thực thi thành công. Tạo 1 agent (knowledge-agent), 10 skills
  (.opencode/skills/knowledge/*), 11 commands (knowledge-*), 1 script (knowledge-index.ps1),
  1 README + Knowledge Index thực tế (7 JSON files). Đăng ký vào opencode.json
  (18 agents, 32 commands). Regression: build PASS + 154/154 unit tests PASS.
  Doctor 97/100, Syncdocs 95/100.
steps:
  - { order: 1, status: "PASS", action: "CREATE", file: ".opencode/backup/WF-20260801-001/opencode.json", note: "Backup Utility đã save opencode.json + SYSTEM_MAP.md (SHA256)" }
  - { order: 2, status: "PASS", action: "CREATE", file: ".opencode/agents/knowledge-agent.md", note: "Intent Analyzer + Router, bash: allow (fix từ review)" }
  - { order: 3, status: "PASS", action: "CREATE", file: ".opencode/skills/knowledge/*/ + index/", note: "10 skill dirs + index dir" }
  - { order: 4, status: "PASS", action: "CREATE", file: ".opencode/skills/knowledge/code-understanding/SKILL.md" }
  - { order: 5, status: "PASS", action: "CREATE", file: ".opencode/skills/knowledge/document-understanding/SKILL.md" }
  - { order: 6, status: "PASS", action: "CREATE", file: ".opencode/skills/knowledge/dependency-analyzer/SKILL.md" }
  - { order: 7, status: "PASS", action: "CREATE", file: ".opencode/skills/knowledge/workflow-reader/SKILL.md" }
  - { order: 8, status: "PASS", action: "CREATE", file: ".opencode/skills/knowledge/search-engine/SKILL.md" }
  - { order: 9, status: "PASS", action: "CREATE", file: ".opencode/skills/knowledge/architecture-reader/SKILL.md" }
  - { order: 10, status: "PASS", action: "CREATE", file: ".opencode/skills/knowledge/data-model-reader/SKILL.md" }
  - { order: 11, status: "PASS", action: "CREATE", file: ".opencode/skills/knowledge/git-history/SKILL.md" }
  - { order: 12, status: "PASS", action: "CREATE", file: ".opencode/skills/knowledge/impact-analyzer/SKILL.md" }
  - { order: 13, status: "PASS", action: "CREATE", file: ".opencode/skills/knowledge/answer-builder/SKILL.md" }
  - { order: 14, status: "PASS", action: "CREATE", file: ".opencode/scripts/knowledge-index.ps1", note: "Fix lỗi encoding lần 1 (UTF-8 BOM + ASCII comments)" }
  - { order: 15, status: "PASS", action: "CREATE", file: ".opencode/knowledge/knowledge-assistant/README.md + .gitkeep" }
  - { order: 16, status: "PASS", action: "CREATE", file: ".opencode/commands/knowledge*.md (11 files)" }
  - { order: 17, status: "PASS", action: "MODIFY", file: "opencode.json", note: "Thêm knowledge-agent + 11 commands, JSON validate OK" }
  - { order: 18, status: "PASS", action: "CREATE", file: ".opencode/knowledge/knowledge-assistant/index/*.json", note: "14 routes, 46 symbols, 5 DI, 4 models, 33 dep edges, 19 docs" }
  - { order: 19, status: "PASS", action: "CREATE", file: "(validation report)", note: "0 lỗi CRITICAL — frontmatter, JSON, code blocks, index parse" }
  - { order: 20, status: "PASS", action: "MODIFY", file: "(no file — validation)", note: "dotnet build PASS + dotnet test 154/154 PASS" }
  - { order: 21, status: "PASS", action: "CREATE", file: "(smoke test output)", note: "3/3 smoke tests PASS (ask, where, trace)" }
  - { order: 22, status: "PASS", action: "CREATE", file: "(doctor report)", note: "Doctor 97/100 — knowledge-agent PASS 8/8 sub-checks" }
  - { order: 23, status: "PASS", action: "MODIFY", file: ".opencode/SYSTEM_MAP.md", note: "Syncdocs 95/100, 18 agents/52 commands/28 skills, 0 issues" }
changed_files:
  - "opencode.json"
  - ".opencode/SYSTEM_MAP.md"
created_files:
  - ".opencode/agents/knowledge-agent.md"
  - ".opencode/commands/knowledge.md"
  - ".opencode/commands/knowledge-ask.md"
  - ".opencode/commands/knowledge-where.md"
  - ".opencode/commands/knowledge-why.md"
  - ".opencode/commands/knowledge-flow.md"
  - ".opencode/commands/knowledge-impact.md"
  - ".opencode/commands/knowledge-explain.md"
  - ".opencode/commands/knowledge-trace.md"
  - ".opencode/commands/knowledge-compare-doc.md"
  - ".opencode/commands/knowledge-health.md"
  - ".opencode/commands/knowledge-index.md"
  - ".opencode/skills/knowledge/*/SKILL.md (10 files)"
  - ".opencode/scripts/knowledge-index.ps1"
  - ".opencode/knowledge/knowledge-assistant/README.md"
  - ".opencode/knowledge/knowledge-assistant/index/*.json (7 files)"
deleted_files: []
backup_workflow_id: "WF-20260801-001"
validation_status: "PASS"
out_of_plan_findings:
  - file: ".opencode/commands/ask.md, where.md, why.md, trace.md, flow.md, impact.md, explain.md, compare-doc.md"
    note: "8 file command pre-existing (untracked, encoding hỏng, agent: general, trỏ skill cũ .opencode/skills/search-engine/). KHÔNG thuộc plan — không sửa/xóa. Gợi ý: user xem xét xóa hoặc alias sang knowledge-*."
```

## Ghi chú Builder

1. **Lỗi gặp phải + fix**: `knowledge-index.ps1` lỗi parse do UTF-8 không BOM + ký tự box-drawing `─` → PowerShell 5.1 đọc sai. Đã sửa: viết lại với comment ASCII thuần + ghi BOM UTF-8.
2. **Quyết định tên command**: dùng prefix `knowledge-*` (knowledge-ask, knowledge-where...) thay vì tên ngắn (ask, where...) để tránh xung đột với 8 file pre-existing + đúng namespace convention.
3. **Không sửa file ngoài plan**: 8 file command cũ (`ask.md`...) được bỏ qua theo đúng quy tắc FileOutsidePlan — chỉ báo cáo.
