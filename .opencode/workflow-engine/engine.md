---
name: workflow-engine
description: >
  Controller cua Workflow Engine v4 — pipeline 7 buoc, decision tree sau moi phase,
  checkpoint state.json, WF_CONTEXT_ROOT override, timeout 120s/phase.
agent: general
---

# Engine (Controller)

Dieu phoi toan bo vong doi workflow. Doc file nay dau tien sau README.md.

## 1. Pipeline 7 buoc

| # | Buoc | Input | Output |
|---|------|-------|--------|
| 1 | load | `--workflow` id (mac dinh `default`) | phase graph (loader.md) |
| 2 | validate | phase graph | PASS / WF-ERR-00x (validator.md) |
| 3 | resolve dependencies | execution_order (topological) | danh sach phase san sang |
| 4 | run phase | phase node + context | phase output (phase-runner.md) |
| 5 | validate output | output contract | PASS / WF-ERR-008 |
| 6 | save artifact | output | `.opencode/workflow/<WF-ID>/artifacts/<NN>_<phase>.md` |
| 7 | update state | phase status | checkpoint `state.json` |

## 2. Decision tree sau moi phase

```yaml
decision:
  after_phase:
    - if: "phase.status == completed"
      action: next_phase
    - if: "phase.status == failed and retry_count < 3 and same_error < 2"
      action: retry_phase
    - if: "phase.status == failed and (retry_count >= 3 or same_error >= 2)"
      action: rollback        # catastrophic
    - if: "phase.status == failed and phase.optional == true"
      action: skip_phase      # ghi skipped, khong block
    - if: "phase.status == failed and phase.continue_on_error == true"
      action: next_phase      # log warning, tiep tuc
    - if: "error.code in [WF-ERR-006, WF-ERR-007, WF-ERR-004]"
      action: abort           # dung workflow, bao CRITICAL
    - if: "phase.status == cancelled or user_request"
      action: abort
  retry_policy:
    max_retries: 3
    same_error_max: 2         # same_error >= 2 -> rollback
```

## 3. Resolve workflow id

- `default_workflow: default` trong schema.
- Khong truyen `--workflow` -> dung `default`.
- `--workflow <invalid>` -> WF-ERR-009 + danh sach 5 definitions
  (`default, bugfix, feature, ui, docs`).
- KHONG tu fallback mu sang default khi id invalid.

## 4. State checkpoint

- Doc `state.json`: tim `phase_index` cua phase completed cuoi cung = restore point.
- Ghi checkpoint sau MOI phase: cap nhat `phase_index`, `current_phase`, `status`,
  `retry_count`, `error_history`, `artifacts`.
- Workflow moi: khoi tao state.json default (phase_index 0, status pending).

## 5. WF_CONTEXT_ROOT override

- Bien moi truong `WF_CONTEXT_ROOT` cho phep override root cua `.opencode/workflow/WF-*/`.
- Dung cho smoke-test chay trong `$env:TEMP/wf-smoke-20260801-003/`, KHONG tao WF-* trong repo.
- Khi khong set -> root mac dinh `.opencode/workflow/`.

## 6. Timeout

- 120 giay / phase (phase-runner.md ap dung, retry theo phase.retry).

## 7. Output contract

```yaml
engine_output:
  workflow_id: string
  definition_id: string
  status: "completed" | "failed" | "cancelled" | "rolled_back"
  phases:
    - id: string
      status: phase_status
      retry_count: int
      error_history: [string]
  artifacts: [string]
  final_report: string | null
```

## 8. Checklist

- [ ] Pipeline 7 buoc: load -> validate -> resolve -> run -> validate output -> save artifact -> update state.
- [ ] Decision tree sau moi phase day du (6 nhanh + retry policy).
- [ ] default_workflow: default; invalid -> WF-ERR-009, khong fallback mu.
- [ ] Doc state.json (last completed) + ghi checkpoint sau moi phase.
- [ ] WF_CONTEXT_ROOT override ho tro smoke-test temp.
- [ ] Timeout 120s/phase.
- [ ] KHONG viet `#` truoc WF-ID / WF-ERR.
