# 01 — Analysis (Analyst Agent)

**Workflow:** WF-20260731-002
**Schema:** 3.1
**Status:** READY
**Effort:** Small

## Summary

Phân tích 3 bug pre-existing trong `.opencode/scripts/`, tất cả đều đã được xác nhận bằng cách chạy thực tế trên PowerShell 5.1 (win32). Cả 3 script hiện đều HỎNG:

1. `sync-system-docs.ps1` — switch `$report` bị shadow bởi hashtable `$report` → crash ngay lúc khởi tạo hashtable (dòng 17).
2. `schema-validator.ps1` — file UTF-8 không BOM chứa em-dash `—` (U+2014) → PS 5.1 đọc ANSI → mojibake → vỡ string literal → parse error toàn file.
3. `cross-ref-validator.ps1` — double prefix `team-team-` (Get-CommandNames trả BaseName nhưng logic lại tự nối `team-`) → Get-Content liên tục `Cannot find path` + `ArgumentNullException`; ngoài ra file chứa 12 arrow `→` (U+2192) không BOM.

## Evidence (chạy thực tế 2026-07-31)

### BUG 1 — sync-system-docs.ps1
```
Cannot create object of type "System.Management.Automation.SwitchParameter". The issues property was not found for the
System.Management.Automation.SwitchParameter object. The available property is: [IsPresent <System.Boolean>]
At C:\...\.opencode\scripts\sync-system-docs.ps1:17 char:1
+ $report = @{
```
→ `$report = @{...}` gán đè switch `[switch]$report` (dòng 11). PS không cho gán hashtable lên biến SwitchParameter → crash.

Root cause: dòng 11 `[switch]$report` và dòng 17 `$report = @{...}` trùng tên. Tham chiếu switch ở dòng 585 (`-or $report`) và 604 (`$runReport = $report -or`) thực ra đang trỏ vào hashtable → logic report-mode sai ngay cả khi không crash.

### BUG 2 — schema-validator.ps1
```
At C:\...\schema-validator.ps1:27 char:65
+ ...    $errors += "Literal block scalar (|/>) detected �?" ensure proper  ...
+                                                            ~~~~~~
Unexpected token 'ensure' in expression or statement.
```
Non-ASCII scan: 2 em-dash `—` U+2014 tại dòng 27 và 74 (6 bytes UTF-8), file **không BOM** → PS 5.1 đọc ANSI → byte 0x94 (của U+2014 trong UTF-8 là E2 80 94) decode sai → vỡ chuỗi.

### BUG 3 — cross-ref-validator.ps1
```
Get-Content : Cannot find path '.opencode/commands/team-backup.md' because it does not exist.
Get-Content : Cannot find path '.opencode/commands/team-team-analyze.md' because it does not exist.
Exception calling "Match" with "2" argument(s): "Value cannot be null. Parameter name: input"
```
- Dòng 45: `"$opencodeDir/commands/team-$cmd.md"` — với `$cmd = "backup"` → `team-backup.md` (sai); với `$cmd = "team-analyze"` → `team-team-analyze.md` (sai gấp đôi).
- Dòng 36: `"team-$cmd"` cho section Agent→Command — same double prefix.
- Danh sách command thực tế: `backup, doctor, impeccable, team, team-analyze, team-analyze-failure, team-build, team-cleanup, team-doctor, team-explore, team-gitguard, team-gitpush, team-learn, team-plan, team-review, team-root-cause, team-selfimprove, team-syncdocs, team-test, team-testplan, team-ui-audit` (21 file).
- Non-ASCII: 12 arrow `→` U+2192 (36 bytes), không BOM → mojibake output.

## scanned_paths
- `.opencode/scripts/sync-system-docs.ps1` (811 dòng)
- `.opencode/scripts/schema-validator.ps1` (122 dòng)
- `.opencode/scripts/cross-ref-validator.ps1` (128 dòng)
- `.opencode/commands/*.md` (21 file — để xác minh tên command thật)

## ignored_paths
- (rỗng — phạm vi khép kín 3 file theo yêu cầu)

## requirements
| id | description | priority |
|----|-------------|----------|
| REQ-001 | Fix `$report` shadow trong sync-system-docs.ps1 — đổi tên switch → `$evolutionReport`, cập nhật 2 tham chiếu (dòng 585, 604) | HIGH |
| REQ-002 | Fix mojibake schema-validator.ps1 — thay non-ASCII bằng ASCII + lưu UTF-8 BOM | HIGH |
| REQ-003 | Fix double prefix cross-ref-validator.ps1 — dùng `$cmd.md` thay vì `team-$cmd.md`, handle cả command có/không prefix `team-` | HIGH |
| REQ-004 | Xóa toàn bộ non-ASCII còn lại (schema line 74, cross-ref 12 arrows) | MEDIUM |
| REQ-005 | KHÔNG sửa logic chức năng khác, KHÔNG sửa file ngoài 3 file | HIGH |

## risks
| id | description | severity | mitigation |
|----|-------------|----------|------------|
| RISK-001 | Đổi tên switch sai chỗ → mất khả năng bật report-mode | MEDIUM | Chỉ đổi tên switch ở dòng 11 + 2 tham chiếu switch; hashtable `$report` giữ nguyên |
| RISK-002 | Ghi lại file làm hỏng encoding/CRLF | LOW | Dùng .NET ReadAllBytes/WriteAllBytes với UTF8 BOM, giữ CRLF |
| RISK-003 | cross-ref logic vẫn còn references tới command không tồn tại thật sự | LOW | Script chỉ FAIL khi file thực sự không tồn tại sau khi fix prefix |

## impact_scope
| file | level | notes |
|------|-------|-------|
| .opencode/scripts/sync-system-docs.ps1 | DIRECT | Fix switch shadow |
| .opencode/scripts/schema-validator.ps1 | DIRECT | Fix encoding + non-ASCII |
| .opencode/scripts/cross-ref-validator.ps1 | DIRECT | Fix prefix + non-ASCII |
| .opencode/commands/*.md | INDIRECT | Chỉ đọc, không sửa |
| UI/.NET (JapaneseLearner) | UNRELATED | Không đụng |

## conclusion
- **status:** READY
- **reason:** Cả 3 bug đã có bằng chứng thực thi + root cause rõ ràng + cách fix an toàn đã được xác định
- **missing_info:** []
