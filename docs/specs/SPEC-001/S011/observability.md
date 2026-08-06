---
name: spec-001-s011-observability
description: >
  SPEC-001 S011 — Runtime Observability. Trả lời: Runtime quan sát và ghi nhận
  việc thực thi như thế nào? Event/Metrics/Trace/Audit — nền tảng cho
  Dashboard, Doctor, Evolution, Simulation. 16 sections OB001-OB016.
agent: general
---

# S011 — Runtime Observability

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: Draft
> **Vị trí**: Nền tảng cho Dashboard, Doctor, Evolution, Simulation — nhiều phần S010 đã tham chiếu Event/Metrics/Trace nhưng chưa được đặc tả đầy đủ.

## Mục tiêu

> **Runtime quan sát và ghi nhận việc thực thi như thế nào?**

Không mô tả implementation — chỉ mô tả các model quan sát.

## OB001 — Observability Philosophy

- Mọi hoạt động đều sinh dữ liệu quan sát (P014).
- Không đo được thì không kiểm soát được.
- Observability phục vụ Dashboard, Doctor, Evolution, Simulation.

## OB002 — Observability Principles

- **Event**: state change (P005).
- **Metrics**: hiệu năng.
- **Trace**: luồng thực thi.
- **Audit**: quyết định/quyền thay đổi (P008).
- **Correlation ID**: xuyên suốt.
- **Lineage**: nguồn gốc.

## OB003 — Event Model

```yaml
event:
  fields: [id, type, correlation_id, execution_id, state_from, state_to, timestamp, lineage, immutable]
```

- Event immutable (P005).
- Event chỉ append.
- Mọi transition sinh Event (S009).
- Event có correlation_id.

## OB004 — Metrics Model

```yaml
metrics:
  fields: [id, name, value, unit, correlation_id, execution_id, timestamp, tags]
```

- Metrics chỉ append.
- Không chứa Business Data (S008 D006).
- Metrics phát **sau** Trace (S010 EF010).

## OB005 — Trace Model

```yaml
trace:
  fields: [trace_id, span_id, parent_span_id, correlation_id, execution_id, operation, started_at, ended_at, duration, status]
```

- Trace chỉ append.
- Trace luôn **trước** Metrics (S010 EF010).
- Span cha-con qua parent_span_id.

## OB006 — Audit Trail

```yaml
audit:
  fields: [id, actor, action, target, correlation_id, timestamp, rationale, artifact_ref]
```

- Ghi mọi quyết định/quyền thay đổi (P008).
- Audit immutable (append-only).
- Retention: 5 năm (governance).

## OB007 — Correlation ID

- Correlation ID: định danh xuyên suốt một Execution.
- Sinh khi Execution Created.
- Gắn vào: Event, Metrics, Trace, Audit, Artifact.
- Một Execution một Correlation ID.
- Không đổi trong vòng đời (P009).

## OB008 — Lineage

```yaml
lineage:
  fields: [execution_id, root_id, parent_id, lineage_type, created_at]
lineage_types: [root, parent, child, replay, simulation, fork]
```

- Lineage immutable (append-only).
- Mỗi Execution có lineage_ref.
- Tham chiếu S010 EF023.

## OB009 — Log Principles

- Structured log (machine-readable).
- Có correlation_id.
- Không log secret/key (P016).
- Levels: DEBUG, INFO, WARN, ERROR, FATAL.
- Không log Business Data (S008 D006).

## OB010 — Dashboard Metrics

```yaml
metrics:
  execution_count: 0
  event_count: 0
  artifact_count: 0
  failure_rate: 0
  retry_rate: 0
  timeout_rate: 0
  cancellation_rate: 0
  state_distribution: {}
  outcome_distribution: {}
  average_duration: 0
```

## OB011 — Doctor Integration

Doctor kiểm tra:

- **Event Coverage** — mọi state change có Event.
- **Trace Completeness** — mọi operation có Trace.
- **Audit Completeness** — mọi quyết định có Audit.
- **Correlation Coverage** — mọi dữ liệu có correlation_id.
- **Lineage Integrity** — lineage đầy đủ, không vòng.

## OB012 — Alerting Hooks

- `on_failure` — Failure Event → alert.
- `on_timeout` — TimedOut → alert.
- `on_aborted` — Aborted → alert.
- `on_approval_required` — Waiting → notify.
- `on_sla_violation` — duration > threshold → alert.

**Rules:** Hook qua Contract (P002); Hook không chứa Business Logic.

## OB013 — Machine-readable

```text
observability.yaml
event-model.yaml
metrics-model.yaml
trace-model.yaml
audit-trail.yaml
correlation-id.yaml
lineage.yaml
log-principles.yaml
dashboard-metrics.yaml
doctor-integration.yaml
alerting-hooks.yaml
observability.schema.json
```

## OB014 — Traceability

```text
Observability → Event (S009/S010) → Metrics → Trace → Audit
              → Correlation ID → Lineage (S010 EF023) → Dashboard → Doctor
```

## OB015 — Success Criteria

Hoàn thành khi:

- 6 model quan sát được định nghĩa (Event/Metrics/Trace/Audit/Correlation ID/Lineage).
- Mọi dữ liệu quan sát có correlation_id.
- Doctor kiểm tra 5 checks từ machine-readable.
- Dashboard đọc metrics trực tiếp.
- Không chứa Business Data.

## OB016 — Compliance

| Principle | Observability |
|-----------|---------------|
| P005 Event Driven | Event Model |
| P008 Observable → P014 Observability First | Metrics/Trace/Audit |
| P009 Single Source of Truth | Correlation ID |

## Tham chiếu

- `observability.yaml` — nguồn dữ liệu chuẩn.
- `event-model.yaml` · `metrics-model.yaml` · `trace-model.yaml`
- `audit-trail.yaml` · `correlation-id.yaml` · `lineage.yaml`
- `log-principles.yaml` · `dashboard-metrics.yaml`
- `doctor-integration.yaml` · `alerting-hooks.yaml`
- `observability.schema.json`
- S009: `../S009/state-machine.yaml`
- S010: `../S010/execution-flow.md`
- S008: `../S008/data-model.md`
- Constitution: `docs/specs/SPEC-000/`
