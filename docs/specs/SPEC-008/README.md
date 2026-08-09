---
name: spec-008-event-bus
description: >
  SPEC-008 — Event Bus. Đặc tả quản lý Event — Publish, Route, Deliver,
  Subscribe, Replay, Archive (S011 Event Model, RULE-007). Event immutable
  (P010/P005), lineage. Phụ thuộc: SPEC-000, SPEC-001, SPEC-005, SPEC-007.
  Roadmap 20 bước X001-X020, 4 tầng.
agent: general
---

# SPEC-008 — Event Bus

> **Trạng thái**: ✅ Hoàn thành (20/20) · **Version**: 1.0.0
> **Phụ thuộc**: SPEC-000 (Constitution) · SPEC-001 (Runtime Kernel — S011 Event Model) · SPEC-005 (Registry) · SPEC-007 (Artifact)
> **Vai trò**: Event Bus quản lý vòng đời Event — publish, route, deliver, subscribe, replay, archive — theo RULE-007.

## Câu hỏi trung tâm

> **Event được publish, route, deliver và replay như thế nào?**

- Event là thông báo bất biến về state change (TERM-012).
- Event luôn immutable (P010/RULE-007).
- Event có lineage (event chain).
- Mọi state change phải phát Event (RULE-007).
- Event Bus là backbone cho replay/simulate/audit (RULE-007).

## 4 Tầng của SPEC-008

### Tier 1 — Foundation

```text
X001 Event Vision           ✅
X002 Event Requirements     ✅
X003 Event Responsibilities ✅
X004 Event Boundaries       ✅
X005 Event Architecture     ✅
X006 Event Components       ✅
X007 Event Contracts        ✅
Appendix: Canonical Models  ✅
```

### Tier 2 — Behavior

```text
X008 Event Data Model       ✅
X009 Event State Machine    ✅
X010 Event Execution Flow   ✅
```

### Tier 3 — Operations

```text
X011 Event Observability    ✅
X012 Event Policies         ✅
X013 Event Governance       ✅
```

### Tier 4 — Experience

```text
X014 Event Registry         ✅
X015 Event Resources        ✅
X016 Event Compliance       ✅
X017 Event Extensions       ✅
X018 Event Evolution        ✅
X019 Event Doctor           ✅
X020 Event Dashboard        ✅
```

## Quy trình (20 bước — freeze từng bước)

| # | Bước | File | Tier | Trạng thái |
|---|------|------|------|-----------|
| X001 | Event Vision | `X001-vision.md` | 1 | ✅ |
| X002 | Event Requirements | `X002/requirements.md` | 1 | ✅ |
| X003 | Event Responsibilities | `X003/responsibilities.md` | 1 | ✅ |
| X004 | Event Boundaries | `X004/boundaries.md` | 1 | ✅ |
| X005 | Event Architecture | `X005/architecture.md` | 1 | ✅ |
| X006 | Event Components | `X006/components.md` | 1 | ✅ |
| X007 | Event Contracts | `X007/contracts.md` | 1 | ✅ |
| — | Appendix: Canonical Models | `event-models/` | 1 | ✅ |
| X008 | Event Data Model | `X008/data-model.md` | 2 | ✅ |
| X009 | Event State Machine | `X009/state-machine.md` | 2 | ✅ |
| X010 | Event Execution Flow | `X010/execution-flow.md` | 2 | ✅ |
| X011 | Event Observability | `X011/observability.md` | 3 | ✅ |
| X012 | Event Policies | `X012/policies.md` | 3 | ✅ |
| X013 | Event Governance | `X013/governance.md` | 3 | ✅ |
| X014 | Event Registry | `X014/registry.md` | 3 | ✅ |
| X015 | Event Resources | `X015/resources.md` | 3 | ✅ |
| X016 | Event Compliance | `X016/compliance.md` | 3 | ✅ |
| X017 | Event Extensions | `X017/extensions.md` | 4 | ✅ |
| X018 | Event Evolution | `X018/evolution.md` | 4 | ✅ |
| X019 | Event Doctor | `X019/doctor.md` | 4 | ✅ |
| X020 | Event Dashboard | `X020/dashboard.md` | 4 | ✅ |

## Thứ tự viết (Behavior Before Data)

```text
Foundation (X001-X007 + Appendix) → X009 State Machine → X010 Flow → X008 Data Model
    ↓
X011 Observability → X012 Policies → X013 Governance
    ↓
X014 Registry → X015 Resources → X016 Compliance
    ↓
X017 Extensions → X018 Evolution → X019 Doctor → X020 Dashboard
```

## Kế thừa từ SPEC-001/005/007

| Nguồn | Dùng cho Event |
|-------|-----------------|
| S011 | Event Model (fields, types, severity) |
| S007 | Event Contract (S011 tham chiếu) |
| S008 | Event Entity |
| S009 | State Events (mọi transition sinh Event) |
| RULE-007 | Event immutable + lineage |
| TERM-012 | Event definition (Event Bus) |
| SPEC-007 | Artifact events |
| SPEC-005 | Event Registry |

> Event Bus thực thi S011 Event Model — không định nghĩa lại Event.

## Tham chiếu

- Constitution: `../SPEC-000/`
- Runtime Kernel: `../SPEC-001/` (S011 Event Model)
- Registry: `../SPEC-005/`
- Artifact Manager: `../SPEC-007/`
