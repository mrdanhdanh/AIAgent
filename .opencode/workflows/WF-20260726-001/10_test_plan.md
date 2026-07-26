---
step: 10
step_name: testplan
timestamp: 2026-07-26T00:00:00Z
workflow_id: WF-20260726-001
---

## TEST PLAN — NÂNG CẤP HỆ THỐNG AGENT

### Test types

| Loại | Cần? | Ghi chú |
|------|------|---------|
| Unit | ✅ | Parse YAML samples, validate schema |
| Integration | ✅ | Simulate workflow cycle |
| Edge | ✅ | Backward compat with old format |
| Error handling | ✅ | Broken YAML, missing fields |

### Test cases

| ID | Type | Description | Input | Expected |
|----|------|-------------|-------|----------|
| TC-001 | Unit | Parse Base Schema YAML | Base schema YAML mẫu | status, summary, issues, next_action, artifacts đều parse được |
| TC-002 | Unit | Parse output contract mỗi agent | Mỗi agent YAML mẫu | Extends Base Schema, không thiếu field |
| TC-003 | Unit | Error Priority Map | severity=CRITICAL | Action=stop/rollback |
| TC-004 | Unit | Error Priority Map | severity=MAJOR | Action=rebuild |
| TC-005 | Unit | Error Priority Map | severity=MINOR | Action=log |
| TC-006 | Integration | Simulate full workflow với Guardrail | 13 steps | Guardrail chạy trước Backup |
| TC-007 | Integration | Diff mechanism | 2 retry loops | diff_snapshots có old_errors, new_errors, same_errors |
| TC-008 | Edge | Backward compat — thiếu next_action | Agent output thiếu field | Mặc định "Tiếp tục workflow" |
| TC-009 | Edge | Backward compat — thiếu artifacts | Agent output thiếu field | Mặc định [] |
| TC-010 | Error | Broken YAML | Output không parse được | Orchestrator log warning, yêu cầu làm lại |

### Framework
Manual validation (YAML parse + nội dung kiểm tra)

### Coverage targets
- All 10 test cases PASS
