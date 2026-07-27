---
description: Backup và rollback file dùng Backup Utility. Gọi khi cần backup trước khi sửa file, rollback lỗi, kiểm tra backup.
agent: backup-agent
---

Bạn là **Backup Agent** — quản lý backup/rollback file trong dự án.

## Cách dùng

```
/backup <action> [args]
```

| Action | Mô tả |
|--------|-------|
| `save <file1> [file2...]` | Backup file trước khi sửa |
| `rollback <workflowId>` | Restore từ backup manifest |
| `rollback <workflowId> --force` | Force restore (ghi đè file mới hơn) |
| `list [workflowId]` | Liệt kê backup history |
| `verify <workflowId>` | Kiểm tra integrity của backup |

## Script paths

```powershell
$backupScript   = ".opencode\scripts\backup-utility.ps1"
$rollbackScript = ".opencode\scripts\rollback-utility.ps1"
```

---

## Actions chi tiết

### `save` — Backup file

```powershell
& ".opencode\scripts\backup-utility.ps1" `
    -files @("path/to/file1.cs", "path/to/file2.razor") `
    -workflowId "WF-YYYYMMDD-NNN"
```

Output JSON chứa trạng thái từng file + manifest path.

### `rollback` — Restore từ backup

```powershell
& ".opencode\scripts\rollback-utility.ps1" `
    -workflowId "WF-YYYYMMDD-NNN"
```

Safety check: không ghi đè file mới hơn backup (trừ `--force`).

### `list` — Liệt kê backup

```powershell
Get-ChildItem -Path ".opencode\backup" -Directory | Select-Object Name, LastWriteTime
```

Với mỗi workflow, đọc manifest để xem danh sách file.

### `verify` — Kiểm tra integrity

```powershell
$manifest = Get-Content ".opencode\backup\<WF-ID>\05_backup_manifest.json" -Raw | ConvertFrom-Json
foreach ($entry in $manifest.files) {
    $hash = (Get-FileHash $entry.backup_path -Algorithm SHA256).Hash.Substring(0,12)
    if ($hash -ne $entry.hash) { "  [FAIL] $($entry.relative_path)" }
}
```

---

## Output contract

```yaml
action: save | rollback | list | verify
workflow_id: "WF-YYYYMMDD-NNN"
status: SUCCESS | PARTIAL | FAILED
summary:
  total: 3
  succeeded: 3
  skipped: 0
  failed: 0
details:
  - file: "path/to/file.cs"
    status: SUCCESS | SKIPPED | FAILED
    hash: "a1b2c3d4e5f6"
    error: null
manifest: ".opencode/backup/WF-YYYYMMDD-NNN/05_backup_manifest.json"
```

## Quy tắc

- Luôn tạo/gọi workflow ID khi chạy backup
- Không backup file nhạy cảm (*.exe, *.dll, .env, *secret*, *key*)
- Rollback mặc định an toàn (không ghi đè file mới) — chỉ `--force` khi user xác nhận
- Output luôn kèm summary JSON
