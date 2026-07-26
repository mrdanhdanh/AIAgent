---
name: workspace-cleaner
description: Dọn rác Workspace tự động — xóa build artifacts, backup cũ, temp files, cache không cần thiết. Tích hợp dry-run, backup trước khi xóa, confirmation gate. Sử dụng câu lệnh /team-cleanup.
schema_version: "1.0"
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

### RÁC CẤP 1 — An toàn để xóa (không cần backup)

| Loại | Mô tả | Điều kiện |
|------|-------|-----------|
| `build` | `bin/`, `obj/` directories | Luôn an toàn, tái tạo được bằng `dotnet build` |
| `test_results` | `TestResults/`, coverage reports | Luôn an toàn |
| `nuget_temp` | `~/.nuget/packages/` cache cũ (aggressive) | Chỉ khi `--aggressive` |
| `dotnet_temp` | `%TEMP%/dotnet-*` | Chỉ khi `--aggressive` |

### RÁC CẤP 2 — Cần backup trước khi xóa

| Loại | Mô tả | Điều kiện |
|------|-------|-----------|
| `backup_old` | `.opencode/backup/WF-*` cũ | Giữ lại N workflow gần nhất (`--keep-backup`) |
| `log_files` | `*.log`, `*.out`, error logs | File > 1MB hoặc cũ hơn 30 ngày |
| `temp_zip` | `*.zip`, `*.tar.gz`, `*.7z` trong workspace | File > 100MB hoặc cũ hơn 7 ngày |
| `publish` | `release/`, `publish/`, `dist/` | Chỉ khi `--aggressive` |
| `ide_cache` | `.vs/`, `.vscode/` (workspace settings giữ lại) | Chỉ cache, không xóa settings |

### RÁC CẤP 3 — Chỉ xóa khi có xác nhận đặc biệt

| Loại | Mô tả | Điều kiện |
|------|-------|-----------|
| `workflow_artifact` | `.opencode/workflow/WF-*` artifacts | User confirm từng cái |
| `large_file` | File lạ > 500MB trong workspace | User confirm riêng |
| `node_modules` | `node_modules/` (nếu có) | `--aggressive` + user confirm |

### FILE KHÔNG BAO GIỜ XÓA (Protected Patterns)

```
*.cs, *.razor, *.csproj, *.sln, *.json (config), *.md (doc),
.gitignore, .editorconfig, Directory.Build.props,
.opencode/skills/*/SKILL.md, .opencode/agents/*.md,
AGENTS.md, opencode.json
```

---

## ARCHITECTURE

```
User request (/team-cleanup)
        │
        ▼
┌─────────────────────┐
│   Cleaner Agent     │
│   (cleaner.md)      │
└──────────┬──────────┘
           │
           ├── 1. Workspace scan
           │      └── Glob tất cả file/folder, phân loại rác
           │
           ├── 2. Dry-run report (luôn chạy trước)
           │      └── size calculation, category grouping
           │
           ├── 3. Backup nếu cần (Cấp 2+)
           │      └── Backup Utility → .opencode/backup/cleanup-{timestamp}/
           │
           ├── 4. Confirmation gate
           │      └── Summary table → user confirm Y/N
           │
           ├── 5. Cleanup execution
           │      └── Xóa file theo thứ tự: Cấp 1 → Cấp 2 → Cấp 3
           │
           └── 6. Post-cleanup report
                  └── Dung lượng giải phóng, file đã xóa, file đã backup
```

---

## QUY TRÌNH DỌN DẸP

### Bước 1: Workspace scan

Quét toàn bộ workspace, phân loại file/folder theo 3 cấp rác:

```powershell
# Scan build artifacts
Get-ChildItem -Directory -Filter "bin","obj" -Recurse -Depth 2

# Scan backup cũ
Get-ChildItem -Path ".opencode\backup" -Directory

# Scan log files
Get-ChildItem -Filter "*.log" -Recurse

# Scan temp archives
Get-ChildItem -Filter "*.zip" -Recurse
```

Output:
```yaml
scan_results:
  total_size_bytes: 524288000    # 500MB
  categories:
    build:
      count: 12
      size_bytes: 314572800      # 300MB
      paths:
        - "JapaneseLearner/bin/"
        - "JapaneseLearner/obj/"
        - "JapaneseLearner.Tests/bin/"
        - ...
    backup_old:
      count: 8
      size_bytes: 104857600      # 100MB
      keep: 5                    # giữ 5 workflow gần nhất
      to_delete: 3
    temp_zip:
      count: 2
      size_bytes: 52428800       # 50MB
    log_files:
      count: 5
      size_bytes: 10485760       # 10MB
    publish:
      count: 1
      size_bytes: 41943040       # 40MB
  protected_files_skipped: 0
```

### Bước 2: Dry-run report

Hiển thị bảng dự kiến trước khi xóa:

```
╔══════════════════════════════════════════════════════╗
║           WORKSPACE CLEANUP — DRY RUN               ║
╠══════════════════════════════════════════════════════╣
║ Tổng dung lượng rác: 500.0 MB                       ║
║──────────────────────────────────────────────────────║
║ Cấp 1 (an toàn):                                    ║
║   • build artifacts     12 items    300.0 MB        ║
║   • test_results         3 items     10.0 MB        ║
║──────────────────────────────────────────────────────║
║ Cấp 2 (cần backup):                                 ║
║   • backup cũ (giữ 5)   3 items    100.0 MB         ║
║   • temp zip            2 items     50.0 MB         ║
║   • log files           5 items     10.0 MB         ║
║──────────────────────────────────────────────────────║
║ Cấp 3 (cần xác nhận):                               ║
║   • publish artifacts    1 item     40.0 MB         ║
╠══════════════════════════════════════════════════════╣
║ Dung lượng giải phóng dự kiến: 500.0 MB             ║
║ Cần backup trước: 160.0 MB (Cấp 2 items)            ║
║ Tiếp tục cleanup? (Y/N):                             ║
╚══════════════════════════════════════════════════════╝
```

### Bước 3: Backup (Cấp 2 items)

Trước khi xóa Cấp 2 items, gọi Backup Utility:

```powershell
$backupScript = ".opencode\scripts\backup-utility.ps1"
$items = @(
    ".opencode\backup\WF-20260720-001",
    ".opencode\backup\WF-20260719-002",
    "logs\error.log"
)
& $backupScript -files $items -workflowId "cleanup-$timestamp"
```

Backup được lưu vào `.opencode/backup/cleanup-{YYYYMMDD-HHmmss}/`.

### Bước 4: Confirmation gate

Hiển thị summary cuối cùng:

```
╔══════════════════════════════════════════════════════╗
║           WORKSPACE CLEANUP — CONFIRM               ║
╠══════════════════════════════════════════════════════╣
║ SẮP XÓA: 23 items, tổng 500.0 MB                    ║
║ Backup đã lưu: Cấp 2 items (160.0 MB)              ║
║──────────────────────────────────────────────────────║
║ Build artifacts    → 300.0 MB (không cần backup)    ║
║ Backup cũ (giữ 5)  → 100.0 MB (đã backup)           ║
║ Temp zip           → 50.0 MB  (đã backup)           ║
║ Log files          → 10.0 MB  (đã backup)           ║
║ Publish artifacts  → 40.0 MB  (cần xác nhận thêm)   ║
╠══════════════════════════════════════════════════════╣
║ Xác nhận xóa? (Y/N):                                 ║
╚══════════════════════════════════════════════════════╝
```

### Bước 5: Cleanup execution

```powershell
# Cấp 1 — xóa ngay
Remove-Item -Recurse -Force "JapaneseLearner/bin/", "JapaneseLearner/obj/"
Remove-Item -Recurse -Force "TestResults/"

# Cấp 2 — đã backup, xóa
Remove-Item -Recurse -Force ".opencode\backup\WF-20260720-001"
Remove-Item -Force "logs\error.log"

# Cấp 3 — cần user confirm từng cái
# (nếu `--force` thì xóa, nếu không thì hỏi)
```

### Bước 6: Post-cleanup report

```yaml
cleanup_summary:
  status: SUCCESS | PARTIAL | FAILED | CANCELLED
  before_size_bytes: 524288000
  freed_bytes: 500000000
  after_size_bytes: 24288000
  files_deleted: 23
  files_backed_up: 8
  backup_location: ".opencode/backup/cleanup-20260726-091500/"
  errors:
    - file: "JapaneseLearner/obj/"
      error: "File đang được process khác sử dụng — bỏ qua"
  details:
    build:
      deleted: 12
      freed: 314572800
    backup_old:
      kept: 5
      deleted: 3
      freed: 104857600
    temp_zip:
      deleted: 2
      freed: 52428800
    log_files:
      deleted: 5
      freed: 10485760
    publish:
      deleted: 1
      freed: 41943040
```

---

## 8 KÊNH KIỂM TRA RÁC

| # | Kênh | Mô tả | Cấp | Mặc định |
|---|------|-------|-----|----------|
| 1 | **Build artifacts** | `bin/`, `obj/` trong tất cả project | Cấp 1 | ✅ Luôn dọn |
| 2 | **Test results** | `TestResults/`, coverage reports | Cấp 1 | ✅ Luôn dọn |
| 3 | **Backup cũ** | `.opencode/backup/WF-*` quá hạn | Cấp 2 | ✅ Giữ 5 gần nhất |
| 4 | **Log files** | `*.log`, `*.out` > 1MB hoặc > 30 ngày | Cấp 2 | ✅ Luôn dọn |
| 5 | **Temp archives** | `*.zip`, `*.tar.gz` trong workspace | Cấp 2 | ✅ Dọn nếu > 100MB |
| 6 | **Publish output** | `release/`, `publish/`, `dist/` | Cấp 3 | ❌ Chỉ `--aggressive` |
| 7 | **NuGet cache** | `~/.nuget/packages/` cache cũ | Cấp 3 | ❌ Chỉ `--aggressive` |
| 8 | **IDE cache** | `.vs/`, `.vscode/` cache | Cấp 2 | ✅ Dọn cache, giữ settings |

---

## ĐỊNH DẠNG ĐẦU RA (YAML CONTRACT)

```yaml
status: SUCCESS | PARTIAL | FAILED | CANCELLED
summary: "Đã giải phóng 500MB, xóa 23 items, backup 8 items"

scan_results:
  total_size_bytes: 524288000
  categories: { ... }

dry_run:
  generated_at: "2026-07-26T09:00:00Z"
  would_delete: 23
  would_free: 524288000
  requires_backup: true
  backup_items: 8

backup:
  performed: true
  location: ".opencode/backup/cleanup-20260726-091500/"
  items:
    - source: ".opencode/backup/WF-20260720-001"
      backup: ".opencode/backup/cleanup-20260726-091500/opencode_backup_WF-20260720-001"
      hash: "a1b2c3d4e5f6"
    - source: "logs/error.log"
      backup: "..."
      hash: "f6e5d4c3b2a1"

confirmation:
  requested: true
  response: "Y"
  timestamp: "2026-07-26T09:01:00Z"

cleanup:
  status: SUCCESS
  files_deleted: 23
  freed_bytes: 500000000
  errors:
    - file: "path/to/file"
      error: "Không thể xóa — file đang được sử dụng"
      severity: WARNING

post_cleanup:
  after_size_bytes: 24288000
  disk_usage_pct: 15
  recommendation: "Workspace hiện sạch, có thể chạy định kỳ hàng tuần"
```

---

## SƠ ĐỒ QUYẾT ĐỊNH

```yaml
bước_1_scan:
  không tìm thấy rác: → CANCELLED "Workspace đã sạch, không cần dọn"

bước_2_dry_run:
  user không confirm: → CANCELLED "User hủy cleanup"
  user confirm Y: → tiếp tục

bước_3_backup:
  có Cấp 2 items: → backup → tiếp tục
  không có Cấp 2 items: → tiếp tục (không cần backup)

bước_4_xóa_cấp_1:
  xóa thành công: → tiếp tục
  xóa thất bại (file đang dùng): → log WARNING, tiếp tục items khác

bước_5_xóa_cấp_2:
  xóa thành công: → tiếp tục
  xóa thất bại: → log WARNING, có thể rollback từ backup

bước_6_xóa_cấp_3:
  --force hoặc user confirm: → xóa
  user không confirm: → skip, log "User giữ lại"

bước_7_báo_cáo:
  tất cả thành công: → SUCCESS
  có lỗi nhưng không critical: → PARTIAL
  catastrophic: → FAILED (gợi ý rollback)
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
| Quyền hạn không đủ để xóa | Log ERROR, đề xuất chạy với quyền admin |
| Backup thất bại | Không xóa Cấp 2 items, báo user |
| Disk đầy trong lúc backup | Dừng cleanup, rollback đã backup |
| User không phản hồi (timeout 60s) | CANCELLED tự động |
| Phát hiện protected file trong danh sách xóa | BLOCKED — không bao giờ xóa protected file |
| .gitignore thay đổi bất thường | WARNING — kiểm tra thủ công |

### Rollback

```powershell
# Rollback từ backup nếu cần
$rollbackScript = ".opencode\scripts\rollback-utility.ps1"
& $rollbackScript -workflowId "cleanup-20260726-091500" -force
```

## GHI CHÚ

- Luôn chạy dry-run trước khi cleanup thực tế
- Backup Cấp 2 items trước khi xóa — lưu vào `.opencode/backup/cleanup-*/`
- Không bao giờ xóa source code (`.cs`, `.razor`, config files)
- Retention mặc định: giữ 5 workflow backup gần nhất
- Aggressive mode (`--aggressive`) yêu cầu xác nhận kép
- Khi tích hợp vào dev-team workflow, chạy cleanup ở đầu hoặc cuối workflow
- Workspace càng sạch → build càng nhanh, ít conflict
