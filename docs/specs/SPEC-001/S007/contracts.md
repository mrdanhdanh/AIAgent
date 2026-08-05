---
name: spec-001-s007-contracts
description: >
  SPEC-001 S007 — Runtime Contracts. Trả lời: Các Component trong Runtime giao
  tiếp với nhau như thế nào? 15 sections CT001-CT015, 12 contracts CTR-001..012.
  Không nói class/interface/API/method/DTO/protocol/implementation.
agent: general
---

# S007 — Runtime Contracts

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Các Component trong Runtime giao tiếp với nhau như thế nào?**

Không nói:

- class
- interface
- API
- method
- DTO
- implementation
- protocol

Chỉ định nghĩa **Contract Logic**.

## CT001 — Contract Philosophy

- Mọi giao tiếp qua Contract (P002).
- Component không gọi trực tiếp Component khác.
- Contract là biên giới duy nhất giữa các Component.

## CT002 — Contract Principles

- Một Component sở hữu **một Primary Contract**.
- Contract versioned (P004).
- Contract backward compatible (P018).
- Không bypass Contract.

## CT003 — Contract Model

```yaml
contract:
  id:
  name:
  version:
  status:
  owner:
  layer:
  domain:
  purpose:
  responsibilities:
  inputs:
  outputs:
  preconditions:
  postconditions:
  invariants:
  dependencies:
  compatibility:
  lifecycle:
  metadata:
```

> Template chung cho toàn AIOS, không chỉ Runtime.

## CT004 — Runtime Contracts (12)

| ID | Contract | Sử dụng bởi |
|----|----------|-------------|
| CTR-001 | Execution Contract | Execution Manager |
| CTR-002 | Workflow Contract | Workflow Loader |
| CTR-003 | Coordination Contract | Execution Orchestrator |
| CTR-004 | Capability Contract | Capability Resolver |
| CTR-005 | Registry Contract | Registry Resolver |
| CTR-006 | Context Contract | Context Manager |
| CTR-007 | State Contract | State Manager |
| CTR-008 | Event Contract | Event Dispatcher |
| CTR-009 | Artifact Contract | Artifact Dispatcher |
| CTR-010 | Metrics Contract | Metrics Collector |
| CTR-011 | Policy Contract | Policy Engine |
| CTR-012 | Resource Contract | Execution Resource Manager |

> Mỗi Component chỉ sở hữu **một Primary Contract**.

## Contract Types (toàn AIOS)

```text
Execution Contract   Workflow Contract   Capability Contract
Context Contract     State Contract      Event Contract
Artifact Contract    Metrics Contract    Policy Contract
Registry Contract
Plugin Contract      SDK Contract        External Contract
```

> Runtime định nghĩa 12 contract đầu; Plugin/SDK/External thuộc SPEC sau — không định nghĩa lại.

## Contract Categories

| Category | Contracts |
|----------|-----------|
| Execution | Execution, Workflow, Coordination, State, Resource |
| Registry | Capability, Registry |
| Data | Context, Artifact |
| Observability | Event, Metrics |
| Governance | Policy |
| Extension | Plugin, SDK, External |

## Contract Direction

Mỗi contract có direction: Request / Response / Publish / Subscribe / Read / Write.

> Doctor phát hiện `Write Contract → Read Component` là sai.

## Contract Communication Pattern

Mỗi contract có pattern: Sync / Async / Event / Fire-and-forget / Request-Response.

## CT005 — Contract Lifecycle

```text
Draft → Review → Approved → Published → Deprecated → Retired
```

## Contract Ownership

- Một Contract chỉ có đúng **một Owner**.
- Không cho phép shared owner.

## Contract Invariants

- Contract luôn **immutable**.
- Published Contract **không sửa**.
- Contract **không chứa Business Logic**.
- Contract **độc lập Implementation**.
- Contract luôn **Versioned** (P004).

## CT006 — Contract Versioning (SemVer)

```text
1.0.0  → 1.1.0 → 1.2.0 → 1.2.1   (backward compatible)
2.0.0  ← breaking change
```

## CT007 — Contract Compatibility

| Version | Compatible |
|---------|-----------|
| 1.0 | 1.x |
| 1.1 | 1.x |
| 2.0 | 2.x |

> Nền tảng cho Plugin.

## CT008 — Contract Validation

```text
Contract
    ↓
Input
    ↓
Validation
    ↓
Execution
    ↓
Output
    ↓
Event
    ↓
Artifact
```

Doctor kiểm tra: input/output hợp lệ, pre/post conditions, invariant.

## CT009 — Contract Registry

`contract-registry.yaml` — CTR-### → name → owner → version → dependencies. Runtime và Doctor đọc.

## CT010 — Contract Mapping

```text
Contract → Component → Layer → Domain → Capability → Responsibility → Requirement → Boundary → Rule → Principle
```

Đây là một trong những sơ đồ truy vết mạnh nhất của AIOS.

## CT011 — Communication Matrix

| From | To | Contract |
|------|-----|----------|
| Execution Manager | Workflow Loader | Workflow Contract |
| Execution Manager | Context Manager | Context Contract |
| Execution Manager | State Manager | State Contract |
| Execution Manager | Event Dispatcher | Event Contract |
| Execution Manager | Artifact Dispatcher | Artifact Contract |
| Execution Manager | Metrics Collector | Metrics Contract |
| Execution Manager | Execution Resource Manager | Resource Contract |
| Execution Manager | Execution Orchestrator | Coordination Contract |
| Execution Orchestrator | Capability Resolver | Capability Contract |
| Execution Orchestrator | Policy Engine | Policy Contract |
| Capability Resolver | Registry Resolver | Registry Contract |
| State Manager | Event Dispatcher | Event Contract |
| Policy Engine | Registry Resolver | Registry Contract |
| Metrics Collector | Event Dispatcher | Event Contract |

> Doctor đọc bảng này → phát hiện ngay lời gọi không hợp lệ.

## CT012 — Contract Constraints

- Component không gọi Component trực tiếp — qua Contract.
- Không bypass Contract.
- Không truyền object nội bộ qua Contract.
- Contract bất biến sau Published — sửa → version mới.

## CT013 — Contract Quality

| Metric | Target |
|--------|--------|
| Completeness | 100% |
| Traceability | 100% |
| Version Coverage | 100% |
| Compatibility | 100% |
| Validation Coverage | 100% |

## CT014 — Contract Metrics (Dashboard)

```yaml
contract_count: 12
violations: 0
version_mismatch: 0
unresolved_contract: 0
```

## CT015 — Contract Governance

- Contract thay đổi → RFC + ADR (breaking).
- Contract versioned theo SemVer (POLICY-002).
- Backward required, forward preferred (POLICY-003).
- Contract lifecycle theo Governance (Draft→Review→Approved→Published→Deprecated→Retired).

## CT016 — Contract Anti-patterns

Doctor dùng danh sách này để phát hiện vi phạm:

- Component gọi trực tiếp Component.
- Contract chứa Business Logic.
- Contract không Version.
- Contract Circular Dependency.
- Contract biết Agent cụ thể.
- Contract biết Plugin cụ thể.
- Contract ghi Database.

## CT017 — Success Criteria

- Mọi Component giao tiếp chỉ qua Contract.
- Mọi Contract có đủ model (inputs/outputs/pre/post/invariants).
- Communication Matrix phản ánh đúng Dependency Graph (S006).
- Không có lời gọi không hợp lệ (Doctor kiểm tra).
- Contract versioned + compatible.

## Tham chiếu

- `contracts.yaml` — nguồn dữ liệu chuẩn (12 contracts, category/direction/pattern).
- `contract-model.yaml` — CT003.
- `contract-registry.yaml` — CT009 (metadata đầy đủ).
- `communication-matrix.yaml` — CT011.
- `contract-compatibility.yaml` — CT007 (matrix Component→Contract→Version).
- `contract-mapping.yaml` — CT010 (ma trận truy vết mở rộng).
- `contract-types.yaml` — Contract Types (13).
- `contract-categories.yaml` — Contract Categories (6).
- `contract-anti-patterns.yaml` — CT016.
- `contract-quality.yaml` — CT013.
- `contracts.schema.json` — validate cấu trúc.
- S006: `../S006/components.yaml`
- S005: `../S005/architecture.yaml`
- Constitution: `docs/specs/SPEC-000/`
