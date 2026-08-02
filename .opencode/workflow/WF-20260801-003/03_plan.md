# 03_plan.md — WF-20260801-003 (REVISION v3)

## Plan — Sprint 1: Workflow Engine (v4 Foundation) — sau review

```yaml
status: "READY"
summary: >
  REVISION v3 theo review CHANGES_REQUESTED (overall 8.3). Plan 21 bước (4 chunks, effort LARGE).
  Khắc phục thêm 3 MAJOR của review #2: (1) workflow-validator.ps1 dùng parser YAML subset tự viết
  (ConvertFrom-Yaml KHÔNG available — đã verify schema-validator-report.json), không phụ thuộc module;
  (2) thêm step 18b RUN sync-system-docs.ps1 sau MODIFY để regenerate file no-BOM + verify script không vỡ;
  (3) step 19 smoke-test thêm guard `git status --porcelain` trước/sau để verify zero diff ngoài $env:TEMP.
  Cập nhật 4 MINOR: 5 chỗ Out-File utf8 (line 224 bổ sung), giữ /team-gitpush (11 refs), validator derive
  agent/command từ dir scan runtime, thêm check $ARGUMENTS trong step 20. Blocking cũ đã xử lý từ v2 giữ nguyên.

blocking_issues: []
non_blocking_issues:
  - id: "#NB-01"
    severity: "MINOR"
    category: "TOOLING"
    description: "schema-validator.ps1 Test-InternalLinks báo LINK lỗi giả nếu '#' trước WF-ID/WF-ERR."
    suggestion: "Giữ quy ước KHÔNG viết '#' trước WF-ID/WF-ERR-* trong engine docs."
  - id: "#NB-02"
    severity: "INFO"
    category: "CONSISTENCY"
    description: "sync-system-docs.ps1 block UPDATE team.md — sau cutover không còn bảng."
    suggestion: "Step 18: guard 'thin launcher' → skip update với log INFO."
  - id: "#NB-03"
    severity: "INFO"
    category: "STYLE"
    description: "Nội dung 13 bước hardcode trong team.md sẽ bị thay."
    suggestion: "Bản đầy đủ vẫn còn trong dev-team/SKILL.md + engine docs mới."
  - id: "#NB-04"
    severity: "INFO"
    category: "TOOLING"
    description: "DEFERRED: /knowledge-index --update là no-op với workflow-engine/."
    suggestion: "Final validation chỉ chạy --status; note deferred trong MIGRATION_GUIDE."
  - id: "#NB-05"
    severity: "INFO"
    category: "PERFORMANCE"
    description: "DEFERRED: các Out-File utf8 ngoài 5 chỗ đã sửa vẫn có BOM (backup-utility dòng 169, v.v.)."
    suggestion: "Chỉ chuẩn hóa 5 chỗ trong scope sprint (line 224/711/746/785/1089); phần còn lại note deferred."
  - id: "#NB-06"
    severity: "INFO"
    category: "STYLE"
    description: "DEFERRED: AGENTS.md + DOCTOR_REPORT.md chưa cập nhật phản ánh v4."
    suggestion: "Checklist hậu kỳ optional trong MIGRATION_GUIDE."
  - id: "#NB-07"
    severity: "INFO"
    category: "LOGIC"
    description: "DEFERRED: quyết định giữ/bỏ vĩnh viễn guard update bảng team.md."
    suggestion: "Giữ guard tạm; quyết định cuối sau 2-3 sprint."

open_questions:
  - id: "#Q01"
    description: "Phase list 5 definitions — chấp nhận đề xuất?"
    suggestion: "default=13, bugfix=6, feature=8, ui=6, docs=5 (đã chốt theo #Q02 design)."
  - id: "#Q02"
    description: "SMOKE-TEST chạy workflow nào?"
    suggestion: "docs (5 phases ngắn nhất) — đã chốt."
  - id: "#Q03"
    description: "workflow-validator.ps1 deep-validate theo schema?"
    suggestion: "Sprint này: key-check + cross-ref; deep schema deferred."
  - id: "#Q04"
    description: "Tạo /team-workflow riêng?"
    suggestion: "Sprint 1 dùng flag --workflow; /team-workflow để sprint sau."

next_action: "Chuyển sang Review phase (revision v2)"
effort: "Large"
```

## Các bước (21)

| # | Action | File | Chunk | Risk |
|---|---|---|---|---|
| 1 | CREATE | `.opencode/workflow/schemas/workflow.schema.yaml` | 1 | LOW |
| 2 | CREATE | `.opencode/workflow-engine/README.md` | 1 | LOW |
| 3 | CREATE | `.opencode/workflow-engine/state-machine.md` | 2 | LOW |
| 4 | CREATE | `.opencode/workflow-engine/loader.md` | 2 | LOW |
| 5 | CREATE | `.opencode/workflow-engine/validator.md` (WF-ERR-009) | 2 | LOW |
| 6 | CREATE | `.opencode/workflow-engine/engine.md` (default_workflow) | 2 | MEDIUM |
| 7 | CREATE | `.opencode/workflow-engine/executor.md` | 2 | MEDIUM |
| 8 | CREATE | `.opencode/workflow-engine/phase-runner.md` | 2 | MEDIUM |
| 9 | CREATE | `.opencode/workflow-engine/recovery.md` | 2 | MEDIUM |
| 10 | CREATE | `.opencode/workflow/definitions/default.workflow.yaml` (13) | 3 | LOW |
| 11 | CREATE | `.opencode/workflow/definitions/bugfix.workflow.yaml` (6) | 3 | LOW |
| 12 | CREATE | `.opencode/workflow/definitions/feature.workflow.yaml` (8) | 3 | LOW |
| 13 | CREATE | `.opencode/workflow/definitions/ui.workflow.yaml` (6) | 3 | LOW |
| 14 | CREATE | `.opencode/workflow/definitions/docs.workflow.yaml` (5) | 3 | LOW |
| 15 | CREATE | `.opencode/workflow/MIGRATION_GUIDE.md` | 3 | LOW |
| 16 | CREATE | `.opencode/scripts/workflow-validator.ps1` (parser YAML subset, không dùng ConvertFrom-Yaml) | 3 | MEDIUM |
| 17 | RUN | backup sync-system-docs.ps1 | 4 | LOW |
| 18 | MODIFY | `.opencode/scripts/sync-system-docs.ps1` (guard + utf8NoBOM 5 chỗ) | 4 | MEDIUM |
| 18b | RUN | `.opencode/scripts/sync-system-docs.ps1` regenerate no-BOM + verify không vỡ | 4 | MEDIUM |
| 19 | RUN | SMOKE-TEST engine (docs workflow, temp context + git status snapshot guard) | 4 | HIGH |
| 20 | MODIFY | `.opencode/commands/team.md` CUTOVER (sau smoke-test) | 4 | HIGH |
| 21 | RUN | POST-CUTOVER VERIFY: /team --workflow docs trong temp context + git status clean | 4 | HIGH |

## Ghi chú vận hành cho Builder

- Không thay đổi mã C# — validation dùng PowerShell + opencode commands
- Step 17 backup sync-system-docs.ps1; step 20 backup team.md trước khi sửa
- YAML/MD UTF-8 no-BOM, spaces không tab
- Không viết `#` trước WF-ID/WF-ERR-*
- Step 19 smoke-test bắt buộc trước cutover; context giả trong $env:TEMP, không sửa file repo (verify git status snapshot before/after, delta chỉ trong $env:TEMP/wf-smoke-*/)
- Step 20 giữ frontmatter (description, agent: general) + HELP + 11 references /team-* (gồm team-gitpush)
- Step 20 giữ placeholder $ARGUMENTS để /team nhận input
- Step 21: sau cutover chạy /team --workflow docs với yêu cầu giả trong temp context; verify pipeline đến COMPLETE + git status sạch (snapshot before/after); FAIL → rollback team.md ngay, không đóng sprint
- workflow-validator.ps1: KHÔNG dùng ConvertFrom-Yaml (không available) — dùng parser YAML subset tự viết
- workflow-validator.ps1: derive danh sách agent/command từ dir scan runtime (Get-ChildItem .opencode/agents/*.md, .opencode/commands/*.md), normalize command strip '/'; 18/53 là kỳ vọng runtime, KHÔNG hardcode
- sync-system-docs.ps1: chuẩn hóa no-BOM 5 chỗ Out-File utf8 (line 224 stress-test, 711 SYSTEM_MAP, 746 team.md, 785 SKILL.md, 1089 sync-last-report.json)
- engine.md/state-machine.md: hỗ trợ override context root qua biến môi trường WF_CONTEXT_ROOT (để smoke-test chạy hoàn toàn trong $env:TEMP, không tạo WF-*/ trong repo)
- Step 18b chạy sync-system-docs.ps1 ở default mode (không truyền --evolve) để tránh kích hoạt evolution engine

## Rollback scope mở rộng (review #3)

Rollback phủ mọi thay đổi:
- restore `.opencode/commands/team.md` (step 20 backup)
- restore `.opencode/scripts/sync-system-docs.ps1` (step 17 backup)
- delete CREATE: workflow-engine/, workflow/schemas/, workflow/definitions/, MIGRATION_GUIDE.md, workflow-validator.ps1
- **3 file regenerate bởi step 18b**: SYSTEM_MAP.md, dev-team/SKILL.md, sync-last-report.json — nếu rollback cần repo sạch hoàn toàn → backup + restore 3 file này; hoặc ghi rõ "encoding-only diff, chấp nhận được" trong MIGRATION_GUIDE (khuyến nghị: chấp nhận encoding-only diff)
- Step 19/21 (smoke-test + post-cutover verify): không rollback — context giả trong $env:TEMP, xóa thư mục temp là đủ
