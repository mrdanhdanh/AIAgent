---
name: spec-012-simulation-engine
description: >
  SPEC-012 — Simulation Engine. Đặc tả mô phỏng workflow — Define Scenario,
  Configure, Run, Observe, Compare, Report. 6 scenario types (Bug Fix,
  New Feature, Migration, Review, Testing, Refactoring) qua workflow (SPEC-002).
  Phụ thuộc: SPEC-000, SPEC-001, SPEC-002, SPEC-005, SPEC-011.
  Roadmap 20 bước X001-X020, 4 tầng.
agent: general
---

# SPEC-012 — Simulation Engine

> **Trạng thái**: ✅ · **Version**: 1.0.0
> **Phụ thuộc**: SPEC-000 (Constitution) · SPEC-001 (Runtime Kernel) · SPEC-002 (Workflow) · SPEC-005 (Registry) · SPEC-011 (Doctor)
> **Vai trò**: Simulation Engine mô phỏng workflow để kiểm tra hành vi trước khi chạy thật — theo RULE-007 (replay/simulate).

## Câu hỏi trung tâm

> **Workflow được mô phỏng để kiểm tra hành vi như thế nào?**

- Simulation mô phỏng workflow trước khi chạy thật (RULE-007).
- 6 scenario types: Bug Fix, New Feature, Migration, Review, Testing, Refactoring.
- Simulation không thay đổi hệ thống thật — isolated.
- Simulation dùng Event log để replay (RULE-007).
- Simulation không chứa Business Data (S011 OB003A).

## 4 Tầng của SPEC-012

### Tier 1 — Foundation

```text
X001 Simulation Vision       ✅
X002 Simulation Requirements
X003 Simulation Responsibilities
X004 Simulation Boundaries
X005 Simulation Architecture
X006 Simulation Components
X007 Simulation Contracts
Appendix: Canonical Models
```

### Tier 2 — Behavior

```text
X008 Simulation Data Model
X009 Simulation State Machine
X010 Simulation Execution Flow
```

### Tier 3 — Operations

```text
X011 Simulation Observability
X012 Simulation Policies
X013 Simulation Governance
X014 Simulation Registry
X015 Simulation Resources
X016 Simulation Compliance
```

### Tier 4 — Experience

```text
X017 Simulation Extensions
X018 Simulation Evolution
X019 Simulation Doctor
X020 Simulation Dashboard
```

## Quy trình (20 bước — freeze từng bước)

| # | Bước | File | Tier | Trạng thái |
|---|------|------|------|-----------|
| X001 | Simulation Vision | `X001-vision.md` | 1 | ✅ |
| X002 | Simulation Requirements | `X002/requirements.md` | 1 | ✅ |
| X003 | Simulation Responsibilities | `X003/responsibilities.md` | 1 | ✅ |
| X004 | Simulation Boundaries | `X004/boundaries.md` | 1 | ✅ |
| X005 | Simulation Architecture | `X005/architecture.md` | 1 | ✅ |
| X006 | Simulation Components | `X006/components.md` | 1 | ✅ |
| X007 | Simulation Contracts | `X007/contracts.md` | 1 | ✅ |
| — | Appendix: Canonical Models | `simulation-models/` | 1 | ✅ |
| X008 | Simulation Data Model | `X008/data-model.md` | 2 | ✅ |
| X009 | Simulation State Machine | `X009/state-machine.md` | 2 | ✅ |
| X010 | Simulation Execution Flow | `X010/execution-flow.md` | 2 | ✅ |
| X011 | Simulation Observability | `X011/observability.md` | 3 | ✅ |
| X012 | Simulation Policies | `X012/policies.md` | 3 | ✅ |
| X013 | Simulation Governance | `X013/governance.md` | 3 | ✅ |
| X014 | Simulation Registry | `X014/registry.md` | 3 | ✅ |
| X015 | Simulation Resources | `X015/resources.md` | 3 | ✅ |
| X016 | Simulation Compliance | `X016/compliance.md` | 3 | ✅ |
| X017 | Simulation Extensions | `X017/extensions.md` | 4 | ✅ |
| X018 | Simulation Evolution | `X018/evolution.md` | 4 | ✅ |
| X019 | Simulation Doctor | `X019/doctor.md` | 4 | ✅ |
| X020 | Simulation Dashboard | `X020/dashboard.md` | 4 | ✅ |

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

## Kế thừa từ SPEC-001/002/005/011

| Nguồn | Dùng cho Simulation |
|-------|---------------------|
| SPEC-002 | Workflow để mô phỏng |
| S010 | Execution Flow (mô phỏng) |
| S011 | Event log để replay |
| RULE-007 | Replay/simulate/audit |
| SPEC-011 | Doctor simulation check |
| SPEC-005 | Registry |

> Simulation Engine mô phỏng workflow — không định nghĩa lại workflow.

## Tham chiếu

- Constitution: `../SPEC-000/`
- Runtime Kernel: `../SPEC-001/`
- Workflow: `../SPEC-002/`
- Registry: `../SPEC-005/`
- Doctor: `../SPEC-011/`
