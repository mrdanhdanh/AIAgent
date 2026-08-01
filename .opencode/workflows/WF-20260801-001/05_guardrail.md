---
workflow_id: "WF-20260801-001"
step: 5
step_name: "guardrail"
agent: "general (orchestrator)"
schema_version: "3.2"
timestamp: "2026-08-01T17:40:00Z"
---

# Bước 5: Guardrail (Pre-Build)

```yaml
guardrail_result:
  overall: "PASS"
  checks:
    - { id: "1_test_cases", result: "PASS", detail: "23 steps đều có check + validation_command" }
    - { id: "2_rollback_strategy", result: "PASS", detail: "rollback_strategy.enabled: true, trigger_conditions + restore_order + requires_user_confirmation" }
    - { id: "3_step_action_check", result: "PASS", detail: "Mỗi step có action CREATE/MODIFY/DELETE rõ ràng" }
    - { id: "4_step_expected_result", result: "PASS", detail: "23/23 steps có expected_result" }
    - { id: "5_requires_backup_check", result: "PASS", detail: "Step 17 (opencode.json) + step 23 (SYSTEM_MAP) requires_backup: true" }
    - { id: "6_per_step_validation_check", result: "PASS", detail: "per_step_validation có 3 mục" }
    - { id: "7_final_validation_check", result: "PASS", detail: "final_validation có 3 lệnh (build/test/JSON validate)" }
    - { id: "8_dependency_check", result: "PASS", detail: "depends_on forward-only, không circular" }
    - { id: "9_backup_check", result: "PASS", detail: ".opencode/scripts/backup-utility.ps1 tồn tại" }
    - { id: "10_validate_steps", result: "PASS", detail: "23 steps đủ order/description/file/logic/check" }
  blocked_issues: []
  warnings: []
  next_step: "Backup"
```
