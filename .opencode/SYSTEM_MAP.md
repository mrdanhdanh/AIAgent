# He Thong .opencode - So Do Tong The

> **Tu dong tao luc:** 2026-08-01 10:00:33
> **Workflow ID:** WF-20260801-SYNC
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
|-- agents/           # 17 agent definitions
|-- commands/         # 33 command templates
|-- skills/           # 17 skill packages
|-- scripts/          # 7 utility scripts
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
| failure-agent | Chuyên gia phân tích và chuẩn hóa lỗi — classify error type, normalize error message, search failure memory, đề xuất lesson phù hợp. Read-only agent. | opencode/deepseek-v4-flash-free |  | team-analyze-failure |
| general | General-purpose orchestrator agent — điều phối workflow, triệu hồi sub-agents, quản lý state machine | opencode/deepseek-v4-flash-free |  | team-syncdocs, test-bootstrap, team-doctor, test-e2e, test-cross-browser, doctor-test, approve-test, doctor, team |
| guardian | Chuyên gia review source code trước khi push lên git — phát hiện secret, lỗi convention, lỗ hổng bảo mật, vi phạm quy tắc dự án | opencode/deepseek-v4-flash-free |  | team-gitguard |
| learning-agent | Chuyên gia Learning Pipeline — đọc failure records từ memory, phân tích patterns xuyên suốt, auto-generate lessons và patterns mới. Ghi trực tiếp vào memory/. Cần approval gate cho MEDIUM/HIGH impact. | opencode/deepseek-v4-flash-free |  | team-learn |
| planner | Mở rộng: Thiết kế giải pháp + Lập kế hoạch thực thi chi tiết. Đảm nhiệm cả Design phase và Plan phase. | opencode/deepseek-v4-flash-free |  | team-plan |
| pusher | Chuyên gia thực hiện git push an toàn — auto-commit từ diff, safety checks, build, test, confirmation gate, push execution, post-push verify | opencode/deepseek-v4-flash-free |  | team-gitpush |
| reviewer | Đánh giá kế hoạch thực thi, kiểm tra tính đúng đắn, đầy đủ và hiệu quả | opencode/deepseek-v4-flash-free |  | team-review |
| root-cause-agent | Chuyên gia phân tích nguyên nhân gốc (Root Cause Analysis) — nhận error đã normalized, tìm kiếm trong codebase, tạo hypotheses với confidence score, đề xuất hướng fix. Agent read + suggest. | opencode/deepseek-v4-flash-free |  | team-root-cause |
| self-improver | Sau khi workflow hoàn tất, đọc lại quá trình, phân tích kỹ năng đã dùng và thiếu, đề xuất cải tiến (chỉ suggestion, không ghi KB). Cần qua approval gate trước khi ghi knowledge base. | opencode/deepseek-v4-flash-free |  | team-selfimprove |
| tester | Thực thi kiểm thử, validate tính năng và báo cáo kết quả kèm coverage (v3.0) | opencode/deepseek-v4-flash-free |  | team-test |
| test-planner | Tạo kế hoạch kiểm thử chi tiết, chống overlap, có impact analysis, coverage matrix, risk-based testing | opencode/deepseek-v4-flash-free |  | test-regression, team-testplan, test-plan, test-audit, test-evolve |
| ui-beautifier | >- | opencode/deepseek-v4-flash-free |  | test-accessibility, test-visual, team-ui-audit, impeccable, test-ui |

---

## Commands

| Command | Description | Agent | Deprecated |
|---------|-------------|-------|------------|
| /approve-test | Approve Test Gate — gate cuối trước merge. Chặn nếu coverage < 80%, flaky, accessibility error, visual diff, failed E2E, broken responsive, missing critical scenario | general |  |
| /backup | Backup và rollback file dùng Backup Utility. Gọi khi cần backup trước khi sửa file, rollback lỗi, kiểm tra backup. | backup-agent |  |
| /doctor | Doctor — kiểm tra sức khỏe hệ thống AI Agent Framework: Environment, Agents, Commands, Skills, Knowledge, Workflow, Contracts, Runtime (simulation), Capability (benchmark). Tích hợp health score, self-repair an toàn. Dùng /doctor hoặc /team-doctor. | general |  |
| /doctor-test | QA Doctor — kiểm tra sức khỏe bộ test: thiếu test, duplicate, flaky, timeout, coverage thấp, screenshot cũ, selector dễ hỏng, hardcode wait, missing assertion, missing cleanup, dead test, orphan page object. Health Score + Risk | general |  |
| /impeccable | Design, redesign, shape, critique, audit, polish, or improve frontend UI. Sub-commands: init, shape, document, critique, audit, polish, bolder, quieter, distill, harden, onboard, animate, colorize, typeset, layout, delight, overdrive, clarify, adapt, optimize, live, hooks, doctor, extract. | ui-beautifier |  |
| /team | Chạy toàn bộ team workflow: analyze → design/plan → review → backup → build → static analysis → ui audit → testplan → test → skill validation → complete | general |  |
| /team-analyze | Chỉ chạy bước phân tích yêu cầu (dùng agent analyst) | analyst |  |
| /team-analyze-failure | Phân tích lỗi trong workflow. Thu thập raw error, normalize, classify, search failure memory, output phân tích. Gọi failure-agent. | failure-agent |  |
| /team-build | Thực thi kế hoạch đã duyệt (dùng agent builder) | builder |  |
| /team-cleanup | Dọn rác Workspace tự động — xóa build artifacts, backup cũ, temp files, cache. Tích hợp dry-run, backup trước khi xóa, confirmation gate. | cleaner |  |
| /team-doctor | Doctor (alias /team-doctor) — kiểm tra sức khỏe hệ thống AI Agent Framework. Tương đương /doctor: Environment, System, Runtime, Capability, health score, self-repair an toàn. | general |  |
| /team-explore | [DEPRECATED] Explore step đã được gộp vào Analyze. Dùng team-analyze thay thế. | codebase-explorer | Yes |
| /team-gitguard | Review source code trước khi push lên git — phát hiện secret, lỗi convention, lỗ hổng bảo mật, vi phạm quy tắc dự án | guardian |  |
| /team-gitpush | Auto-commit từ diff, pre-push safety validation + git push execution — kiểm tra secret, convention, build, test, xác nhận user, push lên remote | pusher |  |
| /team-learn | Chạy Learning Pipeline — quét failure records, auto-generate lessons và patterns, cập nhật memory. Gọi learning-agent. | learning-agent |  |
| /team-plan | Mở rộng: Thiết kế (Design) + Lập kế hoạch (Plan) — dùng agent planner | planner |  |
| /team-review | Đánh giá thiết kế hoặc kế hoạch (dùng agent reviewer) — nâng cấp v4.0: decision thresholds, score_rationale, blocking issues, consistency, edge cases | reviewer |  |
| /team-root-cause | Phân tích nguyên nhân gốc từ failure analysis. Tìm evidence trong codebase, tạo hypotheses, đề xuất fix. Gọi root-cause-agent. | root-cause-agent |  |
| /team-selfimprove | Phân tích workflow và đề xuất cải tiến (chỉ suggestion, không ghi KB) | self-improver |  |
| /team-syncdocs | System Evolution Engine — đồng bộ system docs + semantic diff + compatibility check + migration + self-healing + health score + simulation (runtime validation) + capability benchmark + stress test + evolution report. Chạy định kỳ để duy trì sức khỏe hệ thống. | general |  |
| /team-test | Thực thi kiểm thử theo kế hoạch (dùng agent tester, v3.0) | tester |  |
| /team-testplan | Tạo kế hoạch kiểm thử chi tiết — impact analysis, risk-based, validation rules (schema v3.0) | test-planner |  |
| /team-ui-audit | >- | ui-beautifier |  |
| /test-accessibility | Accessibility testing — Run Axe → Generate Report → Fix Suggestion. Tích hợp skill accessibility | ui-beautifier |  |
| /test-audit | Audit chất lượng tổng thể bộ test — coverage theo chức năng, duplication, maintainability, thời gian chạy, flaky rate → kế hoạch cải thiện theo ưu tiên | test-planner |  |
| /test-bootstrap | Bootstrap QA — phân tích dự án (Blazor, React, Angular...), tự phát hiện framework UI, route structure, sinh cấu hình Playwright + Page Object + Fixture + thư mục test ban đầu | general |  |
| /test-cross-browser | Cross-browser testing — Chrome, Edge, Firefox, Safari + iPhone/Android. Tích hợp skill browser-compatibility | general |  |
| /test-e2e | Chạy pipeline E2E — Requirement → Playwright → Fixture → Run → Report. Sinh test Playwright tự động theo skill playwright-e2e | general |  |
| /test-evolve | Evolve test suite — so sánh thay đổi source code với test hiện có, xác định test cần cập nhật, test lỗi thời, sinh test mới cho chức năng mới | test-planner |  |
| /test-plan | Sinh toàn bộ kế hoạch test — Requirement → Test Matrix → Scenario → Boundary → Edge Case → Priority | test-planner |  |
| /test-regression | Regression testing — tự động chọn module bị ảnh hưởng, sinh regression cases, chạy và báo cáo | test-planner |  |
| /test-ui | Review UI tổng hợp — đọc project, đánh giá UI/UX/Consistency/Responsive/Accessibility. Tích hợp skills ui-review, design-system-validator, responsive-layout, accessibility | ui-beautifier |  |
| /test-visual | Visual regression testing — Take Screenshot → Compare → Generate Diff → Generate Report. Tích hợp skills visual-regression, screenshot-analyzer | ui-beautifier |  |

---

## Skills

| Skill | Name | Description | Schema Version |
|-------|------|-------------|----------------|
| accessibility | accessibility | Kiểm tra accessibility — ARIA, Tab Order, Screen Reader, Keyboard, Color Contrast, Alt, Label, Focus Ring. Sinh báo cáo WCAG AA/AAA. Sử dụng câu lệnh /test-accessibility. | 1.0 |
| browser-compatibility | browser-compatibility | Kiểm tra tương thích trình duyệt — Chrome, Edge, Firefox, Safari + iPhone/Android. Phát hiện API/code không tương thích. Sử dụng câu lệnh /test-cross-browser. | 1.0 |
| design-system-validator | design-system-validator | Kiểm tra source code tuân thủ Design System FluentUI — Primary/Secondary/Danger Button, Text Size, Border Radius, Elevation, Shadow, spacing tokens. Sử dụng câu lệnh /test-ui --validate. | 1.0 |
| dev-team | dev-team | Hướng dẫn sử dụng Dev Agent Team gồm 12 agents (10 core + 2 support). Dùng khi cần phân tích, lập kế hoạch, đánh giá, code, kiểm thử một yêu cầu phát triển. Tích hợp cơ chế Self-Improvement với approval gate, Failure Learning System với Root Cause Analysis và Learning Pipeline. Sử dụng câu lệnh team hoặc team-*. | 3.2 |
| flaky-test-detector | flaky-test-detector | Phân tích test flaky — retry, timeout, animation, network, wait, race condition. Đưa ra nguyên nhân gốc và cách khắc phục. Sử dụng trong /doctor-test, /test-audit. | 1.0 |
| gitguard | gitguard | Review source code trước khi push lên git — phát hiện secret, lỗi convention, lỗ hổng bảo mật, vi phạm quy tắc dự án. Tích hợp cơ chế blocking CRITICAL, cảnh báo MAJOR. Sử dụng câu lệnh /team-gitguard. | 2.0 |
| gitpush | gitpush | Pre-push safety validation + git push execution — kiểm tra secret, convention, build, test, sau đó push lên remote với xác nhận từ user. Sử dụng câu lệnh /team-gitpush. | 1.0 |
| impeccable | impeccable | Use when the user wants to design, redesign, shape, critique, audit, polish, clarify, distill, harden, optimize, adapt, animate, colorize, extract, or otherwise improve a frontend interface. Covers websites, landing pages, dashboards, product UI, app shells, components, forms, settings, onboarding, and empty states. Handles UX review, visual hierarchy, information architecture, cognitive load, accessibility, performance, responsive behavior, theming, anti-patterns, typography, fonts, spacing, layout, alignment, color, motion, micro-interactions, UX copy, error states, edge cases, i18n, and reusable design systems or tokens. Also use for bland designs that need to become bolder or more delightful, loud designs that should become quieter, live browser iteration on UI elements, or ambitious visual effects that should feel technically extraordinary. Not for backend-only or non-UI tasks. | 1.0 |
| playwright-component | playwright-component | Sinh test component-level cho FluentUI — button, textbox, dropdown, dialog, grid, form. Kiểm tra validation, keyboard, focus, tab order, shortcut. Dùng bUnit cho Blazor component. Sử dụng câu lệnh /test-e2e kèm --component. | 1.0 |
| playwright-e2e | playwright-e2e | Sinh test E2E Playwright hoàn chỉnh — Playwright Test, Page Object, Test Fixture, Mock API, Login Helper. Input: Screen/API/Requirement. Output: tests/, page-object/, fixtures/. Sử dụng câu lệnh /test-e2e. | 1.0 |
| responsive-layout | responsive-layout | Kiểm tra layout responsive — viewports 320/375/768/1024/1366/1920, overflow, horizontal scroll, hidden control, broken layout, flex, grid. Sử dụng câu lệnh /test-ui --responsive. | 1.0 |
| screenshot-analyzer | screenshot-analyzer | Đọc và phân tích screenshot — layout, alignment, color, missing icon, wrong font, blur, cropped, wrong spacing. Hỗ trợ Vision Model. Sử dụng câu lệnh /test-visual --analyze. | 1.0 |
| test-data-generator | test-data-generator | Sinh dữ liệu test — User, Customer, Order, Invoice, Large Dataset, Boundary Value, Invalid Data, Random Data. Không dùng credential/secret thật. Sử dụng trong /test-e2e, /test-plan. | 1.0 |
| test-report | test-report | Sinh báo cáo kiểm thử — HTML, Markdown, JSON, JUnit, Allure. Gồm coverage, failed, passed, skipped, screenshot, video, trace. Sử dụng trong /test-e2e, /doctor-test, /approve-test. | 1.0 |
| ui-review | ui-review | Đánh giá UI tĩnh (không chạy code) — đọc HTML, Razor, CSS, Tailwind, FluentUI. Kiểm tra spacing, padding, margin, alignment, font, icon, white space, consistency. Sử dụng câu lệnh /test-ui. | 1.0 |
| visual-regression | visual-regression | Visual regression testing — expect(page).toHaveScreenshot(), multi-viewport (Desktop/Tablet/Mobile/Dark/Light), pixel diff, threshold, ignore animation và dynamic content. Sử dụng câu lệnh /test-visual. | 1.0 |
| workspace-cleaner | workspace-cleaner | Dọn rác Workspace tự động — xóa build artifacts, backup cũ, temp files, cache không cần thiết. Tích hợp dry-run bắt buộc, backup trước khi xóa, confirmation gate, protected list cấu trúc, và output contract chi tiết. Sử dụng câu lệnh /team-cleanup. | 2.1 |

---

## Scripts

| Script | Summary | Size |
|--------|---------|------|
| backup-utility | Backup Utility — backup, list và verify snapshot trước khi sửa file. | 13 KB |
| cross-ref-validator | Cross-Reference Validator — kiểm tra tham chiếu chéo trong .opencode (agents, commands, skills, contracts). | 6 KB |
| doctor | Doctor v2.0 - System health checker for AI Agent Framework | 9 KB |
| gitpush-utility | GitPush Utility — thực hiện git push an toàn với auto-commit, safety checks, confirmation gate. | 18 KB |
| rollback-utility | Rollback Utility — rollback file từ backup snapshot khi catastrophic failure. | 9 KB |
| schema-validator | Schema Validator — validate YAML schema của agent definitions. | 5 KB |
| sync-system-docs | System Docs Sync — đồng bộ system docs + System Evolution Engine (9 engines). | 50 KB |

---

## Knowledge Base

| File | Size |
|------|------|
| knowledge/framework\blazor\component-lifecycle.md | 3 KB |
| knowledge/framework\fluentu\design-tokens.md | 1 KB |
| knowledge/framework\fluentu\fluentu.md | 1 KB |
| knowledge/lessons.md | 19 KB |
| knowledge/patterns\localstorage.md | 1 KB |
| knowledge/patterns\seed-data-patterns.md | 1 KB |
| knowledge/project\japanese-learner\deployment.md | 4 KB |
| knowledge/README.md | 2 KB |
| knowledge/skills\blazor\patterns.md | 5 KB |
| knowledge/skills\blazor\ui.md | 4 KB |
| knowledge/skills-learned.md | 14 KB |
| knowledge/testing\playwright-e2e.md | 2 KB |
| knowledge/testing\xunit-bunit-testing.md | 1 KB |
| knowledge/ui\dark-mode-theming.md | 1 KB |
| knowledge/ui\design-system-tokens.md | 5 KB |
| knowledge/ui\fluentui-components.md | 1 KB |
| knowledge/ui\tri-state-rendering.md | 1 KB |
| knowledge/workflow\validate-github-actions-yaml.md | 1 KB |

---

## Ma tran Cross-Reference

### Command -> Agent Mapping

| Command | Agent | Agent File |
|---------|-------|------------|
| /team | general | commands/team.md |
| /team-syncdocs | general | commands/team-syncdocs.md |
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
| general | team-syncdocs, test-bootstrap, team-doctor, test-e2e, test-cross-browser, doctor-test, approve-test, doctor, team |
| guardian | team-gitguard |
| learning-agent | team-learn |
| planner | team-plan |
| pusher | team-gitpush |
| reviewer | team-review |
| root-cause-agent | team-root-cause |
| self-improver | team-selfimprove |
| tester | team-test |
| test-planner | test-regression, team-testplan, test-plan, test-audit, test-evolve |
| ui-beautifier | test-accessibility, test-visual, team-ui-audit, impeccable, test-ui |

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
| --- | OK | Khong phat hien van de. He thong dong bo hoan chinh. |

---

> **Tong so:** 17 agents . 33 commands . 17 skills . 7 scripts . 18 knowledge files
> **Sinh boi:** sync-system-docs.ps1
