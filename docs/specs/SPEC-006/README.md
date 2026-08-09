---
name: spec-006-context-engine
description: >
  SPEC-006 — Context Engine. Đặc tả quản lý Execution Context — Allocate,
  Populate, Distribute, Mutate, Merge, Collect, Release (S010 EF008).
  Phụ thuộc: SPEC-000, SPEC-001 (S010 EF008, S008 ENT Context), SPEC-005.
  Roadmap 20 bước X001-X020, 4 tầng.
agent: general
---

# SPEC-006 — Context Engine

> **Trạng thái**: ✅ Hoàn thành (20/20) · **Version**: 1.0.0
> **Phụ thuộc**: SPEC-000 (Constitution) · SPEC-001 (Runtime Kernel — S010 EF008 Context Flow) · SPEC-005 (Registry)
> **Vai trò**: Context Engine quản lý Execution Context — tạo, cấp, chuyển, cô lập, thu hồi — theo EF008.

## Câu hỏi trung tâm

> **Execution Context được tạo, cấp, chuyển và thu hồi như thế nào?**

- Context là dữ liệu transient của Execution (S008 ENT Context).
- Context luôn isolated (P009/P006).
- Context Flow theo S010 EF008: Allocate → Populate → Distribute → Mutate → Merge → Collect → Release.
- Context không chứa Business Data (S011 OB003A).

## 4 Tầng của SPEC-006

### Tier 1 — Foundation

```text
X001 Context Vision          ✅
X002 Context Requirements    ✅
X003 Context Responsibilities✅
X004 Context Boundaries      ✅
X005 Context Architecture    ✅
X006 Context Components      ✅
X007 Context Contracts       ✅
Appendix: Canonical Models   ✅
```

### Tier 2 — Behavior

```text
X008 Context Data Model      ✅
X009 Context State Machine   ✅
X010 Context Execution Flow  ✅
```

### Tier 3 — Operations

```text
X011 Context Observability
X012 Context Policies
X013 Context Governance
X014 Context Registry
X015 Context Resources
X016 Context Compliance
```

### Tier 4 — Experience

```text
X017 Context Extensions
X018 Context Evolution
X019 Context Doctor
X020 Context Dashboard
```

## Quy trình (20 bước — freeze từng bước)

| # | Bước | File | Tier | Trạng thái |
|---|------|------|------|-----------|
| X001 | Context Vision | `X001-vision.md` | 1 | ✅ Frozen |
| X002 | Context Requirements | `X002/requirements.md` | 1 | ✅ |
| X003 | Context Responsibilities | `X003/responsibilities.md` | 1 | ✅ |
| X004 | Context Boundaries | `X004/boundaries.md` | 1 | ✅ |
| X005 | Context Architecture | `X005/architecture.md` | 1 | ✅ |
| X006 | Context Components | `X006/components.md` | 1 | ✅ |
| X007 | Context Contracts | `X007/contracts.md` | 1 | ✅ |
| — | Appendix: Canonical Models | `context-models/` | 1 | ✅ |
| X008 | Context Data Model | `X008/data-model.md` | 2 | ✅ |
| X009 | Context State Machine | `X009/state-machine.md` | 2 | ✅ |
| X010 | Context Execution Flow | `X010/execution-flow.md` | 2 | ✅ |
| X011 | Context Observability | `X011/observability.md` | 3 | ✅ |
| X012 | Context Policies | `X012/policies.md` | 3 | ✅ |
| X013 | Context Governance | `X013/governance.md` | 3 | ✅ |
| X014 | Context Registry | `X014/registry.md` | 3 | ✅ |
| X015 | Context Resources | `X015/resources.md` | 3 | ✅ |
| X016 | Context Compliance | `X016/compliance.md` | 3 | ✅ |
| X017 | Context Extensions | `X017/extensions.md` | 4 | ✅ |
| X018 | Context Evolution | `X018/evolution.md` | 4 | ✅ |
| X019 | Context Doctor | `X019/doctor.md` | 4 | ✅ |
| X020 | Context Dashboard | `X020/dashboard.md` | 4 | ✅ |

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

## Kế thừa từ SPEC-001/005

| Nguồn | Dùng cho Context |
|-------|-------------------|
| S010 EF008 | Context Flow (Allocate → Release) |
| S008 | ENT Context (transient) |
| S011 OB003A | Context là observability boundary |
| S012 POL-ISOL-001 | Context isolation |
| SPEC-005 | Context Registry |

> Context Engine thực thi EF008 — không định nghĩa lại Context Flow.

## Tham chiếu

- Constitution: `../SPEC-000/`
- Runtime Kernel: `../SPEC-001/` (S010 EF008)
- Registry: `../SPEC-005/`
