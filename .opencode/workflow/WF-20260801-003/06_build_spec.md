# 06_build_spec.md — WF-20260801-003

Build spec đầy đủ cho Builder — 21 bước / 4 chunks. Builder chỉ tạo/sửa đúng các file dưới đây, không sửa file khác ngoài plan.

## QUY ƯỚC CHUNG (bắt buộc, mọi file)

1. **YAML/Markdown UTF-8 KHÔNG BOM** (byte đầu không phải EF BB BF). PowerShell 5.1: dùng `[System.IO.File]::WriteAllText($path, $content, (New-Object System.Text.UTF8Encoding($false)))`.
2. **Không dùng tab** — chỉ spaces. YAML dùng 2-space indent.
3. **KHÔNG viết ký tự `#` đứng trước** `WF-2026-*`, `WF-ERR-*`, `BUG-*` — viết dạng `WF-2026-001`, `WF-ERR-001` (không #). Chỉ dùng `#` cho heading markdown.
4. Mỗi file .md phải có frontmatter YAML 3 keys: `name`, `description`, `agent`. Quy ước frontmatter mở đầu:
   ```
   ---
   name: <tên>
   description: <mô tả>
   agent: general
   ---
   ```
5. Mỗi file .md phải có: **Procedure** (từng bước cụ thể) + **Output contract YAML** + **Checklist bắt buộc**.
6. Code block balance: số ``` mở = số ``` đóng.

---

## CHUNK 1 — Config/Schema (step 1-2)

### STEP 1: CREATE `.opencode/workflow/schemas/workflow.schema.yaml`
- Top-level required: `schema_version: "4.0"`, `description`, `default_workflow: default`, `workflow` object với required: `id, name, version, description, phases[]`.
- `phase` required: `id`, `title`, và ít nhất 1 trong `agent` | `command`.
- Phase optional: `description`, `depends_on[]`, `optional` (bool), `retry` (int), `timeout_seconds` (int), `continue_on_error` (bool), `inputs` (object), `outputs` (object), `expected_result`.
- Phase status enum: `pending, ready, running, completed, failed, retry, skipped, cancelled, rolled_back`.
- Comment đầu file ghi: workflow.schema.yaml là contract chính thức v4; contracts/workflow.yaml (v1.0) giữ nguyên deprecated.
- Dưới 150 dòng. Include sample YAML parse được.

### STEP 2: CREATE `.opencode/workflow-engine/README.md`
- Frontmatter: name: workflow-engine, description, agent: general.
- Nội dung bắt buộc:
  1. Mục đích — Workflow Engine v4 thay thế body 13 bước trong team.md.
  2. Kiến trúc pipeline: team.md (thin launcher) → engine.md → loader.md → validator.md → executor.md → phase-runner.md → state-machine.md → recovery.md.
  3. **VẼ RÕ 3 VAI TRÒ `.opencode/workflow/`** (fix #08):
     - `schemas/` — contract tĩnh (workflow.schema.yaml), KHÔNG sửa tay.
     - `definitions/` — khai báo workflow tĩnh (5 *.yaml), chỉ sửa qua PR.
     - `WF-*/` — runtime context do engine tạo (workflow.json, state.json, context.json, artifacts/, logs/), KHÔNG sửa tay, có thể xóa khi retry.
  4. Cách dùng: `/team --workflow <default|bugfix|feature|ui|docs>` (mặc định default).
  5. Liệt kê 5 definitions + MIGRATION_GUIDE.md.
  6. Quy ước: YAML spaces, no-BOM, không `#` trước WF-ID/WF-ERR.
  7. Link tới 8 module docs + MIGRATION_GUIDE.md.

---

## CHUNK 2 — Engine core docs (step 3-9)

### STEP 3: CREATE `.opencode/workflow-engine/state-machine.md`
- Frontmatter: name: workflow-engine-state-machine, agent: general.
- States: `Pending → Ready → Running → Completed | Failed → Retry → Skipped → Cancelled → RolledBack`.
- Sơ đồ transitions dạng code block ASCII.
- Bảng transition hợp lệ: từ→đến + điều kiện trigger.
- **Backward read** WF-2026*: cách đọc snapshot cũ `.opencode/workflows/*.json` (schema_version 2.0/3.x), map trạng thái legacy (running/completed/failed/cancelled/blocked/waiting_user) sang v4; missing field → default (status→READY, issues→[], retry_count→0).
- `state.json` schema: workflow_id, definition, phase_index, current_phase, status, retry_count, error_history[], artifacts[].
- KHÔNG `#` trước WF-2026.

### STEP 4: CREATE `.opencode/workflow-engine/loader.md`
- Frontmatter: name: workflow-engine-loader, agent: general.
- Procedure 6 bước: (1) đọc `.opencode/workflow/definitions/<name>.workflow.yaml` UTF-8 no-BOM; (2) parse YAML theo schema v4; (3) map phase → node (id, title, agent|command, depends_on, optional, retry, timeout_seconds, continue_on_error, inputs, outputs); (4) topological sort theo depends_on (Kahn); (5) cycle → WF-ERR-004 kèm chuỗi cycle; (6) output phase graph YAML (thứ tự thực thi, leaf nodes, root).
- Error: file missing → WF-ERR-001 (kèm đường dẫn); YAML parse lỗi → WF-ERR-002 (kèm dòng).
- **Resolve workflow id**: nếu `--workflow` không truyền → dùng `default_workflow` (mặc định 'default'). Invalid id → WF-ERR-009 kèm danh sách 5 definitions.
- Sample YAML parse được.

### STEP 5: CREATE `.opencode/workflow-engine/validator.md`
- Frontmatter: name: workflow-engine-validator, agent: general.
- Checklist validate (khớp workflow-validator.ps1):
  1. required keys top-level: id, name, version, description, phases.
  2. mỗi phase required: id, title, đúng 1 trong agent|command.
  3. phase id không trùng lặp.
  4. depends_on trỏ phase id tồn tại.
  5. không cycle (DFS).
  6. agent ∈ 18 agents (.opencode/agents/*.md, tên file không đuôi).
  7. command ∈ 53 commands (.opencode/commands/*.md, tên file không đuôi, bỏ '/'), cho phép 'backup'.
- Bảng mã lỗi (KHÔNG viết `#` trước):
  - WF-ERR-001 file missing
  - WF-ERR-002 YAML parse fail
  - WF-ERR-003 missing required key
  - WF-ERR-004 duplicate phase id
  - WF-ERR-005 depends_on không tồn tại
  - WF-ERR-006 cycle detected
  - WF-ERR-007 agent không tồn tại
  - WF-ERR-008 command không tồn tại
  - WF-ERR-009 invalid --workflow id (kèm danh sách 5 definitions: default, bugfix, feature, ui, docs)
- Mỗi lỗi ghi: error code, mô tả, file:line, gợi ý sửa. Lỗi CRITICAL (001,002,004,005,006,007) → dừng workflow.

### STEP 6: CREATE `.opencode/workflow-engine/engine.md`
- Frontmatter: name: workflow-engine, agent: general. File controller.
- Pipeline 7 bước: load → validate → resolve dependencies → run phase → validate output → save artifact → update state.
- Mỗi bước có input/output.
- **Decision tree YAML** sau mỗi phase: dựa trên status (completed/failed/retry/skipped/cancelled/rolled_back) + error code → hành động (next_phase, retry_phase, skip_phase, rollback, abort, ask_user). Retry tối đa 3, same_error >= 2 → rollback.
- **default_workflow: default**; invalid --workflow id → WF-ERR-009 kèm danh sách 5 definitions, KHÔNG tự fallback mù.
- Cách đọc state.json (last completed phase) + ghi checkpoint sau mỗi phase.
- **Hỗ trợ context root override** qua biến môi trường `WF_CONTEXT_ROOT` (để smoke-test chạy trong temp, không tạo WF-*/ trong repo).
- Timeout 120s/phase.
- KHÔNG `#` trước WF-ID/WF-ERR.

### STEP 7: CREATE `.opencode/workflow-engine/executor.md`
- Frontmatter: name: workflow-engine-executor, agent: general.
- Vòng lặp 6 bước cho mỗi phase (theo thứ tự topological): (1) validate phase (validator.md, error → WF-ERR-00x); (2) resolve dependencies — phase phụ thuộc chưa completed + continue_on_error=false → dừng báo missing dep; (3) run qua phase-runner (agent|command dispatch); (4) validate output theo output contract (status/summary/artifacts) → FAIL → WF-ERR-008; (5) save artifact vào `.opencode/workflow/<WF-ID>/`; (6) update state: phase status + workflow status.
- Optional phase fail → skipped (không block); continue_on_error=true → log warning + tiếp tục.
- Sample loop pseudocode (code block).
- Artifact naming: `<NN>_<phase>.md` (NN = số thứ tự 2 chữ số).
- KHÔNG `#` trước WF-ID.

### STEP 8: CREATE `.opencode/workflow-engine/phase-runner.md`
- Frontmatter: name: workflow-engine-phase-runner, agent: general.
- Dispatcher: phase có `command` → chạy command (.opencode/commands/*.md, bỏ '/'); phase chỉ có `agent` → triệu hồi agent (.opencode/agents/*.md); cả hai → ưu tiên command.
- Bảng dispatch mẫu: analyze→/team-analyze (analyst), plan→/team-plan (planner), review→/team-review (reviewer), build→/team-build (builder), ui→/team-ui-audit (ui-beautifier), testplan→/team-testplan (test-planner), test→/team-test (tester), selfimprove→/team-selfimprove (self-improver), guard→/team-gitguard (guardian), syncdocs→/team-syncdocs (general).
- Xử lý: timeout 120s, retry theo phase.retry (mặc định 3), output parse YAML theo output contract — lỗi format → WF-ERR-008.
- Engine KHÔNG hiểu nội dung agent — chỉ dispatch theo metadata.
- KHÔNG `#` trước WF-ERR.

### STEP 9: CREATE `.opencode/workflow-engine/recovery.md`
- Frontmatter: name: workflow-engine-recovery, agent: general.
- Trigger: catastrophic_failure (backup fail, WF-ERR-006/007, FileOutsidePlan), max_retry_reached (retry >= 3 hoặc same_error >= 2), user_request.
- Hành động: retry_phase, skip_phase (chỉ khi optional=true), abort (status cancelled), rollback (gọi `.opencode/scripts/rollback-utility.ps1 -workflowId <WF-ID> [-force]`, cần user xác nhận).
- Đọc last completed từ state.json = restore point.
- Ghi error_history + same_error_count trong state.
- Backward: snapshot cũ WF-2026* không có state.json mới → khởi tạo default state.
- **Quy trình restore nhanh team.md (<1 phút)**: trỏ tới MIGRATION_GUIDE.md.
- KHÔNG `#` trước WF-ID.

---

## CHUNK 3 — Definitions + MIGRATION_GUIDE + workflow-validator (step 10-16)

### STEP 10: CREATE `.opencode/workflow/definitions/default.workflow.yaml`
- `id: default`, `name: Default Development Workflow`, `version: 1.0.0`, description đầy đủ, `default_workflow: default`.
- 13 phases đúng thứ tự:
  1. analyze (agent: analyst, command: team-analyze, depends_on: [])
  2. design (agent: planner, command: team-plan, depends_on: [analyze])
  3. plan (agent: planner, command: team-plan, depends_on: [design])
  4. review (agent: reviewer, command: team-review, depends_on: [plan])
  5. guardrail (agent: guardian, command: team-gitguard, depends_on: [review])
  6. backup (command: backup, depends_on: [guardrail])
  7. build (agent: builder, command: team-build, depends_on: [backup])
  8. static_analysis (agent: general, depends_on: [build])
  9. ui_audit (agent: ui-beautifier, command: team-ui-audit, depends_on: [static_analysis])
  10. testplan (agent: test-planner, command: team-testplan, depends_on: [ui_audit])
  11. test (agent: tester, command: team-test, depends_on: [testplan])
  12. skill_validation (agent: self-improver, command: team-selfimprove, depends_on: [test], optional: true)
  13. complete (agent: general, depends_on: [skill_validation])
- Mỗi phase có: id, title, description, agent|command, depends_on, retry: 3, timeout_seconds: 120, continue_on_error: false, inputs, outputs, expected_result.

### STEP 11: CREATE `.opencode/workflow/definitions/bugfix.workflow.yaml`
- `id: bugfix`, `name: Bugfix Workflow`, `version: 1.0.0`.
- 6 phases: analyze (analyst/team-analyze, []) → root-cause (root-cause-agent, [analyze]) → plan-fix (planner/team-plan, [root-cause]) → build (builder/team-build, [plan-fix]) → test (tester/team-test, [build]) → complete (general, [test]).

### STEP 12: CREATE `.opencode/workflow/definitions/feature.workflow.yaml`
- `id: feature`, `name: Feature Workflow`, `version: 1.0.0`.
- 8 phases: analyze → design → plan → review → build → test → ui_audit → complete. (depends_on theo thứ tự, agent/command như default tương ứng)

### STEP 13: CREATE `.opencode/workflow/definitions/ui.workflow.yaml`
- `id: ui`, `name: UI Workflow`, `version: 1.0.0`.
- 6 phases: analyze-ui (ui-beautifier/team-ui-audit, []) → design (planner/team-plan, [analyze-ui]) → ui-audit (ui-beautifier/team-ui-audit, [design]) → build-ui (builder/team-build, [ui-audit]) → test (tester/team-test, [build-ui]) → complete (general, [test]).

### STEP 14: CREATE `.opencode/workflow/definitions/docs.workflow.yaml`
- `id: docs`, `name: Docs Workflow`, `version: 1.0.0`.
- 5 phases: analyze (analyst/team-analyze, []) → write (general, [analyze]) → review (reviewer, [write]) → validate (general/team-syncdocs, [review]) → complete (general, [validate]).

### STEP 15: CREATE `.opencode/workflow/MIGRATION_GUIDE.md`
- Frontmatter: name: workflow-migration-guide, agent: general.
- Nội dung 6 mục:
  1. Quy trình migrate team.md cũ → thin launcher (backup → smoke-test → cutover → rollback).
  2. **Quy trình RESTORE NHANH team.md (<1 phút)**: backup tại `.opencode/backup/WF-20260801-003/.opencode/commands/team.md`; restore = verify manifest (backup-utility -action verify -workflowId WF-20260801-003) → Copy-Item từ backup_path về `.opencode/commands/team.md` → kiểm tra frontmatter (description, agent: general) còn nguyên.
  3. **NOTE DEFERRED knowledge-index**: build-knowledge-index.ps1 + knowledge-index.ps1 chỉ scan JapaneseLearner/ + .opencode/knowledge/ — KHÔNG quét workflow-engine/ hay workflow/definitions/; sprint này KHÔNG claim index mới; final validation dùng /knowledge-index --status; post-sprint mở rộng script nếu cần.
  4. Phân vai workflow/ (schemas/ static, definitions/ static, WF-*/ runtime — xem README.md).
  5. Backward compatibility: contracts/workflow.yaml (v1.0) giữ nguyên deprecated; bản 13 bước đầy đủ vẫn ở .opencode/skills/dev-team/SKILL.md + engine docs mới.
  6. Checklist hậu kỳ optional (deferred): AGENTS.md, DOCTOR_REPORT.md, SYSTEM_MAP.md, /team-syncdocs guard, encoding-only diff chấp nhận được cho 3 file regenerate (SYSTEM_MAP.md, SKILL.md, sync-last-report.json).

### STEP 16: CREATE `.opencode/scripts/workflow-validator.ps1`
- Params: `-DefinitionsDir` (default .opencode/workflow/definitions), `-AgentsDir` (default .opencode/agents), `-CommandsDir` (default .opencode/commands), `-SchemaPath` (default .opencode/workflow/schemas/workflow.schema.yaml).
- **KHÔNG dùng ConvertFrom-Yaml** (không available). Viết parser YAML subset tự viết: split lines theo indent (2-space), parse top-level keys (id, name, version, description, phases) và mỗi phase block (id, title, agent, command, depends_on).
- Validate mỗi file *.yaml:
  1. no-tab: không chứa [char]9.
  2. no-BOM: 3 byte đầu không phải EF BB BF.
  3. required keys top-level: id, name, version, description, phases (thiếu → WF-ERR-003).
  4. mỗi phase: required id, title, đúng 1 trong agent|command.
  5. duplicate phase id → WF-ERR-004.
  6. depends_on trỏ phase id tồn tại → WF-ERR-005.
  7. cycle detect (DFS) → WF-ERR-006.
  8. agent ∈ dir scan `.opencode/agents/*.md` (BaseName, KHÔNG hardcode 18) → WF-ERR-007.
  9. command ∈ dir scan `.opencode/commands/*.md` (BaseName, normalize strip '/') → WF-ERR-008.
- Output JSON report (file + errors[] + status PASS/FAIL) ra console + `.opencode/scripts/workflow-validator-report.json`; exit 0 khi tất cả PASS, exit 1 khi có FAIL. KHÔNG sửa file — chỉ đọc.
- Comment header giải thích parser subset + cách mở rộng.

---

## CHUNK 4 — Backup + Sync + Smoke-test + Cutover (step 17-21)

### STEP 17: RUN backup sync-system-docs.ps1
ĐÃ HOÀN TẤT (Backup Bước 6) — manifest `.opencode/backup/WF-20260801-003/backup_manifest.json` chứa cả sync-system-docs.ps1 + team.md. Builder verify bằng `-action verify`.

### STEP 18: MODIFY `.opencode/scripts/sync-system-docs.ps1`
Script hiện 1098 dòng. Sửa 2 nhóm (đúng vị trí, không đụng phần khác):
(a) **GUARD team.md thin launcher**: trong block UPDATE team.md (~dòng 741-754, tìm bảng `| Buoc | Command |`), trước regex, thêm: nếu $teamContent -match 'thin launcher' HOẶC không khớp bảng → Write-Host 'INFO: SKIP team.md — thin launcher (table update disabled)' và KHÔNG thêm issue UPDATE_FAILED.
(b) **utf8NoBOM**: thêm helper `function Write-Utf8NoBom { param([string]$Path,[string]$Content) [System.IO.File]::WriteAllText($Path, $Content, (New-Object System.Text.UTF8Encoding($false))) }`. Thay 5 chỗ `Out-File -FilePath ... -Encoding utf8`:
- line ~224 (stress-test JSON report)
- line ~711 (SYSTEM_MAP.md)
- line ~746 (team.md table update)
- line ~785 (SKILL.md table update)
- line ~1089 (sync-last-report.json)
File .ps1 tự nó lưu no-BOM.
(c) KHÔNG đổi logic scan/evolution khác.

### STEP 18b: RUN sync-system-docs.ps1 (default mode, KHÔNG --evolve)
Chạy `powershell -NoProfile -ExecutionPolicy Bypass -File .opencode/scripts/sync-system-docs.ps1` để regenerate SYSTEM_MAP.md, SKILL.md table, sync-last-report.json no-BOM + verify script không vỡ. Kiểm tra các file output không BOM.

### STEP 19: SMOKE-TEST engine (trước cutover)
- Chạy workflow-validator.ps1 trên 5 definitions → tất cả PASS.
- Mô phỏng resolve workflow: không truyền --workflow → default 'default'; --workflow nonexistent → WF-ERR-009 + danh sách 5 definitions.
- Load docs.workflow.yaml (5 phases) theo loader → validator → state-machine.
- Mô phỏng pipeline 5 phases qua phase-runner (dùng command thật: /team-analyze, /team-plan, /team-build, /team-testplan, complete tự hoàn tất), yêu cầu giả READ-ONLY, context trong `$env:TEMP/wf-smoke-20260801-003/` (WF_CONTEXT_ROOT override).
- **Git status guard**: chạy `git status --porcelain` TRƯỚC và SAU smoke-test; delta chỉ được nằm trong $env:TEMP/wf-smoke-20260801-003/ (untracked files từ steps 1-16 không tính — so sánh snapshot before/after).
- Ghi báo cáo `$env:TEMP/wf-smoke-20260801-003/smoke-test-report.md`.
- Chỉ cutover khi PASS.

### STEP 20: MODIFY `.opencode/commands/team.md` (CUTOVER)
(0) Backup team.md đã có (Bước 6). Verify trước khi sửa.
(1) GIỮ frontmatter: `description: Chạy toàn bộ team workflow: analyze → design/plan → review → backup → build → static analysis → ui audit → testplan → test → skill validation → complete` + `agent: general`.
(2) GIỮ HELP section, RÚT GỌN: mục đích, cách dùng (`/team <yêu cầu> [--workflow <default|bugfix|feature|ui|docs>]`, mặc định default), đầu vào, đầu ra, danh sách lệnh thành phần (11: team-analyze, team-plan, team-review, team-build, team-ui-audit, team-testplan, team-test, team-selfimprove, team-gitguard, team-gitpush, team-syncdocs), xem thêm.
(3) THAY body orchestrator + state machine 13 bước (~dòng 32-870) bằng THIN LAUNCHER:
```
## WORKFLOW ENGINE (v4)

Bạn là General Agent đóng vai Workflow Engine. Làm theo .opencode/workflow-engine/engine.md.

1. Parse $ARGUMENTS: regex '--workflow\s+([\w-]+)' → workflowName (mặc định 'default').
2. Đọc engine docs theo thứ tự: README.md → engine.md → loader.md → validator.md → executor.md → phase-runner.md → recovery.md → state-machine.md.
3. Load definitions: .opencode/workflow/definitions/<workflowName>.workflow.yaml.
4. Thực thi theo executor.md: load → validate (validator.md, WF-ERR-00x kèm file:line) → resolve deps → run từng phase qua phase-runner → validate output → save artifact (.opencode/workflow/<WF-ID>/) → update state (.opencode/workflow/<WF-ID>/state.json).
5. Hỗ trợ WF_CONTEXT_ROOT override context root (cho smoke-test).
6. FALLBACK: thiếu engine docs/definitions/lỗi bất kỳ → BÁO LỖI có file:line, gợi ý /team-syncdocs. TUYỆT ĐỐI KHÔNG tự fallback về quy trình cũ (đã xóa).
```
(4) GIỮ placeholder `Yêu cầu: $ARGUMENTS` để /team nhận input.
(5) Lưu file UTF-8 no-BOM.
Kết quả: file < 130 dòng, frontmatter + HELP + thin launcher + 11 refs /team-* + $ARGUMENTS.

### STEP 21: POST-CUTOVER VERIFY
- Chạy `/team --workflow docs <yêu cầu giả READ-ONLY>` trong $env:TEMP/wf-smoke-20260801-003/ (WF_CONTEXT_ROOT override).
- Verify pipeline chạy đến COMPLETE + git status --porcelain sạch (snapshot before/after).
- FAIL → rollback team.md ngay (theo MIGRATION_GUIDE), không đóng sprint.

---

## ROLLBACK (nếu catastrophic)
1. restore `.opencode/commands/team.md` từ backup (WF-20260801-003).
2. restore `.opencode/scripts/sync-system-docs.ps1` từ backup.
3. delete CREATE: workflow-engine/, workflow/schemas/, workflow/definitions/, MIGRATION_GUIDE.md, workflow-validator.ps1.
4. 3 file regenerate (SYSTEM_MAP.md, SKILL.md, sync-last-report.json): chấp nhận encoding-only diff hoặc restore nếu cần sạch tuyệt đối.
5. Xóa $env:TEMP/wf-smoke-20260801-003/.
