---
name: workflow-phase-backup
description: Backup 2 file truoc khi build — gh-pages-root/index.html + deploy.yml
agent: backup-agent
---

# Phase 06 — Backup (WF-20260805-001)

## Backup manifest

| File goc | Backup | Size | Trang thai |
|----------|--------|------|------------|
| `gh-pages-root/index.html` | `.opencode/backup/WF-20260805-001/gh-pages-root/index.html.bak` | 1130 B | OK |
| `.github/workflows/deploy.yml` | `.opencode/backup/WF-20260805-001/.github/workflows/deploy.yml.bak` | 1521 B | OK |

## Verify

- Backup tai thu muc `.opencode/backup/WF-20260805-001/`
- Ca 2 file ton tai voi kich thuoc dung (>0)
- San sang cho phase build

```yaml
status: "PASS"
backup_workflow_id: "WF-20260805-001"
files_backed_up: 2
```

## Checklist

- [x] Backup truoc khi build (2 files)
- [x] Backup manifest duoc tao
- [x] Verify file backup > 0 bytes
