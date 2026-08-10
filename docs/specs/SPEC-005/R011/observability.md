---
name: spec-005-r011-observability
description: SPEC-005 R011 — Registry Observability.
agent: general
---

# R011 — Registry Observability

> **SPEC-005**: Registry · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Registry được quan sát như thế nào?**

## RO001 — Philosophy

- Mọi hoạt động đều sinh dữ liệu quan sát (P014).
- Registry dùng S011 (Runtime) — không định nghĩa lại.

## RO002 — Principles

- Event Driven · Traceable · Immutable · Correlation First · Metadata First · Append Only (S011).

## RO003 — Domains

- Events · Metrics · Trace · Audit · Health (S011).

## RO003A — Observability Boundary

**Registry quan sát:** Entry Metadata · Entry Version · Entry Domain · Registry Event · Resolution Result.

**Registry không quan sát trực tiếp:** Business Data · User Data · Knowledge Content · Agent Internal State · Plugin Internal State.

## RO004 — Registry Events

- **Definition-level**: REGISTRY_ENTRY_VALIDATING · PUBLISHED · REJECTED · DEPRECATED · REACTIVATED · RETIRED (R009).
- **Run-level**: EXECUTION_* (S011).

Rules: Event immutable (P010); chỉ append; có correlation_id.

## RO005 — Registry Metrics

- entry_count · lookup_count · resolution_count · resolution_success_rate · cache_hit · query_count · state_distribution · outcome_distribution · avg_resolution_time.

## RO006 — Registry Trace

- Scope: Entry · Resolution (S014) · Parent/Child · Correlation · Causation · Lineage.

## RO007 — Registry Audit

- Append Only · Immutable · Ordered · Time Consistent (S011).
- Ghi mọi quyết định (publish, deprecate, reject, ownership) (P008).
- Không ghi Business Data.

## RO008 — Correlation

```yaml
model:
  fields: [entry_id, execution_id, correlation_id, lineage_id, parent_id]
```

## RO009 — Health

- Healthy · Degraded · Unhealthy (S011 OB009). Không nói công thức; không tự sửa lỗi.

## RO010 — Dashboard

- Chỉ đọc: Registry Events · Metrics · Trace · Audit · Health (S011 OB010).

## RO011 — Doctor

- Missing Registry Event · Missing Registry Metrics · Broken Registry Trace · Broken Lineage (S011) · Invalid Audit (S011).

## RO011A — Evolution Integration

- Evolution chỉ đọc: Registry Event, Metrics, Trace, Audit (S011 OB011A).

## RO012 — Event Lifecycle

```text
Created → Published → Consumed → Archived
```

## RO013 — Metrics Lifecycle

```text
Collected → Aggregated → Published
```

## RO014 — Traceability

```text
Entry → State (R009) → Event → Metrics → Trace → Audit
    ↓
Execution (S008/S009) → S011
```

## RO015 — Machine-readable

```text
registry-observability.yaml
registry-events.yaml
registry-metrics.yaml
registry-traces.yaml
registry-audit.yaml
registry-correlation.yaml
registry-health.yaml
registry-dashboard.yaml
registry-observability-mapping.yaml
registry-observability.schema.json
```

## RO016 — Success Criteria

- Mọi Entry quan sát được. · Mọi Transition sinh Event (R009). · Mọi Entry có Metrics + Trace + Audit. · Dashboard/Doctor chỉ đọc machine-readable. · Không phụ thuộc nền tảng quan sát.

## Tham chiếu

- R009: `../R009/state-machine.md`
- S011: `../../SPEC-001/S011/observability.md`
- Constitution: `docs/specs/SPEC-000/`
