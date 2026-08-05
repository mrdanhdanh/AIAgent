---
name: workflow-migration-guide
description: >
  Huong dan migrate team.md cu sang thin launcher, restore nhanh (<1 phut),
  note deferred knowledge-index, phan vai workflow/, backward compatibility
  va checklist hau ky optional.
agent: general
---

# MIGRATION_GUIDE — Workflow Engine v4 (WF-20260801-003)

## 1. Quy trinh migrate team.md cu -> thin launcher

1. **Backup**: da hoan tat tai `.opencode/backup/WF-20260801-003/`
   (gom `team.md` + `sync-system-docs.ps1`, manifest SHA256).
2. **Smoke-test**: chay workflow-validator.ps1 tren 5 definitions + mo phong
   pipeline docs trong `$env:TEMP/wf-smoke-20260801-003/` (WF_CONTEXT_ROOT override).
   Chi cutover khi smoke-test PASS.
3. **Cutover**: thay body team.md (~dong 32-870) bang thin launcher
   (giu frontmatter + HELP rut gon + placeholder `$ARGUMENTS`).
4. **Rollback**: neu cutover loi, restore theo muc 2 ben duoi (<1 phut).

## 2. RESTORE NHANH team.md (< 1 phut)

Backup cu: `.opencode/backup/WF-20260801-003/.opencode/commands/team.md`

```powershell
# 1. Verify manifest (bao dam backup con nguyen ven)
& ".opencode\scripts\backup-utility.ps1" -action verify -workflowId WF-20260801-003

# 2. Restore file
Copy-Item ".opencode\backup\WF-20260801-003\.opencode\commands\team.md" ".opencode\commands\team.md" -Force

# 3. Kiem tra frontmatter con nguyen: description + agent: general
```

Chi tiet: `.opencode/workflow-engine/recovery.md` muc 6.

## 3. NOTE DEFERRED — knowledge-index

- `build-knowledge-index.ps1` + `knowledge-index.ps1` chi scan
  `JapaneseLearner/` + `.opencode/knowledge/`.
- KHONG quet `workflow-engine/` hay `workflow/definitions/`.
- Sprint WF-20260801-003 KHONG claim index moi.
- Final validation dung `/knowledge-index --status`.
- Post-sprint: mo rong script neu can quet workflow-engine/.
- Lenh /knowledge-index va /knowledge-* van hoat dong binh thuong.

## 4. Phan vai `.opencode/workflow/`

| Thu muc | Vai tro | Duoc sua? |
|---------|---------|-----------|
| `schemas/` | Contract tinh (workflow.schema.yaml) | KHONG sua tay |
| `definitions/` | Khai bao workflow tinh (5 *.yaml) | Chi sua qua PR / review |
| `WF-*/` | Runtime context do engine tao | KHONG sua tay, co the xoa khi retry |

Chi tiet: `.opencode/workflow-engine/README.md` muc 3.

## 5. Backward compatibility

- `contracts/workflow.yaml` (v1.0) giu nguyen **deprecated** — khong dung cho engine moi.
- Ban 13 buoc day du van o: `.opencode/skills/dev-team/SKILL.md` +
  engine docs moi (`.opencode/workflow-engine/*.md`).
- Snapshot cu WF-2026* doc theo state-machine.md (Backward read):
  missing field -> default (status->ready, issues->[], retry_count->0).

## 6. Checklist hau ky (optional, deferred)

- [ ] AGENTS.md: cap nhat mo ta `/team` + workflow-engine neu can.
- [ ] DOCTOR_REPORT.md: cap nhat health score sau doi thay.
- [ ] SYSTEM_MAP.md: file regenerate (tu sync-system-docs.ps1) — encoding-only diff chap nhan duoc.
- [ ] `/team-syncdocs` guard: thin launcher khong bi table update pha vo.
- [ ] 3 file regenerate (SYSTEM_MAP.md, SKILL.md, sync-last-report.json):
      encoding-only diff chap nhan duoc, khong can restore.

## Checklist bat buoc

- [ ] Migrate: backup -> smoke-test -> cutover -> rollback.
- [ ] Restore nhanh team.md < 1 phut (verify manifest -> Copy-Item -> check frontmatter).
- [ ] NOTE DEFERRED knowledge-index duoc ghi ro, khong claim index moi.
- [ ] Phan vai workflow/ ro rang (schemas/, definitions/, WF-*/).
- [ ] Backward compatibility: contracts/workflow.yaml deprecated; 13 buoc o SKILL.md + engine docs.
- [ ] Checklist hau ky optional (deferred) duoc liet ke.
