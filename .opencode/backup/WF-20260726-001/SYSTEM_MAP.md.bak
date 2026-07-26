# He Thong .opencode - So Do Tong The

> **Tu dong tao luc:** 2026-07-26 09:54:26
> **Workflow ID:** WF-20260726-SYNC
> **Cap nhat:** Toan bo agents, commands, skills, scripts, knowledge

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
|-- agents/           # 12 agent definitions
|-- commands/         # 14 command templates
|-- skills/           # 4 skill packages
|-- scripts/          # 4 utility scripts
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
| builder | Thực thi kế hoạch đã được đánh giá, viết code và thực hiện thay đổi | opencode/deepseek-v4-flash-free |  | team-build |
| cleaner | Workspace Cleaner Agent — quét rác, phân loại, backup, dọn dẹp workspace tự động với dry-run và confirmation gate. | opencode/deepseek-v4-flash-free |  | --- |
| codebase-explorer | Khám phá cấu trúc dự án, phân tích codebase, mapping dependencies và patterns. Agent read-only chạy trước khi thực hiện thay đổi. | opencode/deepseek-v4-flash-free |  | team-explore |
| guardian | Chuyên gia review source code trước khi push lên git — phát hiện secret, lỗi convention, lỗ hổng bảo mật, vi phạm quy tắc dự án | default |  | team-gitguard |
| planner | Mở rộng: Thiết kế giải pháp + Lập kế hoạch thực thi chi tiết. Đảm nhiệm cả Design phase và Plan phase. | opencode/deepseek-v4-flash-free |  | team-plan |
| pusher | Chuyên gia thực hiện git push an toàn — auto-commit từ diff, safety checks, build, test, confirmation gate, push execution, post-push verify | default |  | team-gitpush |
| reviewer | Đánh giá kế hoạch thực thi, kiểm tra tính đúng đắn, đầy đủ và hiệu quả | opencode/deepseek-v4-flash-free |  | team-review |
| self-improver | Sau khi workflow hoàn tất, đọc lại quá trình, phân tích kỹ năng đã dùng và thiếu, đề xuất cải tiến (chỉ suggestion, không ghi KB). Cần qua approval gate trước khi ghi knowledge base. | opencode/deepseek-v4-flash-free |  | team-selfimprove |
| tester | Thực thi kiểm thử, validate tính năng và báo cáo kết quả kèm coverage | opencode/deepseek-v4-flash-free |  | team-test |
| test-planner | Tạo kế hoạch kiểm thử chi tiết cho tính năng đã phát triển | opencode/deepseek-v4-flash-free |  | team-testplan |
| ui-beautifier | Chuyên đánh giá và cải thiện giao diện người dùng cho Japanese Learner (Blazor WASM + FluentUI 4.14.3). Phân tích .razor files, phát hiện CSS issues, accessibility problems, và đề xuất cải tiến UI/UX. | opencode/deepseek-v4-flash-free |  | team-ui-audit |

---

## Commands

| Command | Description | Agent | Deprecated |
|---------|-------------|-------|------------|
| /backup | Backup và rollback file dùng Backup Utility. Gọi khi cần backup trước khi sửa file, rollback lỗi, kiểm tra backup. | backup-agent |  |
| /team | Cháº¡y toÃ n bá»™ team workflow: analyze â†’ design/plan â†’ review â†’ backup â†’ build â†’ smoke test â†’ testplan â†’ test â†’ self-improve | general |  |
| /team-analyze | Chỉ chạy bước phân tích yêu cầu (dùng agent analyst) | analyst |  |
| /team-build | Thực thi kế hoạch đã duyệt (dùng agent builder) | builder |  |
| /team-explore | [DEPRECATED] Explore step đã được gộp vào Analyze. Dùng team-analyze thay thế. | codebase-explorer | Yes |
| /team-gitguard | Review source code trước khi push lên git — phát hiện secret, lỗi convention, lỗ hổng bảo mật, vi phạm quy tắc dự án | guardian |  |
| /team-gitpush | Auto-commit từ diff, pre-push safety validation + git push execution — kiểm tra secret, convention, build, test, xác nhận user, push lên remote | pusher |  |
| /team-plan | Mở rộng: Thiết kế (Design) + Lập kế hoạch (Plan) — dùng agent planner | planner |  |
| /team-review | Đánh giá thiết kế hoặc kế hoạch (dùng agent reviewer) | reviewer |  |
| /team-selfimprove | Phân tích workflow và đề xuất cải tiến (chỉ suggestion, không ghi KB) | self-improver |  |
| /team-syncdocs | Đồng bộ toàn bộ system docs: quét agents, commands, skills, scripts, knowledge → cập nhật SYSTEM_MAP.md, cross-references, fix lỗi. Chạy định kỳ khi thêm/sửa/xóa file hệ thống. | general |  |
| /team-test | Thực thi kiểm thử theo kế hoạch (dùng agent tester) | tester |  |
| /team-testplan | Tạo kế hoạch kiểm thử cho tính năng (dùng agent test-planner) | test-planner |  |
| /team-ui-audit | Chạy UI audit trên toàn bộ .razor files — phát hiện CSS issues, accessibility problems, đề xuất cải tiến UI/UX | ui-beautifier |  |

---

## Skills

| Skill | Name | Description | Schema Version |
|-------|------|-------------|----------------|
| dev-team | dev-team | Hướng dẫn sử dụng Dev Agent Team gồm 9 agents (7 core + 2 support). Dùng khi cần phân tích, lập kế hoạch, đánh giá, code, kiểm thử một yêu cầu phát triển. Tích hợp cơ chế Self-Improvement với approval gate. Sử dụng câu lệnh team hoặc team-*. | 2.0 |
| gitguard | gitguard | Review source code trước khi push lên git — phát hiện secret, lỗi convention, lỗ hổng bảo mật, vi phạm quy tắc dự án. Tích hợp cơ chế blocking CRITICAL, cảnh báo MAJOR. Sử dụng câu lệnh /team-gitguard. | 1.0 |
| gitpush | gitpush | Pre-push safety validation + git push execution — kiểm tra secret, convention, build, test, sau đó push lên remote với xác nhận từ user. Sử dụng câu lệnh /team-gitpush. | 1.0 |
| workspace-cleaner | workspace-cleaner | Dọn rác Workspace tự động — xóa build artifacts, backup cũ, temp files, cache không cần thiết. Tích hợp dry-run, backup trước khi xóa, confirmation gate. Sử dụng câu lệnh /team-cleanup. | 1.0 |

---

## Scripts

| Script | Summary | Size |
|--------|---------|------|
| backup-utility | Utility script | 1 KB |
| gitpush-utility | GitPush Utility — thực hiện git push an toàn với auto-commit, safety checks, confirmation gate. | 18 KB |
| rollback-utility | Utility script | 2 KB |
| sync-system-docs | Utility script | 23 KB |

---

## Knowledge Base

| File | Size |
|------|------|
| knowledge/blazor-ref-timing.md | 1 KB |
| knowledge/deployment\blazor-wasm-github-pages.md | 2 KB |
| knowledge/lessons.md | 11 KB |
| knowledge/patterns\common.md | 5 KB |
| knowledge/skills-learned.md | 9 KB |
| knowledge/workflow\validate-github-actions-yaml.md | 1 KB |

---

## Ma tran Cross-Reference

### Command -> Agent Mapping

| Command | Agent | Agent File |
|---------|-------|------------|
| /team-analyze | analyst | agents/analyst.md |
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
| /team-explore | codebase-explorer | agents/codebase-explorer.md |
| /backup | backup-agent | commands/backup.md |

### Agent -> Commands

| Agent | Commands |
|-------|----------|
| analyst | team-analyze |
| builder | team-build |
| cleaner | Orphaned |
| codebase-explorer | team-explore |
| guardian | team-gitguard |
| planner | team-plan |
| pusher | team-gitpush |
| reviewer | team-review |
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
             | SMOKE TEST |
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
| 7 | Smoke Test (orch.) | --- | SKILL.md |
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
| Explore | /team-explore (DEPR.) | codebase-explorer | commands/team-explore.md |
| Backup | /backup | backup-agent | commands/backup.md |

---

## Phat hien van de

| # | Loai | Chi tiet |
|---|------|----------|
| 1 | MISSING_AGENT | command=backup, agent=backup-agent |
| 2 | MISSING_AGENT | command=team, agent=general |
| 3 | MISSING_AGENT | command=team-syncdocs, agent=general |
| 4 | ORPHAN_AGENT | agent=cleaner |

---

> **Tong so:** 12 agents . 14 commands . 4 skills . 4 scripts . 6 knowledge files
> **Sinh boi:** sync-system-docs.ps1
