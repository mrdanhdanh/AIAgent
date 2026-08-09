---
name: spec-005-r006-components
description: SPEC-005 R006 — Registry Components. 8 RCP.
agent: general
---

# R006 — Registry Components

> **SPEC-005**: Registry · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Registry gồm những thành phần nào?**

## Philosophy

- Component càng ít càng tốt.
- Mỗi Component chỉ có một trách nhiệm.

## Principles

- Một Responsibility · Một Owner · Một hoặc nhiều Contract · Có thể thay thế · Không chứa Business Logic.

## Groups (3)

- **Core** (5): Registry Engine, Declaration Manager, Storage Manager, Validation Engine, Domain Manager.
- **Resolution** (2): Resolution Service, Query Provider.
- **Infrastructure** (1): Registry Event Dispatcher.

## Components (8)

| ID | Component | Layer | Domain | Boundary |
|----|-----------|-------|--------|----------|
| RCP-001 | Registry Engine | Command | Execution | RB009 |
| RCP-002 | Declaration Manager | Declaration | Definition | RB001 |
| RCP-003 | Storage Manager | Storage | Definition | RB002 |
| RCP-004 | Validation Engine | Validation | Validation | RB003 |
| RCP-005 | Resolution Service | Resolution | Capability | RB004 |
| RCP-006 | Query Provider | Query | Data | RB006 |
| RCP-007 | Domain Manager | Storage | Definition | RB007 |
| RCP-008 | Registry Event Dispatcher | Publication | Observability | RB009 |

Mỗi component: `capability` / `contracts` / `dependencies` / `owner` / `replaceable` / `metric` / `rule` / `principles`.

## Not in Registry

- Execution Manager (CMP-001) · Context Manager (CMP-003) · State Manager (CMP-004) · Policy Engine (CMP-006) — SPEC-001 S006.
- **Registry (S014)** · **Runtime Resolver (S010 EF007)**.

## Contracts

| Contract | Components |
|----------|------------|
| Registry Contract | RCP-001..007 |
| Event Contract | RCP-008 |

## Dependencies

- RCP-005 → [Runtime (SPEC-001)] — delegate.
- RCP-008 → Event Store (S011).

## Lifecycles

- **runtime**: Defined → Initialized → Ready → Active → Stopping → Disposed.
- **entry**: Idle → Assigned → Running → Completed.

## Validation

Missing Component · Duplicate ID · Missing Contract · Boundary Violation (R004) · Business Logic.

## Machine-readable

```text
components.yaml
component-model.yaml
component-lifecycle.yaml
component-ownership.yaml
component-contracts.yaml
component-dependencies.yaml
component-mapping.yaml
component-metrics.yaml
component-validation.yaml
component-registry.yaml
components.schema.json
```

## Tham chiếu

- R004: `../R004/boundaries.md`
- R005: `../R005/architecture.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
