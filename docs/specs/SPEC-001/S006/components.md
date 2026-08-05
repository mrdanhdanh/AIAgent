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
- Một hoặc nhiều Contract.
- Một Lifecycle.
- Một Metadata.
- Có thể thay thế.
- Không chứa Business Logic.
- Không phụ thuộc Component ngoài Contract.

## C003 — Component Model

```yaml
component_model:
  fields: [id, name, version, status, layer, domain, responsibility,
           capability, contracts, dependencies, lifecycle, owner, metadata]
```

- Component phải **versioned** (P004).
- Component có thể implement **nhiều Contract**.
- Component có **Dependency**.
- Component thường phục vụ **nhiều Capability**.

## C004 — Core Components (12, 3 nhóm)

```text
Runtime
│
├── Core Components
│   ├── Execution Manager
│   ├── Execution Orchestrator
│   ├── Context Manager
│   ├── State Manager
│   └── Policy Engine
│
├── Resolution Components
│   ├── Workflow Loader
│   ├── Capability Resolver
│   └── Registry Resolver
│
└── Infrastructure Components
    ├── Event Dispatcher
    ├── Artifact Dispatcher
    ├── Metrics Collector
    └── Execution Resource Manager
```

### Lợi ích 3 nhóm

- Dễ mở rộng.
- Dashboard hiển thị rõ ràng.
- Doctor kiểm tra theo nhóm.
- Evolution Engine đánh giá tác động theo subsystem.
- Component mới biết thuộc subsystem nào.

## C005 — Component Responsibilities

| Component | Group | Responsibility |
|-----------|-------|----------------|
| Execution Manager | Core | Quản lý vòng đời Execution |
| Execution Orchestrator | Core | Điều phối toàn bộ luồng thực thi |
| Context Manager | Core | Quản lý Execution Context |
| State Manager | Core | Quản lý State Machine |
| Policy Engine | Core | Thực thi Policy/Governance |
| Workflow Loader | Resolution | Đọc và chuẩn bị Workflow |
| Capability Resolver | Resolution | Resolve Capability thành Agent |
| Registry Resolver | Resolution | Truy cập Registry qua Contract và resolve |
| Event Dispatcher | Infrastructure | Publish Event, hỗ trợ nhiều cơ chế |
| Artifact Dispatcher | Infrastructure | Bàn giao Artifact (không lưu trữ) |
| Metrics Collector | Infrastructure | Thu Metrics |
| Execution Resource Manager | Infrastructure | Quản lý tài nguyên trong một Execution |

## C006 — Component Relationships (DAG)

```text
                 Execution Manager
                         │
        ┌────────────────┼──────────────┐
        │                │              │
 Workflow Loader   State Manager   Context Manager
        │                │              │
        └────────────┬───┘              │
                     │                  │
            Execution Orchestrator      │
                     │                  │
          Capability Resolver           │
                     │                  │
            Registry Resolver           │
                     │                  │
     ┌───────────────┼──────────────────┐
     │               │                  │
Event Dispatcher Artifact Dispatcher Metrics Collector
                     │
             Policy Engine
                     │
       Execution Resource Manager
```

> Quan hệ là **DAG** — không vòng lặp. Doctor sinh graph từ đây.

## C007 — Component Dependencies

| Component | Depends on |
|-----------|-----------|
| Execution Manager | Workflow Loader, Context Manager, State Manager, Execution Resource Manager, Event Dispatcher, Artifact Dispatcher, Metrics Collector, Execution Orchestrator |
| Execution Orchestrator | Capability Resolver, Policy Engine |
| Context Manager | — |
| State Manager | Event Dispatcher |
| Policy Engine | Registry Resolver |
| Workflow Loader | — |
| Capability Resolver | Registry Resolver |
| Registry Resolver | — |
| Event Dispatcher | — |
| Artifact Dispatcher | — |
| Metrics Collector | Event Dispatcher |
| Execution Resource Manager | — |

> Nguyên tắc: **Higher orchestration depends on lower service.** Không đảo chiều.

## C008 — Component Contracts

| Component | Contract |
|-----------|----------|
| Execution Manager | Execution Contract (S007) |
| Execution Orchestrator | Orchestrator Contract (S007) |
| Context Manager | Context Contract (S007) |
| State Manager | State Contract (S007) |
| Policy Engine | Policy Contract (S007) |
| Workflow Loader | Workflow Contract (S007) |
| Capability Resolver | Capability Contract (S007) |
| Registry Resolver | Registry Contract (S007) |
| Event Dispatcher | Event Contract (S007) |
| Artifact Dispatcher | Artifact Contract (S007) |
| Metrics Collector | Metrics Contract (S007) |
| Execution Resource Manager | Resource Contract (S007) |

## C009 — Component Lifecycle (2 lifecycle)

### Runtime Lifecycle

```text
Defined → Initialized → Ready → Active → Stopping → Disposed
```

### Execution Lifecycle

```text
Idle → Assigned → Running → Completed
```

> Hai lifecycle khác nhau. Runtime component không register mỗi lần chạy.

## C010 — Component Ownership

Mọi component thuộc **Runtime** — không Component nào có nhiều Owner.

## C011 — Component Communication

5 kênh:

- Contract
- **Capability**
- Context
- Event
- Artifact

> Runtime nội bộ resolve Capability liên tục → Capability là kênh giao tiếp nội bộ.

## C012 — Component State

- Execution Manager: Active, Terminated
- Context Manager: Created, Active, Closed
- Execution Resource Manager: Allocated, Released
- Component khác: Active (runtime lifecycle)

> State của component thuộc component; State của Execution thuộc Runtime (S004 B006).

## C013 — Component Registry

`component-registry.yaml` — mỗi component: id → layer → domain → contracts → capabilities → owner → status. Dashboard đọc trực tiếp.

## C014 — Component Validation

Doctor kiểm tra:

- Component có đúng một Owner?
- Component có Contract hợp lệ?
- Component có đúng một Responsibility?
- Component có chứa Business Logic?
- Dependency có vòng lặp?
- Component có phụ thuộc ngoài Contract?
- Component có thuộc đúng Layer/Domain?
- Component có version/status?

### Component Constraints

- Một Component **không biết implementation** của Component khác.
- Một Component **không tự thay đổi Context**.
- Component **không được publish Event ngoài Contract**.

## C015 — Component Mapping (Ma trận truy vết)

```text
CMP → Layer → Domain → Capability → RR → FR → Boundary → Principle → Rule
```

## Component Metrics (Dashboard)

```yaml
component_count: 12
average_dependency: 1.3
max_dependency_depth: 4
orphan_component: 0
```

## Tham chiếu

- `components.yaml` — nguồn dữ liệu chuẩn (12 components, 3 nhóm).
- `component-model.yaml` — C003.
- `component-registry.yaml` — C013.
- `component-dependencies.yaml` — C007 (DAG).
- `component-lifecycle.yaml` — C009 (2 lifecycle).
- `component-contracts.yaml` — C008.
- `component-ownership.yaml` — C010.
- `component-mapping.yaml` — C015 (ma trận truy vết).
- `component-metrics.yaml` — Dashboard.
- `component-validation.yaml` — C014.
- `components.schema.json` — validate cấu trúc.
- S005: `../S005/architecture.yaml`
- Constitution: `docs/specs/SPEC-000/`
