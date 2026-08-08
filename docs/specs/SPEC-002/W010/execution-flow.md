---
name: spec-002-w010-execution-flow
description: >
  SPEC-002 W010 — Workflow Execution Flow. Trả lời: Workflow chạy như thế
  nào? Workflow chạy qua Runtime (SPEC-001 S010) — Workflow Engine chỉ điều
  phối lớp khai báo. Mirror S010 (SPEC-001).
agent: general
---

# W010 — Workflow Execution Flow

> **SPEC-002**: Workflow Engine · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Workflow chạy như thế nào?**

## FL001 — Flow Philosophy

- Workflow chạy như Execution của Runtime (SPEC-001).
- Workflow Engine điều phối, Runtime thực thi (WB004).
- Mọi step là Capability đã resolve (S014).
- Không bước nào thiếu Event (S011).

## FL002 — Flow Principles

- **Declarative** — luồng khai báo trước, không hardcode.
- **Validate trước khi chạy** (WFR-003).
- **Normalize trước khi điều phối** (EF006).
- **Delegate thực thi cho Runtime** (WB004).
- Mọi step có trace + event (S011).

## FL003 — Execution Stages (7)

Workflow dùng 7 stages của **S010 EF004** (qua Runtime) — không định nghĩa lại:

```text
Initialize → Validate → Prepare → Execute → Coordinate → Finalize → Complete
```

## FL004 — Canonical Workflow Flow

```text
Command
    ↓
Load (Registry S014)
    ↓
Validate
    ↓
Normalize (EF006)
    ↓
Resolve Steps (S014)
    ↓
Orchestrate (delegate Runtime S010)
    ↓
Finalize
    ↓
Complete
```

## FL005 — Definition Resolution

```text
Workflow (Registry S014)
    ↓
Validate
    ↓
Normalize
    ↓
Workflow Plan
```

## FL006 — Step Resolution

- Mỗi step khai báo Capability → resolve qua Registry (S014 RG005).
- Không resolve được → Capability Failure (EF017).
- Step chạy qua Runtime — không tự chạy (WB004).

## FL007 — Sequential Flow

```text
Step 1 (Capability A) → Step 2 (Capability B) → Step 3 (Capability C)
```

- Step sau chỉ chạy khi step trước Terminal (S009).
- Context chuyển giữa các step (EF008).

## FL008 — Parallel Flow

Scatter / Gather (S010 EF021):

```text
Scatter → Step A, Step B, Step C
                ↓
              Barrier
                ↓
              Gather
                ↓
              Join → step tiếp
```

**Join Policy:** ALL · ANY · QUORUM · CUSTOM.

## FL009 — Barrier & Join

- Barrier chờ mọi step con đạt Terminal State (S009).
- Delegate Runtime thực thi (S010 EF021).
- Partial Success khi join ANY/QUORUM (S010 EF024).

## FL010 — Gate Flow

```text
Step → Gate (chưa duyệt) → Waiting (ST-005)
    → Approved → step tiếp
    → Denied → Failure (ST-009)
```

- Gate cần approval (S012 POL-APPROVAL-001).
- Quyết định ghi Audit (S011).

## FL011 — Retry Flow

```text
Step Failed (ST-009) → Retry (guard: retry_count < max_retry)
    → Retrying (ST-013) → Success → step tiếp
    → Hết retry → Failure
```

- Delegate Runtime (S010 EF012, POL-RETRY-001).
- Mỗi retry sinh Event (S011).

## FL012 — Timeout Flow

```text
Step Running (ST-004) → Timeout exceeded → TimedOut (ST-011)
```

- Delegate Runtime (S010 EF014, POL-TIMEOUT-001).
- Mỗi timeout sinh Event + Audit (S011).

## FL013 — Compensation Flow

```text
Workflow Failed (ST-009) → Rollback các step đã xong → Failure
```

- Delegate Runtime (S010 EF022, POL-COMP-001).
- Compensation theo thứ tự ngược (LIFO).

## FL014 — Failure Flow

5 loại failure (tham chiếu S010 EF017):

- Validation Failure (Workflow không hợp lệ)
- Capability Failure (không resolve được S014)
- Execution Failure (step lỗi)
- Policy Failure (Gate deny)
- System Failure

```text
Failure → Isolation → Failure Event → Failure Artifact → Terminal State
```

## FL015 — Workflow Lineage

- Root Workflow (không có parent) · Sub-workflow · Replay (ST-012) · Simulation (GV011A).
- Lineage immutable (append-only, S011).
- Delegate Runtime (S010 EF023).

## FL016 — Workflow Outcome

| Outcome | State |
|---------|-------|
| Success | Completed (ST-008) |
| Partial Success | Completed (ST-008) — join ANY/QUORUM |
| Failure | Failed (ST-009) |
| Cancelled | Cancelled (ST-010) |
| Timeout | TimedOut (ST-011) |
| Aborted | Aborted (ST-014) |

## FL017 — Machine-readable

```text
workflow-execution-flow.yaml
workflow-stages.yaml
workflow-sequential.yaml
workflow-parallel.yaml
workflow-gate.yaml
workflow-retry.yaml
workflow-timeout.yaml
workflow-compensation.yaml
workflow-failure.yaml
workflow-lineage.yaml
workflow-outcome.yaml
workflow-policies.yaml
workflow-validation.yaml
workflow-execution-flow.schema.json
```

## FL018 — Traceability

```text
Workflow Plan → Steps → Capability (S014) → Runtime Execution (S010) → Event (S011)
```

## FL019 — Success Criteria

- Canonical flow 8 bước đầy đủ.
- Mọi sub-flow delegate Runtime (không tự chạy).
- Mọi step resolve Capability trước khi chạy.
- Mọi bước sinh Event (S011).
- Workflow kết thúc bằng Terminal State (S009).
- Workflow khai báo tham số policy, không định nghĩa policy (WB008).
- Doctor xác minh từ machine-readable.

## Tham chiếu

- W009: `../W009/state-machine.md`
- S009: `../../SPEC-001/S009/state-machine.yaml`
- S010: `../../SPEC-001/S010/execution-flow.md` (mẫu + delegate)
- S011: `../../SPEC-001/S011/observability.md`
- S012: `../../SPEC-001/S012/policies.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
