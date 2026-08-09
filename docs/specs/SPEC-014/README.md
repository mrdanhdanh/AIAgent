---
name: spec-014-dashboard
description: >
  SPEC-014 — Dashboard. Đặc tả giao diện quan sát AIOS — Widget, Panel, View,
  Filter, Refresh, Export. Doc dữ liệu từ S011 metrics/events.
  Phụ thuộc: SPEC-000, SPEC-001, SPEC-005, SPEC-008, SPEC-011.
  Roadmap 20 bước X001-X020, 4 tầng.
agent: general
---

# SPEC-014 — Dashboard

> **Trạng thái**: ✅ · **Version**: 1.0.0
> **Phụ thuộc**: SPEC-000 (Constitution) · SPEC-001 (Runtime Kernel — S011 metrics) · SPEC-005 (Registry) · SPEC-008 (Event Bus) · SPEC-011 (Doctor)
> **Vai trò**: Dashboard hiển thị sức khỏe và hoạt động AIOS — widget, panel, view, filter, refresh, export.

## Câu hỏi trung tâm

> **Hoạt động của AIOS được quan sát trên một màn hình như thế nào?**

- Dashboard doc dữ liệu TỪ S011 metrics/events — không tạo nguồn mới (P005).
- Dashboard không chứa Business Data (S011 OB003A).
- Dashboard theo dõi sức khỏe (SPEC-011) và sự kiện (SPEC-008).
- Không có dashboard → không debug được (P005).

## 4 Tầng của SPEC-014

### Tier 1 — Foundation

```text
X001 Dashboard Vision       ✅
X002 Dashboard Requirements
X003 Dashboard Responsibilities
X004 Dashboard Boundaries
X005 Dashboard Architecture
X006 Dashboard Components
X007 Dashboard Contracts
Appendix: Canonical Models
```

### Tier 2 — Behavior

```text
X008 Dashboard Data Model
X009 Dashboard State Machine
X010 Dashboard Execution Flow
```

### Tier 3 — Operations

```text
X011 Dashboard Observability
X012 Dashboard Policies
X013 Dashboard Governance
X014 Dashboard Registry
X015 Dashboard Resources
X016 Dashboard Compliance
```

### Tier 4 — Experience

```text
X017 Dashboard Extensions
X018 Dashboard Evolution
X019 Dashboard Doctor
X020 Dashboard
```

## Quy trình (20 bước — freeze từng bước)

| # | Bước | File | Tier | Trạng thái |
|---|------|------|------|-----------|
| X001 | Dashboard Vision | `X001-vision.md` | 1 | ✅ |
| X002 | Dashboard Requirements | `X002/requirements.md` | 1 | ✅ |
| X003 | Dashboard Responsibilities | `X003/responsibilities.md` | 1 | ✅ |
| X004 | Dashboard Boundaries | `X004/boundaries.md` | 1 | ✅ |
| X005 | Dashboard Architecture | `X005/architecture.md` | 1 | ✅ |
| X006 | Dashboard Components | `X006/components.md` | 1 | ✅ |
| X007 | Dashboard Contracts | `X007/contracts.md` | 1 | ✅ |
| — | Appendix: Canonical Models | `dashboard-models/` | 1 | ✅ |
| X008 | Dashboard Data Model | `X008/data-model.md` | 2 | ✅ |
| X009 | Dashboard State Machine | `X009/state-machine.md` | 2 | ✅ |
| X010 | Dashboard Execution Flow | `X010/execution-flow.md` | 2 | ✅ |
| X011 | Dashboard Observability | `X011/observability.md` | 3 | ✅ |
| X012 | Dashboard Policies | `X012/policies.md` | 3 | ✅ |
| X013 | Dashboard Governance | `X013/governance.md` | 3 | ✅ |
| X014 | Dashboard Registry | `X014/registry.md` | 3 | ✅ |
| X015 | Dashboard Resources | `X015/resources.md` | 3 | ✅ |
| X016 | Dashboard Compliance | `X016/compliance.md` | 3 | ✅ |
| X017 | Dashboard Extensions | `X017/extensions.md` | 4 | ✅ |
| X018 | Dashboard Evolution | `X018/evolution.md` | 4 | ✅ |
| X019 | Dashboard Doctor | `X019/doctor.md` | 4 | ✅ |
| X020 | Dashboard | `X020/dashboard.md` | 4 | ✅ |

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

## Kế thừa từ SPEC-000..013

| Nguồn | Dùng cho Dashboard |
|-------|---------------------|
| S011 | Metrics/events (nguồn dữ liệu chính) |
| SPEC-008 | Event Bus (event streams) |
| SPEC-011 | Doctor (health score) |
| SPEC-005 | Registry (definition) |
| dashboard-sdk | `.opencode/aios-sdk/dashboard-sdk.md` |
| P005 | Observability first |

> Dashboard doc dữ liệu từ S011 — không định nghĩa lại observability.

## Tham chiếu

- Constitution: `../SPEC-000/`
- Runtime Kernel: `../SPEC-001/` (S011 metrics)
- Registry: `../SPEC-005/`
- Event Bus: `../SPEC-008/`
- Doctor: `../SPEC-011/`
