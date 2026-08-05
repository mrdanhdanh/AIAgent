---
phase: 01_analyze
agent: analyst
workflow_id: WF-20260731-001
status: READY
schema_version: "3.2"
---

# 01 — Analysis: Command "Doctor" cho AI Agent Framework

## Summary

Yêu cầu tạo một command `Doctor` cho OpenCode — kiểm tra sức khỏe toàn bộ hệ sinh thái
AI Agent Framework (`.opencode/`). Không clone y nguyên `claude doctor` (vốn chỉ kiểm tra
môi trường: NodeJS, permissions, MCP, terminal), mà mở rộng để kiểm tra cả hệ sinh thái
Agent: Environment, System (agents/commands/skills/knowledge/workflow/contracts), Runtime
(simulation), Capability (benchmark). Tích hợp health score, self-repair và suggested actions.

Hiện trạng hệ thống (đã khảo sát):
- 17 agents trong `.opencode/agents/` (analyst, planner, reviewer, builder, test-planner, tester, ...)
- 19 commands trong `.opencode/commands/` (team, team-analyze, team-build, team-syncdocs, ...)
- 5 skills trong `.opencode/skills/` (dev-team, gitguard, gitpush, impeccable, workspace-cleaner)
- Scripts: backup-utility.ps1, rollback-utility.ps1, sync-system-docs.ps1, cross-ref-validator.ps1,
  schema-validator.ps1, gitpush-utility.ps1 + `scripts/evolution/` (7 engines)
- Contract registry: `.opencode/system/contracts/` (planner, builder, reviewer, tester, workflow)
- Knowledge base: `.opencode/knowledge/` + `memory/` (failures, lessons, patterns)
- `opencode.json` đăng ký 17 agents + 19 commands
- `SYSTEM_MAP.md`, `SYSTEM_EVOLUTION_REPORT.md` tồn tại

Chưa có: `doctor.md`, `doctor.ps1`, `scripts/doctor/`, health-check command chuyên dụng.
`team-syncdocs` đã có health-score engine (8 categories) nhưng không phải là command kiểm tra
sức khỏe độc lập như Doctor yêu cầu.

## Requirements

- [REQ-1] Tạo command `/doctor` (và alias `/team-doctor`) gọi được từ OpenCode
- [REQ-2] 4 pillars kiểm tra: Environment, System, Runtime, Capability
- [REQ-3] 12 modes: `--quick`, `--full`, `--runtime`, `--workflow`, `--agent`, `--skill`,
  `--command`, `--knowledge`, `--contracts`, `--simulation`, `--benchmark`, `--repair`
- [REQ-4] Environment check: OpenCode version, agent/command/skill folders, scripts, PowerShell,
  Python, Git, model config, API config, permissions, knowledge folders, contract registry
- [REQ-5] Agent check: YAML syntax, description, contract, permissions, dependencies, prompt size,
  output schema, deprecated fields, missing fields, circular dependency
- [REQ-6] Command check: syntax, agent mapping, flags, workflow, dependencies, output contract
- [REQ-7] Skill check: SKILL.md, version, dependencies, knowledge, compatibility, missing files,
  deprecated contents
- [REQ-8] Knowledge check: missing topics, deprecated frameworks, coverage, learning maturity,
  pending learning items
- [REQ-9] Workflow check: loop, missing step, dependency, contract mismatch, output mismatch,
  version mismatch
- [REQ-10] Runtime check (`--runtime`): giả lập fake task qua planner→builder→tester→reviewer
- [REQ-11] Simulation check (`--simulation`): giả lập Bug Fix, New Feature, Migration, Review,
  Testing, Refactoring → success rate
- [REQ-12] Capability check (`--benchmark`): chấm điểm năng lực agent theo domain
- [REQ-13] Self Repair (`--repair`): chỉ sửa lỗi an toàn (broken references, missing docs, wrong
  version, cross refs, typos, folder structure, SYSTEM_MAP, contract mappings). KHÔNG sửa agent
  prompts, skills, workflows, knowledge trừ khi `--force`
- [REQ-14] Health Score: Environment, Agents, Commands, Skills, Knowledge, Workflow, Compatibility,
  Runtime, Learning → OVERALL /100
- [REQ-15] Suggested Actions: HIGH / MEDIUM / LOW priority
- [REQ-16] Folder structure theo spec:
  `commands/doctor.md`, `scripts/doctor.ps1`, `scripts/doctor/{environment,agents,skills,commands,
  workflows,runtime,benchmark,simulation,repair,report}.ps1`
- [REQ-17] Phân biệt rõ Doctor vs SyncDocs (bảng so sánh trong command doc)

## Task Breakdown

| # | Task | Files |
|---|------|-------|
| T1 | Tạo command doc chính | CREATE `.opencode/commands/doctor.md` |
| T2 | Tạo alias command doc | CREATE `.opencode/commands/team-doctor.md` |
| T3 | Tạo orchestrator script | CREATE `.opencode/scripts/doctor.ps1` |
| T4 | Tạo module environment check | CREATE `.opencode/scripts/doctor/environment.ps1` |
| T5 | Tạo module agent check | CREATE `.opencode/scripts/doctor/agents.ps1` |
| T6 | Tạo module command check | CREATE `.opencode/scripts/doctor/commands.ps1` |
| T7 | Tạo module skill check | CREATE `.opencode/scripts/doctor/skills.ps1` |
| T8 | Tạo module workflow + knowledge + contracts check | CREATE `.opencode/scripts/doctor/workflows.ps1` |
| T9 | Tạo module runtime simulation | CREATE `.opencode/scripts/doctor/runtime.ps1` |
| T10 | Tạo module simulation engine | CREATE `.opencode/scripts/doctor/simulation.ps1` |
| T11 | Tạo module benchmark | CREATE `.opencode/scripts/doctor/benchmark.ps1` |
| T12 | Tạo module repair | CREATE `.opencode/scripts/doctor/repair.ps1` |
| T13 | Tạo module report | CREATE `.opencode/scripts/doctor/report.ps1` |
| T14 | Đăng ký command trong opencode.json | MODIFY `opencode.json` |
| T15 | Cập nhật agent general (liệt kê doctor) | MODIFY `.opencode/agents/general.md` |
| T16 | Cập nhật AGENTS.md (mục lục command) | MODIFY `AGENTS.md` |
| T17 | Đồng bộ SYSTEM_MAP + cross-references | MODIFY `.opencode/SYSTEM_MAP.md` (chạy sync) |

## Risks

- **R1 (MEDIUM)** — `opencode.json` là cấu hình nhạy cảm: sai JSON → OpenCode không load được.
  Mitigation: validate JSON trước/sau khi sửa (ConvertFrom-Json), backup trước.
- **R2 (MEDIUM)** — 11 scripts PowerShell phức tạp: dễ syntax error. Mitigation: validate parse
  bằng PowerShell Parser API trước khi kết thúc build; test chạy thật `doctor.ps1 -Mode quick`.
- **R3 (LOW)** — Environment-dependent: python/git/dotnet version detection phụ thuộc máy.
  Mitigation: mọi check phải fail-safe (không throw khi thiếu tool), trả WARNING thay vì ERROR.
- **R4 (LOW)** — `--repair` có thể sửa nhầm file. Mitigation: backup trước mỗi repair, chỉ sửa
  target an toàn, `--dry-run` bắt buộc hiển thị trước.
- **R5 (LOW)** — Sync SYSTEM_MAP bằng script có thể đè format thủ công. Mitigation: chạy
  sync-system-docs.ps1 chuẩn, kiểm tra output.
- **R6 (LOW)** — Quá nhiều check → report dài. Mitigation: mỗi module chỉ output checks cần
  thiết + issues; report tóm tắt theo pillar.

## Constraints

- Ngôn ngữ script: Windows PowerShell 5.1 (compatible — không dùng syntax PS7-only)
- Convention command doc: frontmatter YAML `description` + `agent`, cấu trúc HELP section
- Convention script: `<# .SYNOPSIS #>` header, `param()` khai báo rõ, output JSON/object
- Output contract YAML cho command doc
- Không phá vỡ workflow hiện tại (`team.md`, `team-syncdocs.md`)
- Model: `opencode/deepseek-v4-pro` (Planner/Architect/Reviewer/Analyst), `opencode/deepseek-v4-flash` (Coder/Tester/Routine)

## Output Schema (Analyst)

```yaml
status: READY
summary: "5 dòng mô tả"
requirements:
  - id: REQ-1
    description: "..."
    priority: HIGH|MEDIUM|LOW
    acceptance_criteria:
      - "..."
risks:
  - id: R1
    description: "..."
    severity: LOW|MEDIUM|HIGH
    mitigation: "..."
tasks:
  - id: T1
    description: "..."
    files:
      - action: CREATE|MODIFY|DELETE
        path: "..."
effort: LARGE
```
