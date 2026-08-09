---
name: spec-011-doctor
description: >
  SPEC-011 — Doctor. Đặc tả kiểm tra sức khỏe AIOS — Scan, Diagnose, Score,
  Repair, Report. Kiểm tra Environment, Agents, Commands, Skills, Knowledge,
  Workflow, Contracts, Runtime (simulation), Capability (benchmark).
  Health score + self-repair an toàn. Phụ thuộc: SPEC-000..010.
  Roadmap 20 bước X001-X020, 4 tầng.
agent: general
---

# SPEC-011 — Doctor

> **Trạng thái**: ✅ · **Version**: 1.0.0
> **Phụ thuộc**: SPEC-000..010 (toàn bộ hệ thống AIOS)
> **Vai trò**: Doctor kiểm tra sức khỏe hệ thống — scan, diagnose, score, repair, report.

## Câu hỏi trung tâm

> **Sức khỏe của AIOS được kiểm tra, chấm điểm và tự sửa như thế nào?**

- Doctor kiểm tra toàn bộ hệ sinh thái (Environment/Agents/Commands/Skills/Knowledge/Workflow/Contracts/Runtime/Capability).
- Doctor chấm điểm Health Score (0-100).
- Doctor self-repair an toàn (chỉ sửa doc, không sửa core).
- Doctor không tự quyết định — chỉ phát hiện + đề xuất (S013).

## 4 Tầng của SPEC-011

### Tier 1 — Foundation

```text
X001 Doctor Vision          ✅
X002 Doctor Requirements
X003 Doctor Responsibilities
X004 Doctor Boundaries
X005 Doctor Architecture
X006 Doctor Components
X007 Doctor Contracts
Appendix: Canonical Models
```

### Tier 2 — Behavior

```text
X008 Doctor Data Model
X009 Doctor State Machine
X010 Doctor Execution Flow
```

### Tier 3 — Operations

```text
X011 Doctor Observability
X012 Doctor Policies
X013 Doctor Governance
X014 Doctor Registry
X015 Doctor Resources
X016 Doctor Compliance
```

### Tier 4 — Experience

```text
X017 Doctor Extensions
X018 Doctor Evolution
X019 Doctor Doctor
X020 Doctor Dashboard
```

## Quy trình (20 bước — freeze từng bước)

| # | Bước | File | Tier | Trạng thái |
|---|------|------|------|-----------|
| X001 | Doctor Vision | `X001-vision.md` | 1 | ✅ |
| X002 | Doctor Requirements | `X002/requirements.md` | 1 | ✅ |
| X003 | Doctor Responsibilities | `X003/responsibilities.md` | 1 | ✅ |
| X004 | Doctor Boundaries | `X004/boundaries.md` | 1 | ✅ |
| X005 | Doctor Architecture | `X005/architecture.md` | 1 | ✅ |
| X006 | Doctor Components | `X006/components.md` | 1 | ✅ |
| X007 | Doctor Contracts | `X007/contracts.md` | 1 | ✅ |
| — | Appendix: Canonical Models | `doctor-models/` | 1 | ✅ |
| X008 | Doctor Data Model | `X008/data-model.md` | 2 | ✅ |
| X009 | Doctor State Machine | `X009/state-machine.md` | 2 | ✅ |
| X010 | Doctor Execution Flow | `X010/execution-flow.md` | 2 | ✅ |
| X011 | Doctor Observability | `X011/observability.md` | 3 | ✅ |
| X012 | Doctor Policies | `X012/policies.md` | 3 | ✅ |
| X013 | Doctor Governance | `X013/governance.md` | 3 | ✅ |
| X014 | Doctor Registry | `X014/registry.md` | 3 | ✅ |
| X015 | Doctor Resources | `X015/resources.md` | 3 | ✅ |
| X016 | Doctor Compliance | `X016/compliance.md` | 3 | ✅ |
| X017 | Doctor Extensions | `X017/extensions.md` | 4 | ✅ |
| X018 | Doctor Evolution | `X018/evolution.md` | 4 | ✅ |
| X019 | Doctor Doctor | `X019/doctor.md` | 4 | ✅ |
| X020 | Doctor Dashboard | `X020/dashboard.md` | 4 | ✅ |

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

## Kế thừa từ SPEC-000..010

| Nguồn | Dùng cho Doctor |
|-------|------------------|
| SPEC-001 | Runtime simulation |
| SPEC-002 | Workflow checks |
| SPEC-003 | Capability benchmark |
| SPEC-004 | Agent checks |
| SPEC-005 | Registry checks |
| SPEC-006 | Context checks |
| SPEC-007 | Artifact checks |
| SPEC-008 | Event checks |
| SPEC-009 | Contract checks |
| SPEC-010 | Plugin checks |
| /doctor | CLI entrypoint |

> Doctor kiểm tra hệ thống — không định nghĩa lại bất kỳ hệ thống nào.

## Tham chiếu

- Constitution: `../SPEC-000/`
- Runtime Kernel: `../SPEC-001/`
- /doctor command: `.opencode/commands/doctor.md`
