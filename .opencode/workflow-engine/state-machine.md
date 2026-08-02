---
name: workflow-engine-state-machine
description: >
  May trang thai cho Workflow Engine v4 — dinh nghia states, transitions,
  bang backward read WF-2026* va schema state.json.
agent: general
---

# State Machine

## 1. Cac trang thai (states)

```
Pending -> Ready -> Running -> Completed
                    |  -> Failed -> Retry (toi da 3) -> Running
                    |           -> Skipped (chi khi optional=true)
                    |           -> Cancelled (abort / user_request)
                    |           -> RolledBack (sau rollback)
```

- `pending`: phase chua san sang (depends_on chua completed).
- `ready`: san sang chay (moi dep completed).
- `running`: dang chay qua phase-runner.
- `completed`: output hop le, artifact da luu.
- `failed`: output loi / timeout / exception.
- `retry`: dang doi chay lai (retry_count < max).
- `skipped`: optional phase fail -> khong block.
- `cancelled`: user y/c dung hoac abort.
- `rolled_back`: da rollback ve restore point.

## 2. So do transitions (ASCII)

```
+---------+    dep ok     +-------+    dispatch   +---------+
| pending | ------------> | ready | ------------> | running |
+---------+               +-------+               +---------+
                                                      |  output OK
                                                      v
                                                  +-----------+
                                                  | completed |
                                                  +-----------+
                                                      ^
                                                      |  retry < 3
+---------+    fail/timeout   +--------+  ----------+
| running | ----------------->| failed |
+---------+                    +--------+
                                  |  retry >= 3 / same_error >= 2
                                  v
                              +-----------+
                              | cancelled |  (abort)
                              +-----------+
                                  |
                                  v
                              +-----------+
                              | rolled_back| (rollback ve restore point)
                              +-----------+
```

## 3. Bang transition hop le

| Tu | Den | Dieu kien trigger |
|----|-----|-------------------|
| pending | ready | tat ca depends_on completed (hoac khong co dep) |
| ready | running | executor bat dau chay phase |
| running | completed | output hop le theo output contract |
| running | failed | output loi / timeout 120s / exception |
| running | cancelled | user_request hoac abort (catastrophic) |
| failed | retry | retry_count < max (3) va same_error < 2 |
| retry | running | executor chay lai phase |
| failed | skipped | optional=true va fail (khong retry tiep) |
| failed | cancelled | retry >= 3 hoac same_error >= 2 |
| failed | rolled_back | recovery.rollback duoc goi |
| completed | rolled_back | rollback duoc goi (workflow cap) |

## 4. Backward read WF-2026* (snapshot cu)

Doc snapshot cu tu `.opencode/workflows/*.json` (schema_version 2.0 / 3.x):

| Field legacy | Gia tri cu | Map sang v4 |
|--------------|-----------|-------------|
| `step` (int) | 1-13 | `phase_index` (0-based = step - 1) |
| `status: running` | running | `ready` (chay tiep tu phase_index) |
| `status: completed` | completed | `completed` |
| `status: failed` | failed | `cancelled` (khong retry) |
| `status: cancelled` | cancelled | `cancelled` |
| `status: blocked` | blocked | `cancelled` |
| `status: waiting_user` | waiting_user | `cancelled` (can user quyet dinh moi) |
| `current_data.<phase>` | object | `artifacts[]` (ten file `<NN>_<phase>.md` neu co) |

Missing field -> default:

| Field | Default |
|-------|---------|
| status | ready |
| issues | [] |
| retry_count | 0 |
| error_history | [] |
| same_error_count | 0 |
| phase_index | 0 |

Neu snapshot cu khong co `state.json` moi -> recovery.md khoi tao default state.

## 5. Schema state.json

```yaml
state:
  workflow_id: "WF-2026-MMDD-NNN"
  definition:
    id: docs
    name: Docs Workflow
    version: 1.0.0
  phase_index: 2
  current_phase: write
  status: running            # pending|ready|running|completed|failed|retry|skipped|cancelled|rolled_back
  retry_count: 0
  same_error_count: 0
  error_history:
    - phase: analyze
      code: WF-ERR-005
      message: "depends_on 'xyz' khong ton tai"
      occurred_at: "2026-08-01T10:00:00Z"
  artifacts:
    - "01_analyze.md"
    - "02_write.md"
```

Luu y: state.json duoc ghi checkpoint sau moi phase (engine.md), duoc doc de
phuc hoi khi engine khoi dong lai (last completed phase = restore point).

## 6. Checklist

- [ ] States du dinh nghia du 9 gia tri enum (schema v4).
- [ ] Transitions hop le duoc ghi bang ro rang.
- [ ] Backward read WF-2026* map dung schema 2.0/3.x -> v4.
- [ ] Missing field co default cu the.
- [ ] state.json schema co: workflow_id, definition, phase_index, current_phase, status, retry_count, error_history[], artifacts[].
- [ ] KHONG viet `#` truoc WF-2026*.
