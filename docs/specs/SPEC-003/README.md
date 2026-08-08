---
name: spec-003-capability-system
description: >
  SPEC-003 — Capability System. Đặc tả khai báo, đăng ký và phân giải năng
  lực (capability) của Agents/Plugins trên Runtime Kernel.
  Phụ thuộc: SPEC-000 (Constitution), SPEC-001 (Runtime Kernel), SPEC-002
  (Workflow Engine). Roadmap 20 bước C001-C020, 4 tầng.
agent: general
---

# SPEC-003 — Capability System

> **Trạng thái**: ✅ COMPLETE (20/20 sections Draft) · **Version**: 1.0.0
> **Phụ thuộc**: SPEC-000 (Constitution) · SPEC-001 (Runtime Kernel) · SPEC-002 (Workflow Engine)
> **Vai trò**: Capability System khai báo, đăng ký và phân giải năng lực — mọi Agent/Plugin expose capability qua đây, Runtime resolve qua Registry.

## Câu hỏi trung tâm

> **Năng lực (capability) được khai báo, đăng ký và phân giải như thế nào?**

- Capability là hợp đồng năng lực: Agent/Plugin khai báo — Runtime resolve (S010 EF007).
- Capability đăng ký trong Registry (S014 capability-registry).
- Workflow (SPEC-002) dùng capability làm step.
- Capability không định nghĩa lại Runtime.

## 4 Tầng của SPEC-003

### Tier 1 — Foundation ✅

```text
C001 Capability Vision          ✅ Draft
C002 Capability Requirements    ✅ Draft
C003 Capability Responsibilities ✅ Draft
C004 Capability Boundaries      ✅ Draft
C005 Capability Architecture    ✅ Draft
C006 Capability Components      ✅ Draft
C007 Capability Contracts       ✅ Draft
Appendix: Canonical Models      ✅ Draft
```

### Tier 2 — Behavior ✅

```text
C008 Capability Data Model      ✅ Draft
C009 Capability State Machine   ✅ Draft
C010 Capability Execution Flow  ✅ Draft
```

### Tier 3 — Operations ✅

```text
C011 Capability Observability   ✅ Draft
C012 Capability Policies        ✅ Draft
C013 Capability Governance       ✅ Draft
C014 Capability Registry        ✅ Draft
C015 Capability Resources       ✅ Draft
C016 Capability Compliance      ✅ Draft
```

### Tier 4 — Experience ✅

```text
C017 Capability Extensions      ✅ Draft
C018 Capability Evolution       ✅ Draft
C019 Capability Doctor          ✅ Draft
C020 Capability Dashboard       ✅ Draft
```

## Quy trình (20 bước — freeze từng bước)

| # | Bước | File | Tier | Trạng thái |
|---|------|------|------|-----------|
| C001 | Capability Vision | `C001-vision.md` | 1 | ✅ Draft |
| C002 | Capability Requirements | `C002/requirements.md` | 1 | ✅ Draft |
| C003 | Capability Responsibilities | `C003/responsibilities.md` | 1 | ✅ Draft |
| C004 | Capability Boundaries | `C004/boundaries.md` | 1 | ✅ Draft |
| C005 | Capability Architecture | `C005/architecture.md` | 1 | ✅ Draft |
| C006 | Capability Components | `C006/components.md` | 1 | ✅ Draft |
| C007 | Capability Contracts | `C007/contracts.md` | 1 | ✅ Draft |
| — | Appendix: Canonical Models | `capability-models/` | 1 | ✅ Draft |
| C008 | Capability Data Model | `C008/data-model.md` | 2 | ✅ Draft |
| C009 | Capability State Machine | `C009/state-machine.md` | 2 | ✅ Draft |
| C010 | Capability Execution Flow | `C010/execution-flow.md` | 2 | ✅ Draft |
| C011 | Capability Observability | `C011/observability.md` | 3 | ✅ Draft |
| C012 | Capability Policies | `C012/policies.md` | 3 | ✅ Draft |
| C013 | Capability Governance | `C013/governance.md` | 3 | ✅ Draft |
| C014 | Capability Registry | `C014/registry.md` | 3 | ✅ Draft |
| C015 | Capability Resources | `C015/resources.md` | 3 | ✅ Draft |
| C016 | Capability Compliance | `C016/compliance.md` | 3 | ✅ Draft |
| C017 | Capability Extensions | `C017/extensions.md` | 4 | ✅ Draft |
| C018 | Capability Evolution | `C018/evolution.md` | 4 | ✅ Draft |
| C019 | Capability Doctor | `C019/doctor.md` | 4 | ✅ Draft |
| C020 | Capability Dashboard | `C020/dashboard.md` | 4 | ✅ Draft |

## Thứ tự viết (Behavior Before Data)

```text
Foundation (C001-C007 + Appendix) → C009 State Machine → C010 Flow → C008 Data Model
    ↓
C011 Observability → C012 Policies → C013 Governance
    ↓
C014 Registry → C015 Resources → C016 Compliance
    ↓
C017 Extensions → C018 Evolution → C019 Doctor → C020 Dashboard
```

## Kế thừa từ SPEC-001/002

| Nguồn | Dùng cho Capability |
|-------|---------------------|
| S010 EF007 | Capability Resolution (làm chuẩn) |
| S014 | capability-registry (đăng ký) |
| S006 CMP | Capability Resolver |
| W010 | Workflow step = capability |
| S012 | Policy cho capability (POL-SEC-001...) |

> Capability System không định nghĩa lại Runtime — chỉ khai báo và phân giải năng lực.

## Tham chiếu

- Constitution: `../SPEC-000/`
- Runtime Kernel: `../SPEC-001/`
- Workflow Engine: `../SPEC-002/`
