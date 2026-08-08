---
name: spec-002-w006-components
description: >
  SPEC-002 W006 — Workflow Components. Trả lời: Workflow Engine gồm những
  thành phần nào? 8 components, 3 nhóm — không lặp lại component của Runtime
  (SPEC-001 S006). Mirror S006 (SPEC-001).
agent: general
---

# W006 — Workflow Components

> **SPEC-002**: Workflow Engine · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Workflow Engine gồm những thành phần nào?**

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

- **Core** (4): Workflow Engine, Definition Manager, Validation Engine, Workflow Orchestrator.
- **Resolution** (2): Workflow Loader, Step Resolver.
- **Infrastructure** (2): Workflow Registrar, Workflow Event Dispatcher.

## Components (8)

| ID | Component | Layer | Domain | Responsibility | Boundary |
|----|-----------|-------|--------|----------------|----------|
| WCP-001 | Workflow Engine | Command | Execution | Quản lý vòng đời Workflow | WB004 |
| WCP-002 | Definition Manager | Declaration | Definition | Definition + Version | WB001 |
| WCP-003 | Validation Engine | Validation | Validation | Validate + Normalize (EF006) | WB003 |
| WCP-004 | Workflow Orchestrator | Orchestration | Coordination | Điều phối — delegate Runtime | WB004 |
| WCP-005 | Workflow Loader | Definition | Definition | Nạp từ Registry (S014) | WB002 |
| WCP-006 | Step Resolver | Resolution | Capability | Resolve capability step | WB006 |
| WCP-007 | Workflow Registrar | Definition | Definition | Đăng ký Entry (S014) | WB002 |
| WCP-008 | Workflow Event Dispatcher | Publication | Observability | Publish Event/Metrics/Trace/Audit (S011) | WB009 |

Mỗi component: `capability` / `contracts` / `dependencies` / `lifecycle` / `owner` / `replaceable` / `metric` / `rule` / `responsibilities (WRR)` / `requirements (WFR)` / `principles`.

**Replaceable:** WCP-001, WCP-004 = false (core); còn lại = true.

## Not in Workflow Engine

Thuộc Runtime (SPEC-001 S006) — dùng qua Runtime, không lặp lại:

- Execution Manager (CMP-001) · Execution Orchestrator (CMP-002)
- Context Manager (CMP-003) · State Manager (CMP-004) · Policy Engine (CMP-006)

## Contracts

| Contract | Components |
|----------|------------|
| Workflow Contract | WCP-001 |
| Definition Contract | WCP-002 |
| Validation Contract | WCP-003 |
| Orchestrator Contract | WCP-004 |
| Registry Contract | WCP-005, WCP-006, WCP-007 |
| Event Contract | WCP-008 |

## Dependencies

- WCP-004 → [WCP-006, **Runtime (SPEC-001)**] — delegate.
- WCP-005/006/007 → Registry (S014).
- WCP-008 → Event Store (S011).

## Lifecycles

- **runtime**: Defined → Initialized → Ready → Active → Stopping → Disposed.
- **workflow**: Idle → Assigned → Running → Completed.

## Validation

Doctor kiểm tra: Missing Component · Duplicate Component ID · Missing Contract · Missing Capability · Boundary Violation (W004) · Business Logic trong Component.

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

- W004: `../W004/boundaries.md`
- W005: `../W005/architecture.md`
- S006: `../../SPEC-001/S006/components.yaml` (mẫu cấu trúc)
- S011: `../../SPEC-001/S011/observability.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
