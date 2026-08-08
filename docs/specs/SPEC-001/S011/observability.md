---
name: spec-001-s011-observability
description: >
  SPEC-001 S011 — Execution Observability. Trả lời: Runtime được quan sát,
  theo dõi và truy vết như thế nào? Event/Metrics/Trace/Audit/Health —
  nền tảng cho Dashboard, Doctor, Evolution, Simulation.
  18 sections OB001-OB016 (kèm OB003A, OB011A).
agent: general
---

# S011 — Execution Observability

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: Draft
> **Vị trí**: Nền tảng cho Dashboard, Doctor, Evolution, Simulation — nhiều phần S010 đã tham chiếu Event/Metrics/Trace nhưng chưa được đặc tả đầy đủ.
> **Vai trò**: Nguồn chuẩn duy nhất (Single Source of Truth) cho toàn bộ Event, Metrics, Trace, Audit và Health — S015, S016, Dashboard, Doctor, Evolution, Simulation chỉ cần tham chiếu, không định nghĩa lại.

## Mục tiêu

> **Runtime được quan sát, theo dõi và truy vết như thế nào?**

Không mô tả:

- implementation
- logging framework
- monitoring tool
- telemetry protocol
- code

Chỉ mô tả **Observability Model**.

## OB001 — Observability Philosophy

- Runtime luôn Observable.
- Không có Execution "ẩn".
- Mọi hoạt động đều truy vết được.
- Quan sát không làm thay đổi Execution.

## OB002 — Observability Principles

- Event Driven
- Traceable
- Immutable
- Correlation First
- Metadata First
- Append Only

## OB003 — Observability Domains

- Events
- Metrics
- Trace
- Audit
- Health

## OB003A — Observability Boundary

Runtime quan sát:

- Execution
- State
- Context
- Event
- Artifact Metadata
- Metrics
- Trace

Runtime không quan sát trực tiếp:

- Business Data
- User Data
- Knowledge Content
- Agent Internal State
- Plugin Internal State

> Đồng bộ với S004 (Boundary) và S008 (Data Model).

## OB004 — Event Model

Chuẩn hóa:

- Event Type
- Event Category
- Event Severity
- Event Level
- Event Scope
- Event Source
- Event Timestamp
- Event Lineage

**Event Level:**

- Debug
- Info
- Warning
- Error
- Critical

**Event Scope:**

- Runtime
- Execution
- Workflow
- Capability
- Resource
- Policy

> Dashboard và Alerting dùng trực tiếp Event Level + Event Scope.

Tham chiếu:

- S007 Event Contract
- S008 Event Entity
- S009 State Events

## OB005 — Metrics Model

Phân cấp:

```text
Runtime Metrics
├── Execution Metrics
├── Resource Metrics
├── Performance Metrics
├── Reliability Metrics
├── Policy Metrics
└── Capability Metrics
```

> S015 Resource Metrics tham chiếu trực tiếp phân cấp này.

## OB006 — Trace Model

Trace bao gồm:

- Execution
- Parent
- Child
- Correlation
- Causation
- Lineage

> **Correlation ≠ Causation** — Correlation liên kết dữ liệu, Causation chỉ nguyên nhân.

Không phụ thuộc implementation.

## OB007 — Audit Model

Audit ghi nhận:

- ai
- khi nào
- cái gì
- kết quả

Audit:

- Append Only
- Immutable
- Ordered
- Time Consistent

> Doctor verify được 4 properties.

Không ghi Business Data.

## OB008 — Correlation Model

Chuẩn hóa:

- Execution ID
- Correlation ID
- Lineage ID
- Parent ID

## OB009 — Health Model

Runtime công bố:

- Healthy
- Degraded
- Unhealthy

Health được tính từ:

- Execution
- Resource
- Event
- Metrics
- Policy

> Không nói công thức.

Không tự sửa lỗi.

## OB010 — Dashboard Model

Dashboard chỉ đọc:

- Events
- Metrics
- Trace
- Audit
- Health

Không đọc implementation.

## OB011 — Doctor Integration

Doctor xác minh:

- Missing Event
- Missing Metrics
- Broken Trace
- Broken Lineage
- Invalid Audit

## OB011A — Evolution Integration

Evolution chỉ đọc:

- Event
- Metrics
- Trace
- Audit

Evolution không đọc implementation.

> SPEC Evolution (sau này) không cần định nghĩa lại.

## OB012 — Event Lifecycle

```text
Created
    ↓
Published
    ↓
Consumed
    ↓
Archived
```

## OB013 — Metrics Lifecycle

```text
Collected
    ↓
Aggregated
    ↓
Published
```

## OB014 — Traceability

```text
Execution
    ↓
State
    ↓
Event
    ↓
Metrics
    ↓
Trace
    ↓
Audit
```

## OB015 — Machine-readable

```text
observability.yaml
events.yaml
metrics.yaml
traces.yaml
audit.yaml
health.yaml
dashboard.yaml
correlation.yaml
lineage.yaml
observability-mapping.yaml
observability.schema.json
```

> `correlation.yaml`, `lineage.yaml`, `observability-mapping.yaml` được Dashboard, Doctor và Evolution dùng chung.

## OB016 — Success Criteria

- Mọi Execution đều quan sát được.
- Mọi Transition đều sinh Event.
- Mọi Execution đều có Metrics.
- Mọi Execution đều có Trace.
- Mọi Execution đều Audit được.
- Dashboard và Doctor chỉ cần đọc machine-readable để dựng toàn bộ trạng thái Runtime.
- Không phụ thuộc bất kỳ nền tảng quan sát cụ thể nào.
- Mọi Event đều truy vết được tới Execution.
- Mọi Metrics đều gắn với Execution hoặc Runtime.
- Mọi Trace đều có Correlation và Lineage.
- Audit luôn append-only.
- Health được xác định từ Observability Data.

## Tham chiếu

- `observability.yaml` — nguồn dữ liệu chuẩn
- `events.yaml` · `metrics.yaml` · `traces.yaml`
- `audit.yaml` · `health.yaml` · `dashboard.yaml`
- `correlation.yaml` · `lineage.yaml` · `observability-mapping.yaml`
- `observability.schema.json`
- S007: `../S007/contracts.md`
- S008: `../S008/data-model.md`
- S009: `../S009/state-machine.yaml`
- S010: `../S010/execution-flow.md`
- Constitution: `docs/specs/SPEC-000/`
