---
name: system-baseline
description: SYSTEM_BASELINE — khóa trạng thái hiện tại Agent Framework v3. Điểm tham chiếu cho Doctor/Simulation/Evolution.
agent: general
---

# SYSTEM_BASELINE.md — Agent Framework

> Tài liệu quan trọng nhất của Phase 0.1. Khóa trạng thái hiện tại trước khi nâng cấp v4.

## 1. Version

| Field | Value |
|-------|-------|
| Framework | Agent Framework v3 (baseline) |
| Build date | 2026-08-02 |
| Git commit | 3d55b30 |
| Git tag | untagged |
| Repository | https://github.com/mrdanhdanh/AIAgent.git |
| Branch | NewVersion |
| Model | opencode/deepseek-v4-pro (Planner/Architect/Reviewer/Analyst), opencode/deepseek-v4-flash (Coder/Tester/Routine) |

## 2. System Summary

| Thành phần | Count |
|-----------|-------|
| Agents | 18 |
| Commands | 54 |
| Skills (registry) | 29 |
| Skills (all SKILL.md) | 38 |
| Contracts (schema) | 2 |
| Knowledge | 27 (19 md + 8 json) |
| Memory | 14 |
| Workflow (definitions) | 5 |
| Scripts | 12 |
| Registry files | 10 |
| Workflow engine files | 8 |

> Số liệu chi tiết: `SYSTEM_STATISTICS.md` · machine-readable: `baseline.json`

## 3. Directory Structure

```
.opencode/
  agents/        → 18 agent definitions (markdown)
  commands/      → 54 command definitions
  skills/        → hệ thống skills (top-level + knowledge/ nested)
  workflow/      → engine v4 + definitions + WF-* runtime context
  workflow-engine/ → 8 module workflow engine
  registry/      → Capability Registry (10 file, Sprint 2)
  memory/        → BUG-/LSN-/PAT- records
  knowledge/     → lessons, patterns, index
  scripts/       → validator, baseline, catalog, sync...
  baseline/      → Phase 0.1 deliverables (file này nằm ở đây)
  backup/        → backup trước migrate
  reports/       → coverage report
```

## 4. Current Features

- **Workflow Engine v4** — `/team` launcher, 8 module (engine, loader, validator, executor, phase-runner, state-machine, recovery), definitions YAML
- **Capability Registry** (Sprint 2) — capabilities/agent/skill/command registry + validator CR-001..009
- **Knowledge Assistant** — /ask, /where, /why, /flow, /impact, /explain, /trace, /compare-doc, /knowledge-index
- **Doctor** — health scan (environment, agents, commands, skills, knowledge, workflow, contracts, runtime, capability)
- **GitGuard / GitPush** — pre-push review + auto git
- **Backup / Rollback** — backup-agent
- **Failure Analysis + Learning Pipeline** — root-cause + lessons
- **Self-Improve** — self-improver (approval gate)
- **QA Testing commands** — /test-plan, /test-e2e, /test-ui, /test-visual, /approve-test...

## 5. Current Limitations

- **Workflow vẫn một phần hardcode** — phase mapping dính agent theo tên, chưa chạy qua Capability
- **Không có Context Engine** — context build thủ công trong từng agent
- **Không có Event System** — không event-driven
- **Không có Artifact Manager** — artifact chỉ là file thường, không có checksum/version/object
- **Agent metadata thiếu** — agent.md chỉ là prompt, chưa có agent.yaml với contracts/constraints/token budget
- **Knowledge chưa đủ graph** — có index JSON nhưng chưa đủ confidence/references
- **Không có Simulation** — /team-simulate chưa tồn tại
- **Không có Extension System** — chưa cài plugin từ ngoài
- **Không có Observability Dashboard** — only logs/rắn report