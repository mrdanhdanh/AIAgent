---
name: spec-001-runtime-kernel
description: >
  SPEC-001 — Runtime Kernel. Execution kernel thống nhất của AIOS.
  3 tầng: Foundation (S001-S007+Appendix) / Behavior (S008-S010) / Operations (S011-S016).
  Mỗi bước review + freeze trước khi sang bước tiếp.
agent: general
---

# SPEC-001 — Runtime Kernel

> **Trạng thái**: ✅ Frozen (S001-S020, 2026-08-08) · **Version**: 1.0.0 · **Phụ thuộc**: SPEC-000 (Constitution)
> **`implements: Runtime`** — xem compliance-matrix trong Constitution.
> **Toàn bộ SPEC-001 (20 mục): ✅ Frozen**

## Runtime tồn tại để làm gì?

**Mission**: Runtime là trung tâm điều phối của AIOS. Mọi hoạt động đều phải được Runtime khởi tạo, điều phối, giám sát và kết thúc. Không có thành phần nào được phép thực thi bên ngoài Runtime.

**Vision**: Runtime trở thành một Execution Kernel thống nhất cho toàn bộ AIOS.

## 3 Tầng của SPEC-001

### Tier 1 — Foundation ✅ Frozen

```text
Vision · Requirements · Responsibilities · Boundaries · Architecture
Components · Contracts · Canonical Models (Appendix)
```

### Tier 2 — Runtime Behavior ✅ Frozen

```text
S008 Runtime Data Model     ✅ Frozen
S009 Runtime State Machine  ✅ Frozen
S010 Runtime Execution Flow ✅ Frozen
```

### Tier 3 — Runtime Operations ✅ Frozen

```text
S011 Execution Observability ✅ Frozen
S012 Runtime Policies       ✅ Frozen
S013 Runtime Governance     ✅ Frozen
S014 Runtime Registry       ✅ Frozen
S015 Runtime Resources      ✅ Frozen
S016 Runtime Compliance     ✅ Frozen
S017 Runtime Plugins        ✅ Frozen
S018 Runtime Evolution      ✅ Frozen
S019 Runtime Doctor         ✅ Frozen
S020 Runtime Dashboard      ✅ Frozen
```

## Quy trình (20 bước — freeze từng bước)

| # | Bước | File | Tier | Trạng thái |
|---|------|------|------|-----------|
| S001 | Runtime Vision | `S001-vision.md` | 1 | ✅ Frozen |
| S002 | Runtime Requirements | `S002/requirements.md` | 1 | ✅ Frozen |
| S003 | Runtime Responsibilities | `S003/responsibilities.md` | 1 | ✅ Frozen |
| S004 | Runtime Boundaries | `S004/boundaries.md` | 1 | ✅ Frozen |
| S005 | Runtime Architecture | `S005/architecture.md` | 1 | ✅ Frozen |
| S006 | Runtime Components | `S006/components.md` | 1 | ✅ Frozen |
| S007 | Runtime Contracts | `S007/contracts.md` | 1 | ✅ Frozen |
| — | Appendix: Canonical Models | `runtime-models/` | 1 | ✅ Frozen |
| S008 | Runtime Data Model | `S008/data-model.md` | 2 | ✅ Frozen |
| S009 | Runtime State Machine | `S009/state-machine.md` | 2 | ✅ Frozen |
| S010 | Runtime Execution Flow | `S010/execution-flow.md` | 2 | ✅ Frozen |
| S011 | Execution Observability | `S011/observability.md` | 3 | ✅ Frozen |
| S012 | Runtime Policies | `S012/policies.md` | 3 | ✅ Frozen |
| S013 | Runtime Governance | `S013/governance.md` | 3 | ✅ Frozen |
| S014 | Runtime Registry | `S014/registry.md` | 3 | ✅ Frozen |
| S015 | Runtime Resources | `S015/resources.md` | 3 | ✅ Frozen |
| S016 | Runtime Compliance | `S016/compliance.md` | 3 | ✅ Frozen |
| S017 | Runtime Plugins | `S017/plugins.md` | 3 | ✅ Frozen |
| S018 | Runtime Evolution | `S018/evolution.md` | 3 | ✅ Frozen |
| S019 | Runtime Doctor | `S019/doctor.md` | 3 | ✅ Frozen |
| S020 | Runtime Dashboard | `S020/dashboard.md` | 3 | ✅ Frozen |

## Thứ tự viết (Behavior Before Data)

```text
Foundation ✅ → Canonical Models ✅ → S008 Data Model ✅
    ↓
S009 State Machine    ✅ (Behavior trước)
    ↓
S010 Execution Flow   ✅
    ↓
    S011 Observability ✅ (Execution — Event/Metrics/Trace/Audit/Health)
    ↓
S012 Policies ✅ Frozen (Define) → S013 Governance ✅ Frozen (Enforce) → S014 Registry ✅ Frozen (Resolve)
    ↓
S015 Resources ✅ Frozen (Allocate) → S016 Compliance ✅ Frozen (Verify)
    ↓
S017 Plugins ✅ Frozen (Extend) → S018 Evolution ✅ Frozen (Learn) → S019 Doctor ✅ Frozen (Check) → S020 Dashboard ✅ Frozen (View)
```

## Quy tắc

- Mỗi bước phải được **review + freeze** trước khi sang bước tiếp.
- **Behavior Before Data** — không định nghĩa Data Model trước khi biết State Machine/Flow.
- 100% SPEC hoàn thành trước khi viết code.
- SPEC chỉ tham chiếu Constitution (SPEC-000) + Canonical Models, không định nghĩa lại.

## Tham chiếu

- Constitution: `../SPEC-000/`
- Compliance cho Runtime: `../SPEC-000/compliance-matrix.yaml`
- Roadmap: `../README.md`
