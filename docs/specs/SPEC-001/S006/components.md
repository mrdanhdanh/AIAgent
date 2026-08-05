---
name: spec-001-s006-components
description: >
  SPEC-001 S006 — Runtime Components (Kernel Internal Architecture). Trả lời:
  Runtime được cấu thành từ những thành phần logic nào? 15 sections C001-C015.
  Không phải class/interface/package/namespace/project/source code.
agent: general
---

# S006 — Runtime Components

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: Draft
> **Vị trí**: Kernel Internal Architecture — mọi implementation (C#, Go, Rust, Python...) phải tuân theo.

## Câu hỏi duy nhất

> **Runtime được cấu thành từ những thành phần logic nào?**

**Không trả lời:**

- class
- interface
- package
- namespace
- project
- source code

## C001 — Component Philosophy

- Component càng ít càng tốt.
- Mỗi Component chỉ có **một trách nhiệm**.
- Component có thể mở rộng bằng **Capability**, không mở rộng bằng thêm Component mới.

## C002 — Component Principles

Mỗi Component phải tuân thủ:

- Một Responsibility.
- Một Owner.
- Một Contract.
- Một Lifecycle.
- Một Metadata.
- Có thể thay thế.
- Không chứa Business Logic.
- Không phụ thuộc Component ngoài Contract.

## C003 — Component Model

```yaml
component_model:
  id: CMP-###
  fields: [id, name, layer, domain, responsibility, contract, lifecycle, owner, metadata]
```

## C004 — Core Components (12)

```text
Runtime
│
├── Execution Manager
├── Workflow Loader
├── Execution Coordinator
├── Capability Resolver
├── Registry Resolver
├── Context Manager
├── State Manager
├── Event Dispatcher
├── Artifact Dispatcher
├── Metrics Collector
├── Policy Engine
└── Execution Resource Manager
```

> Đây là **Core Runtime**. Không thêm nữa.

### Vì sao chỉ 12?

- Component càng ít càng tốt.
- Mỗi Component chỉ có một trách nhiệm.
- Mở rộng bằng Capability, không bằng Component mới.

## C005 — Component Responsibilities

| Component | Responsibility |
|-----------|----------------|
| Execution Manager | Quản lý vòng đời Execution |
| Workflow Loader | Đọc và chuẩn bị Workflow |
| Execution Coordinator | Điều phối luồng thực thi |
| Capability Resolver | Resolve Capability thành Agent |
| Registry Resolver | Truy cập Registry qua Contract và resolve |
| Context Manager | Quản lý Execution Context |
| State Manager | Quản lý State Machine |
| Event Dispatcher | Publish Event, hỗ trợ nhiều cơ chế |
| Artifact Dispatcher | Bàn giao Artifact (không lưu trữ) |
| Metrics Collector | Thu Metrics |
| Policy Engine | Thực thi Policy/Governance |
| Execution Resource Manager | Quản lý tài nguyên trong một Execution |

## C006 — Component Relationships

```text
Execution Manager
        │
Workflow Loader
        │
Execution Coordinator
        │
Capability Resolver
        │
Registry Resolver
```

và

```text
Execution Coordinator
        │
├── Context Manager
├── State Manager
├── Event Dispatcher
├── Artifact Dispatcher
├── Metrics Collector
├── Policy Engine
└── Execution Resource Manager
```

## C007 — Component Dependencies

| Component | Depends on |
|-----------|-----------|
| Execution Manager | Context, State, Event Dispatcher, Artifact Dispatcher, Metrics, Execution Resource Manager |
| Workflow Loader | Execution Manager |
| Execution Coordinator | Execution Manager, Capability Resolver, Policy Engine |
| Capability Resolver | Registry Resolver |
| Registry Resolver | — |
| Context Manager | — |
| State Manager | Event Dispatcher |
| Event Dispatcher | — |
| Artifact Dispatcher | — |
| Metrics Collector | Event Dispatcher |
| Policy Engine | Registry Resolver |
| Execution Resource Manager | — |

> Quan hệ phải là **DAG (Directed Acyclic Graph)** — không được có vòng lặp. Doctor validate.

## C008 — Component Contracts

| Component | Contract |
|-----------|----------|
| Execution Manager | Execution Contract (S007) |
| Workflow Loader | Workflow Contract (S007) |
| Execution Coordinator | Coordinator Contract (S007) |
| Capability Resolver | Capability Contract (S007) |
| Registry Resolver | Registry Contract (S007) |
| Context Manager | Context Contract (S007) |
| State Manager | State Contract (S007) |
| Event Dispatcher | Event Contract (S007) |
| Artifact Dispatcher | Artifact Contract (S007) |
| Metrics Collector | Metrics Contract (S007) |
| Policy Engine | Policy Contract (S007) |
| Execution Resource Manager | Resource Contract (S007) |

## C009 — Component Lifecycle

```text
Defined → Instantiated → Registered → Active → Suspended → Terminated
```

## C010 — Component Ownership

Mọi component thuộc **Runtime** — không Component nào có nhiều Owner.

| Component | Owner |
|-----------|-------|
| Execution Manager | Runtime |
| Workflow Loader | Runtime |
| Execution Coordinator | Runtime |
| Capability Resolver | Runtime |
| Registry Resolver | Runtime |
| Context Manager | Runtime |
| State Manager | Runtime |
| Event Dispatcher | Runtime |
| Artifact Dispatcher | Runtime |
| Metrics Collector | Runtime |
| Policy Engine | Runtime |
| Execution Resource Manager | Runtime |

## C011 — Component Communication

- Component giao tiếp qua **Contract** (P002).
- Không gọi trực tiếp implementation.
- 4 kênh: Contract, Context, Event, Artifact (A004 S005).

## C012 — Component State

- Execution Manager: Active, Terminated
- Context Manager: Created, Active, Closed
- Execution Resource Manager: Allocated, Released
- Component khác: Active

> State của component thuộc component; State của Execution thuộc Runtime (S004 B006).

## C013 — Component Registry

- `component-registry.yaml` — registry tổng hợp (Doctor/Dashboard đọc một file).
- Mỗi component: id, name, layer, domain, contract.

## C014 — Component Validation

Doctor kiểm tra:

- Component có đúng một Owner?
- Component có đúng một Contract?
- Component có đúng một Responsibility?
- Component có chứa Business Logic?
- Dependency có vòng lặp?
- Component có phụ thuộc ngoài Contract?
- Component có thuộc đúng Layer/Domain?

## C015 — Component Mapping

```text
CMP-### → Layer → Domain → RR (S003) → FR (S002) → P (Constitution)
```

Chi tiết: `component-mapping.yaml`

## Tham chiếu

- `components.yaml` — nguồn dữ liệu chuẩn (12 components).
- `component-model.yaml` — C003.
- `component-registry.yaml` — C013.
- `component-dependencies.yaml` — C007 (DAG).
- `component-lifecycle.yaml` — C009.
- `component-contracts.yaml` — C008.
- `component-ownership.yaml` — C010.
- `component-mapping.yaml` — C015.
- `component-metrics.yaml` — Dashboard.
- `component-validation.yaml` — C014.
- `components.schema.json` — validate cấu trúc.
- S005: `../S005/architecture.yaml`
- Constitution: `docs/specs/SPEC-000/`
