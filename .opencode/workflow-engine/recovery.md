---
name: workflow-engine-recovery
description: >
  Recovery cho Workflow Engine v4 — xu ly catastrophic_failure, max_retry_reached,
  user_request. Retry / skip / abort / rollback, doc restore point tu state.json.
agent: general
---

# Recovery

Xu ly khi workflow gap loi nghiem trong hoac can phuc hoi.

## 1. Trigger

| Trigger | Dieu kien |
|---------|-----------|
| catastrophic_failure | backup fail, WF-ERR-006/007, FileOutsidePlan |
| max_retry_reached | retry >= 3 hoac same_error >= 2 |
| user_request | user y/c dung hoac rollback |

## 2. Hanh dong

| Hanh dong | Dieu kien | Ket qua |
|-----------|-----------|---------|
| retry_phase | retry < 3 va same_error < 2 | chay lai phase (state: retry) |
| skip_phase | chi khi `optional=true` | phase -> skipped, khong block |
| abort | catastrophic / user_request | workflow status = cancelled |
| rollback | catastrophic, retry >= 3, same_error >= 2, hoac user y/c | goi rollback-utility |

Rollback goi:

```powershell
& ".opencode\scripts\rollback-utility.ps1" -workflowId "<WF-ID>" [-force]
```

- Can user xac nhan truoc khi rollback (tru khi `-force`).

## 3. Restore point

- Doc `state.json` -> phase completed cuoi cung (max `phase_index` voi
  `status == completed`) = restore point.
- Rollback ve restore point: xoa artifact sau restore point, dat lai
  `phase_index` = restore point, workflow status = `rolled_back`.

## 4. Error history

- Moi lan fail: ghi `error_history[]` kem code, message, occurred_at.
- `same_error_count`: dem so lan cung error_normalized lien tiep.
  - >= 2 -> catastrophic -> rollback (khong retry vo han).

## 5. Backward (snapshot cu WF-2026*)

- Snapshot cu khong co `state.json` moi -> khoi tao default state
  (status ready, phase_index 0, retry_count 0, error_history [], artifacts []).
- Chi tiet map: state-machine.md muc Backward read WF-2026*.

## 6. Restore nhanh team.md (< 1 phut)

Khi thin launcher team.md bi loi va can quay ve ban cu:

1. Verify backup:
   ```powershell
   & ".opencode\scripts\backup-utility.ps1" -action verify -workflowId WF-20260801-003
   ```
2. Restore:
   ```powershell
   Copy-Item ".opencode\backup\WF-20260801-003\.opencode\commands\team.md" ".opencode\commands\team.md" -Force
   ```
3. Kiem tra frontmatter (`description`, `agent: general`) con nguyen.
4. Neu can chi tiet hon: doc `.opencode/workflow/MIGRATION_GUIDE.md`.

## 7. Output contract

```yaml
recovery_output:
  action: "retry_phase" | "skip_phase" | "abort" | "rollback"
  trigger: "catastrophic_failure" | "max_retry_reached" | "user_request"
  phase_id: string | null
  restore_point: int | null
  rollback_command: string | null
  status: "OK" | "FAILED"
  error: string | null
```

## 8. Checklist

- [ ] 3 trigger recovery du dinh nghia.
- [ ] 4 hanh dong (retry/skip/abort/rollback) dung dieu kien.
- [ ] Rollback goi rollback-utility.ps1 -workflowId, can user xac nhan.
- [ ] Doc last completed tu state.json = restore point.
- [ ] Ghi error_history + same_error_count trong state.
- [ ] Snapshot cu WF-2026* khong state.json -> khoi tao default state.
- [ ] Quy trinh restore nhanh team.md < 1 phut (tro MIGRATION_GUIDE.md).
- [ ] KHONG viet `#` truoc WF-ID.
