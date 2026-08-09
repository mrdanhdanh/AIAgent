---
name: spec-007-artifact-manager
description: >
  SPEC-007 — Artifact Manager. Đặc tả quản lý Artifact — Create, Validate,
  Publish, Version, Index, Consume, Archive (S008 ENT-008). Artifact immutable
  (P010), checksum, không overwrite. Phụ thuộc: SPEC-000, SPEC-001, SPEC-005.
  Roadmap 20 bước X001-X020, 4 tầng.
agent: general
---

# SPEC-007 — Artifact Manager

> **Trạng thái**: ✅ Hoàn thành (20/20) · **Version**: 1.0.0
> **Phụ thuộc**: SPEC-000 (Constitution) · SPEC-001 (Runtime Kernel — S008 ENT-008 Artifact) · SPEC-005 (Registry)
> **Vai trò**: Artifact Manager quản lý vòng đời Artifact — tạo, publish, version, index, consume, archive — theo P010.

## Câu hỏi trung tâm

> **Artifact được tạo, publish, version và archive như thế nào?**

- Artifact là output của Task/Agent (TERM-008).
- Artifact luôn immutable (P010).
- Artifact có version + checksum, không overwrite (RULE-005).
- Artifact lưu trong Artifact Store, metadata trong Registry (SPEC-005).
- Artifact không chứa Business Data (S011 OB003A).

## 4 Tầng của SPEC-007

### Tier 1 — Foundation

```text
X001 Artifact Vision        ✅
X002 Artifact Requirements  ✅
X003 Artifact Responsibilities✅
X004 Artifact Boundaries    ✅
X005 Artifact Architecture  ✅
X006 Artifact Components    ✅
X007 Artifact Contracts     ✅
Appendix: Canonical Models  ✅
```

### Tier 2 — Behavior

```text
X008 Artifact Data Model    ✅
X009 Artifact State Machine ✅
X010 Artifact Execution Flow✅
```

### Tier 3 — Operations

```text
X011 Artifact Observability ✅
X012 Artifact Policies      ✅
X013 Artifact Governance    ✅
```

### Tier 4 — Experience

```text
X014 Artifact Registry      ✅
X015 Artifact Resources     ✅
X016 Artifact Compliance    ✅
X017 Artifact Extensions    ✅
X018 Artifact Evolution     ✅
X019 Artifact Doctor        ✅
X020 Artifact Dashboard     ✅
```

## Quy trình (20 bước — freeze từng bước)

| # | Bước | File | Tier | Trạng thái |
|---|------|------|------|-----------|
| X001 | Artifact Vision | `X001-vision.md` | 1 | ✅ |
| X002 | Artifact Requirements | `X002/requirements.md` | 1 | ✅ |
| X003 | Artifact Responsibilities | `X003/responsibilities.md` | 1 | ✅ |
| X004 | Artifact Boundaries | `X004/boundaries.md` | 1 | ✅ |
| X005 | Artifact Architecture | `X005/architecture.md` | 1 | ✅ |
| X006 | Artifact Components | `X006/components.md` | 1 | ✅ |
| X007 | Artifact Contracts | `X007/contracts.md` | 1 | ✅ |
| — | Appendix: Canonical Models | `artifact-models/` | 1 | ✅ |
| X008 | Artifact Data Model | `X008/data-model.md` | 2 | ✅ |
| X009 | Artifact State Machine | `X009/state-machine.md` | 2 | ✅ |
| X010 | Artifact Execution Flow | `X010/execution-flow.md` | 2 | ✅ |
| X011 | Artifact Observability | `X011/observability.md` | 3 | ✅ |
| X012 | Artifact Policies | `X012/policies.md` | 3 | ✅ |
| X013 | Artifact Governance | `X013/governance.md` | 3 | ✅ |
| X014 | Artifact Registry | `X014/registry.md` | 3 | ✅ |
| X015 | Artifact Resources | `X015/resources.md` | 3 | ✅ |
| X016 | Artifact Compliance | `X016/compliance.md` | 3 | ✅ |
| X017 | Artifact Extensions | `X017/extensions.md` | 4 | ✅ |
| X018 | Artifact Evolution | `X018/evolution.md` | 4 | ✅ |
| X019 | Artifact Doctor | `X019/doctor.md` | 4 | ✅ |
| X020 | Artifact Dashboard | `X020/dashboard.md` | 4 | ✅ |

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

| Nguồn | Dùng cho Artifact |
|-------|-------------------|
| S008 ENT-008 | Artifact (persistent metadata, immutable) |
| S010 | Execution Flow (Artifact sinh ra trong luồng) |
| S011 | Artifact events + metrics (RULE-014) |
| S012 | Artifact policies |
| S014 | Registry (SPEC-005) |
| P010 | Immutable Artifact (checksum, không overwrite) |
| TERM-008 | Artifact definition |

> Artifact Manager thực thi ENT-008 — không định nghĩa lại Artifact.

## Tham chiếu

- Constitution: `../SPEC-000/`
- Runtime Kernel: `../SPEC-001/` (S008 ENT-008)
- Registry: `../SPEC-005/`
