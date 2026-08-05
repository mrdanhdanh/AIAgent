---
name: agent-state-machine
description: state-machine — định nghĩa trạng thái, transition, guard của Agent Object. Mở rộng từ lifecycle.md.
agent: general
---

# Agent State Machine

## 1. States (enums)

Trạng thái **instance** (1 task):

```text
CREATED, LOADED, VALIDATED, READY, RUNNING, WAITING,
COMPLETED, ARCHIVED, FAILED, DISABLED
```

Trạng thái **status** khai báo (trong agent.yaml, mức định nghĩa — không phải instance):
```text
draft, experimental, beta, stable, deprecated, disabled
```

> Phân biệt: `status` = mức trưởng thành tĩnh; state = trạng thái runtime động.

## 2. Transition table

| # | From | To | Guard |
|---|------|----|-------|
| T1 | Created | Loaded | metadata parse OK |
| T2 | Loaded | Validated | validator ALL PASS |
| T3 | Loaded | Failed | validator ERROR |
| T4 | Validated | Ready | no block |
| T5 | Ready | Running | task assigned |
| T6 | Running | Waiting | missing context/input |
| T7 | Waiting | Running | context ready |
| T8 | Running | Completed | output contract valid |
| T9 | Running | Failed | exception/timeout |
| T10 | Failed | Retry | retry_count < retry |
| T11 | Retry | Ready | pass again |
| T12 | Retry | Disabled | retry exhausted |
| T13 | Completed | Archived | task closed |
| T14 | Ready | Disabled | cancelled externally |

## 3. Guards

- **T2**: validator đọc `required` theo agent.schema.yaml (identity trường bắt buộc), kiểm capability tồn tại (capabilities.yaml), contract tồn tại (input/output.schema.yaml).
- **T5**: capability của task phải nằm trong `supports`; compatibility match.
- **T6**: Phase 4 Context Engine chưa cấp đủ `requires_context`.
- **T8**: output phải đủ required field theo output contract.

## 4. Legal status

- `deprecated`/`disabled` agent: `enabled: false` → Resolver KHÔNG chọn (trừ fallback).
- Deprecated có `replacement` → Resolver ưu tiên replacement.

## 5. Persistence

- State transition log → `state-store` (workflow-runtime/state-store.md).
- Doctor đọc số lần FAILED/DISABLED để tính health.