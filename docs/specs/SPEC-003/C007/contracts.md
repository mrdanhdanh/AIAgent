---
name: spec-003-c007-contracts
description: >
  SPEC-003 C007 — Capability Contracts. Trả lời: Capability System giao tiếp
  qua những hợp đồng nào? 6 CCT — Contract Logic, không class/interface/API.
  Mirror W007 (SPEC-002).
agent: general
---

# C007 — Capability Contracts

> **SPEC-003**: Capability System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Capability System giao tiếp qua những hợp đồng nào?**

Contract Logic — không class/interface/API/method/DTO/protocol.

## Contracts (6)

### CCT-001 — Capability Contract

| Field | Giá trị |
|-------|---------|
| category | Execution · direction: Request/Response · pattern: Sync |
| owner | Capability Engine (CCP-001) · layer: Command · domain: Execution |
| purpose | Quản lý vòng đời Capability |
| inputs | Capability Request, Capability Definition |
| outputs | Capability, Resolution Result |
| invariants | **Capability đăng ký trong S014**; Không hardcode; **Resolution qua EF007** |
| capability | capability-management |

### CCT-002 — Declaration Contract

| Field | Giá trị |
|-------|---------|
| category | Data · direction: Read |
| owner | Declaration Manager (CCP-002) · layer: Declaration · domain: Definition |
| purpose | Quản lý Capability Definition + Version |
| invariants | Definition immutable khi Published; **không chứa code** |
| capability | capability-declaration |

### CCT-003 — Validation Contract

| Field | Giá trị |
|-------|---------|
| category | Execution · pattern: Sync |
| owner | Validation Engine (CCP-003) · layer: Validation |
| purpose | Validate + Compatibility Check (S013 GV010) |
| invariants | Validate trước khi đăng ký; không đăng ký trực tiếp |
| capability | capability-validation |

### CCT-004 — Registration Contract

| Field | Giá trị |
|-------|---------|
| category | Data · direction: Read/Write |
| owner | Registration Manager (CCP-004) · layer: Registration · domain: Mapping |
| purpose | Đăng ký S014 + Mapping Agent/Plugin |
| outputs | Registry Entry, Agent Mapping |
| invariants | **Không hardcode mapping (CB007)**; Mapping qua Registry |
| capability | capability-registration |

### CCT-005 — Registry Contract

| Field | Giá trị |
|-------|---------|
| category | Registry · direction: Read |
| owner | Capability Resolver / Discovery Provider |
| purpose | Truy cập Registry (S014) và resolve |
| invariants | Registry không phải Database |
| capability | capability-resolution |

### CCT-006 — Event Contract

| Field | Giá trị |
|-------|---------|
| category | Observability · direction: Publish · pattern: Event |
| owner | Capability Event Dispatcher (CCP-008) · layer: Publication |
| purpose | Publish Event/Metrics/Trace/Audit (S011) |
| invariants | Không chứa Business Data; Event immutable |
| capability | capability-observability |

## Contract Quality

- **Deterministic** — cùng input → cùng output.
- **Versioned** — semver.
- **Immutable** — published không đổi.
- **Observable** — mọi gọi có Event (S011).

## Anti-patterns (cấm)

- Contract trả Business Data.
- **Contract hardcode mapping Agent.**
- Contract định nghĩa lại Policy (S012).
- Contract phụ thuộc Agent/Plugin cụ thể.

## Communication Matrix (10 edges)

`CCP-001→CCP-002/003/004/005/008`, `CCP-003→CCP-002`, `CCP-004→Registry`, `CCP-005→**Runtime**`, `CCP-006→Registry`, `CCP-008→Event Store` — mọi edge qua Contract.

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

- C005: `../C005/architecture.md`
- C006: `../C006/components.md`
- W007: `../../SPEC-002/W007/contracts.yaml` (mẫu cấu trúc)
- S011: `../../SPEC-001/S011/observability.md`
- S012: `../../SPEC-001/S012/policies.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
