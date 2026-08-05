# 04_review.md — WF-20260801-003

## Review — Sprint 1: Workflow Engine (v4 Foundation)

```yaml
decision: "CHANGES_REQUESTED"
scores:
  completeness: 8
  accuracy: 8
  safety: 6
  efficiency: 8
  testability: 6
  overall: 7.1
score_rationale:
  completeness: "Thiếu: (1) bước smoke-test engine, (2) validator script cụ thể cho definitions .yaml, (3) backup cho step 16 MODIFY sync-system-docs.ps1."
  safety: "Cutover cuối + backup team.md + rollback 3 bước tốt, nhưng step 16 không backup sync-system-docs.ps1; fallback chỉ báo lỗi file:line — /team phụ thuộc hoàn toàn engine docs."
consistency_checks:
  contract_match: true
  file_path_match: true
  dependency_valid: true
issues:
  - id: "#01"
    severity: "MAJOR"
    category: "LOGIC"
    blocking: true
    fix_priority: 1
    affected_phase: "PLAN"
    description: "Design #01 yêu cầu chạy thử workflow trước cutover nhưng 03_plan.md không có step smoke-test."
    suggestion: "Thêm step smoke-test engine trước cutover: chạy /team --workflow docs hoặc ui với yêu cầu giả, verify pipeline đến COMPLETE; chỉ chốt cutover khi PASS. Ghi rõ quy trình restore nhanh team.md trong MIGRATION_GUIDE."
  - id: "#02"
    severity: "MAJOR"
    category: "DESIGN"
    blocking: true
    fix_priority: 2
    affected_phase: "BUILD"
    description: "Step 16 MODIFY sync-system-docs.ps1 không có backup."
    suggestion: "Backup sync-system-docs.ps1 trước khi MODIFY (backup-utility.ps1 -action save)."
  - id: "#03"
    severity: "MAJOR"
    category: "TESTABILITY"
    blocking: true
    fix_priority: 3
    affected_phase: "BUILD"
    description: "5 definitions .yaml không có validator thực thi rõ ràng."
    suggestion: "Tạo scripts/workflow-validator.ps1 (hoặc ghi rõ inline PowerShell + expected output) cho final validation."
  - id: "#04"
    severity: "MAJOR"
    category: "LOGIC"
    blocking: false
    fix_priority: 4
    affected_phase: "PLAN"
    description: "Final validation gồm /knowledge-index --update nhưng build-knowledge-index.ps1 chỉ scan JapaneseLearner/ + .opencode/knowledge/ — không quét workflow-engine/."
    suggestion: "Chạy --status để xác nhận index không vỡ, không claim index cho docs mới; hoặc mở rộng script (deferred + note trong MIGRATION_GUIDE)."
  - id: "#05"
    severity: "MINOR"
    category: "CONSISTENCY"
    blocking: false
    fix_priority: 5
    affected_phase: "BUILD"
    description: "Cutover team.md không nêu rõ giữ frontmatter (description, agent: general) + HELP section."
    suggestion: "Step 17 phải giữ frontmatter + HELP section; engine docs vẫn reference /team-analyze etc cho phase-runner dispatch."
  - id: "#06"
    severity: "MINOR"
    category: "LOGIC"
    blocking: false
    fix_priority: 6
    affected_phase: "BUILD"
    description: "Flag --workflow chưa định nghĩa default + invalid id."
    suggestion: "Bổ sung engine.md/validator.md: default_workflow: default; invalid id → WF-ERR kèm danh sách definitions."
  - id: "#07"
    severity: "MINOR"
    category: "PERFORMANCE"
    blocking: false
    fix_priority: 7
    affected_phase: "BUILD"
    description: "sync-system-docs.ps1 dùng Out-File -Encoding utf8 (PS 5.1 → BOM), mâu thuẫn quy ước no-BOM."
    suggestion: "Chuẩn hóa utf8NoBOM; thêm check BOM vào final validation cho cả file do script sinh."
  - id: "#08"
    severity: "MINOR"
    category: "CONSISTENCY"
    blocking: false
    fix_priority: 8
    affected_phase: "BUILD"
    description: "MIGRATION_GUIDE.md + schemas/ + definitions/ đặt trong workflow/ lẫn với runtime WF-*/."
    suggestion: "README.md vẽ rõ 3 vai trò (schemas/ static, definitions/ static, WF-*/ runtime)."

required_updates:
  - "Thêm step smoke-test engine trước cutover (theo design #01)"
  - "Thêm backup cho sync-system-docs.ps1 ở step 16"
  - "Materialize validator cho definitions .yaml: tạo scripts/workflow-validator.ps1 hoặc ghi rõ inline command"
  - "Làm rõ phạm vi /knowledge-index --update trong final validation"
  - "Bổ sung xử lý edge --workflow default + invalid id"
  - "Thêm check BOM cho output của sync-system-docs.ps1"
  - "Step 17 giữ frontmatter (agent: general) + HELP section + reference /team-analyze etc"

recommendation: "REVISE_PLAN"
next_step: "Planner cập nhật 03_plan.md theo required_updates, sau đó gửi lại reviewer."
summary: "Design vững (18/18 agents khớp, cutover an toàn), nhưng plan thiếu smoke-test engine, backup step 16, validator definitions .yaml thực thi được; final validation có 2 giả định sai (knowledge-index không quét thư mục mới, schema-validator chỉ scan *.md). CHANGES_REQUESTED (overall 7.1 < 8.5)."
```
