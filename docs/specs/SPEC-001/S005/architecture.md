---
name: spec-001-s005-architecture
description: >
  SPEC-001 S005 — Runtime Architecture (Blueprint). Trả lời: Runtime được tổ
  chức như thế nào? Logical Architecture: 9 layers + 6 domains + rules.
  Không mô tả class/interface/package/namespace/code.
agent: general
---

# S005 — Runtime Architecture

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: Draft

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
Persistence Layer
```

| Layer | Trách nhiệm | Không chịu trách nhiệm |
|-------|-------------|------------------------|
| Command | Entry Point, Khởi tạo Runtime | Nghiệp vụ |
| Workflow | Workflow Definition, Phase, Task | Điều phối |
| Execution | Execution Lifecycle, Execution Context | Business Logic |
| Coordination | Orchestration, Scheduling, Retry, Timeout, Approval | Business Logic |
| Capability | Capability Resolution, Capability Mapping | Biết Agent |
| Resolution | Registry Lookup, Contract Validation | Business Logic |
| State | State Machine, Context State, Execution State | Business State |
| Event | Event, Metrics, Trace, Audit | Business Data |
| Persistence | Artifact Metadata, Event Store, Metrics, Snapshot | Business Data |

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

```text
Execution
Coordination
Capability
State
Observability
Persistence
```

> Không Domain nào chứa Business Logic.

## A006 — Architecture Invariants

- Runtime luôn Metadata Driven.
- Runtime không biết Agent cụ thể.
- Runtime không biết Plugin cụ thể.
- Runtime không phụ thuộc Framework.
- Runtime luôn Stateless giữa các Execution.
- Runtime luôn Event Driven.
- Runtime luôn Contract First.

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

## Hai góc nhìn kiến trúc

### 1. Layer View (luồng xử lý)

```text
Command → Workflow → Execution → Coordination → Capability → Resolution → State → Event → Persistence
```

### 2. Domain View (trách nhiệm nghiệp vụ của Runtime)

```text
Execution · Coordination · Capability · State · Observability · Persistence
```

> Mỗi Component (S006) thuộc **một Domain** và **một Layer** — Dashboard/Doctor/Evolution phân tích đa chiều không đổi kiến trúc cốt lõi.

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
- `architecture-matrix.yaml` — Layer × Domain × Principle.
- `architecture-decision-log.yaml` — AD-001..003.
- `architecture-registry.yaml` — registry tổng hợp.
- `architecture.schema.json` — validate cấu trúc.
- Constitution: `docs/specs/SPEC-000/`
