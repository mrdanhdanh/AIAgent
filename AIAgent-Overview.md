# AIAgent System — Tổng Quan

Hệ thống AIAgent trong dự án Japanese Learner, quản lý qua **OpenCode** với model `opencode/deepseek-v4-flash-free`.

---

## Kiến trúc

```
OpenCode CLI
   │
   ├── Orchestrator (General Agent)
   │     └── Điều phối workflow: gọi đúng agent, truyền context, quyết định bước tiếp
   │
   ├── 12 Sub-Agents  (.opencode/agents/)
   │     └── Mỗi agent chuyên biệt, có permission riêng (read/edit/bash)
   │
   ├── Skills          (.opencode/skills/)
   │     └── Hướng dẫn workflow phức tạp (dev-team, gitguard, gitpush, cleanup)
   │
   ├── Commands        (.opencode/commands/)
   │     └── Lệnh /team-* gọi agent riêng lẻ
   │
   └── Knowledge Base  (.opencode/knowledge/)
         └── Bài học, patterns từ workflow trước (qua Self-Improver + approval gate)
```

---

## Danh Sách Agents

| # | Agent | Permission | Vai trò chính | Gọi qua |
|---|-------|-----------|---------------|---------|
| 1 | **Analyst** | read-only | Phân tích yêu cầu, xác định phạm vi, rủi ro, task con | `/team-analyze` |
| 2 | **Codebase Explorer** | read-only | Khám phá cấu trúc dự án, mapping dependencies & patterns | Task tool (explore) |
| 3 | **Planner** | read-only | Thiết kế giải pháp (Design) + Lập kế hoạch thực thi (Plan) | `/team-plan` |
| 4 | **Reviewer** | read-only | Đánh giá kế hoạch theo 6 tiêu chí, quyết định APPROVED/CHANGES_REQUESTED/REJECTED | `/team-review` |
| 5 | **Builder** | edit + bash | Thực thi kế hoạch: viết code, tạo/sửa file, kiểm tra syntax | `/team-build` |
| 6 | **Test-Planner** | read-only | Tạo kế hoạch kiểm thử (unit, integration, e2e, edge, security...) | `/team-testplan` |
| 7 | **Tester** | bash (no edit) | Chạy test cases, ghi nhận PASS/FAIL/SKIP, tính coverage | `/team-test` |
| 8 | **UI Beautifier** | edit + bash | Đánh giá & cải thiện UI (CSS, accessibility, dark mode, FluentUI) | `/team-ui-audit` |
| 9 | **Guardian** | — | Review source code trước push: secret scan, convention, security, code quality | `/team-gitguard` |
| 10 | **Pusher** | — | Git push an toàn: auto-commit, build, test, confirmation gate | `/team-gitpush` |
| 11 | **Self-Improver** | edit + bash | Đọc workflow, đề xuất cải tiến (qua approval gate trước khi ghi KB) | — |
| 12 | **Cleaner** | — | Dọn rác workspace (bin/obj, backup cũ, temp) | `/team-cleanup` |

### Chi tiết từng Agent

**1. Analyst** — `.opencode/agents/analyst.md`
- Đọc codebase, phân tích yêu cầu, liệt kê task con và rủi ro
- Output: YAML contract (`status`, `summary`, `requirements`, `risks`, `tasks`)
- Read-only: không sửa file, không chạy bash

**2. Codebase Explorer** — `.opencode/agents/codebase-explorer.md`
- Khám phá cấu trúc, phân tích dependency tree, mapping patterns
- Output: YAML contract (`structure`, `dependencies`, `patterns`, `impact_scope`)
- Read-only: dùng glob/grep/read để phân tích

**3. Planner (mở rộng)** — `.opencode/agents/planner.md`
- **Design phase**: Kiến trúc, components, data flow, security, edge cases
- **Plan phase**: Steps chi tiết (mô tả, file, logic, check, chunk)
- Output: YAML contract (`design`, `steps`, `rollback_strategy`, `validate`)
- Read-only: không sửa file

**4. Reviewer** — `.opencode/agents/reviewer.md`
- 6 tiêu chí: Completeness, Accuracy, Safety, Efficiency, Testability, Edge Cases
- Quyết định: APPROVED / CHANGES_REQUESTED / REJECTED
- Output: YAML contract (`decision`, `scores`, `issues`)
- Read-only: chỉ đánh giá, không sửa

**5. Builder** — `.opencode/agents/builder.md`
- Thực thi code: tạo/sửa/xóa file theo kế hoạch đã duyệt
- Kiểm tra syntax/lint sau mỗi thay đổi
- Output: YAML contract (`status`, `steps`, `failure_type`)
- Có quyền edit + bash

**6. Test-Planner** — `.opencode/agents/test-planner.md`
- Xác định loại test (unit, integration, e2e, edge, security...)
- Thiết kế test cases kèm input/expected/file
- Output: YAML contract (`test_types`, `test_cases`, `coverage_target`)
- Read-only

**7. Tester** — `.opencode/agents/tester.md`
- Chạy test, ghi PASS/FAIL/SKIP, tính coverage
- Output: YAML contract (`status`, `coverage`, `results`)
- Bash allowed (chạy lệnh test), edit denied

**8. UI Beautifier** — `.opencode/agents/ui-beautifier.md`
- Chuyên cho Blazor WASM + FluentUI 4.14.3
- Phát hiện: CSS issues, accessibility, dark mode, hardcoded colors
- Output: YAML contract (`status`, `changes`)
- Edit + bash allowed

**9. Guardian** — `.opencode/agents/guardian.md`
- Pre-push review: secret scan, convention check, security scan, code quality
- Output: YAML contract (`secrets`, `conventions`, `security`, `code_quality`, `final_verdict`)
- Verdict: PASS / BLOCKED / WARNING

**10. Pusher** — `.opencode/agents/pusher.md`
- Git push an toàn: auto-commit từ diff → safety checks → build → test → confirm → push
- Output theo YAML contract

**11. Self-Improver** — `.opencode/agents/self-improver.md`
- Đọc workflow output, phân tích kỹ năng đã dùng/thếu
- Đề xuất cải tiến (chỉ suggestion, không ghi KB trực tiếp)
- Approval gate bắt buộc cho impact MEDIUM/HIGH

**12. Cleaner** — `.opencode/agents/cleaner.md`
- Dọn rác workspace: build artifacts, backup cũ, temp files
- 3 cấp độ: Cấp 1 (an toàn) / Cấp 2 (cần backup) / Cấp 3 (cần xác nhận)
- Output: YAML contract (`status`, `summary`, `cleanup_report`)

---

## Skills & Workflow

### Dev Team Workflow (`.opencode/skills/dev-team/SKILL.md`)

Quy trình phát triển phần mềm hoàn chỉnh gồm 12 bước:

```
Analyze → Design → Plan → Review → Backup → Build → Smoke Test → UI Audit → Test Plan → Test → Self-Improve → Complete
```

Đặc điểm:
- **Workflow ID**: `WF-YYYYMMDD-NNN` (ex: `WF-20260726-001`)
- **State machine**: Orchestrator theo dõi trạng thái, retry, error_history
- **Output contract**: Mỗi agent output YAML contract để orchestrator parse
- **Retry mechanism**: Review loop (max 3) + Test-fix loop (max 3)
- **Same error detection**: Hash error → nếu trùng ≥ 2 lần → STOP
- **Backup/Rollback**: Backup Utility script trước khi build, rollback khi catastrophic failure
- **Approval gate**: Self-Improver suggestions cần user approve trước khi ghi KB

### GitGuard (`.opencode/skills/gitguard/SKILL.md`)
- Pre-push review: secrets, conventions, security, code quality, build + test
- Verdict: CRITICAL → BLOCKED, MAJOR → WARNING, MINOR → PASS

### GitPush (`.opencode/skills/gitpush/SKILL.md`)
- auto-commit → safety checks → build → test → confirmation → push → post-push verify

### Workspace Cleaner (`.opencode/skills/workspace-cleaner/SKILL.md`)
- Dọn rác theo cấp độ: build artifacts, backup cũ, log files, temp zip

---

## Commands (`.opencode/commands/`)

| Command | Agent | Mô tả |
|---------|-------|-------|
| `/team` | Orchestrator | Chạy full workflow 12 bước |
| `/team-analyze` | Analyst | Phân tích yêu cầu |
| `/team-explore` | Codebase Explorer | Khám phá codebase |
| `/team-plan` | Planner | Design + Plan |
| `/team-review` | Reviewer | Đánh giá kế hoạch |
| `/team-build` | Builder | Thực thi code |
| `/team-ui-audit` | UI Beautifier | Audit giao diện |
| `/team-testplan` | Test-Planner | Kế hoạch test |
| `/team-test` | Tester | Chạy test |
| `/team-gitguard` | Guardian | Review pre-push |
| `/team-gitpush` | Pusher | Push an toàn |
| `/team-selfimprove` | Self-Improver | Đề xuất cải tiến |
| `/team-cleanup` | Cleaner | Dọn rác workspace |

---

## Knowledge Base (`.opencode/knowledge/`)

Nơi lưu trữ bài học và patterns từ workflow trước:

- `lessons.md` — Bài học tổng hợp
- `skills-learned.md` — Kỹ năng đã học
- `patterns/` — Design patterns, coding patterns
- `deployment/` — Deployment notes
- `workflow/` — Workflow templates

Ghi vào knowledge base chỉ qua **Self-Improver + approval gate**.

---

## Mối Quan Hệ Giữa Agents

```
User Request
     │
     ▼
┌──────────┐     ┌──────────────────┐
│  Analyst  │────▶│ Codebase Explorer │
└──────────┘     └──────────────────┘
     │
     ▼
┌──────────┐
│  Planner  │  (Design + Plan)
└────┬─────┘
     │
     ▼
┌──────────┐
│  Reviewer │  (APPROVED / CHANGES_REQUESTED / REJECTED)
└────┬─────┘
     │
     ▼
┌──────────┐
│  Builder  │  (Code changes)
└────┬─────┘
     │
     ├───────────────────────┐
     ▼                       ▼
┌────────────┐      ┌──────────────┐
│UI Beautifier│      │ Test-Planner │
└────────────┘      └──────┬───────┘
                           │
                           ▼
                      ┌────────┐
                      │ Tester │
                      └───┬────┘
                          │
                          ▼
                   ┌──────────────┐
                   │Self-Improver │
                   └──────┬───────┘
                          │
                     (approval gate)
                          │
                          ▼
                   ┌────────────┐
                   │ Guardian + │
                   │  Pusher    │  (git push)
                   └────────────┘
```
