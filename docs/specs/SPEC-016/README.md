---
name: spec-016-cli-commands
description: >
  SPEC-016 — CLI & Commands. Đặc tả entry point AIOS — Command, Flag, Alias,
  Help, Completion, Shell Integration. Command chỉ khởi động Runtime
  — không làm việc (TERM-007).
  Phụ thuộc: SPEC-000, SPEC-001, SPEC-002, SPEC-005, SPEC-015.
  Roadmap 20 bước X001-X020, 4 tầng.
agent: general
---

# SPEC-016 — CLI & Commands

> **Trạng thái**: ✅ · **Version**: 1.0.0
> **Phụ thuộc**: SPEC-000 (Constitution) · SPEC-001 (Runtime Kernel) · SPEC-002 (Workflow) · SPEC-005 (Registry) · SPEC-015 (SDK)
> **Vai trò**: CLI & Commands là entry point AIOS — command, flag, alias, help, completion, shell integration.

## Câu hỏi trung tâm

> **Người dùng khởi động AIOS qua CLI như thế nào?**

- Command là entry point — chỉ khởi động Runtime, không làm việc (TERM-007).
- Command trigger workflow (SPEC-002) — không xử lý nghiệp vụ.
- CLI cung cấp flag, alias, help, completion.
- CLI truy cập AIOS qua SDK (SPEC-015).

## 4 Tầng của SPEC-016

### Tier 1 — Foundation

```text
X001 CLI Vision             ✅
X002 CLI Requirements
X003 CLI Responsibilities
X004 CLI Boundaries
X005 CLI Architecture
X006 CLI Components
X007 CLI Contracts
Appendix: Canonical Models
```

### Tier 2 — Behavior

```text
X008 CLI Data Model
X009 CLI State Machine
X010 CLI Execution Flow
```

### Tier 3 — Operations

```text
X011 CLI Observability
X012 CLI Policies
X013 CLI Governance
X014 CLI Registry
X015 CLI Resources
X016 CLI Compliance
```

### Tier 4 — Experience

```text
X017 CLI Extensions
X018 CLI Evolution
X019 CLI Doctor
X020 CLI Dashboard
```

## Quy trình (20 bước — freeze từng bước)

| # | Bước | File | Tier | Trạng thái |
|---|------|------|------|-----------|
| X001 | CLI Vision | `X001-vision.md` | 1 | ✅ |
| X002 | CLI Requirements | `X002/requirements.md` | 1 | ✅ |
| X003 | CLI Responsibilities | `X003/responsibilities.md` | 1 | ✅ |
| X004 | CLI Boundaries | `X004/boundaries.md` | 1 | ✅ |
| X005 | CLI Architecture | `X005/architecture.md` | 1 | ✅ |
| X006 | CLI Components | `X006/components.md` | 1 | ✅ |
| X007 | CLI Contracts | `X007/contracts.md` | 1 | ✅ |
| — | Appendix: Canonical Models | `cli-models/` | 1 | ✅ |
| X008 | CLI Data Model | `X008/data-model.md` | 2 | ✅ |
| X009 | CLI State Machine | `X009/state-machine.md` | 2 | ✅ |
| X010 | CLI Execution Flow | `X010/execution-flow.md` | 2 | ✅ |
| X011 | CLI Observability | `X011/observability.md` | 3 | ✅ |
| X012 | CLI Policies | `X012/policies.md` | 3 | ✅ |
| X013 | CLI Governance | `X013/governance.md` | 3 | ✅ |
| X014 | CLI Registry | `X014/registry.md` | 3 | ✅ |
| X015 | CLI Resources | `X015/resources.md` | 3 | ✅ |
| X016 | CLI Compliance | `X016/compliance.md` | 3 | ✅ |
| X017 | CLI Extensions | `X017/extensions.md` | 4 | ✅ |
| X018 | CLI Evolution | `X018/evolution.md` | 4 | ✅ |
| X019 | CLI Doctor | `X019/doctor.md` | 4 | ✅ |
| X020 | CLI Dashboard | `X020/dashboard.md` | 4 | ✅ |

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

## Kế thừa từ SPEC-000..015

| Nguồn | Dùng cho CLI |
|-------|---------------|
| TERM-007 | Command = entry point (không làm việc) |
| SPEC-002 | Workflow trigger |
| SPEC-015 | SDK truy cập |
| SPEC-005 | Registry (command registration) |
| .opencode/commands | 58 commands hiện có |

> Command chỉ khởi động Runtime — không làm việc (TERM-007).

## Tham chiếu

- Constitution: `../SPEC-000/`
- Runtime Kernel: `../SPEC-001/`
- Registry: `../SPEC-005/`
- SDK: `../SPEC-015/`
