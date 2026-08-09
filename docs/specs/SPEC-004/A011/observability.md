---
name: spec-004-a011-observability
description: >
  SPEC-004 A011 — Agent Observability. Trả lời: Agent được quan sát như thế
  nào? Agent dùng Observability của Runtime (S011) — chỉ thêm definition-level.
  Mirror C011 (SPEC-003).
agent: general
---

# A011 — Agent Observability

> **SPEC-004**: Agent System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Agent được quan sát như thế nào?**

## AO001 — Philosophy

- Mọi hoạt động đều sinh dữ liệu quan sát (P014).
- Không đo được thì không kiểm soát được.
- Agent dùng S011 (Runtime) — không định nghĩa lại.

## AO002 — Principles

- Event Driven · Traceable · Immutable · Correlation First · Metadata First · Append Only (S011).

## AO003 — Domains

- Events · Metrics · Trace · Audit · Health (S011).

## AO003A — Observability Boundary

**Agent quan sát:**

- Agent Definition
- Capability Mapping
- Agent Binding
- Agent Event
- Agent Result

**Agent không quan sát trực tiếp:**

- Business Data
- User Data
- Knowledge Content
- Agent Internal State
- Plugin Internal State

## AO004 — Agent Events

- **Definition-level**: AGENT_VALIDATING · AGENT_PUBLISHED · AGENT_REJECTED · AGENT_DEPRECATED · AGENT_REACTIVATED · AGENT_RETIRED (A009).
- **Run-level**: EXECUTION_* (S011 — Runtime).

**Rules:** Event immutable (P010); chỉ append; mọi transition sinh Event (A009); có correlation_id.

## AO005 — Agent Metrics

- agent_count · execution_count · execution_success_rate · execution_failure_rate · fallback_count · mapping_count · binding_count · state_distribution · outcome_distribution · avg_execution_time.

**Rules:** Metrics chỉ append (S011); không chứa Business Data.

## AO006 — Agent Trace

Scope: Agent · **Orchestration (Workflow SPEC-002)** · Parent (workflow dùng agent) · Child (agent gọi agent qua capability) · Correlation · **Causation** · Lineage.

**Rules:** Trace chỉ append (S011); Correlation ≠ Causation; delegate Runtime/Workflow.

## AO007 — Agent Audit

- **Append Only · Immutable · Ordered · Time Consistent** (S011).
- Ghi mọi quyết định (publish, deprecate, reject, **mapping**) (P008).
- Không ghi Business Data.

## AO008 — Correlation

```yaml
model:
  fields: [agent_id, execution_id, correlation_id, lineage_id, parent_id]
```

- Sinh khi Agent Created.
- Gắn vào: Event, Metrics, Trace, Audit.
- Không đổi trong vòng đời (P009).

## AO009 — Health

- **Healthy · Degraded · Unhealthy** (S011 OB009).
- Nguồn: Execution, Resource, Event, Metrics, Policy.
- Không nói công thức; không tự sửa lỗi.

## AO010 — Dashboard

Chỉ đọc: Agent Events · Metrics · Trace · Audit · Health (S011 OB010). Không đọc implementation.

## AO011 — Doctor

Kiểm tra: Missing Agent Event · Missing Agent Metrics · Broken Agent Trace · Broken Lineage (S011) · Invalid Audit (S011).

## AO011A — Evolution Integration

- Evolution chỉ đọc: Agent Event, Metrics, Trace, Audit.
- Evolution không đọc implementation (S011 OB011A).

## AO012 — Event Lifecycle

```text
Created → Published → Consumed → Archived
```

(S011 reuse)

## AO013 — Metrics Lifecycle

```text
Collected → Aggregated → Published
```

(S011 reuse)

## AO014 — Traceability

```text
Agent → State (A009) → Event → Metrics → Trace → Audit
    ↓
Execution (S008/S009) → S011
```

## AO015 — Machine-readable

```text
agent-observability.yaml
agent-events.yaml
agent-metrics.yaml
agent-traces.yaml
agent-audit.yaml
agent-correlation.yaml
agent-health.yaml
agent-dashboard.yaml
agent-observability-mapping.yaml
agent-observability.schema.json
```

## AO016 — Success Criteria

- Mọi Agent đều quan sát được.
- Mọi Transition đều sinh Event (A009).
- Mọi Agent đều có Metrics + Trace + Audit.
- Dashboard và Doctor chỉ cần đọc machine-readable.
- Không phụ thuộc nền tảng quan sát cụ thể.
- Agent dùng S011 — không định nghĩa lại.

## Tham chiếu

- A009: `../A009/state-machine.md`
- A010: `../A010/execution-flow.md`
- C011: `../../SPEC-003/C011/observability.md` (mẫu)
- S011: `../../SPEC-001/S011/observability.md` (reuse)
- S013: `../../SPEC-001/S013/governance.md`
- Constitution: `docs/specs/SPEC-000/`