---
name: spec-004-a007-contracts
description: >
  SPEC-004 A007 — Agent Contracts. Trả lời: Agent System giao tiếp qua những
  hợp đồng nào? 7 ACT — Contract Logic, không class/interface/API.
  Mirror C007 (SPEC-003).
agent: general
---

# A007 — Agent Contracts

> **SPEC-004**: Agent System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Agent System giao tiếp qua những hợp đồng nào?**

Contract Logic — không class/interface/API/method/DTO/protocol.

## Contracts (7)

### ACT-001 — Agent Contract

| Field | Giá trị |
|-------|---------|
| category | Execution · direction: Request/Response · pattern: Sync |
| owner | Agent Engine (ACP-001) · layer: Command · domain: Execution |
| purpose | Quản lý vòng đời Agent |
| inputs | Agent Request, Agent Definition |
| outputs | Agent, Lifecycle Event |
| invariants | **Agent đăng ký trong S014**; **Capability mapping qua SPEC-003**; **Chạy qua Runtime SPEC-001** |
| capability | agent-management |

### ACT-002 — Declaration Contract

| Field | Giá trị |
|-------|---------|
| category | Data · direction: Read |
| owner | Declaration Manager (ACP-002) · layer: Declaration · domain: Definition |
| purpose | Quản lý Agent Definition + Version |
| invariants | Definition immutable khi Published; **không chứa code** |
| capability | agent-declaration |

### ACT-003 — Validation Contract

| Field | Giá trị |
|-------|---------|
| category | Execution · pattern: Sync |
| owner | Validation Engine (ACP-003) · layer: Validation |
| purpose | Validate + Compatibility Check (S013 GV010) |
| invariants | Validate trước khi đăng ký; không đăng ký trực tiếp |
| capability | agent-validation |

### ACT-004 — Registration Contract

| Field | Giá trị |
|-------|---------|
| category | Data · direction: Read/Write |
| owner | Registration Manager (ACP-004) · layer: Registration · domain: Mapping |
| purpose | Đăng ký S014 + Capability Mapping (SPEC-003) |
| outputs | Registry Entry, Capability Mapping |
| invariants | **Không hardcode capability mapping (AB007)**; Mapping qua SPEC-003 |
| capability | agent-registration |

### ACT-005 — Orchestration Contract

| Field | Giá trị |
|-------|---------|
| category | Execution · pattern: Sync/Async |
| owner | Orchestration Provider (ACP-005) · layer: Orchestration |
| purpose | Điều phối qua Workflow (SPEC-002) + delegate Runtime (SPEC-001) |
| outputs | Workflow Execution Request |
| invariants | **Không tự chạy Agent (AB004)**; Delegate Runtime SPEC-001 |
| dependencies | Workflow Engine (SPEC-002), Runtime (SPEC-001) |
| capability | agent-orchestration |

### ACT-006 — Registry Contract

| Field | Giá trị |
|-------|---------|
| category | Registry · direction: Read |
| owner | Discovery Provider (ACP-006) |
| purpose | Truy cập Registry (S014) và khám phá |
| invariants | Registry không phải Database |
| capability | agent-discovery |

### ACT-007 — Event Contract

| Field | Giá trị |
|-------|---------|
| category | Observability · direction: Publish · pattern: Event |
| owner | Agent Event Dispatcher (ACP-008) · layer: Publication |
| purpose | Publish Event/Metrics/Trace/Audit (S011) |
| invariants | Không chứa Business Data; Event immutable |
| capability | agent-observability |

## Contract Quality

- **Deterministic** — cùng input → cùng output.
- **Versioned** — semver.
- **Immutable** — published không đổi.
- **Observable** — mọi gọi có Event (S011).

## Anti-patterns (cấm)

- Contract trả Business Data.
- **Contract hardcode capability mapping.**
- Contract định nghĩa lại Policy (S012).
- Contract phụ thuộc Agent/Plugin cụ thể.

## Communication Matrix (11 edges)

`ACP-001→ACP-002/003/004/005/008`, `ACP-003→ACP-002`, `ACP-004→**Capability System**`, `ACP-005→**Workflow**`, `ACP-005→**Runtime**`, `ACP-006→Registry`, `ACP-008→Event Store` — mọi edge qua Contract.

## Machine-readable

```text
contracts.yaml
contract-model.yaml
contract-categories.yaml
contract-types.yaml
contract-compatibility.yaml
contract-mapping.yaml
contract-quality.yaml
contract-anti-patterns.yaml
communication-matrix.yaml
contract-registry.yaml
contracts.schema.json
```

## Tham chiếu

- A005: `../A005/architecture.md`
- A006: `../A006/components.md`
- C007: `../../SPEC-003/C007/contracts.yaml` (mẫu cấu trúc)
- S011: `../../SPEC-001/S011/observability.md`
- S012: `../../SPEC-001/S012/policies.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
