---
name: component-inventory
description: COMPONENT_INVENTORY — liệt kê toàn bộ component của Agent Framework v3.
agent: general
---

# COMPONENT_INVENTORY.md — Agent Framework v3

> Liệt kê component cùng Purpose / Owner / Files / Dependencies.

| Component | Purpose | Files (đại diện) | Dependencies |
|-----------|---------|------------------|--------------|
| Workflow Engine | Điều phối workflow v4 | `.opencode/workflow-engine/*` (8 module) | Definitions YAML, Agent |
| Workflow Definitions | Khai báo phases | `.opencode/workflow/definitions/*.yaml` | Engine |
| Capability Registry | Khai báo capability + map | `.opencode/registry/*` (10) | - |
| Knowledge | lessons, patterns, index | `.opencode/knowledge/**` | Skills |
| Memory | failure/lesson/pattern records | `.opencode/memory/**` | Learning |
| Agent System | agent definitions | `.opencode/agents/*.md` (18) | Skills, Model |
| Command System | command definitions | `.opencode/commands/*.md` (54) | Agents, Workflow |
| Doctor | health scan | `.opencode/commands/doctor.md` | Scripts |
| Backup | backup/rollback | `.opencode/commands/backup.md` | backup-agent |
| Learning Pipeline | lessons từ failure | `.opencode/skills/failure`... | Memory |
| Self-Improve nhân | suggestion improvement | self-improver.md | Knowledge |
| GitGuard/GitPush | pre-push review | gitguard.md, gitpush.md | Scripts |

Owner quy ước: agent/command module. Files đúng đường dẫn; Dependencies = phụ thuộc chi tiêu.