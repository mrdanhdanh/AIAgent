---
name: spec-001-s005-architecture
description: >
  SPEC-001 S005 — Runtime Architecture (Blueprint). Trả lời: Runtime được tổ
  chức như thế nào? Logical Architecture: 9 layers + 6 domains + 4 views + rules.
  Không mô tả class/interface/package/namespace/code.
agent: general
---

# S005 — Runtime Architecture

> **SPEC-001**: Runtime Kernel · **Version**: 1.1.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Runtime được tổ chức như thế nào?**

Không mô tả:

- class
- interface
- package
- namespace
- code

Chỉ mô tả **Logical Architecture**.

## Mục tiêu

Xây dựng kiến trúc logic của Runtime sao cho:

- ổn định
- mở rộng
- độc lập implementation
- phù hợp Constitution

## A000 — Architectural Decisions

Mọi quyết định kiến trúc của Runtime phải tuân theo:

- Runtime là **Orchestrator**, không phải Executor.
- Runtime ưu tiên **Metadata** hơn Configuration.
- Runtime chỉ phụ thuộc **Abstraction**.
- Runtime không biết **Implementation**.
- Runtime không chứa **Domain Logic**.
- Runtime được thiết kế để **Evolution** mà không phá vỡ Core.

> Đây là "kim chỉ nam" cho mọi ADR sau này.

## A001 — Architecture Vision

Runtime là một **Execution Kernel** được tổ chức theo kiến trúc phân tầng.

Mỗi tầng chỉ có một trách nhiệm.

Mỗi tầng chỉ giao tiếp với tầng kế cận thông qua Contract.

## A002 — Runtime Layers (9 tầng logic)

```text
Command Layer
        │
Workflow Layer
        │
Execution Layer
        │
Coordination Layer
        │
Capability Layer
        │
Resolution Layer
        │
State Layer
        │
Event Layer
        │
Publication Layer
```

| Layer | Input | Output | Trách nhiệm | Không chịu trách nhiệm |
|-------|-------|--------|--------------|------------------------|
| Command | User Request | Workflow | Entry Point, Khởi tạo Runtime | Nghiệp vụ |
| Workflow | Workflow Definition | Execution Plan | Workflow Definition, Phase, Task | Điều phối |
| Execution | Execution Plan | Coordination | Execution Lifecycle, Execution Context | Business Logic |
| Coordination | Execution Context | Capability Request | Orchestration, Scheduling, Retry, Timeout, Approval | Business Logic |
| Capability | Capability Request | Resolution Result | Capability Resolution, Capability Mapping | Biết Agent |
| Resolution | Registry | Agent Contract | Registry Lookup, Contract Validation | Business Logic |
| State | Execution State | Event | State Machine, Context State, Execution State | Business State |
| Event | State Change | Artifact | Event, Metrics, Trace, Audit | Business Data |
| Publication | Metadata | Snapshot | Publish Artifact/Event/Metrics, Snapshot, Handoff | Lưu trữ, Business Data |

> **Publication Layer** (không phải Persistence): Runtime chỉ **publish** Artifact/Event/Metrics — việc lưu trữ thuộc Artifact Store/Event Store bên ngoài (S004 Boundary, P010).

## A003 — Dependency Rules

```text
Layer N
    ↓
Layer N+1     ← Được phép
```

```text
Layer N
    ↓
Layer N+2     ← Không được phép
```

- Không Circular Dependency.
- Không Skip Layer.

## A004 — Communication Rules

Chỉ có 4 cách giao tiếp:

- Contract
- Context
- Event
- Artifact

> Ngoài ra đều bị cấm.

## A005 — Runtime Domains (6)

| Domain | Owner | Layers |
|--------|-------|--------|
| Execution | Runtime | Command, Workflow, Execution |
| Coordination | Runtime | Coordination |
| Capability | Runtime | Capability, Resolution |
| State | Runtime | State |
| Observability | Runtime | Event |
| Publication | Runtime | Publication |

> Không Domain nào chứa Business Logic. Mỗi Domain một Owner.

## A006 — Architecture Invariants

- Runtime luôn Metadata Driven.
- Runtime không biết Agent cụ thể.
- Runtime không biết Plugin cụ thể.
- Runtime không phụ thuộc Framework.
- Runtime luôn Stateless giữa các Execution.
- Runtime luôn Event Driven.
- Runtime luôn Contract First.

## Layer Invariants

- Command: Không chứa nghiệp vụ.
- Workflow: Không điều phối.
- Execution: **Execution luôn có Context.**
- Coordination: Không chứa Business Logic.
- Capability: **Không biết Agent.**
- Resolution: Không biết Agent/Plugin cụ thể.
- State: Không quản lý Business State.
- Event: Không chứa Business Data.
- Publication: **Chỉ publish, không lưu trữ.**

## A007 — Architecture Quality

| Thuộc tính | Mục tiêu |
|-----------|----------|
| Modularity | Cao |
| Coupling | Thấp |
| Cohesion | Cao |
| Extensibility | Rất cao |
| Testability | Cao |
| Evolvability | Rất cao |
| Determinism | 100% |

## A008 — Architecture Constraints

Không được:

- Circular Dependency.
- Hidden Dependency.
- Shared Mutable State.
- Direct Agent Coupling.
- Direct Plugin Coupling.
- Business Logic trong Runtime.

## A009 — Architecture Mapping

```text
Architecture
    ↓
Components
    ↓
Services
    ↓
Contracts
    ↓
Execution
    ↓
Implementation
```

## A010 — Architecture Validation

Doctor phải kiểm tra:

- Layering.
- Dependency.
- Coupling.
- Circular Dependency.
- Contract Compliance.
- Boundary Compliance.
- Principle Compliance.

## Architecture Views (4)

### Layer View (luồng xử lý)

```text
Command → Workflow → Execution → Coordination → Capability → Resolution → State → Event → Publication
```

### Dependency View

```text
Workflow
    ↓
Execution
    ↓
Capability
    ↓
Registry
```

### Data Flow View

```text
Context
    ↓
Agent
    ↓
Artifact
```

### Event Flow View

```text
Execution
    ↓
State
    ↓
Event
    ↓
Metrics
    ↓
Dashboard
```

> Ba sơ đồ sau là những gì Dashboard sẽ dùng.

## Cross Mapping

### Layer × Principle

| Layer | Principle |
|-------|-----------|
| Command/Workflow/Execution/Coordination | P001 |
| Capability/Resolution | P007 |
| State | P009 |
| Event | P014 |
| Publication | P010 |

### Layer × Boundary

| Layer | Boundary |
|-------|----------|
| Command | B005 Interface |
| Workflow | B003 Delegation |
| Execution | B001 Ownership |
| Coordination | B002 Permission |
| Capability | B003 Delegation |
| Resolution | B004 Dependency |
| State | B006 State |
| Event | B007 Data |
| Publication | B007 Data |

> Layer × Responsibility, Layer × Requirement xem `architecture-registry.yaml` (Doctor đọc YAML).

## Architecture Stability

- **Stable**: Layers, Domains
- **Evolvable**: Components, Contracts, Capabilities
- **Replaceable**: Agents, Plugins

> Nền tảng cho Evolution Engine.

## Architecture Metrics (Dashboard)

```yaml
layer_count: 9
domain_count: 6
max_layer_dependency: 1
circular_dependency: 0
contract_violation: 0
hidden_dependency: 0
```

## Architecture Principles Mapping

| Architecture | Principle |
|--------------|-----------|
| Layering | P008 |
| Contract | P002 |
| Event | P005 |
| Capability | P007 |
| Metadata | P003 |
| Plugin | P012 |
| Constitution | P020 |

## Success Criteria

S005 hoàn thành khi:

- Kiến trúc được mô tả hoàn toàn ở mức logic.
- Mọi Layer có trách nhiệm rõ ràng.
- Không có Layer chồng chéo.
- Không có phụ thuộc vòng.
- Mọi giao tiếp đều qua Contract, Context, Event hoặc Artifact.
- Có thể ánh xạ trực tiếp sang S006 (Components) mà không phải thay đổi kiến trúc.

## Tham chiếu

- `architecture.yaml` — nguồn dữ liệu chuẩn.
- `layer-model.yaml` — Layer View.
- `domain-model.yaml` — Domain View.
- `dependency-rules.yaml` — A003.
- `communication-rules.yaml` — A004.
- `architecture-matrix.yaml` — Layer × Domain × Principle × Boundary.
- `architecture-decision-log.yaml` — AD-001..003.
- `architecture-registry.yaml` — registry tổng hợp.
- `architecture.schema.json` — validate cấu trúc.
- Constitution: `docs/specs/SPEC-000/`
