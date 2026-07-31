# 02 — Design (Planner — Design Phase)

**Workflow:** WF-20260731-002
**Schema:** 3.2
**Status:** READY
**Effort:** Small

## Summary

Thiết kế giải pháp fix 3 bug script. Chiến lược chung: **minimal-diff, không đổi logic chức năng**. Mỗi bug có hướng tiếp cận riêng nhưng tuân theo nguyên tắc: chỉ đổi đúng chỗ hỏng, giữ nguyên data container, bảo toàn CRLF, chuẩn hóa encoding về UTF-8 có BOM (an toàn cho PS 5.1).

## design

### architecture
- Không thêm component mới. 3 file script độc lập được sửa trực tiếp.
- Encoding chuẩn hoá: **UTF-8 có BOM** cho tất cả 3 file (PS 5.1 đọc BOM → đúng UTF-8; không BOM → ANSI → mojibake).
- CRLF giữ nguyên (Windows convention).

### components
| name | path | action |
|------|------|--------|
| sync-system-docs.ps1 | .opencode/scripts/sync-system-docs.ps1 | MODIFY — rename switch |
| schema-validator.ps1 | .opencode/scripts/schema-validator.ps1 | MODIFY — non-ASCII → ASCII + BOM |
| cross-ref-validator.ps1 | .opencode/scripts/cross-ref-validator.ps1 | MODIFY — prefix logic + non-ASCII → ASCII + BOM |

### data_flow (BUG 1 cụ thể)
1. `param(...)` khai báo `[switch]$report` → **đổi thành** `[switch]$evolutionReport` (dòng 11).
2. `$report = @{...}` (dòng 17) — hashtable GIỮ NGUYÊN tên `$report` (hàng chục tham chiếu dòng 50-803 đang dùng nó làm data container).
3. Dòng 585: `$runEvolution = ... -or $report` → đổi thành `-or $evolutionReport`.
4. Dòng 604: `$runReport = $report -or ...` → đổi thành `$evolutionReport -or ...`.
5. Lưu ý: dòng 807 `if ($runReport -and ...)` dùng `$runReport` (biến trung gian) — KHÔNG cần đổi.

### data_flow (BUG 3 cụ thể)
1. `Get-CommandNames` trả BaseName thật: `backup`, `doctor`, `impeccable`, `team`, `team-analyze`, ...
2. Section Agent→Command (dòng 36): `$content -match "team-$cmd"` và `Test-Path "$opencodeDir/commands/team-$cmd.md"` — vấn đề kép:
   - `-match "team-$cmd"` với `$cmd="team-analyze"` sẽ match `team-team-analyze` trong content → false trigger. Cần logic: kiểm tra command thật được nhắc tới trong content.
   - `Test-Path "team-$cmd.md"` luôn sai khi `$cmd` đã có prefix hoặc không có.
   → **Thiết kế:** normalize command name: `$cmdFile = "$cmd.md"` (BaseName chính là tên file). Với match trong content, dùng pattern linh hoạt: command được nhắc tới có thể là `/team-analyze`, `team-analyze`, `team-analyze.md`, `/team-analyze.md`. Nếu content match **bất kỳ** biến thể nào của tên command → kiểm tra file `$cmd.md` tồn tại; chỉ FAIL khi file thật sự không tồn tại.
3. Section Command→Agent (dòng 45): `Get-Content "$opencodeDir/commands/team-$cmd.md"` → đổi thành `"$opencodeDir/commands/$cmd.md"`. Nếu file không tồn tại → ghi WARN (command không có file, không crash), skip.
4. Đảm bảo với `$cmd` không có prefix (backup, doctor, impeccable, team) vẫn chạy đúng.

### security_concerns
- Không có input từ user, không network. Rủi ro duy nhất: script sửa file ngoài phạm vi → bị chặn bởi guardrail (chỉ 3 file được phép).

### edge_cases
| edge case | handling |
|-----------|----------|
| `$cmd = "team"` (command có file team.md, không prefix kép) | `$cmd.md` = `team.md` tồn tại → PASS |
| `$cmd = "backup"` (không prefix) | `backup.md` tồn tại → PASS |
| Content nhắc tới command qua `/team-analyze` | pattern match bắt biến thể có dấu `/` |
| Command có trong content nhưng file không tồn tại | FAIL đúng (đây là mục đích validator) |
| File command không tồn tại (Command→Agent section) | WARN + skip thay vì crash ArgumentNullException |

## blocking_issues
- (rỗng)

## non_blocking_issues
- (rỗng)

## open_questions
- (rỗng — yêu cầu đã đầy đủ)

## next_action
Chuyển sang Plan phase
## artifacts
- [02_design.md]
