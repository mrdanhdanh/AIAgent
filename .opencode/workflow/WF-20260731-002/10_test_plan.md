# 10 — Test Plan (Test-Planner v2.0)

**Workflow:** WF-20260731-002
**Status:** READY

## Summary

Kế hoạch test thực tế cho 3 script PowerShell 5.1. Không dùng xUnit/bUnit (không thuộc dự án .NET) — test bằng cách chạy trực tiếp script + verify output/exit code. Framework: PowerShell script execution tests.

## impact_analysis
- modified_files:
  - .opencode/scripts/sync-system-docs.ps1
  - .opencode/scripts/schema-validator.ps1
  - .opencode/scripts/cross-ref-validator.ps1
- dependencies: PowerShell 5.1, .opencode/commands/*.md (read-only), .opencode/agents/*.md (read-only)
- public_api_changed: switch `-report` → `-evolutionReport` (sync-system-docs.ps1) — breaking change nhỏ cho CLI, cần test
- ui_changed: false
- database_changed: false
- config_changed: false
- breaking_changes: true (switch rename) — nhưng đây là bug fix được yêu cầu, chỉ 1 file gọi script này (team-syncdocs.md)
- affects: scripts/.opencode
- does_not_affect: JapaneseLearner app, .NET tests, E2E tests

## requirements
| id | description |
|----|-------------|
| REQ-001 | sync-system-docs.ps1 chạy `-dryRun` không lỗi, không crash |
| REQ-002 | sync-system-docs.ps1 báo report đúng (agents/commands/skills/scripts/knowledge) |
| REQ-003 | schema-validator.ps1 không parse error (mojibake fix) |
| REQ-004 | cross-ref-validator.ps1 không `Cannot find path`, không ArgumentNullException |
| REQ-005 | cross-ref-validator.ps1 JSON report hợp lệ, checks_fail = 0 |
| REQ-006 | Cả 3 file parse-clean bằng PS 5.1 parser |
| REQ-007 | Cả 3 file có BOM UTF-8, CRLF giữ nguyên |

## existing
- framework: PowerShell script execution (không có test framework hiện có cho scripts)
- files: (không có test tự động cho scripts .opencode)
- already_cover: []
- missing: test thực thi scripts
- duplicated: []

## risk_assessment
- risk_level: low
- reason: Sửa 3 utility scripts phục vụ dev-team, không đụng production code. Rủi ro chính: script vẫn crash sau fix.
- coverage_target: unit N/A, overall N/A (manual execution)

## testability
- status: GOOD
- issues: []
- recommendations: []

## test_cases
| id | type | description | input | expected | priority |
|----|------|-------------|-------|----------|----------|
| TC-001 | EXECUTION | Chạy sync-system-docs -dryRun | `& sync-system-docs.ps1 -dryRun` | Không exception, report hiển thị agents 17/commands 21, DRY-RUN messages | P0 |
| TC-002 | EXECUTION | Chạy schema-validator | `& schema-validator.ps1` | Không ParserError, files_scanned 17, report JSON sinh | P0 |
| TC-003 | EXECUTION | Chạy cross-ref-validator | `& cross-ref-validator.ps1` | EXIT 0, không `Cannot find path`, checks_fail 0, JSON hợp lệ | P0 |
| TC-004 | STATIC | Parse 3 file PS 5.1 parser | Parser.ParseFile | 0 errors | P0 |
| TC-005 | STATIC | Verify encoding | byte check | 3 file đều EF BB BF | P1 |
| TC-006 | REGRESSION | Verify switch rename không sót | grep `$evolutionReport` | đúng 3 occurrences; không còn `-or $report`/`$report -or` | P1 |
| TC-007 | REGRESSION | Verify non-ASCII trong 2 file đã fix | regex `[^\x00-\x7F]` | schema/cross-ref chỉ còn 3 bytes BOM | P1 |
| TC-008 | EDGE | cross-ref với command không prefix | (chạy TC-003) | backup/doctor/impeccable/team xử lý đúng, không FAIL | P1 |

## coverage_matrix
| requirement | test_cases |
|-------------|-----------|
| REQ-001, REQ-002 | TC-001 |
| REQ-003 | TC-002 |
| REQ-004, REQ-005 | TC-003 |
| REQ-006 | TC-004 |
| REQ-007 | TC-005 |
| (regression) | TC-006, TC-007, TC-008 |

## regression_scope
- direct: sync-system-docs.ps1, schema-validator.ps1, cross-ref-validator.ps1
- indirect: team-syncdocs.md (gọi sync-system-docs.ps1)
- unaffected: JapaneseLearner app, .NET tests, E2E tests, các scripts khác (backup-utility, rollback-utility, gitpush-utility, doctor.ps1)
- regression_cases: TC-006, TC-007, TC-008

## coverage_target
- unit: N/A (không có test framework cho scripts)
- integration: N/A
- e2e: N/A
- overall: N/A — thay bằng "execution coverage: 8/8 test cases"

## validation
- checklist:
  - All requirements covered? PASS
  - Regression exists? PASS
  - Positive test exists? PASS (TC-001..005)
  - Negative test exists? PASS (TC-006..008 kiểm tra điều kiện không được vi phạm)
  - Edge cases exist? PASS (TC-008)
  - Test file path valid? PASS
  - Framework detected? PASS (PowerShell execution)
- all_pass: true

## issues
- (không có)

## next_action
Thực thi test plan (Tester agent)
## artifacts
- [10_test_plan.md]
