# He Thong .opencode - So Do Tong The

> **Cap nhat luc:** 2026-07-31 (WF-20260731-001 - Doctor Agent)
> **Workflow ID:** WF-20260731-001
> **Cap nhat:** Them /doctor + /team-doctor (11 scripts), bo sung failure-agent, learning-agent, root-cause-agent, team-analyze-failure, team-learn, team-root-cause, cross-ref-validator, schema-validator

---

## Muc luc

- [Cau truc thu muc](#cau-truc-thu-muc)
- [Agents](#agents)
- [Commands](#commands)
- [Skills](#skills)
- [Scripts](#scripts)
- [Knowledge Base](#knowledge-base)
- [Ma tran Cross-Reference](#ma-tran-cross-reference)
- [Workflow Overview](#workflow-overview)
- [Phat hien van de](#phat-hien-van-de)

---

## Cau truc thu muc

```
.opencode/
|-- agents/           # 17 agent definitions
|-- commands/         # 21 command templates
|-- skills/           # 5 skill packages
|-- scripts/          # 7 utility scripts + doctor/ (10 modules)
|-- knowledge/        # Knowledge base
|-- backup/           # Backup artifacts
|-- workflow/         # Workflow artifacts
'-- workflows/        # Workflow snapshots
```

---

## Agents

| Agent | Description | Model | Permissions | Commands |
|-------|-------------|-------|-------------|----------|
| analyst | Phân tích yêu cầu người dùng, xác định phạm vi, rủi ro và các task cần thực hiện | opencode/deepseek-v4-flash-free |  | team-analyze |
| backup-agent | Backup và rollback file dùng Backup Utility. Hỗ trợ: backup trước khi sửa file, rollback khi catastrophic failure, liệt kê backup history, verify backup integrity. | opencode/deepseek-v4-flash-free |  | backup |
| builder | Thực thi kế hoạch đã được đánh giá, viết code và thực hiện thay đổi | opencode/deepseek-v4-flash-free |  | team-build |
| cleaner | Workspace Cleaner Agent v2.0 — quét rác theo tiêu chí cấu hình chi tiết, phân loại LOW/MEDIUM/HIGH, backup workflow-linked, dry-run bắt buộc, protected list 4 nhóm. | opencode/deepseek-v4-flash-free |  | team-cleanup |
| codebase-explorer | Khám phá cấu trúc dự án, phân tích codebase, mapping dependencies và patterns. Agent read-only chạy trước khi thực hiện thay đổi. | opencode/deepseek-v4-flash-free |  | team-explore |
| general | General-purpose orchestrator agent — điều phối workflow, triệu hồi sub-agents, quản lý state machine | opencode/deepseek-v4-flash-free |  | team, team-syncdocs, doctor, team-doctor |
| guardian | Chuyên gia review source code trước khi push lên git — phát hiện secret, lỗi convention, lỗ hổng bảo mật, vi phạm quy tắc dự án | default |  | team-gitguard |
| failure-agent | Failure Learning Agent — theo dõi failure history, trích xuất bài học, kích hoạt Root Cause Analysis khi lặp lại | opencode/deepseek-v4-flash-free |  | team-analyze-failure |
| learning-agent | Learning Agent — chốt bài học vào knowledge base (cần approval gate), quản lý learning pipeline | opencode/deepseek-v4-flash-free |  | team-learn |
| planner | Mở rộng: Thiết kế giải pháp + Lập kế hoạch thực thi chi tiết. Đảm nhiệm cả Design phase và Plan phase. | opencode/deepseek-v4-flash-free |  | team-plan |
| pusher | Chuyên gia thực hiện git push an toàn — auto-commit từ diff, safety checks, build, test, confirmation gate, push execution, post-push verify | default |  | team-gitpush |
| reviewer | Đánh giá kế hoạch thực thi, kiểm tra tính đúng đắn, đầy đủ và hiệu quả | opencode/deepseek-v4-flash-free |  | team-review |
| root-cause-agent | Root Cause Analysis Agent — phân tích nguyên nhân gốc failure, đệ trình đề xuất khắc phục (chỉ suggestion) | opencode/deepseek-v4-flash-free |  | team-root-cause |
| self-improver | Sau khi workflow hoàn tất, đọc lại quá trình, phân tích kỹ năng đã dùng và thiếu, đề xuất cải tiến (chỉ suggestion, không ghi KB). Cần qua approval gate trước khi ghi knowledge base. | opencode/deepseek-v4-flash-free |  | team-selfimprove |
| tester | Thực thi kiểm thử, validate tính năng và báo cáo kết quả kèm coverage | opencode/deepseek-v4-flash-free |  | team-test |
| test-planner | Tạo kế hoạch kiểm thử chi tiết cho tính năng đã phát triển | opencode/deepseek-v4-flash-free |  | team-testplan |
| ui-beautifier | >- | opencode/deepseek-v4-flash-free |  | team-ui-audit |

---

## Commands

| Command | Description | Agent | Deprecated |
|---------|-------------|-------|------------|
| /backup | Backup và rollback file dùng Backup Utility. Gọi khi cần backup trước khi sửa file, rollback lỗi, kiểm tra backup. | backup-agent |  |
| /doctor | Doctor Agent — kiểm tra sức khỏe toàn hệ thống AI Agent Framework: Environment, Agents, Commands, Skills, Knowledge, Workflow, Contracts, Runtime (simulation), Capability (benchmark). Health score + self-repair an toàn. Modes: quick/full/runtime/workflow/agent/skill/command/knowledge/contracts/simulation/benchmark/repair. | general |  |
| /impeccable | Design, redesign, shape, critique, audit, polish, or improve frontend UI. Sub-commands: init, shape, document, critique, audit, polish, bolder, quieter, distill, harden, onboard, animate, colorize, typeset, layout, delight, overdrive, clarify, adapt, optimize, live, hooks, doctor, extract. | --- |  |
| /team | Chạy toàn bộ team workflow: analyze → design/plan → review → backup → build → static analysis → ui audit → testplan → test → skill validation → complete | general |  |
| /team-analyze | Chỉ chạy bước phân tích yêu cầu (dùng agent analyst) | analyst |  |
| /team-analyze-failure | Phân tích failure history, trích xuất bài học, kích hoạt Root Cause Analysis khi lỗi lặp lại (dùng agent failure-agent) | failure-agent |  |
| /team-build | Thực thi kế hoạch đã duyệt (dùng agent builder) | builder |  |
| /team-cleanup | Dọn rác Workspace tự động — xóa build artifacts, backup cũ, temp files, cache. Tích hợp dry-run, backup trước khi xóa, confirmation gate. | cleaner |  |
| /team-doctor | Alias của /doctor — Doctor Agent kiểm tra sức khỏe hệ thống. | general |  |
| /team-explore | [DEPRECATED] Explore step đã được gộp vào Analyze. Dùng team-analyze thay thế. | codebase-explorer | Yes |
| /team-gitguard | Review source code trước khi push lên git — phát hiện secret, lỗi convention, lỗ hổng bảo mật, vi phạm quy tắc dự án | guardian |  |
| /team-gitpush | Auto-commit từ diff, pre-push safety validation + git push execution — kiểm tra secret, convention, build, test, xác nhận user, push lên remote | pusher |  |
| /team-learn | Learning Agent — chốt bài học từ failure/workflow vào knowledge base qua approval gate, quản lý learning pipeline | learning-agent |  |
| /team-plan | Mở rộng: Thiết kế (Design) + Lập kế hoạch (Plan) — dùng agent planner | planner |  |
| /team-review | Đánh giá thiết kế hoặc kế hoạch (dùng agent reviewer) — nâng cấp v4.0: decision thresholds, score_rationale, blocking issues, consistency, edge cases | reviewer |  |
| /team-root-cause | Root Cause Analysis — phân tích nguyên nhân gốc failure, đệ trình đề xuất khắc phục (chỉ suggestion, không tự sửa) | root-cause-agent |  |
| /team-selfimprove | Phân tích workflow và đề xuất cải tiến (chỉ suggestion, không ghi KB) | self-improver |  |
| /team-syncdocs | Đồng bộ toàn bộ system docs: quét agents, commands, skills, scripts, knowledge → cập nhật SYSTEM_MAP.md, cross-references, fix lỗi. Chạy định kỳ khi thêm/sửa/xóa file hệ thống. | general |  |
| /team-test | Thực thi kiểm thử theo kế hoạch (dùng agent tester) | tester |  |
| /team-testplan | Tạo kế hoạch kiểm thử cho tính năng (dùng agent test-planner) | test-planner |  |
| /team-ui-audit | >- | ui-beautifier |  |

---

## Skills

| Skill | Name | Description | Schema Version |
|-------|------|-------------|----------------|
| dev-team | dev-team | Hướng dẫn sử dụng Dev Agent Team gồm 9 agents (7 core + 2 support). Dùng khi cần phân tích, lập kế hoạch, đánh giá, code, kiểm thử một yêu cầu phát triển. Tích hợp cơ chế Self-Improvement với approval gate. Sử dụng câu lệnh team hoặc team-*. | 3.2 |
| gitguard | gitguard | Review source code trước khi push lên git — phát hiện secret, lỗi convention, lỗ hổng bảo mật, vi phạm quy tắc dự án. Tích hợp cơ chế blocking CRITICAL, cảnh báo MAJOR. Sử dụng câu lệnh /team-gitguard. | 2.0 |
| gitpush | gitpush | Pre-push safety validation + git push execution — kiểm tra secret, convention, build, test, sau đó push lên remote với xác nhận từ user. Sử dụng câu lệnh /team-gitpush. | 1.0 |
| impeccable | impeccable | Use when the user wants to design, redesign, shape, critique, audit, polish, clarify, distill, harden, optimize, adapt, animate, colorize, extract, or otherwise improve a frontend interface. Covers websites, landing pages, dashboards, product UI, app shells, components, forms, settings, onboarding, and empty states. Handles UX review, visual hierarchy, information architecture, cognitive load, accessibility, performance, responsive behavior, theming, anti-patterns, typography, fonts, spacing, layout, alignment, color, motion, micro-interactions, UX copy, error states, edge cases, i18n, and reusable design systems or tokens. Also use for bland designs that need to become bolder or more delightful, loud designs that should become quieter, live browser iteration on UI elements, or ambitious visual effects that should feel technically extraordinary. Not for backend-only or non-UI tasks. |  |
| workspace-cleaner | workspace-cleaner | Dọn rác Workspace tự động — xóa build artifacts, backup cũ, temp files, cache không cần thiết. Tích hợp dry-run bắt buộc, backup trước khi xóa, confirmation gate, protected list cấu trúc, và output contract chi tiết. Sử dụng câu lệnh /team-cleanup. | 2.1 |

---

## Scripts

| Script | Summary | Size |
|--------|---------|------|
| backup-utility | Backup và rollback file dùng Backup Utility | 12 KB |
| cross-ref-validator | Kiểm tra consistency cross-reference agents/commands/skills | 4 KB |
| doctor | Doctor Agent orchestrator — dispatch theo -Mode, health score, JSON report | 9 KB |
| gitpush-utility | GitPush Utility — thực hiện git push an toàn với auto-commit, safety checks, confirmation gate. | 18 KB |
| rollback-utility | Rollback Utility | 9 KB |
| schema-validator | Validate schema agents/commands/skills | 4 KB |
| sync-system-docs | Utility script (luu y: dang loi [switch]$report - can fix) | 24 KB |

### scripts/doctor/ (10 modules)

| Module | Chuc nang |
|--------|-----------|
| environment | 13 checks moi truong (git, dotnet, node, opencode, duong dan...) |
| agents | Kiem tra 17 agent definitions (frontmatter, permissions, references) |
| commands | Kiem tra 21 command files (frontmatter, agent ton tai) |
| skills | Kiem tra 5 skill packages (SKILL.md, references) |
| workflows | Kiem tra workflow state machine, knowledge base, contracts |
| runtime | Runtime simulation (parse-check, dry-run scripts) |
| simulation | Invoke-DoctorSimulation — chay fake tasks do workflow stability |
| benchmark | Capability Benchmark — cham diem agent theo domain |
| repair | Invoke-DoctorRepair — sua an toan file bi loi (dry-run mac dinh) |
| report | New-DoctorReport — tong hop health score + suggestions + JSON report |

---

## Knowledge Base

| File | Size |
|------|------|
| knowledge/README.md | new |
| knowledge/lessons.md | 17 KB |
| knowledge/skills-learned.md | 11 KB |
| knowledge/framework/blazor/component-lifecycle.md | migrated |
| knowledge/skills/blazor/ui.md | migrated |
| knowledge/skills/blazor/patterns.md | migrated |
| knowledge/project/japanese-learner/deployment.md | migrated |
| knowledge/workflow/validate-github-actions-yaml.md | 1 KB |

---

## Ma tran Cross-Reference

### Command -> Agent Mapping

| Command | Agent | Agent File |
|---------|-------|------------|
| /team | general | commands/team.md |
| /team-syncdocs | general | commands/team-syncdocs.md |
| /doctor | general | commands/doctor.md |
| /team-doctor | general | commands/team-doctor.md |
| /team-analyze | analyst | agents/analyst.md |
| /team-analyze-failure | failure-agent | agents/failure-agent.md |
| /team-plan | planner | agents/planner.md |
| /team-review | reviewer | agents/reviewer.md |
| /team-build | builder | agents/builder.md |
| /team-ui-audit | ui-beautifier | agents/ui-beautifier.md |
| /team-testplan | test-planner | agents/test-planner.md |
| /team-test | tester | agents/tester.md |
| /team-selfimprove | self-improver | agents/self-improver.md |
| /team-gitguard | guardian | agents/guardian.md |
| /team-gitpush | pusher | agents/pusher.md |
| /team-cleanup | cleaner | agents/cleaner.md |
| /team-learn | learning-agent | agents/learning-agent.md |
| /team-root-cause | root-cause-agent | agents/root-cause-agent.md |
| /backup | backup-agent | commands/backup.md |

### Agent -> Commands

| Agent | Commands |
|-------|----------|
| analyst | team-analyze |
| backup-agent | backup |
| builder | team-build |
| cleaner | team-cleanup |
| codebase-explorer | team-explore |
| failure-agent | team-analyze-failure |
| general | team, team-syncdocs, doctor, team-doctor |
| guardian | team-gitguard |
| learning-agent | team-learn |
| planner | team-plan |
| pusher | team-gitpush |
| reviewer | team-review |
| root-cause-agent | team-root-cause |
| self-improver | team-selfimprove |
| tester | team-test |
| test-planner | team-testplan |
| ui-beautifier | team-ui-audit |

---

## Workflow Overview

```
                    +---------+
                    |  START  |
                    +----+----+
                         |
                         v
                    +---------+
                    |ANALYZE  |
                    +----+----+
                         |
                         v
                    +---------+
                    | DESIGN  |
                    +----+----+
                         |
                         v
                    +---------+
                    |  PLAN   |
                    +----+----+
                         |
                         v
                    +---------+
                    | REVIEW  |
                    +----+----+
                    +----+----+
                    |         |
                    v         v
             +---------+  +--------------+
             |APPROVED |  |CHANGES_REQ   |
             +----+----+  +------+-------+
                  |              |
                  v              v
             +---------+   +---------+
             | BACKUP  |   |  PLAN   |
             +----+----+   +---------+
                  |
                  v
             +---------+
             |  BUILD  |
             +----+----+
                  |
                  v
             +-------+----+
             | STATIC ANALYSIS |
             +-----+------+
                   |
                   v
             +-------+----+
             |  UI AUDIT  |
             +-----+------+
                   |
                   v
             +---------+
             | TESTPLAN|
             +----+----+
                   |
                   v
             +---------+
             |  TEST   |
             +----+----+
              +---+---+
              |       |
              v       v
          +--------+ +--------+
          | PASS   | | FAIL   |
          +---+----+ +--------+
              |
         +-----------+
         |SELF_IMPRV.|
         +-----+-----+
               |
         +----------+
         | APPROVAL |
         +----+-----+
              |
       +------+------+
       |             |
       v             v
  +---------+  +---------+
  |COMPLETE |  |COMPLETE |
  +---------+  +---------+
```

### Buoc theo Command

| Buoc | Command | Agent | File |
|------|---------|-------|------|
| 1 | /team-analyze | analyst | commands/team-analyze.md |
| 2-3 | /team-plan | planner (m rong) | commands/team-plan.md |
| 4 | /team-review | reviewer | commands/team-review.md |
| 5 | Backup (utility) | --- | scripts/backup-utility.ps1 |
| 6 | /team-build | builder | commands/team-build.md |
| 7 | Static Analysis | --- | skills/dev-team/SKILL.md |
| 8 | /team-ui-audit | ui-beautifier | commands/team-ui-audit.md |
| 9 | /team-testplan | test-planner | commands/team-testplan.md |
| 10 | /team-test | tester | commands/team-test.md |
| 11 | /team-selfimprove | self-improver | commands/team-selfimprove.md |
| 12 | /team-gitpush | pusher | commands/team-gitpush.md |

### Pre/Post Steps

| Step | Command | Agent | File |
|------|---------|-------|------|
| Pre-push | /team-gitguard | guardian | commands/team-gitguard.md |
| Cleanup | /team-cleanup | cleaner | skills/workspace-cleaner/SKILL.md |
| Backup | /backup | backup-agent | commands/backup.md |

---

## Phat hien van de

| # | Loai | Chi tiet |
|---|------|----------|
| 1 | BUG (pre-existing) | scripts/sync-system-docs.ps1: `[switch]$report` (line 11) trung ten bien `$report = @{}` (line 17) -> script khong chay duoc ("Cannot create object of type SwitchParameter"). Can doi ten param thanh `$evolutionReport`. Duoc phat hien boi /doctor (WF-20260731-001). |
| 2 | WARN | knowledge/README.md chua co noi dung thuc su (new), knowledge/skills/blazor/ui.md + patterns.md dang o trang thai migrated. |

---

> **Tong so:** 17 agents . 21 commands . 5 skills . 7 scripts + 10 doctor modules . 8 knowledge files
> **Sinh boi:** sync-system-docs.ps1 (cap nhat thu cong lan cuoi: WF-20260731-001 vi script dang loi)
