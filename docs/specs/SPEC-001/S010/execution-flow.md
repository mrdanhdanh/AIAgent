---
name: spec-001-s010-execution-flow
description: >
  SPEC-001 S010 — Runtime Execution Flow (Execution Constitution). Trả lời:
  Execution diễn ra theo trình tự nào? 20 sections EF001-EF020. Kết nối S002-S009.
  Không mô tả implementation.
agent: general
---

# S010 — Runtime Execution Flow

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: Draft
> **Vị trí**: Execution Constitution — kết nối S002 Requirements → S009 State Machine thành một chuỗi thực thi hoàn chỉnh.

## Mục tiêu

> **Execution diễn ra theo trình tự nào?**

Không mô tả implementation — chỉ mô tả **thứ tự và luồng điều phối**, tham chiếu State Machine (S009) thay vì định nghĩa lại state/transition.

## EF001 — Execution Philosophy

- Execution là một chuỗi thống nhất, có thể quan sát.
- Mỗi bước tham chiếu State Machine (S009), không định nghĩa lại state.
- Mỗi bước chỉ thao tác trên Entity của S008.
- Flow chỉ mô tả thứ tự — không định nghĩa lại state/transition.

## EF002 — Execution Principles

- Flow xác định bởi State Machine.
- Mỗi bước có Contract (S007).
- Mỗi bước có Event (P005).
- Flow deterministic (P009).
- Không bypass bước.

## EF003 — Execution Lifecycle Overview

```text
Initiation → Preparation → Execution → Finalization → Archive
```

## EF004 — Execution Stages (4)

| Stage | Nội dung |
|-------|----------|
| STAGE-1 | Initiation, Validate Workflow, Prepare Context |
| STAGE-2 | Resolve Capability, Assign Agent, Execute Tasks |
| STAGE-3 | Collect Artifacts, Emit Events, Finalize Result |
| STAGE-4 | Archive, Publish Summary |

## EF005 — End-to-End Flow

```text
User/Command → Execution Manager → Workflow Loader → Execution Orchestrator
    → Capability Resolver → Registry Resolver → Agent
    → Artifact Dispatcher → Event Dispatcher → State Manager
    → Result → Archive
```

## EF006 — Workflow Resolution Flow

```text
Command → Workflow Loader nạp → Validate Workflow → Execution Plan
States: ST-001 → ST-002
Contract: CTR-002
```

## EF007 — Capability Resolution Flow

```text
Execution Orchestrator → Capability Resolver → Registry Resolver → Chọn Agent
States: ST-002 → ST-003
Contracts: CTR-004, CTR-005
```

## EF008 — Context Flow

```text
Execution Manager → Context Manager tạo → Cấp cho Agent → Thu hồi sau Execution
States: ST-003
Contract: CTR-006
```

## EF009 — State Flow

```text
State Manager khởi tạo → Theo dõi → Chuyển state → Terminal
States: ST-001..ST-014
Contract: CTR-007
```

## EF010 — Event Flow

```text
Mọi state change → Event Dispatcher nhận → Validate schema → Publish
States: Mọi transition
Contract: CTR-008
```

## EF011 — Artifact Flow

```text
Agent output → Artifact Dispatcher nhận → Checksum → Publish metadata
States: ST-004
Contract: CTR-009
```

## EF012 — Retry Flow

```text
Failed → Retrying → Running (nếu policy cho phép)
Guard: retry_count < policy.max_retry
States: ST-009 → ST-013 → ST-004
```

## EF013 — Timeout Flow

```text
Running → TimedOut → Timeout Artifact
States: ST-004 → ST-011
```

## EF014 — Cancellation Flow

```text
Running → Cancelling → Cancelled
States: ST-004 → ST-007 → ST-010
```

## EF015 — Approval Flow

```text
Running → Waiting → Approved → Running
States: ST-004 → ST-005 → ST-004
Contract: CTR-011 (Policy)
```

## EF016 — Replay Flow

```text
Completed/Failed → Replayed → Tạo Execution mới → Lineage giữ nguyên
States: ST-008/ST-009 → ST-012
Entities: ENT-001, ENT-014
```

## EF017 — Failure Flow

```text
Phát hiện lỗi → Cô lập → Failure Event → Failure Artifact → Rollback/Retry
States: ST-004 → ST-009/ST-011/ST-014
Principle: P015 Fail Safe
```

## EF018 — Machine-readable Files

```text
execution-flow.yaml
end-to-end-flow.yaml
flow-definitions.yaml
execution-flow-registry.yaml
execution-flow.schema.json
```

## EF019 — Traceability

```text
Flow → State (S009) → Entity (S008) → Contract (S007) → Component (S006)
     → Requirement (S002) → Responsibility (S003) → Boundary (S004)
```

## EF020 — Success Criteria

Hoàn thành khi:

- Execution là một chuỗi thống nhất, có thể quan sát.
- Mỗi bước tham chiếu State Machine, không định nghĩa lại.
- Mỗi bước có Contract + Event.
- 12 flows được định nghĩa (workflow/capability/context/state/event/artifact/retry/timeout/cancellation/approval/replay/failure).
- Doctor kiểm tra toàn bộ từ file machine-readable.
- Dashboard dựng được sequence flow.

## Tham chiếu

- `execution-flow.yaml` — nguồn dữ liệu chuẩn.
- `end-to-end-flow.yaml` — EF005.
- `flow-definitions.yaml` — EF006-EF017 (12 flows).
- `execution-flow-registry.yaml` — registry.
- `execution-flow.schema.json` — validate cấu trúc.
- S009: `../S009/state-machine.yaml`
- S008: `../S008/data-model.md`
- S007: `../S007/contracts.yaml`
- S006: `../S006/components.yaml`
- Constitution: `docs/specs/SPEC-000/`
