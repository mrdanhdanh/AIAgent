# 11 — Test (Tester)

**Workflow:** WF-20260731-002
**Status:** APPROVED

## Summary

8/8 test cases PASS. Cả 3 script chạy thực tế không lỗi, JSON reports hợp lệ, encoding chuẩn, không regression.

## results

| id | type | status | detail |
|----|------|--------|--------|
| TC-001 | EXECUTION | PASS | sync-system-docs.ps1 -dryRun: không exception, Agents 17 / Commands 21 / Skills 5 / Scripts 7 / Knowledge 8, DRY-RUN mode hoạt động |
| TC-002 | EXECUTION | PASS | schema-validator.ps1: 0 ParserError, files_scanned 17, report JSON sinh |
| TC-003 | EXECUTION | PASS | cross-ref-validator.ps1: EXIT 0, 0 "Cannot find path", 0 ArgumentNullException, checks_fail 0, all_pass True |
| TC-004 | STATIC | PASS | Parse 3 file bằng PS 5.1 Parser.ParseFile: 0 errors |
| TC-005 | STATIC | PASS | Cả 3 file BOM UTF-8 (EF BB BF) |
| TC-006 | REGRESSION | PASS | $evolutionReport đúng 3 occurrences; 0 tham chiếu switch $report cũ |
| TC-007 | REGRESSION | PASS | schema/cross-ref non-ASCII chỉ còn 3 bytes (BOM); không mojibake |
| TC-008 | EDGE | PASS | backup.md, doctor.md, impeccable.md, team.md (không prefix) đều không FAIL |

## Output thực tế (copy-paste)

### TC-001 — `& .opencode\scripts\sync-system-docs.ps1 -dryRun`
```
Scanning agents...
Scanning commands...
Scanning skills...
Scanning scripts...
Scanning knowledge...
Cross-referencing...
Generating SYSTEM_MAP.md...
DRY-RUN: Would generate SYSTEM_MAP.md
Updating team.md command table...
DRY-RUN: Would update team.md table
Updating SKILL.md integration table...
DRY-RUN: Would update SKILL.md table

========================================
  SYSTEM DOCS SYNC REPORT
========================================
  Agents:     17
  Commands:   21
  Skills:     5
  Scripts:    7
  Knowledge:  8
  Evolution:  Executed
  Issues:     3
  ---------- Issues ----------
    ! ORPHAN_AGENT: agent=learning-agent
    ! ORPHAN_AGENT: agent=root-cause-agent
    ! ORPHAN_AGENT: agent=failure-agent
========================================
Done!
```
(3 ORPHAN_AGENT là dữ liệu thật — support agents không có command riêng, không phải lỗi script)

### TC-002 — `& .opencode\scripts\schema-validator.ps1`
```
[FAIL] analyst.md
  - FRONTMATTER: No YAML frontmatter found (--- ... ---)
  ...
Report: .opencode/scripts/schema-validator-report.json
EXIT: 1 | ParserError count: 0 | report JSON: True
```
(Không còn ParserError — script chạy đúng. FAIL files là kết quả phân tích thật của validator: agent .md files dùng frontmatter không match regex chuẩn — nằm ngoài phạm vi fix 3 bug)

### TC-003 — `& .opencode\scripts\cross-ref-validator.ps1`
```
=== Cross-Reference Validator ===

[WARN] skill->anchor: SKILL.md -> #mô-hình-orchestrator
       Possible broken internal link
... (90 WARN, pre-existing section 6)
Report: .opencode/scripts/cross-ref-validator-report.json
EXIT: 0 | Cannot find path: 0 | ArgumentNullException: 0 | checks_fail: 0 | all_pass: True
```

## coverage
- unit: N/A (PowerShell scripts, không có test framework)
- integration: N/A
- e2e: N/A
- execution_coverage: 8/8 (100%)
- thresholds_met: true

## issues
- severity: MINOR
- category: STYLE
- description: "90 WARN skill->anchor từ section 6 (anchor check trong SKILL.md TOC) — phần lớn là false positive do TOC dùng anchor tiếng Việt không dấu vs header có dấu"
- suggestion: "Ngoài phạm vi workflow này — ghi nhận cho workflow sau. WARN không block (exit 0)."

## next_action
Chuyển sang Skill Validation
## artifacts
- [11_test.md]
