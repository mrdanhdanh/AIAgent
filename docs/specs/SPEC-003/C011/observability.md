---
name: spec-003-c011-observability
description: >
  SPEC-003 C011 — Capability Observability. Trả lời: Capability được quan sát
  như thế nào? Capability dùng Observability của Runtime (S011) — chỉ thêm
  definition-level. Mirror W011 (SPEC-002).
agent: general
---

# C011 — Capability Observability

> **SPEC-003**: Capability System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Capability được quan sát như thế nào?**

## CO001 — Philosophy

- Mọi hoạt động đều sinh dữ liệu quan sát (P014).
- Không đo được thì không kiểm soát được.
- Capability dùng S011 (Runtime) — không định nghĩa lại.

## CO002 — Principles

- Event Driven · Traceable · Immutable · Correlation First · Metadata First · Append Only (S011).

## CO003 — Domains

- Events · Metrics · Trace · Audit · Health (S011).

## CO003A — Observability Boundary

**Capability quan sát:**

- Capability Definition
- Capability Mapping
- Capability Binding
- Capability Event
- Capability Result

**Capability không quan sát trực tiếp:**

- Business Data
- User Data
- Knowledge Content
- Agent Internal State
- Plugin Internal State

## CO004 — Capability Events

- **Definition-level**: CAPABILITY_VALIDATING · CAPABILITY_PUBLISHED · CAPABILITY_REJECTED · CAPABILITY_DEPRECATED · CAPABILITY_REACTIVATED · CAPABILITY_RETIRED (C009).
- **Run-level**: EXECUTION_* (S011 — Runtime).

**Rules:** Event immutable (P005); chỉ append; mọi transition sinh Event (C009); có correlation_id.

## CO005 — Capability Metrics

- capability_count · resolution_count · resolution_success_rate · resolution_failure_rate · fallback_count · mapping_count · binding_count · state_distribution · outcome_distribution · avg_resolution_time.

**Rules:** Metrics chỉ append (S011); không chứa Business Data.

## CO006 — Capability Trace

Scope: Capability · **Resolution (EF007)** · Parent (workflow dùng capability) · Child (capability gọi capability) · Correlation · **Causation** · Lineage.

**Rules:** Trace chỉ append (S011); Correlation ≠ Causation; delegate Runtime.

## CO007 — Capability Audit

- **Append Only · Immutable · Ordered · Time Consistent** (S011).
- Ghi mọi quyết định (publish, deprecate, reject, **mapping**) (P008).
- Không ghi Business Data.

## CO008 — Correlation

```yaml
model:
  fields: [capability_id, execution_id, correlation_id, lineage_id, parent_id]
```

- Sinh khi Capability Created.
- Gắn vào: Event, Metrics, Trace, Audit.
- Không đổi trong vòng đời (P009).

## CO009 — Health

- **Healthy · Degraded · Unhealthy** (S011 OB009).
- Nguồn: Execution, Resource, Event, Metrics, Policy.
- Không nói công thức; không tự sửa lỗi.

## CO010 — Dashboard

Chỉ đọc: Capability Events · Metrics · Trace · Audit · Health (S011 OB010). Không đọc implementation.

## CO011 — Doctor

Kiểm tra: Missing Capability Event · Missing Capability Metrics · Broken Capability Trace · Broken Lineage (S011) · Invalid Audit (S011).

## CO011A — Evolution Integration

- Evolution chỉ đọc: Capability Event, Metrics, Trace, Audit.
- Evolution không đọc implementation (S011 OB011A).

## CO012 — Event Lifecycle

```text
Created → Published → Consumed → Archived
```

(S011 reuse)

## CO013 — Metrics Lifecycle

```text
Collected → Aggregated → Published
```

(S011 reuse)

## CO014 — Traceability

```text
Capability → State (C009) → Event → Metrics → Trace → Audit
    ↓
Execution (S008/S009) → S011
```

## CO015 — Machine-readable

```text
capability-observability.yaml
capability-events.yaml
capability-metrics.yaml
capability-traces.yaml
capability-audit.yaml
capability-correlation.yaml
capability-health.yaml
capability-dashboard.yaml
capability-observability-mapping.yaml
capability-observability.schema.json
```

## CO016 — Success Criteria

- Mọi Capability đều quan sát được.
- Mọi Transition đều sinh Event (C009).
- Mọi Capability đều có Metrics + Trace + Audit.
- Dashboard và Doctor chỉ cần đọc machine-readable.
- Không phụ thuộc nền tảng quan sát cụ thể.
- Capability dùng S011 — không định nghĩa lại.

## Tham chiếu

- C009: `../C009/state-machine.md`
- C010: `../C010/execution-flow.md`
- W011: `../../SPEC-002/W011/observability.md` (mẫu)
- S011: `../../SPEC-001/S011/observability.md` (reuse)
- S013: `../../SPEC-001/S013/governance.md`
- Constitution: `docs/specs/SPEC-000/`
