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

## CT005 — Contract Lifecycle

```text
Draft → Versioned → Published → Deprecated → Retired
```

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

## CT013 — Contract Metrics (Dashboard)

```yaml
contract_count: 12
violations: 0
version_mismatch: 0
unresolved_contract: 0
```

## CT014 — Contract Governance

- Contract thay đổi → RFC + ADR (breaking).
- Contract versioned theo SemVer (POLICY-002).
- Backward required, forward preferred (POLICY-003).

## CT015 — Success Criteria

- Mọi Component giao tiếp chỉ qua Contract.
- Mọi Contract có đủ model (inputs/outputs/pre/post/invariants).
- Communication Matrix phản ánh đúng Dependency Graph (S006).
- Không có lời gọi không hợp lệ (Doctor kiểm tra).
- Contract versioned + compatible.

## Tham chiếu

- `contracts.yaml` — nguồn dữ liệu chuẩn (12 contracts).
- `contract-model.yaml` — CT003.
- `contract-registry.yaml` — CT009.
- `communication-matrix.yaml` — CT011.
- `contract-compatibility.yaml` — CT007.
- `contract-mapping.yaml` — CT010 (ma trận truy vết).
- `contracts.schema.json` — validate cấu trúc.
- S006: `../S006/components.yaml`
- S005: `../S005/architecture.yaml`
- Constitution: `docs/specs/SPEC-000/`
