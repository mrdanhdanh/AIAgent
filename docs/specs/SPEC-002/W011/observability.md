---
name: spec-002-w011-observability
description: >
  SPEC-002 W011 — Workflow Observability. Trả lời: Workflow được quan sát
  như thế nào? Workflow dùng Observability của Runtime (S011) — chỉ thêm
  definition-level. Mirror S011 (SPEC-001).
agent: general
---

# W011 — Workflow Observability

> **SPEC-002**: Workflow Engine · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Workflow được quan sát như thế nào?**

## WO001 — Philosophy

- Mọi hoạt động đều sinh dữ liệu quan sát (P014).
- Không đo được thì không kiểm soát được.
- Workflow dùng S011 (Runtime) — không định nghĩa lại.

## WO002 — Principles

- Event Driven · Traceable · Immutable · Correlation First · Metadata First · Append Only (S011).

## WO003 — Domains

- Events · Metrics · Trace · Audit · Health (S011).

## WO003A — Observability Boundary

**Workflow quan sát:**

- Workflow Definition
- Workflow Step
- Step Context
- Workflow Event
- Workflow Result

**Workflow không quan sát trực tiếp:**

- Business Data
- User Data
- Knowledge Content
- Agent Internal State
- Plugin Internal State

## WO004 — Workflow Events

- **Definition-level**: WORKFLOW_VALIDATING · WORKFLOW_PUBLISHED · WORKFLOW_REJECTED · WORKFLOW_DEPRECATED · WORKFLOW_REACTIVATED · WORKFLOW_RETIRED (W009).
- **Run-level**: EXECUTION_* (S009 — Runtime State Machine).

**Rules:** Event immutable (P010); chỉ append; mọi transition sinh Event (W009); có correlation_id.

## WO005 — Workflow Metrics

- workflow_count · workflow_completion_rate · workflow_failure_rate · step_count · gate_wait_time · retry_count · timeout_count · state_distribution · outcome_distribution · avg_step_duration.

**Rules:** Metrics chỉ append (S011); không chứa Business Data.

## WO006 — Workflow Trace

Scope: Workflow · Step · Parent (workflow gọi workflow) · Child (sub-workflow) · Correlation · **Causation** · Lineage.

**Rules:** Trace chỉ append (S011); Correlation ≠ Causation (S011 OB006); delegate Runtime.

## WO007 — Workflow Audit

- **Append Only · Immutable · Ordered · Time Consistent** (S011).
- Ghi mọi quyết định (gate, deprecate, reject) (P014).
- Không ghi Business Data.

## WO008 — Correlation

```yaml
model:
  fields: [workflow_id, execution_id, correlation_id, lineage_id, parent_id]
```

- Sinh khi Workflow Created.
- Gắn vào: Event, Metrics, Trace, Audit.
- Không đổi trong vòng đời (P010).

## WO009 — Health

- **Healthy · Degraded · Unhealthy** (S011 OB009).
- Nguồn: Execution, Resource, Event, Metrics, Policy.
- Không nói công thức; không tự sửa lỗi.

## WO010 — Dashboard

Chỉ đọc: Workflow Events · Metrics · Trace · Audit · Health (S011 OB010). Không đọc implementation.

## WO011 — Doctor

Kiểm tra: Missing Workflow Event · Missing Workflow Metrics · Broken Workflow Trace · Broken Lineage (S011) · Invalid Audit (S011).

## WO011A — Evolution Integration

- Evolution chỉ đọc: Workflow Event, Metrics, Trace, Audit.
- Evolution không đọc implementation (S011 OB011A).

## WO012 — Event Lifecycle

```text
Created → Published → Consumed → Archived
```

(S011 cung cấp event model — fields, correlation_id)

## WO013 — Metrics Lifecycle

```text
Collected → Aggregated → Published
```

(S011 cung cấp metric model)

## WO014 — Traceability

```text
Workflow → State (W009) → Event → Metrics → Trace → Audit
    ↓
Execution (S008/S009) → S011
```

## WO015 — Machine-readable

```text
workflow-observability.yaml
workflow-events.yaml
workflow-metrics.yaml
workflow-traces.yaml
workflow-audit.yaml
workflow-correlation.yaml
workflow-health.yaml
workflow-dashboard.yaml
workflow-observability-mapping.yaml
workflow-observability.schema.json
```

## WO016 — Success Criteria

- Mọi Workflow đều quan sát được.
- Mọi Transition đều sinh Event (W009).
- Mọi Workflow đều có Metrics + Trace + Audit.
- Dashboard và Doctor chỉ cần đọc machine-readable.
- Không phụ thuộc nền tảng quan sát cụ thể.
- Workflow dùng S011 — không định nghĩa lại.

## Tham chiếu

- W009: `../W009/state-machine.md`
- W010: `../W010/execution-flow.md`
- S011: `../../SPEC-001/S011/observability.md` (mẫu + reuse)
- S013: `../../SPEC-001/S013/governance.md`
- Constitution: `docs/specs/SPEC-000/`
