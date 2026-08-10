---
name: spec-010-plugin-framework
description: >
  SPEC-010 — Plugin Framework. Đặc tả quản lý Plugin — Install, Validate,
  Enable, Disable, Uninstall (TERM-015, S014 Plugin Registry). Plugin là
  extension, không sửa Core, manifest permission.
  Phụ thuộc: SPEC-000, SPEC-001, SPEC-003, SPEC-005, SPEC-009.
  Roadmap 20 bước X001-X020, 4 tầng.
agent: general
---

# SPEC-010 — Plugin Framework

> **Trạng thái**: ✅ · **Version**: 1.0.0
> **Phụ thuộc**: SPEC-000 (Constitution) · SPEC-001 (Runtime Kernel — S014 Plugin Registry) · SPEC-003 (Capability) · SPEC-005 (Registry) · SPEC-009 (Contract)
> **Vai trò**: Plugin Framework quản lý vòng đời Plugin — install, validate, enable, disable, uninstall — theo TERM-015.

## Câu hỏi trung tâm

> **Plugin được install, validate, enable và uninstall như thế nào?**

- Plugin là extension (TERM-015).
- Plugin không được sửa Core (TERM-015).
- Plugin khai báo permission trong manifest (TERM-015).
- Plugin export capability/agent/skill/widget.
- Plugin không truy cập ngoài permission (TERM-015).

## 4 Tầng của SPEC-010

### Tier 1 — Foundation

```text
X001 Plugin Vision          ✅
X002 Plugin Requirements
X003 Plugin Responsibilities
X004 Plugin Boundaries
X005 Plugin Architecture
X006 Plugin Components
X007 Plugin Contracts
Appendix: Canonical Models
```

### Tier 2 — Behavior

```text
X008 Plugin Data Model
X009 Plugin State Machine
X010 Plugin Execution Flow
```

### Tier 3 — Operations

```text
X011 Plugin Observability
X012 Plugin Policies
X013 Plugin Governance
X014 Plugin Registry
X015 Plugin Resources
X016 Plugin Compliance
```

### Tier 4 — Experience

```text
X017 Plugin Extensions
X018 Plugin Evolution
X019 Plugin Doctor
X020 Plugin Dashboard
```

## Quy trình (20 bước — freeze từng bước)

| # | Bước | File | Tier | Trạng thái |
|---|------|------|------|-----------|
| X001 | Plugin Vision | `X001-vision.md` | 1 | ✅ |
| X002 | Plugin Requirements | `X002/requirements.md` | 1 | ✅ |
| X003 | Plugin Responsibilities | `X003/responsibilities.md` | 1 | ✅ |
| X004 | Plugin Boundaries | `X004/boundaries.md` | 1 | ✅ |
| X005 | Plugin Architecture | `X005/architecture.md` | 1 | ✅ |
| X006 | Plugin Components | `X006/components.md` | 1 | ✅ |
| X007 | Plugin Contracts | `X007/contracts.md` | 1 | ✅ |
| — | Appendix: Canonical Models | `plugin-models/` | 1 | ✅ |
| X008 | Plugin Data Model | `X008/data-model.md` | 2 | ✅ |
| X009 | Plugin State Machine | `X009/state-machine.md` | 2 | ✅ |
| X010 | Plugin Execution Flow | `X010/execution-flow.md` | 2 | ✅ |
| X011 | Plugin Observability | `X011/observability.md` | 3 | ✅ |
| X012 | Plugin Policies | `X012/policies.md` | 3 | ✅ |
| X013 | Plugin Governance | `X013/governance.md` | 3 | ✅ |
| X014 | Plugin Registry | `X014/registry.md` | 3 | ✅ |
| X015 | Plugin Resources | `X015/resources.md` | 3 | ✅ |
| X016 | Plugin Compliance | `X016/compliance.md` | 3 | ✅ |
| X017 | Plugin Extensions | `X017/extensions.md` | 4 | ✅ |
| X018 | Plugin Evolution | `X018/evolution.md` | 4 | ✅ |
| X019 | Plugin Doctor | `X019/doctor.md` | 4 | ✅ |
| X020 | Plugin Dashboard | `X020/dashboard.md` | 4 | ✅ |

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

## Kế thừa từ SPEC-001/003/005/009

| Nguồn | Dùng cho Plugin |
|-------|------------------|
| S014 | Plugin Registry (SPEC-001) |
| TERM-015 | Plugin definition |
| SPEC-003 | Exported Capability |
| SPEC-009 | Plugin Contract |
| SPEC-005 | Registry |
| RULE-005 | Plugin không mutable |

> Plugin Framework thực thi TERM-015 — không định nghĩa lại Plugin.

## Tham chiếu

- Constitution: `../SPEC-000/`
- Runtime Kernel: `../SPEC-001/` (S014 Plugin Registry)
- Capability: `../SPEC-003/`
- Registry: `../SPEC-005/`
- Contract System: `../SPEC-009/`
