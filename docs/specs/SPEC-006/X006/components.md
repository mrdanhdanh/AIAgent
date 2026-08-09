---
name: spec-006-x006-components
description: SPEC-006 X006 — Context Components. 8 XCP.
agent: general
---

# X006 — Context Components

> **SPEC-006**: Context Engine · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Context Engine gồm những thành phần nào?**

## Philosophy

- Component càng ít càng tốt.
- Mỗi Component chỉ có một trách nhiệm.

## Principles

- Một Responsibility · Một Owner · Một hoặc nhiều Contract · Có thể thay thế · Không chứa Business Logic.

## Groups (3)

- **Core** (5): Context Engine, Allocation Manager, Population Manager, Validation Engine, Isolation Manager.
- **Distribution** (2): Distribution Manager, Collection Manager.
- **Infrastructure** (1): Context Event Dispatcher.

## Components (8)

| ID | Component | Layer | Domain | Boundary |
|----|-----------|-------|--------|----------|
| XCP-001 | Context Engine | Command | Execution | XB009 |
| XCP-002 | Allocation Manager | Allocation | Definition | XB001 |
| XCP-003 | Population Manager | Population | Definition | XB006 |
| XCP-004 | Validation Engine | Validation | Validation | XB003 |
| XCP-005 | Distribution Manager | Distribution | Execution | XB004 |
| XCP-006 | Collection Manager | Collection | Execution | XB007 |
| XCP-007 | Isolation Manager | Distribution | Execution | XB002 |
| XCP-008 | Context Event Dispatcher | Publication | Observability | XB009 |

Mỗi component: `capability` / `contracts` / `dependencies` / `owner` / `replaceable` / `metric` / `rule` / `principles`.

## Not in Context Engine

- Execution Manager (CMP-001) · Context Manager (CMP-003) · State Manager (CMP-004) · Policy Engine (CMP-006) — SPEC-001 S006.
- **Registry (S014)**.

## Contracts

| Contract | Components |
|----------|------------|
| Context Contract | XCP-001..008 |

## Dependencies

- XCP-001 → State Machine (S009) — delegate.
- XCP-002 → Execution Created (S010 EF008).
- XCP-008 → Event Store (S011).

## Lifecycles

- **runtime**: Defined → Initialized → Ready → Active → Stopping → Disposed.
- **context**: Idle → Assigned → Running → Completed.

## Validation

Missing Component · Duplicate ID · Missing Contract · Boundary Violation (X004) · Business Logic.

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

- X005: `../X005/architecture.md`
- X007: `../X007/contracts.md`
- S011: `../../SPEC-001/S011/observability.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
