---
name: spec-005-r007-contracts
description: SPEC-005 R007 — Registry Contracts. 7 RCT.
agent: general
---

# R007 — Registry Contracts

> **SPEC-005**: Registry · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Registry giao tiếp qua những hợp đồng nào?**

Contract Logic — không class/interface/API/method/DTO/protocol.

## Contracts (7)

| ID | Contract | Owner | Purpose | Invariants |
|----|----------|-------|---------|------------|
| RCT-001 | Registry Contract | Registry Engine | Quản lý vòng đời Entry | Đăng ký trong S014; không Business Data |
| RCT-002 | Declaration Contract | Declaration Manager | Entry Definition + Version | Immutable khi Published |
| RCT-003 | Storage Contract | Storage Manager | Lưu Entry theo S014 | Không lưu Business Data (RB002) |
| RCT-004 | Validation Contract | Validation Engine | Validate trước khi lưu | Validate trước khi lưu (RB003) |
| RCT-005 | Resolution Contract | Resolution Service | Resolve qua S014 pipeline | Không tự resolve (RB004) |
| RCT-006 | Query Contract | Query Provider | Query + Discover Entry | Không phụ thuộc Storage cụ thể |
| RCT-007 | Event Contract | Registry Event Dispatcher | Publish (S011) | Không Business Data; immutable |

## Contract Quality

- **Deterministic** — cùng input → cùng output.
- **Versioned** — semver.
- **Immutable** — published không đổi.
- **Observable** — mọi gọi có Event (S011).

## Anti-patterns (cấm)

- Contract trả Business Data.
- Contract định nghĩa lại S014 model.
- Contract phụ thuộc Storage cụ thể.

## Communication Matrix (10 edges)

`RCP-001→RCP-002/003/004/005/006/008`, `RCP-004→RCP-002`, `RCP-005→**Runtime**`, `RCP-007→RCP-003`, `RCP-008→Event Store`.

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

- R005: `../R005/architecture.md`
- R006: `../R006/components.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
