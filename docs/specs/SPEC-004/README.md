---
name: spec-004-agent-system
description: >
  SPEC-004 — Agent System. Đặc tả khai báo, đăng ký và điều phối Agents trên
  Runtime Kernel. Phụ thuộc: SPEC-000 (Constitution), SPEC-001 (Runtime
  Kernel), SPEC-002 (Workflow Engine), SPEC-003 (Capability System).
  Roadmap 20 bước A001-A020, 4 tầng.
agent: general
---

# SPEC-004 — Agent System

> **Trạng thái**: In progress · **Version**: 1.0.0
> **Phụ thuộc**: SPEC-000 (Constitution) · SPEC-001 (Runtime Kernel) · SPEC-002 (Workflow Engine) · SPEC-003 (Capability System)
> **Vai trò**: Agent System khai báo, đăng ký và điều phối Agents — Agent expose capability qua SPEC-003, chạy qua Runtime (SPEC-001), tham gia Workflow (SPEC-002).

## Câu hỏi trung tâm

> **Agent được khai báo, đăng ký và điều phối như thế nào?**

- Agent là thực thể thực thi — expose capability (SPEC-003), chạy qua Runtime (SPEC-001).
- Agent đăng ký trong Registry (S014 agent-registry).
- Workflow (SPEC-002) điều phối Agent qua capability đã resolve.
- Agent System không định nghĩa lại Runtime/Capability/Workflow.

## 4 Tầng của SPEC-004

### Tier 1 — Foundation

```text
A001 Agent Vision          🚧
A002 Agent Requirements
A003 Agent Responsibilities
A004 Agent Boundaries
A005 Agent Architecture
A006 Agent Components
A007 Agent Contracts
Appendix: Canonical Models
```

### Tier 2 — Behavior

```text
A008 Agent Data Model
A009 Agent State Machine
A010 Agent Execution Flow
```

### Tier 3 — Operations

```text
A011 Agent Observability
A012 Agent Policies
A013 Agent Governance
A014 Agent Registry
A015 Agent Resources
A016 Agent Compliance
```

### Tier 4 — Experience

```text
A017 Agent Extensions
A018 Agent Evolution
A019 Agent Doctor
A020 Agent Dashboard
```

## Quy trình (20 bước — freeze từng bước)

| # | Bước | File | Tier | Trạng thái |
|---|------|------|------|-----------|
| A001 | Agent Vision | `A001-vision.md` | 1 | 🚧 In progress |
| A002 | Agent Requirements | `A002/requirements.md` | 1 | ⬜ |
| A003 | Agent Responsibilities | `A003/responsibilities.md` | 1 | ⬜ |
| A004 | Agent Boundaries | `A004/boundaries.md` | 1 | ⬜ |
| A005 | Agent Architecture | `A005/architecture.md` | 1 | ⬜ |
| A006 | Agent Components | `A006/components.md` | 1 | ⬜ |
| A007 | Agent Contracts | `A007/contracts.md` | 1 | ⬜ |
| — | Appendix: Canonical Models | `agent-models/` | 1 | ⬜ |
| A008 | Agent Data Model | `A008/data-model.md` | 2 | ⬜ |
| A009 | Agent State Machine | `A009/state-machine.md` | 2 | ⬜ |
| A010 | Agent Execution Flow | `A010/execution-flow.md` | 2 | ⬜ |
| A011 | Agent Observability | `A011/observability.md` | 3 | ⬜ |
| A012 | Agent Policies | `A012/policies.md` | 3 | ⬜ |
| A013 | Agent Governance | `A013/governance.md` | 3 | ⬜ |
| A014 | Agent Registry | `A014/registry.md` | 3 | ⬜ |
| A015 | Agent Resources | `A015/resources.md` | 3 | ⬜ |
| A016 | Agent Compliance | `A016/compliance.md` | 3 | ⬜ |
| A017 | Agent Extensions | `A017/extensions.md` | 4 | ⬜ |
| A018 | Agent Evolution | `A018/evolution.md` | 4 | ⬜ |
| A019 | Agent Doctor | `A019/doctor.md` | 4 | ⬜ |
| A020 | Agent Dashboard | `A020/dashboard.md` | 4 | ⬜ |

## Thứ tự viết (Behavior Before Data)

```text
Foundation (A001-A007 + Appendix) → A009 State Machine → A010 Flow → A008 Data Model
    ↓
A011 Observability → A012 Policies → A013 Governance
    ↓
A014 Registry → A015 Resources → A016 Compliance
    ↓
A017 Extensions → A018 Evolution → A019 Doctor → A020 Dashboard
```

## Kế thừa từ SPEC-001/002/003

| Nguồn | Dùng cho Agent |
|-------|----------------|
| S014 | agent-registry (đăng ký) |
| SPEC-003 | Agent expose capability |
| SPEC-002 | Workflow điều phối Agent |
| S012 | Policy cho Agent (POL-SEC-001...) |
| S011 | Agent observability |

> Agent System không định nghĩa lại Runtime/Capability/Workflow — chỉ khai báo và điều phối Agents.

## Tham chiếu

- Constitution: `../SPEC-000/`
- Runtime Kernel: `../SPEC-001/`
- Workflow Engine: `../SPEC-002/`
- Capability System: `../SPEC-003/`
