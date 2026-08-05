---
name: spec-001-runtime-kernel
description: >
  SPEC-001 — Runtime Kernel. Execution kernel thống nhất của AIOS.
  3 tầng: Foundation (S001-S007+Appendix) / Behavior (S008-S012) / Quality (S013-S015).
  Mỗi bước review + freeze trước khi sang bước tiếp.
agent: general
---

# SPEC-001 — Runtime Kernel

> **Trạng thái**: Draft · **Version**: 1.0.0 · **Phụ thuộc**: SPEC-000 (Constitution)
> **`implements: Runtime`** — xem compliance-matrix trong Constitution.
> **Foundation (S001-S007 + Appendix): ✅ Frozen (2026-08-04)**

## Runtime tồn tại để làm gì?

**Mission**: Runtime là trung tâm điều phối của AIOS. Mọi hoạt động đều phải được Runtime khởi tạo, điều phối, giám sát và kết thúc. Không có thành phần nào được phép thực thi bên ngoài Runtime.

**Vision**: Runtime trở thành một Execution Kernel thống nhất cho toàn bộ AIOS.

## 3 Tầng của SPEC-001

### Tier 1 — Foundation ✅ Frozen

```text
Vision · Requirements · Responsibilities · Boundaries · Architecture
Components · Contracts · Canonical Models (Appendix)
```

### Tier 2 — Runtime Behavior (bắt đầu)

```text
S008 Runtime Data Model
S009 Runtime State Machine
S010 Runtime Execution Flow
S011 Runtime Event Model
S012 Runtime Error Model
```

### Tier 3 — Runtime Quality

```text
S013 Observability
S014 Security
S015 Compliance & Verification
```

## Quy trình (15 bước — freeze từng bước)

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
| S008 | Runtime Data Model | `S008/data-model.md` | 2 | 🚧 In progress |
| S009 | Runtime State Machine | `S009/state-machine.md` | 2 | 🚧 In progress |
| S010 | Runtime Execution Flow | `S010-execution-flow.md` | 2 | ⬜ |
| S011 | Runtime Event Model | `S011-event-model.md` | 2 | ⬜ |
| S012 | Runtime Error Model | `S012-error-model.md` | 2 | ⬜ |
| S013 | Runtime Observability | `S013-observability.md` | 3 | ⬜ |
| S014 | Runtime Security | `S014-security.md` | 3 | ⬜ |
| S015 | Runtime Compliance & Verification | `S015-compliance.md` | 3 | ⬜ |

## Thứ tự viết (Behavior Before Data)

```text
Foundation ✅ → Canonical Models ✅
    ↓
S009 State Machine    (Behavior trước)
    ↓
S010 Execution Flow
    ↓
S008 Data Model       (Data là hệ quả của State + Flow)
    ↓
S011 Event Model
    ↓
S012 Error Model
    ↓
S013 Observability → S014 Security → S015 Compliance
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
