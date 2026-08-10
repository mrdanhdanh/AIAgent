---
name: spec-004-a006-components
description: >
  SPEC-004 A006 — Agent Components. Trả lời: Agent System gồm những thành
  phần nào? 8 components, 3 nhóm — không lặp lại component của Runtime
  (SPEC-001 S006). Mirror C006 (SPEC-003).
agent: general
---

# A006 — Agent Components

> **SPEC-004**: Agent System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Agent System gồm những thành phần nào?**

## Philosophy

- Component càng ít càng tốt.
- Mỗi Component chỉ có một trách nhiệm.
- Mở rộng bằng Capability, không mở rộng bằng thêm Component mới.

## Principles

- Một Responsibility · Một Owner · Một hoặc nhiều Contract · Một Lifecycle · Một Metadata.
- Có thể thay thế.
- Không chứa Business Logic.
- Không phụ thuộc Component ngoài Contract.

## Groups (3)

- **Core** (5): Agent Engine, Declaration Manager, Validation Engine, Registration Manager, **Orchestration Provider**.
- **Resolution** (1): Discovery Provider.
- **Infrastructure** (2): Binding Registrar, Agent Event Dispatcher.

## Components (8)

| ID | Component | Layer | Domain | Responsibility | Boundary |
|----|-----------|-------|--------|----------------|----------|
| ACP-001 | Agent Engine | Command | Execution | Quản lý vòng đời Agent | AB004 |
| ACP-002 | Declaration Manager | Declaration | Definition | Definition + Version | AB001 |
| ACP-003 | Validation Engine | Validation | Validation | Validate + Compatibility (GV010) | AB003 |
| ACP-004 | Registration Manager | Registration | Mapping | Đăng ký S014 + Capability Mapping (SPEC-003) | AB007 |
| ACP-005 | Orchestration Provider | Orchestration | Orchestration | Điều phối qua Workflow (SPEC-002) + delegate Runtime (SPEC-001) | AB004 |
| ACP-006 | Discovery Provider | Registration | Mapping | Discovery qua S014 | AB002 |
| ACP-007 | Binding Registrar | Registration | Mapping | Binding Policy (S012) | AB008 |
| ACP-008 | Agent Event Dispatcher | Publication | Observability | Publish Event/Metrics/Trace/Audit (S011) | AB009 |

Mỗi component: `capability` / `contracts` / `dependencies` / `lifecycle` / `owner` / `replaceable` / `metric` / `rule` / `responsibilities (ARR)` / `requirements (AFR)` / `principles`.

**Replaceable:** ACP-001, ACP-004, ACP-005 = false (core); còn lại = true.

## Not in Agent System

Thuộc Runtime (SPEC-001 S006) — dùng qua Runtime, không lặp lại:

- Execution Manager (CMP-001) · Execution Orchestrator (CMP-002)
- Context Manager (CMP-003) · State Manager (CMP-004) · Policy Engine (CMP-006)
- **Registry (S014)** · **Runtime Resolver (S010 EF007)** · **Capability System (SPEC-003)**

## Contracts

| Contract | Components |
|----------|------------|
| Agent Contract | ACP-001 |
| Declaration Contract | ACP-002 |
| Validation Contract | ACP-003 |
| Registry Contract | ACP-004, ACP-006 |
| Orchestration Contract | ACP-005 |
| Binding Contract | ACP-007 |
| Event Contract | ACP-008 |

## Dependencies

- ACP-004 → [Registry (S014), **Capability System (SPEC-003)**] — mapping.
- ACP-005 → [**Workflow Engine (SPEC-002)**, **Runtime (SPEC-001)**] — delegate.
- ACP-006 → Registry (S014).
- ACP-007 → Policy (S012).
- ACP-008 → Event Store (S011).

## Lifecycles

- **runtime**: Defined → Initialized → Ready → Active → Stopping → Disposed.
- **agent**: Idle → Assigned → Running → Completed.

## Validation

Doctor kiểm tra: Missing Component · Duplicate Component ID · Missing Contract · Missing Capability · Boundary Violation (A004) · Business Logic trong Component.

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

- A004: `../A004/boundaries.md`
- A005: `../A005/architecture.md`
- C006: `../../SPEC-003/C006/components.yaml` (mẫu cấu trúc)
- S011: `../../SPEC-001/S011/observability.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
