# 02_design.md — WF-20260801-003

## Design — Sprint 1: Workflow Engine (v4 Foundation)

```yaml
status: "READY"
summary: >
  Thiết kế Workflow Engine v4 (Foundation) dạng configuration-driven trên nền markdown+YAML prompt framework:
  8 module tài liệu trong .opencode/workflow-engine/ (engine, loader, validator, executor, phase-runner,
  state-machine, recovery, README) + 1 schema contract (workflow.schema.yaml) + 5 workflow definitions
  (default/bugfix/feature/ui/docs) + migration guide. /team trở thành thin launcher: đọc workflow.yaml →
  validator → executor → dispatch agent/command theo Phase, framework không còn biết Planner/Builder là gì.
  Effort: LARGE (15 file CREATE + 1-2 file MODIFY).

blocking_issues:
  - id: "#01"
    severity: "CRITICAL"
    category: "CONSISTENCY"
    description: >
      team.md (879 dòng, 13 bước hardcode) đang là nguồn chân lý duy nhất cho orchestrator.
      Nếu Sprint 1 MODIFY team.md thành thin launcher trỏ engine mà workflow/definitions chưa hoàn
      chỉnh hoặc engine.md chưa đủ chi tiết → /team vỡ pipeline đang chạy ổn (RISK-002 trong analysis).
      Cutover phải là bước cuối cùng trong plan, sau khi 5 definitions + validator + executor được tạo
      và verify (dùng chính engine để chạy workflow docs).
    suggestion: >
      Chốt Option A nhưng theo thứ tự: (1) tạo toàn bộ workflow-engine docs + schema + definitions,
      (2) chạy thử workflow docs/validation bằng general agent, (3) backup team.md, (4) MODIFY team.md
      thành launcher với cơ chế fallback: nếu engine/definitions lỗi → báo lỗi có file:line, không tự
      chuyển về legacy.

non_blocking_issues:
  - id: "#02"
    severity: "MINOR"
    category: "DESIGN"
    description: "Trùng tên thư mục .opencode/workflow/ (runtime WF-* + static schemas/definitions)."
    suggestion: "README.md vẽ rõ 3 vai trò: schemas (contract tĩnh), definitions (khai báo tĩnh), WF-*/ (runtime context)."
  - id: "#03"
    severity: "MAJOR"
    category: "CONSISTENCY"
    description: "contracts/workflow.yaml (v1.0, 13 steps) tồn tại sẵn — schema mới workflow.schema.yaml sẽ trùng phạm vi."
    suggestion: "workflow.schema.yaml là contract chính thức v4; contracts/workflow.yaml giữ nguyên như backward reference (ghi deprecated)."
  - id: "#04"
    severity: "MINOR"
    category: "STYLE"
    description: "Engine là markdown instruction, general agent phải đọc và làm theo — không có máy kiểm soát."
    suggestion: "Mỗi module .md theo khuôn: Procedure + Output contract YAML + Checklist bắt buộc. state.json là nguồn chân lý runtime."
  - id: "#05"
    severity: "MINOR"
    category: "PERFORMANCE"
    description: "Loader/validator parse YAML thủ công mỗi lần chạy."
    suggestion: "Giữ YAML dưới 150 dòng/definition; chỉ thêm field khi cần."
  - id: "#06"
    severity: "MINOR"
    category: "LOGIC"
    description: "SYSTEM_MAP.md sẽ không tự biết cấu trúc workflow-engine/ mới."
    suggestion: "Bổ sung vào sync-system-docs.ps1 hoặc chạy /team-syncdocs sau sprint."

open_questions:
  - id: "#Q01"
    description: "Cutover team.md: Option A (MODIFY team.md thành launcher ngay sprint này) hay Option B (giữ team.md, tạo /team-engine pilot)?"
    suggestion: "Đề xuất Option A theo thứ tự an toàn — Sprint 1 deliverable yêu cầu /team chạy qua engine; backup trước khi sửa."
  - id: "#Q02"
    description: "Phase list của 5 workflow definitions — chấp nhận đề xuất mặc định hay điều chỉnh?"
    suggestion: "default=13 phases, bugfix=6 phases, feature=8 phases, ui=6 phases, docs=5 phases."
  - id: "#Q03"
    description: "Có tạo command /team-workflow riêng không, hay chỉ dùng flag --workflow trong team.md?"
    suggestion: "Sprint 1 tối thiểu: flag --workflow. /team-workflow để sprint sau."
  - id: "#Q04"
    description: "Vị trí migration guide: .opencode/workflow/MIGRATION_GUIDE.md hay .opencode/docs/?"
    suggestion: ".opencode/workflow/MIGRATION_GUIDE.md."
  - id: "#Q05"
    description: "5 definitions có cần đăng ký trong SYSTEM_MAP.md / knowledge-index không?"
    suggestion: "Có — post-sprint, đưa vào final_validation."

next_action: "Chuyển sang Plan phase — ưu tiên trả lời #Q01, #Q02 trước"
effort: "Large"
```

## Kiến trúc tổng thể

```
User gõ "/team <yêu cầu> [--workflow <id>]"
  → team.md (thin launcher): resolve workflow_id → gọi engine.md
  → ENGINE (general agent): Loader → read workflow/definitions/<id>.yaml → parse → build phase graph
  → Validator: check schema, duplicate id, cycle, missing phase, agent/command tồn tại, output contract
  → State Machine: tạo context workflow/WF-<id>/ (workflow.json, state.json, context.json, artifacts/, logs/)
  → Executor: foreach phase → validate → resolve dependency → Phase Runner → validate output → save artifact → update state
  → Phase Runner: agent? → triệu hồi agent / command? → thực thi command. Engine KHÔNG biết Planner/Builder.
  → Recovery: fail → last completed → retry → rollback → continue
  → Final report
```

## Components (15 CREATE + 2 MODIFY)

| Component | Path | Action |
|---|---|---|
| workflow-engine README | `.opencode/workflow-engine/README.md` | CREATE |
| engine.md | `.opencode/workflow-engine/engine.md` | CREATE |
| loader.md | `.opencode/workflow-engine/loader.md` | CREATE |
| validator.md | `.opencode/workflow-engine/validator.md` | CREATE |
| executor.md | `.opencode/workflow-engine/executor.md` | CREATE |
| phase-runner.md | `.opencode/workflow-engine/phase-runner.md` | CREATE |
| state-machine.md | `.opencode/workflow-engine/state-machine.md` | CREATE |
| recovery.md | `.opencode/workflow-engine/recovery.md` | CREATE |
| workflow.schema.yaml | `.opencode/workflow/schemas/workflow.schema.yaml` | CREATE |
| default.workflow.yaml | `.opencode/workflow/definitions/default.workflow.yaml` | CREATE |
| bugfix.workflow.yaml | `.opencode/workflow/definitions/bugfix.workflow.yaml` | CREATE |
| feature.workflow.yaml | `.opencode/workflow/definitions/feature.workflow.yaml` | CREATE |
| ui.workflow.yaml | `.opencode/workflow/definitions/ui.workflow.yaml` | CREATE |
| docs.workflow.yaml | `.opencode/workflow/definitions/docs.workflow.yaml` | CREATE |
| MIGRATION_GUIDE.md | `.opencode/workflow/MIGRATION_GUIDE.md` | CREATE |
| team.md | `.opencode/commands/team.md` | MODIFY (Option A, chờ #Q01) |
| sync-system-docs.ps1 | `.opencode/scripts/sync-system-docs.ps1` | MODIFY (optional) |
