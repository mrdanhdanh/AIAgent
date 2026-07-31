# 03 — Plan (Planner — Plan Phase)

**Workflow:** WF-20260731-002
**Schema:** 3.2
**Status:** READY
**Effort:** Small

## Summary

Kế hoạch 8 bước MODIFY trên 3 file, chia 3 chunks: (1) sync-system-docs, (2) schema-validator, (3) cross-ref-validator. Tất cả steps đều `requires_backup: true`. Per-step validation = PowerShell 5.1 parse + chạy script.

## steps

| order | action | file | chunk | requires_backup | depends_on | risk_level | description |
|-------|--------|------|-------|-----------------|------------|------------|-------------|
| 1 | MODIFY | .opencode/scripts/sync-system-docs.ps1 | 1 | true | [] | MEDIUM | Đổi `[switch]$report` → `[switch]$evolutionReport` (dòng 11) |
| 2 | MODIFY | .opencode/scripts/sync-system-docs.ps1 | 1 | true | [1] | MEDIUM | Dòng 585: `-or $report` → `-or $evolutionReport` |
| 3 | MODIFY | .opencode/scripts/sync-system-docs.ps1 | 1 | true | [2] | MEDIUM | Dòng 604: `$runReport = $report -or` → `$runReport = $evolutionReport -or` |
| 4 | MODIFY | .opencode/scripts/schema-validator.ps1 | 2 | true | [] | LOW | Dòng 27: `—` → `-` (viết lại câu rõ ràng); dòng 74: `—` → `-`; lưu UTF-8 BOM |
| 5 | MODIFY | .opencode/scripts/cross-ref-validator.ps1 | 3 | true | [] | MEDIUM | Fix section Agent→Command (dòng 33-41): bỏ prefix kép, match biến thể tên command, chỉ FAIL khi file thật không tồn tại |
| 6 | MODIFY | .opencode/scripts/cross-ref-validator.ps1 | 3 | true | [5] | MEDIUM | Fix section Command→Agent (dòng 44-54): dùng `$cmd.md`, xử lý file không tồn tại → WARN skip |
| 7 | MODIFY | .opencode/scripts/cross-ref-validator.ps1 | 3 | true | [6] | LOW | Thay 12 arrow `→` U+2192 bằng ASCII `->`; lưu UTF-8 BOM |
| 8 | MODIFY | .opencode/scripts/sync-system-docs.ps1 | 1 | true | [3] | LOW | Đảm bảo file lưu UTF-8 BOM (đã có BOM, verify lại) |

## chi tiết logic từng step

### Step 1-3 (BUG 1 — sync-system-docs.ps1)
- **Dòng 11:** `[switch]$report,              # Run only Evolution Report` → `[switch]$evolutionReport,   # Run only Evolution Report`
- **Dòng 585:** `$runEvolution = $evolve -or ... -or $report -or ($evolutionMode -ne "none")` → `... -or $evolutionReport -or ...`
- **Dòng 604:** `$runReport = $report -or ($evolutionMode -in @('full')) -or $evolve` → `$runReport = $evolutionReport -or ($evolutionMode -in @('full')) -or $evolve`
- **KHÔNG đụng** `$report = @{...}` (dòng 17) và mọi tham chiếu hashtable.
- expected_result: `& sync-system-docs.ps1 -dryRun` chạy hết, không crash, không chạy Evolution Engine (dryRun chặn), report JSON sinh ra.

### Step 4 (BUG 2 — schema-validator.ps1)
- Dòng 27: `$errors += "Literal block scalar (|/>) detected — ensure proper indentation"` → `$errors += "Literal block scalar (|/>) detected - ensure proper indentation"`
- Dòng 74: `$errors += "YAML sample block $($i+1): parse error — $($_.Exception.Message)"` → `... parse error - $($_.Exception.Message)"`
- Sau đó ghi file **UTF-8 có BOM** (dùng .NET `[System.Text.UTF8Encoding]::new($true)` hoặc `Set-Content -Encoding utf8`).
- expected_result: PS 5.1 parse-clean, `& schema-validator.ps1` chạy được (có thể báo FAIL cho file agent nếu lỗi YAML — đó là hành vi đúng, không phải parse error).

### Step 5-7 (BUG 3 — cross-ref-validator.ps1)
- **Dòng 36:** thay thế khối `if ($content -match "team-$cmd" -and -not (Test-Path "$opencodeDir/commands/team-$cmd.md"))` bằng:
  ```powershell
  $cmdFile = "$cmd.md"
  $variants = @("/$cmd", "/$cmd.md", "$cmd.md", $cmd)
  $referenced = $false
  foreach ($v in $variants) {
      if ($content -match [regex]::Escape($v)) { $referenced = $true; break }
  }
  if ($referenced -and -not (Test-Path "$opencodeDir/commands/$cmdFile")) {
      # FAIL — command thật sự không tồn tại
  }
  ```
  Lưu ý: nên ưu tiên variant dài nhất trước (`/$cmd.md` → `/$cmd` → `$cmd.md` → `$cmd`) để tránh match nhầm prefix (vd `team` match trong `team-analyze`). Dùng regex có word-boundary hoặc yêu cầu ký tự phân tách.
- **Dòng 45:** `$content = Get-Content -LiteralPath "$opencodeDir/commands/team-$cmd.md" -Raw` → kiểm tra `Test-Path "$opencodeDir/commands/$cmd.md"` trước; nếu không tồn tại → WARN + continue; nếu tồn tại → đọc và parse `agent:`.
- **Dòng 50:** `From = "team-$cmd.md"` → `From = "$cmd.md"`.
- **12 arrows `→`** → `->` (dòng 32, 37, 43, 50, 56, 60, 65, 72, 85, 91, 99, 111).
- Lưu UTF-8 BOM.
- expected_result: chạy hết, **không còn** `Cannot find path`, không `ArgumentNullException`, JSON report hợp lệ.

### Step 8 (verify BOM)
- Kiểm tra cả 3 file có BOM + parse-clean.

## per_step_validation
| step | command | expected |
|------|---------|----------|
| 1-3 | `[System.Management.Automation.Language.Parser]::ParseFile(...)` + `& sync-system-docs.ps1 -dryRun` | parse-clean, chạy không lỗi |
| 4 | `& schema-validator.ps1` | không ParserError (chỉ FAIL/PASS cho từng file agent) |
| 5-7 | `& cross-ref-validator.ps1` | không `Cannot find path`, JSON hợp lệ |
| 8 | byte check BOM 3 file | cả 3 đều EF BB BF |

## final_validation
| command | expected |
|---------|----------|
| Parse 3 file bằng Parser.ParseFile | 0 error |
| Chạy `sync-system-docs.ps1 -dryRun` | exit 0, không exception |
| Chạy `schema-validator.ps1` | không parse error |
| Chạy `cross-ref-validator.ps1` | không `Cannot find path`, JSON hợp lệ |

## rollback_strategy
- enabled: true
- trigger_conditions:
  - catastrophic_failure (threshold 1)
  - max_retry_reached (threshold 3)
  - user_request
- restore_order:
  - Bước 1: restore 3 file từ backup (backup-utility.ps1 / git checkout)
- requires_user_confirmation: true

## validate (backward compat)
- "Chạy cả 3 script sau khi build"
- "Kiểm tra encoding UTF-8 BOM"

## blocking_issues
- (rỗng)
## non_blocking_issues
- (rỗng)
## open_questions
- (rỗng)

## next_action
Chuyển sang Review phase
## artifacts
- [03_plan.md]
