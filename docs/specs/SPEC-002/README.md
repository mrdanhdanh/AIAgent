---
name: spec-002-workflow-engine
description: >
  SPEC-002 — Workflow Engine. Đặc tả Workflow Engine của AIOS — định nghĩa,
  chạy và điều phối Workflow trên Runtime Kernel (SPEC-001).
  Phụ thuộc: SPEC-000 (Constitution), SPEC-001 (Runtime Kernel).
  Roadmap 20 bước W001-W020, 4 tầng.
agent: general
---

# SPEC-002 — Workflow Engine

> **Trạng thái**: In progress · **Version**: 1.0.0
> **Phụ thuộc**: SPEC-000 (Constitution) · SPEC-001 (Runtime Kernel)
> **Vai trò**: Workflow Engine định nghĩa, validate, chạy và điều phối Workflow trên nền Runtime Kernel — mọi Execution của Workflow là Execution của SPEC-001.

## Câu hỏi trung tâm

> **Workflow được định nghĩa, chạy và điều phối như thế nào?**

- Workflow là Execution dạng đặc biệt trên Runtime (SPEC-001).
- Workflow dùng State Machine (S009) và Execution Flow (S010) của Runtime.
- Workflow không định nghĩa lại Runtime — chỉ khai báo luồng nghiệp vụ.

## 4 Tầng của SPEC-002

### Tier 1 — Foundation

```text
W001 Workflow Vision          🚧
W002 Workflow Requirements
W003 Workflow Responsibilities
W004 Workflow Boundaries
W005 Workflow Architecture
W006 Workflow Components
W007 Workflow Contracts
Appendix: Canonical Models
```

### Tier 2 — Behavior

```text
W008 Workflow Data Model
W009 Workflow State Machine
W010 Workflow Execution Flow
```

### Tier 3 — Operations

```text
W011 Workflow Observability
W012 Workflow Policies
W013 Workflow Governance
W014 Workflow Registry
W015 Workflow Resources
W016 Workflow Compliance
```

### Tier 4 — Experience

```text
W017 Workflow Extensions
W018 Workflow Evolution
W019 Workflow Doctor
W020 Workflow Dashboard
```

## Quy trình (20 bước — freeze từng bước)

| # | Bước | File | Tier | Trạng thái |
|---|------|------|------|-----------|
| W001 | Workflow Vision | `W001-vision.md` | 1 | 🚧 In progress |
| W002 | Workflow Requirements | `W002/requirements.md` | 1 | ⬜ |
| W003 | Workflow Responsibilities | `W003/responsibilities.md` | 1 | ⬜ |
| W004 | Workflow Boundaries | `W004/boundaries.md` | 1 | ⬜ |
| W005 | Workflow Architecture | `W005/architecture.md` | 1 | ⬜ |
| W006 | Workflow Components | `W006/components.md` | 1 | ⬜ |
| W007 | Workflow Contracts | `W007/contracts.md` | 1 | ⬜ |
| — | Appendix: Canonical Models | `workflow-models/` | 1 | ⬜ |
| W008 | Workflow Data Model | `W008/data-model.md` | 2 | ⬜ |
| W009 | Workflow State Machine | `W009/state-machine.md` | 2 | ⬜ |
| W010 | Workflow Execution Flow | `W010/execution-flow.md` | 2 | ⬜ |
| W011 | Workflow Observability | `W011/observability.md` | 3 | ⬜ |
| W012 | Workflow Policies | `W012/policies.md` | 3 | ⬜ |
| W013 | Workflow Governance | `W013/governance.md` | 3 | ⬜ |
| W014 | Workflow Registry | `W014/registry.md` | 3 | ⬜ |
| W015 | Workflow Resources | `W015/resources.md` | 3 | ⬜ |
| W016 | Workflow Compliance | `W016/compliance.md` | 3 | ⬜ |
| W017 | Workflow Extensions | `W017/extensions.md` | 4 | ⬜ |
| W018 | Workflow Evolution | `W018/evolution.md` | 4 | ⬜ |
| W019 | Workflow Doctor | `W019/doctor.md` | 4 | ⬜ |
| W020 | Workflow Dashboard | `W020/dashboard.md` | 4 | ⬜ |

## Thứ tự viết (Behavior Before Data)

```text
Foundation (W001-W007 + Appendix) → W009 State Machine → W010 Flow → W008 Data Model
    ↓
W011 Observability → W012 Policies → W013 Governance
    ↓
W014 Registry → W015 Resources → W016 Compliance
    ↓
W017 Extensions → W018 Evolution → W019 Doctor → W020 Dashboard
```

## Kế thừa từ SPEC-001

| SPEC-001 | Dùng cho Workflow |
|----------|-------------------|
| S009 State Machine | Workflow State Machine (W009) tham chiếu ST-001..014 |
| S010 Execution Flow | Workflow Execution là Execution của Runtime |
| S011 Observability | Workflow Events/Metrics/Trace/Audit — cùng model |
| S012 Policies | Workflow dùng policies của Runtime (POL-*) |
| S013 Governance | Workflow chịu Governance của Runtime |
| S014 Registry | Workflow đăng ký trong Registry (S014 workflow-registry) |
| S016 Compliance | Doctor verify Workflow bằng cùng rules |

> Workflow Engine không định nghĩa lại Runtime — chỉ khai báo luồng nghiệp vụ trên Runtime.

## Tham chiếu

- Constitution: `../SPEC-000/`
- Runtime Kernel: `../SPEC-001/`
- Workflow Engine hiện hữu: `.opencode/workflow-engine/`
- Workflow definitions: `.opencode/workflow/definitions/`
