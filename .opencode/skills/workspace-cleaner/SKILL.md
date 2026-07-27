---
name: workspace-cleaner
description: Dọn rác Workspace tự động — xóa build artifacts, backup cũ, temp files, cache không cần thiết. Tích hợp dry-run bắt buộc, backup trước khi xóa, confirmation gate, protected list cấu trúc, và output contract chi tiết. Sử dụng câu lệnh /team-cleanup.
schema_version: "2.0"
workflow_id_format: "WF-YYYYMMDD-NNN"
risk_levels: ["LOW", "MEDIUM", "HIGH"]
mandatory_dry_run: true
---

# Workspace Cleaner — Workspace Garbage Collection Skill

Skill chuyên dọn dẹp rác trong Workspace: xóa file tạm, build artifacts, backup workflow cũ, cache, và các file không cần thiết khác. Đảm bảo an toàn với dry-run mode, backup trước khi xóa, và confirmation gate.

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [PHÂN LOẠI RÁC](#phân-loại-rác)
- [ARCHITECTURE](#architecture)
- [QUY TRÌNH DỌN DẸP](#quy-trình-dọn-dẹp)
- [8 KÊNH KIỂM TRA RÁC](#8-kênh-kiểm-tra-rác)
- [ĐỊNH DẠNG ĐẦU RA](#định-dạng-đầu-ra)
- [SƠ ĐỒ QUYẾT ĐỊNH](#sơ-đồ-quyết-định)
- [TÍCH HỢP VỚI DEV TEAM WORKFLOW](#tích-hợp-với-dev-team-workflow)
- [XỬ LÝ NGOẠI LỆ](#xử-lý-ngoại-lệ)

---

## TỔNG QUAN

Workspace Cleaner là skill dọn dẹp workspace tự động, giúp giải phóng dung lượng ổ đĩa và giữ workspace sạch sẽ. Không tự động xóa bất cứ thứ gì nếu chưa có xác nhận — luôn có dry-run mode để xem trước.

### Khi nào dùng Workspace Cleaner?

- **Khi workspace đầy** — build artifacts, backup cũ chiếm nhiều dung lượng
- **Trước khi commit lớn** — dọn sạch file không cần thiết
- **Định kỳ bảo trì** — giữ workspace gọn gàng
- **Sau khi hoàn thành workflow** — dọn artifact cũ, giữ lại N workflow gần nhất

### Agent

| Vai trò | Agent | File |
|---------|-------|------|
| Cleaner (dọn dẹp) | `cleaner` | `.opencode/agents/cleaner.md` |

### Command

| Command | Mô tả |
|---------|-------|
| `/team-cleanup` | Chạy workspace cleanup với dry-run trước |
| `/team-cleanup --dry-run` | Chỉ xem trước, không xóa gì |
| `/team-cleanup --force` | Bỏ qua confirmation gate, tự động xóa |
| `/team-cleanup --keep-backup <N>` | Giữ lại N workflow backup gần nhất (mặc định: 5) |
| `/team-cleanup --aggressive` | Chế độ mạnh: xóa cả NuGet cache, dotnet temp |
| `/team-cleanup --target <type>` | Chỉ dọn loại rác cụ thể (build|backup|temp|cache|log|all) |
| `/team-cleanup --older-than <days>` | Chỉ xóa file cũ hơn N ngày |

---

## PHÂN LOẠI RÁC

### Hệ thống Risk Level chuẩn hóa

| Mức | Định nghĩa | Hành động | Ví dụ |
|-----|-----------|-----------|-------|
| `LOW` | Cache/temp có thể xóa ngay, tái tạo được | Xóa trực tiếp, không cần backup | `bin/`, `obj/`, `TestResults/` |
| `MEDIUM` | Build artifacts hoặc file có giá trị tạm thời | Cần backup trước khi xóa | Backup cũ, log files, temp zip |
| `HIGH` | Có khả năng ảnh hưởng project nếu xóa nhầm | Chỉ xóa khi có xác nhận đặc biệt hoặc `--aggressive` | Publish artifacts, NuGet cache, node_modules |

### Tiêu chí phát hiện rác chi tiết

Mỗi loại rác được cấu hình với các trường:

| Trường | Kiểu | Mô tả |
|--------|------|-------|
| `patterns` | `string[]` | Glob patterns để quét file/directory |
| `extensions` | `string[]` | File extensions để lọc |
| `max_size_mb` | `int` | Chỉ xóa nếu file/dir > N MB (0 = không giới hạn) |
| `empty_dirs_only` | `bool` | Chỉ xóa directory nếu trống |
| `generated_paths` | `string[]` | Path luôn được tạo lại khi build (luôn an toàn) |

### RÁC MỨC LOW — An toàn để xóa (không cần backup)

| Loại | patterns | extensions | max_size_mb | empty_dirs_only | generated_paths |
|------|----------|------------|-------------|-----------------|-----------------|
| `build` | `**/bin`, `**/obj` | — | 0 | false | `bin/`, `obj/` |
| `test_results` | `**/TestResults` | — | 0 | false | `TestResults/` |
| `coverage` | `**/coverage*`, `**/*.cobertura.xml` | `.xml`, `.json` | 0 | false | — |

### RÁC MỨC MEDIUM — Cần backup trước khi xóa

| Loại | patterns | extensions | max_size_mb | empty_dirs_only | generated_paths |
|------|----------|------------|-------------|-----------------|-----------------|
| `backup_old` | `.opencode/backup/WF-*` | — | 0 | false | — |
| `log_files` | `**/*.log`, `**/*.out` | `.log`, `.out` | 1 | false | — |
| `temp_zip` | `**/*.zip`, `**/*.tar.gz`, `**/*.7z` | `.zip`, `.tar.gz`, `.7z` | 100 | false | — |
| `ide_cache` | `.vs/`, `**/.vscode/` | — | 0 | false | `.vs/`, `.vscode/` (cache) |
| `nuget_temp` | `~/.nuget/packages/*` | — | 0 | false | — |

### RÁC MỨC HIGH — Chỉ xóa khi có xác nhận đặc biệt

| Loại | patterns | extensions | max_size_mb | empty_dirs_only | generated_paths |
|------|----------|------------|-------------|-----------------|-----------------|
| `publish` | `**/release`, `**/publish`, `**/dist` | — | 0 | false | `release/`, `publish/`, `dist/` |
| `workflow_artifact` | `.opencode/workflow/WF-*` | — | 0 | false | — |
| `large_file` | `**/*` | — | 500 | false | — |
| `node_modules` | `**/node_modules` | — | 0 | false | `node_modules/` |
| `dotnet_temp` | `$env:TEMP/dotnet-*` | — | 0 | false | — |

### FILE KHÔNG BAO GIỜ XÓA (Protected List — cấu trúc)

Danh sách protected được tổ chức thành 4 nhóm rõ ràng, có thể cấu hình bởi orchestrator:

```yaml
protected_list:
  protected_extensions:
    - ".cs"           # Source code C#
    - ".razor"        # Blazor components
    - ".csproj"       # Project files
    - ".sln"          # Solution files
    - ".md"           # Documentation
    - ".gitignore"    # Git config
    - ".editorconfig" # Editor config
    - ".props"        # MSBuild properties
    - ".targets"      # MSBuild targets
    - ".ps1"          # PowerShell scripts (non-generated)

  protected_dirs:
    - ".git"                  # Git repository
    - ".opencode/agents"      # Agent definitions
    - ".opencode/skills"      # Skills (SKILL.md files)
    - ".opencode/scripts"     # Script utilities
    - ".opencode/knowledge"   # Knowledge base
    - ".opencode/commands"    # Command definitions

  protected_paths:
    - "AGENTS.md"
    - "opencode.json"
    - "Directory.Build.props"
    - ".opencode/SYSTEM_MAP.md"

  protected_patterns:
    - "**/*.ps1"              # All scripts
    - "**/.opencode/**/*.md"  # All opencode docs
    - ".github/**"            # GitHub workflows/configs
    - "**/launchSettings.json" # Launch configs
```

**Nguyên tắc khóa protected:**
1. Mọi file matching `protected_extensions` đều không bao giờ bị xóa
2. Mọi directory trong `protected_dirs` và nội dung của nó không bao giờ bị xóa
3. Mọi path trong `protected_paths` (tuyệt đối hoặc tương đối) không bao giờ bị xóa
4. Mọi file matching `protected_patterns` (glob) không bao giờ bị xóa
5. Kiểm tra protected LUÔN được thực hiện TRƯỚC khi xóa — nếu match bất kỳ protected list nào → BLOCKED

---

## ARCHITECTURE

```
User request (/team-cleanup [flags])
        │
        ▼
┌──────────────────────────────────┐
│       Cleaner Agent              │
│   (cleaner.md / workspace-cleaner.ps1) │
└──────────┬───────────────────────┘
           │
           ├── 1. WORKSPACE SCAN
           │      └── Glob theo `patterns` + `extensions` + `max_size_mb` + `empty_dirs_only`
           │      └── Phân loại rác thành LOW | MEDIUM | HIGH
           │      └── Bảo vệ: kiểm tra `protected_extensions`, `protected_dirs`, `protected_paths`, `protected_patterns`
           │
           ├── 2. DRY-RUN (BẮT BUỘC — luôn chạy trước)
           │      └── scan_report + classification_report
           │      └── Risk threshold check
           │      └── Nếu `--dry-run` flag → dừng tại đây, chỉ xem
           │      └── Nếu risk vượt ngưỡng → BLOCKED (yêu cầu `--force` để tiếp)
           │
           ├── 3. BACKUP (cho MEDIUM items)
           │      └── Backup Utility → `.opencode/backup/<workflow_id>/`
           │      └── backup_report: workflow_id, manifest_path, backed_up_files, failed_backups, skip_reasons
           │
           ├── 4. CONFIRMATION GATE
           │      └── Summary table (risk level breakdown)
           │      └── User confirm Y/N (trừ khi `--force`)
           │
           ├── 5. CLEANUP EXECUTION
           │      └── Thứ tự: LOW → MEDIUM → HIGH
           │      └── Ghi cleanup_report: deleted, skipped, failed
           │
           ├── 6. VERIFICATION
           │      └── Kiểm tra post-cleanup: freed_bytes, verification_status
           │      └── verification_report
           │
           └── 7. FINAL REPORT
                  └── status, summary, scan_report, classification_report,
                      backup_report, cleanup_report, verification_report
```

---

## QUY TRÌNH DỌN DẸP (7 BƯỚC)

### Bước 1: Workspace scan

Quét toàn bộ workspace bằng tiêu chí cấu hình chi tiết cho từng loại rác:

```powershell
# Scan theo config của từng loại
$config = @{
    build = @{ patterns = @("**/bin", "**/obj"); empty_dirs_only = $false }
    log   = @{ patterns = @("**/*.log", "**/*.out"); extensions = @(".log",".out"); max_size_mb = 1 }
    ...
}
```

Mỗi candidate được kiểm tra protected list TRƯỚC khi đưa vào danh sách:

```powershell
if (Test-Protected -Path $candidatePath) {
    $skipReasons["protected_match"]++
    continue
}
```

Output:
```yaml
scan_report:
  total_candidates: 23
  total_size_bytes: 524288000     # 500MB
  scanned_files: 1542
  scanned_dirs: 89
  protected_skipped: 0
  candidates:
    - type: "build"
      path: "JapaneseLearner/bin/"
      risk: "LOW"
      size_bytes: 157286400
      criteria_match:
        patterns: ["**/bin"]
        empty_dirs_only: false
    - type: "build"
      path: "JapaneseLearner/obj/"
      risk: "LOW"
      size_bytes: 157286400
      criteria_match:
        patterns: ["**/obj"]
        empty_dirs_only: false
    - type: "backup_old"
      path: ".opencode/backup/WF-20260720-001/"
      risk: "MEDIUM"
      size_bytes: 52428800
    - ...
```

### Bước 2: Dry-run report (BẮT BUỘC)

Dry-run luôn chạy đầu tiên. `full` và `aggressive` chỉ được chạy sau khi dry-run pass hoặc có `--force`.

```
╔══════════════════════════════════════════════════════════════╗
║            WORKSPACE CLEANUP — DRY RUN                      ║
╠══════════════════════════════════════════════════════════════╣
║ Workflow ID: WF-20260726-001                                ║
║──────────────────────────────────────────────────────────────║
║ SCAN REPORT                                                 ║
║   Scanned files: 1,542  |  Scanned dirs: 89                ║
║   Candidates found: 23  |  Protected skipped: 0            ║
║──────────────────────────────────────────────────────────────║
║ CLASSIFICATION REPORT                                       ║
║   LOW    → build(12), test(3)       15 items   310.0 MB    ║
║   MEDIUM → backup(3), log(5), zip(2) 10 items   150.0 MB   ║
║   HIGH   → publish(1)                 1 item     40.0 MB   ║
║──────────────────────────────────────────────────────────────║
║ TOTAL: 23 items, 500.0 MB                                   ║
║──────────────────────────────────────────────────────────────║
║ RISK THRESHOLD CHECK                                        ║
║   Max risk level: MEDIUM (threshold: HIGH)                  ║
║   ⚠ HIGH items found (1) — cần xác nhận đặc biệt           ║
║   → Kết luận: Dry-run PASS (risk trong ngưỡng cho phép)    ║
║                                                            ║
║   (Dùng `--dry-run` flag để chỉ xem, không xóa)            ║
╚══════════════════════════════════════════════════════════════╝
```

**Quy tắc Dry-run gate:**
1. Nếu `--dry-run` được chỉ định → hiển thị báo cáo, DỪNG lại, không xóa gì
2. Nếu `--force` → bỏ qua confirmation gate, nhưng vẫn chạy dry-run để báo cáo
3. Nếu không có flag nào → dry-run chạy, hiển thị báo cáo, hỏi user "Tiếp tục? (Y/N)"
4. Nếu dry-run phát hiện HIGH items > ngưỡng cho phép → BLOCKED, yêu cầu `--force`

### Bước 3: Backup (MEDIUM items)

Trước khi xóa MEDIUM items, gọi Backup Utility với workflow_id chuẩn:

```powershell
$backupScript = ".opencode\scripts\backup-utility.ps1"
$items = @(
    ".opencode\backup\WF-20260720-001",
    ".opencode\backup\WF-20260719-002",
    "logs\error.log"
)
& $backupScript -files $items -workflowId "WF-20260726-001"
```

Backup được lưu vào `.opencode/backup/WF-20260726-001/`.

Output backup_report:
```yaml
backup_report:
  workflow_id: "WF-20260726-001"
  status: "SUCCESS"
  manifest_path: ".opencode/backup/WF-20260726-001/05_backup_manifest.json"
  backed_up_files:
    - source: ".opencode/backup/WF-20260720-001"
      backup: ".opencode/backup/WF-20260726-001/backup-WF-20260720-001"
      hash: "a1b2c3d4e5f6"
      size_bytes: 52428800
    - source: "logs/error.log"
      backup: ".opencode/backup/WF-20260726-001/backup-error.log"
      hash: "f6e5d4c3b2a1"
      size_bytes: 1048576
  failed_backups:
    - source: "locked-file.tmp"
      reason: "File đang được process khác sử dụng"
  skip_reasons:
    protected_match: 2
    already_backed_up: 1
    not_found: 0
```

### Bước 4: Confirmation gate

Hiển thị summary cuối cùng trước khi xóa:

```
╔══════════════════════════════════════════════════════════════╗
║           WORKSPACE CLEANUP — CONFIRM                       ║
╠══════════════════════════════════════════════════════════════╣
║ SẮP XÓA: 23 items, tổng 500.0 MB                           ║
║──────────────────────────────────────────────────────────────║
║ LOW    (không cần backup)                                   ║
║   • build artifacts         12 items    300.0 MB            ║
║   • test results             3 items     10.0 MB            ║
║──────────────────────────────────────────────────────────────║
║ MEDIUM (đã backup)                                          ║
║   • backup cũ (giữ 5)       3 items    100.0 MB            ║
║   • log files                5 items     30.0 MB            ║
║   • temp zip                 2 items     20.0 MB            ║
║──────────────────────────────────────────────────────────────║
║ HIGH   (cần xác nhận)                                       ║
║   • publish artifacts        1 item      40.0 MB            ║
╠══════════════════════════════════════════════════════════════╣
║ Backup manifest: .opencode/backup/WF-20260726-001/          ║
║ Xác nhận xóa? (Y/N) [--force để tự động]:                   ║
╚══════════════════════════════════════════════════════════════╝
```

### Bước 5: Cleanup execution

```powershell
# LOW — xóa ngay (không cần backup)
Remove-Item -Recurse -Force "JapaneseLearner/bin/", "JapaneseLearner/obj/"
Remove-Item -Recurse -Force "TestResults/"

# MEDIUM — đã backup, xóa
Remove-Item -Recurse -Force ".opencode\backup\WF-20260720-001"
Remove-Item -Force "logs/error.log"

# HIGH — cần --aggressive hoặc user confirm từng cái
if ($Aggressive -or $Force) {
    Remove-Item -Recurse -Force "JapaneseLearner/bin/release/"
}
```

Ghi cleanup_report:
```yaml
cleanup_report:
  status: "SUCCESS"
  deleted: 22
  skipped: 1
  failed: 0
  details:
    low:
      attempted: 15
      deleted: 15
      skipped: 0
      failed: 0
    medium:
      attempted: 10
      deleted: 10
      skipped: 0
      failed: 0
    high:
      attempted: 1
      deleted: 0    # User không confirm
      skipped: 1
      failed: 0
```

### Bước 6: Verification

Kiểm tra post-cleanup — xác nhận file đã được xóa và tính dung lượng giải phóng:

```yaml
verification_report:
  status: "PASS"
  checks:
    - type: "deleted_confirmed"
      path: "JapaneseLearner/bin/"
      expected: "deleted"
      actual: "deleted"
      pass: true
    - type: "deleted_confirmed"
      path: "JapaneseLearner/obj/"
      expected: "deleted"
      actual: "deleted"
      pass: true
    - type: "skipped_confirmed"
      path: "JapaneseLearner/bin/release/"
      expected: "kept"
      actual: "exists"
      pass: true
  freed_bytes: 460000000
  after_size_bytes: 24288000
  verification_status: "PASS"
```

### Bước 7: Final consolidated report

```yaml
status: "SUCCESS | PARTIAL | FAILED | CANCELLED"
mode: "dry-run | full | aggressive"
target: "all | build | backup | temp | cache | log"
summary: "Đã giải phóng 460MB, xóa 22 items, 1 skipped (HIGH), 0 failed"

scan_report:
  scanned_files: 1542
  scanned_dirs: 89
  candidates: 23
  protected_skipped: 0

classification_report:
  low: 15
  medium: 10
  high: 1

backup_report:
  workflow_id: "WF-20260726-001"
  status: "SUCCESS"
  manifest_path: ".opencode/backup/WF-20260726-001/05_backup_manifest.json"
  backed_up_files: 10
  failed_backups: 0
  skip_reasons:
    protected_match: 2
    already_backed_up: 1

cleanup_report:
  deleted: 22
  skipped: 1
  failed: 0
  details:
    low:  { attempted: 15, deleted: 15, skipped: 0, failed: 0 }
    medium: { attempted: 10, deleted: 10, skipped: 0, failed: 0 }
    high: { attempted: 1, deleted: 0, skipped: 1, failed: 0 }

verification_report:
  freed_bytes: 460000000
  after_size_bytes: 24288000
  verification_status: "PASS"
```

---

## 8 KÊNH KIỂM TRA RÁC

| # | Kênh | patterns | risk | Mặc định | Ghi chú |
|---|------|----------|------|----------|---------|
| 1 | **Build artifacts** | `**/bin`, `**/obj` | LOW | ✅ Luôn dọn | Tái tạo bằng `dotnet build` |
| 2 | **Test results** | `**/TestResults`, `**/coverage*` | LOW | ✅ Luôn dọn | |
| 3 | **Backup cũ** | `.opencode/backup/WF-*` | MEDIUM | ✅ Giữ 5 gần nhất | `--keep-backup` để cấu hình |
| 4 | **Log files** | `**/*.log`, `**/*.out` | MEDIUM | ✅ Dọn nếu > 1MB hoặc > 30 ngày | `--older-than` để cấu hình |
| 5 | **Temp archives** | `**/*.zip`, `**/*.tar.gz`, `**/*.7z` | MEDIUM | ✅ Dọn nếu > 100MB | |
| 6 | **Publish output** | `**/release`, `**/publish`, `**/dist` | HIGH | ❌ Chỉ `--aggressive` | Cần user confirm từng cái |
| 7 | **NuGet cache** | `~/.nuget/packages/*` | HIGH | ❌ Chỉ `--aggressive` | Có thể làm chậm lần build sau |
| 8 | **IDE cache** | `.vs/`, `**/.vscode/` | MEDIUM | ✅ Dọn cache, giữ settings | Không xóa `.vscode/settings.json` |

---

## ĐỊNH DẠNG ĐẦU RA (YAML CONTRACT) — CHI TIẾT

Contract được tách thành 6 sub-report rõ ràng, mỗi report phục vụ một mục đích riêng:

```yaml
status: "SUCCESS | PARTIAL | FAILED | CANCELLED"
mode: "dry-run | full | aggressive"
target: "all | build | backup | temp | cache | log"
summary: "Đã giải phóng 500MB, xóa 23 items, backup 8 items"

# ── Report 1: Scan ──
scan_report:
  scanned_files: 1542
  scanned_dirs: 89
  candidates: 23
  protected_skipped: 0
  candidates_detail:
    - type: "build"
      path: "JapaneseLearner/bin/"
      risk: "LOW"
      size_bytes: 157286400
      criteria:
        patterns: ["**/bin", "**/obj"]
        empty_dirs_only: false
        generated_paths: ["bin/", "obj/"]

# ── Report 2: Classification ──
classification_report:
  low: 15
  medium: 10
  high: 1
  by_type:
    build: 12
    test: 3
    backup_old: 3
    log: 5
    temp_zip: 2
    publish: 1

# ── Report 3: Backup ──
backup_report:
  workflow_id: "WF-20260726-001"
  status: "SUCCESS | PARTIAL | FAILED | SKIPPED"
  manifest_path: ".opencode/backup/WF-20260726-001/05_backup_manifest.json"
  backed_up_files:
    - source: ".opencode/backup/WF-20260720-001"
      backup: ".opencode/backup/WF-20260726-001/backup-WF-20260720-001"
      hash: "a1b2c3d4e5f6"
      size_bytes: 52428800
      status: "success"
  failed_backups:
    - source: "locked-file.tmp"
      reason: "File đang được process khác sử dụng"
      status: "failed"
  skip_reasons:
    protected_match: 2
    already_backed_up: 1
    not_found: 0
    too_small: 3
    too_recent: 1

# ── Report 4: Cleanup ──
cleanup_report:
  status: "SUCCESS | PARTIAL"
  deleted: 22
  skipped: 1
  failed: 0
  details:
    low:
      attempted: 15
      deleted: 15
      skipped: 0
      failed: 0
    medium:
      attempted: 10
      deleted: 10
      skipped: 0
      failed: 0
    high:
      attempted: 1
      deleted: 0
      skipped: 1
      failed: 0
  errors:
    - path: "JapaneseLearner/bin/"
      error: "Không thể xóa — file đang được process khác sử dụng"
      severity: WARNING

# ── Report 5: Verification ──
verification_report:
  freed_bytes: 460000000
  after_size_bytes: 24288000
  verification_status: "PASS | FAIL | SKIPPED"
  spot_checks:
    - type: "deleted_confirmed"
      path: "JapaneseLearner/bin/"
      expected: "deleted"
      actual: "deleted"
      pass: true
    - type: "protected_preserved"
      path: "JapaneseLearner/Program.cs"
      expected: "exists"
      actual: "exists"
      pass: true
```

---

## SƠ ĐỒ QUYẾT ĐỊNH

```yaml
bước_1_scan:
  không tìm thấy rác: → CANCELLED "Workspace đã sạch, không cần dọn"
  có rác nhưng tất cả protected: → CANCELLED "Chỉ có protected files, không dọn được gì"
  tìm thấy rác: → dry_run

bước_2_dry_run:
  --dry-run flag: → hiển thị báo cáo → CANCELLED (không xóa gì)
  risk vượt ngưỡng (HIGH > threshold) và không --force: → BLOCKED "Yêu cầu --force để tiếp tục"
  risk trong ngưỡng và --force: → bỏ qua confirm → backup
  risk trong ngưỡng và không --force:
    user không confirm: → CANCELLED "User hủy cleanup"
    user confirm Y: → backup

bước_3_backup:
  có MEDIUM items: → backup → kiểm tra backup
    backup SUCCESS: → confirm
    backup FAILED: → không xóa MEDIUM items, chỉ xóa LOW → PARTIAL
  không có MEDIUM items: → confirm (bỏ qua backup)

bước_4_confirmation:
  --force: → cleanup execution
  không --force:
    user Y: → cleanup execution
    user N: → CANCELLED "User hủy"

bước_5_cleanup:
  xóa LOW thành công: → tiếp tục
  xóa LOW thất bại (file đang dùng): → log WARNING, tiếp tục items khác
  xóa MEDIUM thành công: → tiếp tục
  xóa MEDIUM thất bại: → log WARNING, đề xuất rollback từ backup
  xóa HIGH: --aggressive + user confirm → xóa / không → skip

bước_6_verification:
  spot-check PASS: → final report
  spot-check FAIL (file lẽ ra đã xóa nhưng còn): → WARNING, ghi vào report

bước_7_báo_cáo:
  tất cả xóa thành công + verification PASS: → SUCCESS
  có lỗi nhưng không critical + verification PARTIAL: → PARTIAL
  catastrophic (backup fail, xóa sai): → FAILED → rollback ngay
```

---

## TÍCH HỢP VỚI DEV TEAM WORKFLOW

Có thể thêm Workspace Cleaner như bước 0 (trước Analyze) hoặc bước cuối (sau Complete, trước GitPush):

```
CLEANUP → ANALYZE → DESIGN → PLAN → ... → COMPLETE → CLEANUP
```

### Chạy độc lập

```powershell
/team-cleanup                        # Dry-run → confirm → cleanup
/team-cleanup --dry-run              # Chỉ xem trước
/team-cleanup --force                # Tự động, không hỏi
/team-cleanup --target build         # Chỉ dọn build artifacts
/team-cleanup --keep-backup 10       # Giữ 10 workflow gần nhất
/team-cleanup --aggressive           # Dọn cả NuGet cache + publish
/team-cleanup --older-than 60        # Chỉ xóa file cũ hơn 60 ngày
```

### Tích hợp script vào workflow

Workspace Cleaner có thể gọi từ PowerShell script:

```powershell
# Chạy cleanup tự động trước khi build
& ".opencode\skills\workspace-cleaner\scripts\workspace-cleaner.ps1" `
    -Target "build" -DryRun -ReportPath "cleanup-report.json"
```

---

## XỬ LÝ NGOẠI LỆ

| Vấn đề | Cách xử lý |
|--------|------------|
| File đang được process khác dùng | Log WARNING, bỏ qua file đó |
| Không tìm thấy rác | CANCELLED "Workspace đã sạch" |
| Chỉ có protected files | CANCELLED "Chỉ có protected files, không dọn được gì" |
| Dry-run phát hiện risk vượt ngưỡng | BLOCKED — yêu cầu `--force` để tiếp tục |
| Quyền hạn không đủ để xóa | Log ERROR, đề xuất chạy với quyền admin |
| Backup thất bại | Không xóa MEDIUM items, chỉ xóa LOW → PARTIAL |
| Backup MEDIUM thất bại 1 phần | Ghi vào `failed_backups`, xóa MEDIUM items đã backup thành công |
| Disk đầy trong lúc backup | Dừng cleanup, rollback đã backup |
| User không phản hồi (timeout 60s) | CANCELLED tự động |
| Phát hiện protected file trong danh sách xóa | BLOCKED — không bao giờ xóa, ghi `skip_reasons.protected_match++` |
| Verification phát hiện file vẫn còn | WARNING — ghi vào verification_report, set verification_status = FAIL |
| .gitignore thay đổi bất thường | WARNING — kiểm tra thủ công |

### Rollback

```powershell
# Rollback từ backup nếu cần (dùng workflow_id chuẩn)
$rollbackScript = ".opencode\scripts\rollback-utility.ps1"
& $rollbackScript -workflowId "WF-20260726-001" -force
```

## GHI CHÚ QUAN TRỌNG

1. **Dry-run LUÔN là bước đầu tiên** — `full` và `aggressive` không được chạy nếu dry-run chưa xác nhận an toàn
2. **Protected list có 4 nhóm riêng biệt**: `protected_extensions`, `protected_dirs`, `protected_paths`, `protected_patterns` — tất cả đều được kiểm tra TRƯỚC khi xóa
3. **Workflow ID chuẩn** (`WF-YYYYMMDD-NNN`) được gắn cho mọi backup và artifact để rollback sau này
4. **Risk threshold** ngăn không cho xóa HIGH items nếu không có `--force`
5. **Backup MEDIUM items** trước khi xóa — lưu vào `.opencode/backup/<workflow_id>/`
6. **Retention mặc định**: giữ 5 workflow backup gần nhất
7. **Aggressive mode** (`--aggressive`) yêu cầu xác nhận kép (dry-run pass + user confirm)
8. Workspace càng sạch → build càng nhanh, ít conflict
