---
name: spec-015-sdk
description: >
  SPEC-015 — SDK. Đặc tả lớp truy cập chính thức vào AIOS — Client, API
  Binding, Typed Access, Auth, Versioning. Core không truy cập trực tiếp
  — qua SDK (aios-sdk.schema.yaml v13, 11 components).
  Phụ thuộc: SPEC-000..014. Roadmap 20 bước X001-X020, 4 tầng.
agent: general
---

# SPEC-015 — SDK

> **Trạng thái**: ✅ · **Version**: 1.0.0
> **Phụ thuộc**: SPEC-000..014 (toàn bộ hệ thống AIOS)
> **Vai trò**: SDK là lớp truy cập chính thức vào AIOS — client, API binding, typed access, auth, versioning.

## Câu hỏi trung tâm

> **Bên ngoài truy cập AIOS qua SDK như thế nào?**

- SDK là lớp truy cập chính thức — Core không bị truy cập trực tiếp.
- SDK cung cấp client cho 11 components (agent, plugin, workflow, context, artifact, event, registry, doctor, simulation, evolution, dashboard).
- SDK có auth + versioning (semver).
- SDK không chứa Business Data (S011 OB003A).

## 4 Tầng của SPEC-015

### Tier 1 — Foundation

```text
X001 SDK Vision             ✅
X002 SDK Requirements
X003 SDK Responsibilities
X004 SDK Boundaries
X005 SDK Architecture
X006 SDK Components
X007 SDK Contracts
Appendix: Canonical Models
```

### Tier 2 — Behavior

```text
X008 SDK Data Model
X009 SDK State Machine
X010 SDK Execution Flow
```

### Tier 3 — Operations

```text
X011 SDK Observability
X012 SDK Policies
X013 SDK Governance
X014 SDK Registry
X015 SDK Resources
X016 SDK Compliance
```

### Tier 4 — Experience

```text
X017 SDK Extensions
X018 SDK Evolution
X019 SDK Doctor
X020 SDK Dashboard
```

## Quy trình (20 bước — freeze từng bước)

| # | Bước | File | Tier | Trạng thái |
|---|------|------|------|-----------|
| X001 | SDK Vision | `X001-vision.md` | 1 | ✅ |
| X002 | SDK Requirements | `X002/requirements.md` | 1 | ✅ |
| X003 | SDK Responsibilities | `X003/responsibilities.md` | 1 | ✅ |
| X004 | SDK Boundaries | `X004/boundaries.md` | 1 | ✅ |
| X005 | SDK Architecture | `X005/architecture.md` | 1 | ✅ |
| X006 | SDK Components | `X006/components.md` | 1 | ✅ |
| X007 | SDK Contracts | `X007/contracts.md` | 1 | ✅ |
| — | Appendix: Canonical Models | `sdk-models/` | 1 | ✅ |
| X008 | SDK Data Model | `X008/data-model.md` | 2 | ✅ |
| X009 | SDK State Machine | `X009/state-machine.md` | 2 | ✅ |
| X010 | SDK Execution Flow | `X010/execution-flow.md` | 2 | ✅ |
| X011 | SDK Observability | `X011/observability.md` | 3 | ✅ |
| X012 | SDK Policies | `X012/policies.md` | 3 | ✅ |
| X013 | SDK Governance | `X013/governance.md` | 3 | ✅ |
| X014 | SDK Registry | `X014/registry.md` | 3 | ✅ |
| X015 | SDK Resources | `X015/resources.md` | 3 | ✅ |
| X016 | SDK Compliance | `X016/compliance.md` | 3 | ✅ |
| X017 | SDK Extensions | `X017/extensions.md` | 4 | ✅ |
| X018 | SDK Evolution | `X018/evolution.md` | 4 | ✅ |
| X019 | SDK Doctor | `X019/doctor.md` | 4 | ✅ |
| X020 | SDK Dashboard | `X020/dashboard.md` | 4 | ✅ |

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

## Kế thừa từ SPEC-000..014

| Nguồn | Dùng cho SDK |
|-------|---------------|
| aios-sdk | `.opencode/aios-sdk/` (schema v13, 11 components) |
| SPEC-001..014 | Components để binding |
| SPEC-005 | Registry (SDK registration) |
| SPEC-009 | Contract (API binding) |
| P006 | Isolation |

> SDK truy cập AIOS qua Contract — không truy cập Core trực tiếp.

## Tham chiếu

- Constitution: `../SPEC-000/`
- Runtime Kernel: `../SPEC-001/`
- Registry: `../SPEC-005/`
- aios-sdk: `.opencode/aios-sdk/`
