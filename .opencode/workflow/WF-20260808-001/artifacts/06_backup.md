---
name: backup
description: >
  Backup manifest truoc khi build dragon-website template. Toan bo file tao moi
  trong thu muc templates/dragon-website/ — khong co file co san bi ghi de.
agent: general
---

# Phase 06 — Backup manifest (WF-20260808-001)

## Ket qua

- **No files to overwrite**: ke hoach chi TAO MOI 4 file trong thu muc `templates/dragon-website/`
  (index.html, style.css, script.js, README.md). Khong sua/ghi de file nao co san.
- Do do khong can snapshot backup file cu (backup-utility: action=save khong co files -> skipped).
- Snapshot de phong van duoc luu tai `.opencode/backup/WF-20260808-001/` (empty manifest) de
  ghi nhan diem build.

## Mang luoi an toan

- Neu build that bai hoac tao file sai vi tri -> chi can xoa thu muc `templates/dragon-website/`
  (git clean cho thu muc moi) — khong anh huong code .NET/Blazor hien tai.
- Git branch hien tai: `NewVersion` (khong cham toi master).

## Output

```yaml
status: PASS
backup_workflow_id: WF-20260808-001
notes: >
  Khong co file co san bi thay doi (toan bo tao moi). Backup manifest de phong
  duoc tao de ghi nhan diem build truoc khi tao templates/dragon-website/.
  Rollback = xoa thu muc templates/dragon-website/ (git clean).
```
