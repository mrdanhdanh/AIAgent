---
name: spec-005-registry
description: >
  SPEC-005 — Registry. Đặc tả Registry System — SSOT cho Runtime Metadata.
  Phụ thuộc: SPEC-000 (Constitution), SPEC-001 (Runtime Kernel, S014
  Registry Model). Roadmap 20 bước R001-R020, 4 tầng.
agent: general
---

# SPEC-005 — Registry

> **Trạng thái**: ✅ COMPLETE (20/20 sections Draft) · **Version**: 1.0.0
> **Phụ thuộc**: SPEC-000 (Constitution) · SPEC-001 (Runtime Kernel — S014 Registry Model)
> **Vai trò**: Registry System thực thi S014 — SSOT cho metadata AIOS: entries versioned, resolution service, multi-domain, lưu trữ-agnostic.

## Câu hỏi trung tâm

> **Registry System quản lý, lưu trữ và phân giải metadata như thế nào?**

- Registry thực thi S014 (Runtime Registry Model) — không định nghĩa lại model.
- Entry versioned, immutable khi Published.
- Resolution service qua Compatibility + Governance.
- Multi-domain: capability/workflow/contract/policy/plugin/agent.
- Storage-agnostic — không ràng buộc database.

## 4 Tầng của SPEC-005

### Tier 1 — Foundation ✅

```text
R001 Registry Vision          ✅ Draft
R002 Registry Requirements
R003 Registry Responsibilities
R004 Registry Boundaries
R005 Registry Architecture
R006 Registry Components
R007 Registry Contracts
Appendix: Canonical Models
```

### Tier 2 — Behavior ✅

```text
R008 Registry Data Model
R009 Registry State Machine
R010 Registry Execution Flow
```

### Tier 3 — Operations ✅

```text
R011 Registry Observability
R012 Registry Policies
R013 Registry Governance
R014 Registry-of-Registries
R015 Registry Resources
R016 Registry Compliance
```

### Tier 4 — Experience ✅

```text
R017 Registry Extensions
R018 Registry Evolution
R019 Registry Doctor
R020 Registry Dashboard
```

## Quy trình (20 bước — freeze từng bước)

| # | Bước | File | Tier | Trạng thái |
|---|------|------|------|-----------|
| R001 | Registry Vision | `R001-vision.md` | 1 | ✅ Draft |
| R002 | Registry Requirements | `R002/requirements.md` | 1 | ✅ Draft |
| R003 | Registry Responsibilities | `R003/responsibilities.md` | 1 | ✅ Draft |
| R004 | Registry Boundaries | `R004/boundaries.md` | 1 | ✅ Draft |
| R005 | Registry Architecture | `R005/architecture.md` | 1 | ✅ Draft |
| R006 | Registry Components | `R006/components.md` | 1 | ✅ Draft |
| R007 | Registry Contracts | `R007/contracts.md` | 1 | ✅ Draft |
| — | Appendix: Canonical Models | `registry-models/` | 1 | ✅ Draft |
| R008 | Registry Data Model | `R008/data-model.md` | 2 | ✅ Draft |
| R009 | Registry State Machine | `R009/state-machine.md` | 2 | ✅ Draft |
| R010 | Registry Execution Flow | `R010/execution-flow.md` | 2 | ✅ Draft |
| R011 | Registry Observability | `R011/observability.md` | 3 | ✅ Draft |
| R012 | Registry Policies | `R012/policies.md` | 3 | ✅ Draft |
| R013 | Registry Governance | `R013/governance.md` | 3 | ✅ Draft |
| R014 | Registry-of-Registries | `R014/registry-of-registries.md` | 3 | ✅ Draft |
| R015 | Registry Resources | `R015/resources.md` | 3 | ✅ Draft |
| R016 | Registry Compliance | `R016/compliance.md` | 3 | ✅ Draft |
| R017 | Registry Extensions | `R017/extensions.md` | 4 | ✅ Draft |
| R018 | Registry Evolution | `R018/evolution.md` | 4 | ✅ Draft |
| R019 | Registry Doctor | `R019/doctor.md` | 4 | ✅ Draft |
| R020 | Registry Dashboard | `R020/dashboard.md` | 4 | ✅ Draft |

## Thứ tự viết (Behavior Before Data)

```text
Foundation (R001-R007 + Appendix) → R009 State Machine → R010 Flow → R008 Data Model
    ↓
R011 Observability → R012 Policies → R013 Governance
    ↓
R014 Registry-of-Registries → R015 Resources → R016 Compliance
    ↓
R017 Extensions → R018 Evolution → R019 Doctor → R020 Dashboard
```

## Kế thừa từ SPEC-001

| Nguồn | Dùng cho Registry |
|-------|-------------------|
| S014 | Registry Model (entry, resolution, lifecycle, constraints) |
| S011 | Registry observability |
| S012 | Policy cho registry (POL-*) |
| S013 | Registry governance |
| S016 | Registry compliance |

> Registry System thực thi S014 — không định nghĩa lại Registry Model.

## Tham chiếu

- Constitution: `../SPEC-000/`
- Runtime Kernel: `../SPEC-001/` (S014 Registry Model)
