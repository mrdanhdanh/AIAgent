---
name: workspace-cleaner
description: Dọn rác Workspace tự động — xóa build artifacts, backup cũ, temp files, cache không cần thiết. Tích hợp dry-run bắt buộc, backup trước khi xóa, confirmation gate, protected list cấu trúc, và output contract chi tiết. Sử dụng câu lệnh /team-cleanup.
schema_version: "2.1"
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

| Mức | Định nghĩa | Hành động | Điều kiện xóa | Ví dụ |
|-----|-----------|-----------|--------------|-------|
| `LOW` | Cache/temp có thể xóa ngay, tái tạo được | Xóa trực tiếp, **không cần backup** | Luôn được xóa nếu user confirm | `bin/`, `obj/`, `TestResults/` |
| `MEDIUM` | File có giá trị tạm thời, có thể cần rollback | **Bắt buộc backup trước khi xóa**. Nếu backup FAIL → **KHÔNG được xóa** | Chỉ xóa khi backup thành công (`backup_report.status == SUCCESS` hoặc `PARTIAL` với item đó thành công) | Backup cũ, log files, temp zip |
| `HIGH` | Có khả năng ảnh hưởng project nếu xóa nhầm | **Bị BLOCKED** nếu không có `--force` hoặc `--aggressive` | Chỉ xóa khi có `--force` hoặc `--aggressive` + user confirm từng item | Publish artifacts, NuGet cache, node_modules |

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

Mỗi candidate trong `candidates_detail` được chuẩn hóa với các trường sau:

| Trường | Kiểu | Bắt buộc | Mô tả |
|--------|------|----------|-------|
| `path` | `string` | ✅ | Đường dẫn tuyệt đối hoặc tương đối tới file/directory |
| `type` | `string` | ✅ | Loại rác: `build`, `test_results`, `coverage`, `backup_old`, `log`, `temp_zip`, `publish`, `workflow_artifact`, `large_file`, `node_modules`, `dotnet_temp`, `ide_cache` |
| `size_bytes` | `int` | ✅ | Kích thước tính bằng bytes |
| `risk` | `string` | ✅ | `LOW` | `MEDIUM` | `HIGH` |
| `reason` | `string` | ✅ | Lý do phát hiện là rác (vd: "Quá 30 ngày", "Dung lượng > 100MB", "Folder có thể tái tạo") |
| `protected_hit` | `bool` | ✅ | `true` nếu candidate match protected list → bị loại khỏi danh sách xóa |
| `backup_required` | `bool` | ✅ | `true` nếu risk == MEDIUM (cần backup trước xóa) |
| `criteria` | `object` | ❌ | Chi tiết tiêu chí đã match: `patterns`, `extensions`, `max_size_mb`, `empty_dirs_only`, `generated_paths` |

Output:
```yaml
scan_report:
  scanned_files: 1542
  scanned_dirs: 89
  candidates: 23
  protected_skipped: 0
  candidates_detail:
    - type: "build"
      path: "JapaneseLearner/bin/"
      size_bytes: 157286400
      risk: "LOW"
      reason: "Build artifact — có thể tái tạo bằng dotnet build"
      protected_hit: false
      backup_required: false
      criteria:
        patterns: ["**/bin"]
        empty_dirs_only: false
        generated_paths: ["bin/"]
    - type: "backup_old"
      path: ".opencode/backup/WF-20260720-001/"
      size_bytes: 52428800
      risk: "MEDIUM"
      reason: "Backup workflow cũ, đã có 5 backup mới hơn (keep-backup: 5)"
      protected_hit: false
      backup_required: true
    - type: "publish"
      path: "JapaneseLearner/bin/Release/net10.0/publish/"
      size_bytes: 41943040
      risk: "HIGH"
      reason: "Publish output — cần --aggressive để xóa"
      protected_hit: false
      backup_required: false
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

**Quy tắc Dry-run gate (siết):**

| # | Quy tắc | Mô tả |
|---|---------|-------|
| 1 | `--dry-run` = không xóa gì | Dry-run mode **không bao giờ xóa bất kỳ file nào**. Chỉ hiển thị báo cáo scan + classification. Set `dry_run_only = true`. Kết thúc workflow tại đây. |
| 2 | `full`/`aggressive` cần dry-run hợp lệ | Chế độ `full` hoặc `aggressive` chỉ được thực thi khi dry-run đã tạo ra **báo cáo hợp lệ** (scan hoàn tất, candidates đã xác định) AND `risk_gate_status == PASS`. Nếu dry-run chưa chạy hoặc báo cáo lỗi → BLOCKED. |
| 3 | HIGH > threshold → STOP | Nếu dry-run phát hiện **số lượng HIGH items vượt ngưỡng cho phép** → `risk_gate_status = BLOCKED`. Execution **dừng lại ngay**, trừ khi có flag `--force`. |
| 4 | `--force` override risk gate | `--force` cho phép bỏ qua risk gate, nhưng vẫn yêu cầu dry-run đã hoàn tất trước đó. Nếu dry-run chưa chạy → tự động chạy dry-run trước. |
| 5 | No flag → dry-run → confirm | Nếu không có flag nào → dry-run tự động chạy, hiển thị báo cáo, hỏi user "Tiếp tục? (Y/N)". Chỉ cleanup nếu user xác nhận. |

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

**Backup gate rules (siết):**

```yaml
backup_gate_rules:
  low:
    backup_required: false
    can_delete_without_backup: true
    note: "LOW items được xóa trực tiếp, không cần backup"

  medium:
    backup_required: true
    can_delete_without_backup: false
    gate: "backup_report.status == SUCCESS || (backup_report.status == PARTIAL && item.status == 'success')"
    block_if_backup_fails: true
    fallback: "Chỉ xóa LOW items → status = PARTIAL. MEDIUM items bị lỗi backup được giữ lại."
    note: "MEDIUM items CHỈ được xóa nếu backup thành công. Nếu backup FAIL → item đó KHÔNG bị xóa."

  high:
    backup_required: false
    can_delete_without_backup: false
    gate: "force == true || aggressive == true"
    block_without_force: true
    note: "HIGH items bị BLOCKED hoàn toàn nếu không có --force. Không cần backup vì không được phép xóa."
```

**Nguyên tắc áp dụng:**
1. **LOW** → xóa ngay, không cần backup, không block
2. **MEDIUM** → backup bắt buộc. Nếu backup fail → item bị **giữ lại**, không xóa. Ghi vào `failed_backups`.
3. **HIGH** → mặc định **BLOCKED**. Chỉ xóa khi có `--force` hoặc `--aggressive` + user confirm từng cái.
4. Nếu tất cả MEDIUM items đều backup fail → cleanup_report chỉ xóa LOW → status = `PARTIAL`.

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

Kiểm tra post-cleanup — xác nhận file đã được xóa và tính dung lượng giải phóng.

**Tiêu chí spot_checks (siết):**

```yaml
verification_criteria:
  spot_checks:
    sampling_method: "stratified"
    description: >
      Chọn mẫu theo tầng (stratified sampling) — mỗi risk level chọn ít nhất
      N file, ưu tiên file dung lượng lớn nhất hoặc có nguy cơ cao nhất.

    minimum_per_risk:
      low: 2       # Ít nhất 2 LOW items
      medium: 3    # Ít nhất 3 MEDIUM items (hoặc tất cả nếu < 3)
      high: 1      # Tất cả HIGH items (nếu có và đã xóa)

    minimum_total: 5   # Tối thiểu 5 file hoặc 10% số items đã xóa (lấy giá trị lớn hơn)
    formula: "max(5, ceil(deleted * 0.1))"

    mandatory_checks:
      - type: "deleted_confirmed"
        description: "Xác nhận file đã được xóa khỏi disk"
        count: "tối thiểu 3 file đã xóa"

      - type: "protected_preserved"
        description: "Xác nhận protected folders KHÔNG bị ảnh hưởng"
        count: "ít nhất 1 folder protected"
        targets: [".git/", ".opencode/agents/", ".opencode/skills/"]

      - type: "backup_manifest_exists"
        description: "Xác nhận backup manifest tồn tại và hợp lệ"
        count: "1 file"
        target: ".opencode/backup/<workflow_id>/05_backup_manifest.json"
        checks:
          - "manifest chứa đúng workflow_id"
          - "số lượng backed_up_files khớp với MEDIUM items đã xóa"

      - type: "freed_bytes_verified"
        description: "Xác nhận dung lượng giải phóng khớp với cleanup_report"
        count: "1 lần tính toán"

    selection_rules:
      - "Luôn chọn file có dung lượng lớn nhất trong mỗi risk level"
      - "Luôn kiểm tra ít nhất 1 protected folder (thường là .git/)"
      - "Luôn kiểm tra backup manifest tồn tại và hợp lệ"
      - "Nếu có HIGH items bị skip → xác nhận chúng vẫn còn trên disk"
```

**Ví dụ output:**

```yaml
verification_report:
  freed_bytes: 460000000
  after_size_bytes: 24288000
  verification_status: "PASS"
  spot_checks:
    # --- Deleted confirmation ---
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
    - type: "deleted_confirmed"
      path: "logs/error.log"
      expected: "deleted"
      actual: "deleted"
      pass: true
    # --- Protected preservation ---
    - type: "protected_preserved"
      path: ".git/"
      expected: "exists"
      actual: "exists"
      pass: true
    - type: "protected_preserved"
      path: ".opencode/agents/"
      expected: "exists"
      actual: "exists"
      pass: true
    # --- Backup manifest ---
    - type: "backup_manifest_exists"
      path: ".opencode/backup/WF-20260726-001/05_backup_manifest.json"
      expected: "valid_manifest"
      actual: "valid_manifest"
      pass: true
      details:
        workflow_id_match: true
        backed_up_count: 10
        deleted_medium_items: 10
    # --- HIGH items skipped ---
    - type: "skipped_confirmed"
      path: "JapaneseLearner/bin/release/"
      expected: "kept"
      actual: "exists"
      pass: true
```

### Bước 7: Final consolidated report

**Output contract chuẩn với đầy đủ trường điều phối:**

```yaml
status: "SUCCESS | PARTIAL | FAILED | CANCELLED"
mode: "dry-run | full | aggressive"
target: "all | build | backup | temp | cache | log"
summary: "string (tóm tắt ngắn gọn kết quả)"
risk_gate_status: "PASS | BLOCKED"
blocked_items: 0           # Số items bị chặn (do protected hoặc risk gate)
backup_required_items: 0   # Số items yêu cầu backup (MEDIUM)
dry_run_only: false        # true nếu chạy ở chế độ dry-run
freed_bytes: 0             # Dung lượng đã giải phóng (sau cleanup)

# ── Report 1: Scan ──
scan_report:
  scanned_files: 1542
  scanned_dirs: 89
  candidates: 23
  protected_skipped: 0
  candidates_detail: []

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
  workflow_id: "WF-YYYYMMDD-NNN"
  status: "SUCCESS | PARTIAL | FAILED | SKIPPED"
  manifest_path: "string"
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

# ── Report 4: Cleanup ──
cleanup_report:
  status: "SUCCESS | PARTIAL | SKIPPED"
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
  spot_checks: []
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

Contract được tách thành 6 sub-report rõ ràng, mỗi report phục vụ một mục đích riêng. Orchestrator dùng các trường điều phối ở cấp cao nhất để quyết định luồng xử lý:

```yaml
status: "SUCCESS | PARTIAL | FAILED | CANCELLED"
mode: "dry-run | full | aggressive"
target: "all | build | backup | temp | cache | log"
summary: "Đã giải phóng 500MB, xóa 23 items, backup 8 items"
risk_gate_status: "PASS | BLOCKED"
blocked_items: 3             # 2 protected + 1 HIGH (chưa force)
backup_required_items: 10    # 10 MEDIUM items yêu cầu backup
dry_run_only: false          # false = đã cleanup thật
freed_bytes: 500000000       # Dung lượng đã giải phóng

# ── Report 1: Scan ──
scan_report:
  scanned_files: 1542
  scanned_dirs: 89
  candidates: 23
  protected_skipped: 2       # 2 items bị protected list chặn
  candidates_detail:
    - type: "build"
      path: "JapaneseLearner/bin/"
      size_bytes: 157286400
      risk: "LOW"
      reason: "Build artifact — có thể tái tạo bằng dotnet build"
      protected_hit: false
      backup_required: false
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
  status: "SUCCESS | PARTIAL | SKIPPED"
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
  freed_bytes: 500000000
  after_size_bytes: 24288000
  verification_status: "PASS | FAIL | SKIPPED"
  spot_checks:
    - type: "deleted_confirmed"
      path: "JapaneseLearner/bin/"
      expected: "deleted"
      actual: "deleted"
      pass: true
    - type: "protected_preserved"
      path: ".git/"
      expected: "exists"
      actual: "exists"
      pass: true
    - type: "backup_manifest_exists"
      path: ".opencode/backup/WF-20260726-001/05_backup_manifest.json"
      expected: "valid_manifest"
      actual: "valid_manifest"
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
  --dry-run flag: → hiển thị báo cáo → set dry_run_only = true → CANCELLED (không xóa gì)
  dry-run không tạo được báo cáo hợp lệ: → BLOCKED "Dry-run chưa hoàn tất, không thể tiếp"
  risk vượt ngưỡng (HIGH > threshold) và không --force:
    → risk_gate_status = BLOCKED
    → blocked_items = số HIGH items
    → BLOCKED "Yêu cầu --force để tiếp tục"
  risk vượt ngưỡng và --force:
    → risk_gate_status = PASS (override)
    → bỏ qua confirm → backup
  risk trong ngưỡng và --force:
    → risk_gate_status = PASS
    → bỏ qua confirm → backup
  risk trong ngưỡng và không --force:
    user không confirm: → CANCELLED "User hủy cleanup"
    user confirm Y: → backup

bước_3_backup:
  có MEDIUM items:
    → backup từng item
    → kiểm tra backup_report
      backup SUCCESS (tất cả thành công):
        → backup_required_items = số MEDIUM items
        → confirm
      backup PARTIAL (một số fail):
        → failed_backups được ghi nhận
        → MEDIUM items bị fail backup → KHÔNG XÓA (blocked_items++)
        → chỉ xóa MEDIUM items đã backup thành công + LOW items
        → confirm với cảnh báo
      backup FAILED (tất cả fail):
        → backup_required_items = 0 (không backup được cái nào)
        → KHÔNG xóa MEDIUM items
        → chỉ xóa LOW items
        → status = PARTIAL
  không có MEDIUM items:
    → backup_required_items = 0
    → backup_report.status = SKIPPED
    → confirm (bỏ qua backup)

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
| Dry-run không tạo được báo cáo hợp lệ | BLOCKED "Dry-run chưa hoàn tất, không thể tiếp" — không cho phép `--force` bypass |
| Dry-run phát hiện risk vượt ngưỡng | BLOCKED — yêu cầu `--force` để tiếp tục. Ghi `risk_gate_status = BLOCKED`, `blocked_items = N` |
| `--force` gọi trước khi dry-run chạy | Tự động chạy dry-run trước, không bypass |
| Quyền hạn không đủ để xóa | Log ERROR, đề xuất chạy với quyền admin |
| Backup thất bại toàn bộ | Không xóa MEDIUM items, chỉ xóa LOW → PARTIAL. `blocked_items` tăng lên |
| Backup MEDIUM thất bại 1 phần | Ghi vào `failed_backups`, chỉ xóa MEDIUM items đã backup thành công |
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
8. **Gate dry-run → backup → delete là điểm dễ sai nhất**: dry-run phải PASS trước, backup MEDIUM phải SUCCESS trước khi xóa, HIGH luôn BLOCKED trừ khi có `--force`. Không được skip bước nào.
9. **Orchestrator phải đọc `risk_gate_status`, `blocked_items`, `backup_required_items`, `dry_run_only`** để quyết định bước tiếp theo — không dựa vào `status` đơn thuần.
10. Workspace càng sạch → build càng nhanh, ít conflict
