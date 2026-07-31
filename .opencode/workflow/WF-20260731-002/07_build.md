# 07 — Build (Builder v3.1)

**Workflow:** WF-20260731-002
**Status:** PASS

## Summary

8/8 steps PASS. Fix 3 bug + 1 parse error ẩn phát hiện trong quá trình build.

## changed_files
- .opencode/scripts/sync-system-docs.ps1
- .opencode/scripts/schema-validator.ps1
- .opencode/scripts/cross-ref-validator.ps1

## created_files
- (rỗng)

## deleted_files
- (rỗng)

## backup_workflow_id
WF-20260731-002

## steps

| order | status | file | action | per_step_validation | detail |
|-------|--------|------|--------|--------------------|--------|
| 1 | PASS | sync-system-docs.ps1 | MODIFY | parse-clean | `[switch]$report` → `[switch]$evolutionReport` (dòng 11) |
| 2 | PASS | sync-system-docs.ps1 | MODIFY | parse-clean | Dòng 585: `-or $report` → `-or $evolutionReport` |
| 3 | PASS | sync-system-docs.ps1 | MODIFY | parse-clean | Dòng 604: `$runReport = $report -or` → `$runReport = $evolutionReport -or` |
| 4 | PASS | schema-validator.ps1 | MODIFY | chạy không parse error | 2 em-dash U+2014 → `-` (dòng 27, 74) + fix `^$field:` → `^${field}:` (dòng 31, parse error ẩn) + lưu UTF-8 BOM |
| 5 | PASS | cross-ref-validator.ps1 | MODIFY | chạy hết không `Cannot find path` | Bỏ prefix kép section Agent→Command: `team-$cmd` → Test-CommandReferenced ($cmd.md) |
| 6 | PASS | cross-ref-validator.ps1 | MODIFY | chạy hết không ArgumentNullException | Section Command→Agent: dùng `$cmd.md`, skip WARN khi thiếu file; regex `agent:\s*([\w-]+)` hỗ trợ dash; chỉ đọc frontmatter |
| 7 | PASS | cross-ref-validator.ps1 | MODIFY | chạy hết | 12 arrow `→` → `->` + thêm `-Encoding UTF8` cho 6 Get-Content + lưu UTF-8 BOM |
| 8 | PASS | cả 3 file | MODIFY | BOM verify | Cả 3 file UTF-8 BOM, CRLF giữ nguyên |

## Phát hiện thêm (parse error ẩn)
- **schema-validator.ps1 dòng 31:** `if ($yaml -notmatch "^$field:")` — PS 5.1 diễn giải `$field:` thành drive-qualified variable → parse error. Trước đây bị che bởi cascade mojibake dòng 27. Fix: `"^${field}:"`. Đây là lỗi thuộc BUG 2 (parse-clean requirement), không phải logic mới.
- **cross-ref-validator.ps1 section 2:** regex `agent:\s*(\w+)` không hỗ trợ agent name có dash (`backup-agent` → match `backup` → false FAIL) và match cả body text không phải frontmatter (`agent: truyền` trong mô tả). Fix: đọc frontmatter + `[\w-]+`.

## validation_status
PASS — final_validation:
1. Parse 3 file (PS 5.1 Parser.ParseFile): **0 errors**
2. `sync-system-docs.ps1 -dryRun`: **chạy hết, không crash**, JSON hợp lệ
3. `schema-validator.ps1`: **không parse error**, chạy được (17 files scanned)
4. `cross-ref-validator.ps1`: **EXIT 0**, checks_fail 0, không `Cannot find path`, JSON hợp lệ

## issues
- (không blocking)

## next_action
Chuyển sang Static Analysis
## artifacts
- [07_build.md]
