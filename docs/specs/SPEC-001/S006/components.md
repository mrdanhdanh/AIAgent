---
name: spec-001-s006-components
description: >
  SPEC-001 S006 — Runtime Components. Trả lời: Runtime được cấu thành từ những
  thành phần logic nào? 12 Core Components. Không phải class/project/thư mục.
agent: general
---

# S006 — Runtime Components

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Runtime được cấu thành từ những thành phần logic nào?**

Không phải class.

Không phải project.

Không phải thư mục.

Mà là **Core Components**.

## 12 Core Components

```text
Runtime
│
├── Execution Manager
├── Workflow Manager
├── Context Manager
├── State Manager
├── Capability Resolver
├── Registry Client
├── Event Publisher
├── Artifact Publisher
├── Metrics Collector
├── Policy Engine
├── Resource Manager
└── Execution Coordinator
```

> Đây là **Core Runtime**. Không thêm nữa.

## Chi tiết Components

| ID | Component | Layer | Domain | Trách nhiệm (RR) |
|----|-----------|-------|--------|-------------------|
| CMP-001 | Execution Manager | Execution | Execution | RR-001, 002, 003 |
| CMP-002 | Workflow Manager | Workflow | Execution | RR-005 |
| CMP-003 | Context Manager | Execution | Execution | RR-011..014 |
| CMP-004 | State Manager | State | State | RR-015..018 |
| CMP-005 | Capability Resolver | Capability | Capability | RR-006, 020 |
| CMP-006 | Registry Client | Resolution | Capability | RR-006 |
| CMP-007 | Event Publisher | Event | Observability | RR-025, 028 |
| CMP-008 | Artifact Publisher | Publication | Publication | RR-029..031 |
| CMP-009 | Metrics Collector | Event | Observability | RR-026, 027 |
| CMP-010 | Policy Engine | Coordination | Coordination | RR-032..035 |
| CMP-011 | Resource Manager | Execution | Execution | RR-001 |
| CMP-012 | Execution Coordinator | Coordination | Coordination | RR-004, 019, 021..024 |

### Mô tả ngắn

- **CMP-001 Execution Manager** — Khởi tạo, quản lý và kết thúc Execution.
- **CMP-002 Workflow Manager** — Nạp và validate Workflow Definition, tạo Execution Plan.
- **CMP-003 Context Manager** — Tạo/cấp/thu hồi Context, cô lập giữa các Execution.
- **CMP-004 State Manager** — Khởi tạo, theo dõi, chuyển State, kết thúc Terminal State.
- **CMP-005 Capability Resolver** — Resolve Capability và mapping Capability → Agent.
- **CMP-006 Registry Client** — Registry Lookup và Contract Validation.
- **CMP-007 Event Publisher** — Publish Event, ghi Audit Trail.
- **CMP-008 Artifact Publisher** — Sinh và publish Artifact, không sửa Artifact đã sinh.
- **CMP-009 Metrics Collector** — Thu Metrics, sinh Trace.
- **CMP-010 Policy Engine** — Thực thi Constitution, kiểm tra Contract, áp dụng Policy, từ chối vi phạm.
- **CMP-011 Resource Manager** — Allocate/Release Execution Resources, cô lập tài nguyên.
- **CMP-012 Execution Coordinator** — Điều phối luồng, đồng bộ, retry, cancellation, approval gate.

## Các thành phần KHÔNG thuộc Runtime

```text
Agent
Workflow Definition
Registry
Plugin
Knowledge
Doctor
Dashboard
Simulation
Evolution
SDK
```

> Runtime chỉ **sử dụng**, không **sở hữu**.

## Layer Coverage

| Layer | Components |
|-------|-----------|
| Command | (qua Execution Manager — khởi tạo) |
| Workflow | CMP-002 Workflow Manager |
| Execution | CMP-001, CMP-003, CMP-011 |
| Coordination | CMP-010, CMP-012 |
| Capability | CMP-005 |
| Resolution | CMP-006 |
| State | CMP-004 |
| Event | CMP-007, CMP-009 |
| Publication | CMP-008 |

## Component Relationships

```text
Workflow Manager → Execution Manager → { Context Manager, State Manager,
  Event Publisher, Artifact Publisher, Metrics Collector, Resource Manager }
Execution Coordinator → { Execution Manager, Capability Resolver, Policy Engine }
Capability Resolver → Registry Client
```

Chi tiết: `component-relationships.yaml`

## Component Dependency Matrix

| Component | Depends on |
|-----------|-----------|
| Execution Manager | Context, State, Event Publisher, Artifact Publisher, Metrics, Resource, Coordinator |
| Workflow Manager | Execution Manager |
| Context Manager | — |
| State Manager | Event Publisher |
| Capability Resolver | Registry Client |
| Registry Client | — |
| Event Publisher | — |
| Artifact Publisher | — |
| Metrics Collector | Event Publisher |
| Policy Engine | Registry Client |
| Resource Manager | — |
| Execution Coordinator | Execution Manager, Capability Resolver, Policy Engine |

> Doctor validate DAG: không vòng, không ngược layer.

## Component Lifecycle

```text
Defined → Instantiated → Registered → Active → Suspended → Terminated
```

## Component Contracts

Mỗi component expose một contract (chi tiết tại S007):

| Component | Contract |
|-----------|----------|
| Execution Manager | Execution Contract |
| Workflow Manager | Workflow Contract |
| Context Manager | Context Contract |
| State Manager | State Contract |
| Capability Resolver | Capability Contract |
| Registry Client | Registry Contract |
| Event Publisher | Event Contract |
| Artifact Publisher | Artifact Contract |
| Metrics Collector | Metrics Contract |
| Policy Engine | Policy Contract |
| Resource Manager | Resource Contract |
| Execution Coordinator | Coordinator Contract |

## Component Ownership

Mọi component thuộc **Runtime Team** — không chồng chéo. Chi tiết: `component-ownership.yaml`

## Tham chiếu

- `components.yaml` — nguồn dữ liệu chuẩn (12 components).
- `component-registry.yaml` — registry tổng hợp.
- `component-mapping.yaml` — CMP → Layer/Domain → RR → FR → P.
- `component-relationships.yaml` — quan hệ giữa các component.
- `component-dependency-matrix.yaml` — ma trận phụ thuộc (Doctor validate DAG).
- `component-lifecycle.yaml` — vòng đời component.
- `component-contracts.yaml` — contract mỗi component (S007).
- `component-ownership.yaml` — chủ sở hữu mỗi component.
- `components.schema.json` — validate cấu trúc.
- S005: `../S005/architecture.yaml`
- S003: `../S003/responsibilities.yaml`
- S002: `../S002/requirements.yaml`
- Constitution: `docs/specs/SPEC-000/`
