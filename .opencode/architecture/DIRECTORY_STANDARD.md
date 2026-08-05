---
name: architecture-directory-standard
description: DIRECTORY_STANDARD — chuẩn thư mục và vị trí file cho Agent Framework v4. Không thêm thư mục tùy ý.
agent: general
---

# DIRECTORY_STANDARD.md — Chuẩn Thư Mục

> Không thêm thư mục tùy ý. Mọi nội dung framework nằm trong `.opencode/` và các thư mục chuẩn bên dưới.

## 1. Cây thư mục chuẩn

```
.opencode/
├── agents/           # agent definitions (.md)
├── commands/         # command definitions (.md)
├── skills/           # skill definitions (SKILL.md)
├── workflow/
│   ├── definitions/  # workflow YAML
│   └── WF-*/         # runtime context (engine tạo, không sửa tay)
├── workflow-engine/  # engine source (8 modules)
├── registry/         # capability/agent/skill/command/contract registry YAML
├── context/          # (Phase 4) context store
├── artifact/         # (Phase 5) artifact store
├── events/           # (Phase 6) event logs
├── knowledge/        # knowledge base
├── knowledge-index/  # 7 loại index
├── memory/           # failure memory, lessons, patterns
├── baseline/         # Phase 0.1 baseline snapshot
├── architecture/     # Phase 0.2 ASP v4 (THIS)
├── backup/           # backup workflow, rollback
├── scripts/          # PS1 scripts
├── reports/          # generated reports
└── templates/        # workflow templates (nếu có)
```

## 2. Quy tắc vị trí

| Nội dung | Thư mục bắt buộc |
|----------|-------------------|
| Agent definition | `.opencode/agents/` |
| Command definition | `.opencode/commands/` |
| Skill | `.opencode/skills/` |
| Workflow definition | `.opencode/workflow/definitions/` |
| Registry YAML | `.opencode/registry/` |
| Context | `.opencode/context/` |
| Artifact | `.opencode/artifact/` |
| Knowledge | `.opencode/knowledge/` |
| Memory | `.opencode/memory/` |
| Script | `.opencode/scripts/` |

## 3. Quy tắc

- Không đặt workflow runtime context trong thư mục khác.
- Không tạo thư mục lạ ngoài cây trên mà không có ADR + cập nhật DIRECTORY_STANDARD.
- WF-* do engine tạo — không sửa tay, không commit tùy ý.
- File sinh tự động (catalog, report) → `.opencode/reports/`.