---
name: spec-002-w007-contracts
description: >
  SPEC-002 W007 — Workflow Contracts. Trả lời: Workflow Engine giao tiếp qua
  những hợp đồng nào? 6 WCT — Contract Logic, không class/interface/API.
  Mirror S007 (SPEC-001).
agent: general
---

# W007 — Workflow Contracts

> **SPEC-002**: Workflow Engine · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Workflow Engine giao tiếp qua những hợp đồng nào?**

Contract Logic — không class/interface/API/method/DTO/protocol.

## Contracts (6)

### WCT-001 — Workflow Contract

| Field | Giá trị |
|-------|---------|
| category | Execution · direction: Request/Response · pattern: Sync |
| owner | Workflow Engine (WCP-001) · layer: Command · domain: Execution |
| purpose | Quản lý vòng đời Workflow |
| inputs | Workflow Request, Workflow Definition |
| outputs | Workflow, Workflow Result |
| preconditions | Workflow hợp lệ, Registry khả dụng |
| postconditions | Workflow đạt Terminal State, Event sinh ra |
| invariants | Workflow không tự thay đổi; **Workflow là Execution của Runtime** |
| dependencies | Definition, Orchestrator, Registry Contract |
| capability | workflow-management |

### WCT-002 — Definition Contract

| Field | Giá trị |
|-------|---------|
| category | Data · direction: Read · pattern: Request/Response |
| owner | Definition Manager (WCP-002) · layer: Declaration · domain: Definition |
| purpose | Quản lý Workflow Definition + Version |
| invariants | Definition immutable khi Published; **không chứa code** |
| capability | workflow-definition |

### WCT-003 — Validation Contract

| Field | Giá trị |
|-------|---------|
| category | Execution · direction: Request/Response · pattern: Sync |
| owner | Validation Engine (WCP-003) · layer: Validation |
| purpose | Validate + Normalize Workflow (EF006) |
| outputs | Validation Result, Normalized Workflow |
| invariants | Validate trước khi chạy; không chạy step |
| capability | workflow-validation |

### WCT-004 — Orchestrator Contract

| Field | Giá trị |
|-------|---------|
| category | Execution · pattern: Sync/Async |
| owner | Workflow Orchestrator (WCP-004) · layer: Orchestration · domain: Coordination |
| purpose | Điều phối luồng — **delegate Runtime (SPEC-001)** |
| inputs | Normalized Workflow |
| outputs | Runtime Execution Request |
| invariants | Không chứa Business Logic; **không tự chạy step** |
| dependencies | Registry Contract, Runtime (SPEC-001) |
| capability | orchestration |

### WCT-005 — Registry Contract

| Field | Giá trị |
|-------|---------|
| category | Registry · direction: Read/Write |
| owner | Workflow Loader / Step Resolver / Workflow Registrar |
| purpose | Truy cập Registry (S014) và resolve |
| invariants | Registry không phải Database |
| capability | registry-resolution |

### WCT-006 — Event Contract

| Field | Giá trị |
|-------|---------|
| category | Observability · direction: Publish · pattern: Event |
| owner | Workflow Event Dispatcher (WCP-008) · layer: Publication |
| purpose | Publish Event/Metrics/Trace/Audit (S011) |
| outputs | Workflow Event |
| postconditions | Event published, có correlation_id |
| invariants | Không chứa Business Data; Event immutable |
| capability | workflow-observability |

## Contract Quality

- **Deterministic** — cùng input → cùng output.
- **Versioned** — semver.
- **Immutable** — published không đổi.
- **Observable** — mọi gọi có Event (S011).

## Anti-patterns (cấm)

- Contract trả Business Data.
- Contract định nghĩa lại State Machine (S009).
- Contract định nghĩa lại Policy (S012).
- Contract phụ thuộc Agent/Plugin cụ thể.

## Communication Matrix (10 edges)

`WCP-001→WCP-002/003/004/005/007`, `WCP-003→WCP-005`, `WCP-004→WCP-006`, `WCP-004→**Runtime**`, `WCP-005→Registry`, `WCP-008→Event Store` — mọi edge qua Contract.

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

- W005: `../W005/architecture.md`
- W006: `../W006/components.md`
- S007: `../../SPEC-001/S007/contracts.yaml` (mẫu cấu trúc)
- S009: `../../SPEC-001/S009/state-machine.yaml`
- S011: `../../SPEC-001/S011/observability.md`
- S012: `../../SPEC-001/S012/policies.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
