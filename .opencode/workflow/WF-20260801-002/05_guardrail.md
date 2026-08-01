# 05_guardrail.md — WF-20260801-002

## Pre-Build Guardrail — Kết quả

**Kết luận: ✅ PASS (10/10 checks)**

| # | Check | Status | Ghi chú |
|---|-------|--------|---------|
| 1 | test_cases | ✅ PASS | Mỗi step có `check` + per_step_validation |
| 2 | rollback_strategy | ✅ PASS | `enabled: true`, trigger_conditions, restore_order (25→1) |
| 3 | step_action_check | ✅ PASS | 23 steps CREATE + 2 steps MODIFY rõ ràng |
| 4 | step_expected_result | ✅ PASS | Tất cả 25 steps có `expected_result` |
| 5 | requires_backup_check | ✅ PASS | Step 24 (AGENTS.md) + 25 (knowledge/README.md) = true |
| 6 | per_step_validation_check | ✅ PASS | 25 per_step + 5 per_chunk validations |
| 7 | final_validation_check | ✅ PASS | dotnet build + dotnet test + build-knowledge-index -Update |
| 8 | dependency_check | ✅ PASS | Không circular: 1-10 → 11 → 12-23 → 24-25 |
| 9 | backup_check | ✅ PASS | backup-utility.ps1 + rollback-utility.ps1 tồn tại |
| 10 | validate_steps | ✅ PASS | Đủ order/description/file/logic/check/risk_level |

## Files cần backup (MODIFY)

- `AGENTS.md`
- `.opencode/knowledge/README.md`

## Files CREATE (không cần backup)

- 11 skills (10 chuyên biệt + 1 orchestrator)
- 10 commands
- 1 script build-knowledge-index.ps1
- knowledge-index/ (7 index + README)

## Chuyển tiếp

→ Bước 6: Backup 2 files MODIFY bằng backup-utility.ps1
