---
name: spec-003-c006-components
description: >
  SPEC-003 C006 — Capability Components. Trả lời: Capability System gồm
  những thành phần nào? 8 components, 3 nhóm — không lặp lại component của
  Runtime (SPEC-001 S006). Mirror W006 (SPEC-002).
agent: general
---

# C006 — Capability Components

> **SPEC-003**: Capability System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Capability System gồm những thành phần nào?**

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

- **Core** (4): Capability Engine, Declaration Manager, Validation Engine, Registration Manager.
- **Resolution** (2): Capability Resolver, Discovery Provider.
- **Infrastructure** (2): Binding Registrar, Capability Event Dispatcher.

## Components (8)

| ID | Component | Layer | Domain | Responsibility | Boundary |
|----|-----------|-------|--------|----------------|----------|
| CCP-001 | Capability Engine | Command | Execution | Quản lý vòng đời Capability | CB004 |
| CCP-002 | Declaration Manager | Declaration | Definition | Definition + Version | CB001 |
| CCP-003 | Validation Engine | Validation | Validation | Validate + Compatibility (GV010) | CB003 |
| CCP-004 | Registration Manager | Registration | Mapping | Đăng ký S014 + Mapping | CB007 |
| CCP-005 | Capability Resolver | Resolution | Capability | Resolve Runtime (EF007) + Fallback | CB004 |
| CCP-006 | Discovery Provider | Registration | Mapping | Discovery qua S014 | CB002 |
| CCP-007 | Binding Registrar | Registration | Mapping | Binding Policy (S012) | CB008 |
| CCP-008 | Capability Event Dispatcher | Publication | Observability | Publish Event/Metrics/Trace/Audit (S011) | CB009 |

Mỗi component: `capability` / `contracts` / `dependencies` / `lifecycle` / `owner` / `replaceable` / `metric` / `rule` / `responsibilities (CRR)` / `requirements (CFR)` / `principles`.

**Replaceable:** CCP-001, CCP-004, CCP-005 = false (core); còn lại = true.

## Not in Capability System

Thuộc Runtime (SPEC-001 S006) — dùng qua Runtime, không lặp lại:

- Execution Manager (CMP-001) · Execution Orchestrator (CMP-002)
- Context Manager (CMP-003) · State Manager (CMP-004) · Policy Engine (CMP-006)
- **Registry (S014)** · **Runtime Resolver (S010 EF007)**

## Contracts

| Contract | Components |
|----------|------------|
| Capability Contract | CCP-001 |
| Declaration Contract | CCP-002 |
| Validation Contract | CCP-003 |
| Registry Contract | CCP-004, CCP-005, CCP-006 |
| Binding Contract | CCP-007 |
| Event Contract | CCP-008 |

## Dependencies

- CCP-005 → [Registry (S014), **Runtime (SPEC-001)**] — delegate.
- CCP-004/006 → Registry (S014).
- CCP-007 → Policy (S012).
- CCP-008 → Event Store (S011).

## Lifecycles

- **runtime**: Defined → Initialized → Ready → Active → Stopping → Disposed.
- **capability**: Idle → Assigned → Running → Completed.

## Validation

Doctor kiểm tra: Missing Component · Duplicate Component ID · Missing Contract · Missing Capability · Boundary Violation (C004) · Business Logic trong Component.

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

- C004: `../C004/boundaries.md`
- C005: `../C005/architecture.md`
- W006: `../../SPEC-002/W006/components.yaml` (mẫu cấu trúc)
- S011: `../../SPEC-001/S011/observability.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
