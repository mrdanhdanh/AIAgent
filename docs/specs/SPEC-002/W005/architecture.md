---
name: spec-002-w005-architecture
description: >
  SPEC-002 W005 — Workflow Architecture. Trả lời: Workflow Engine được cấu
  trúc như thế nào? 7 layers, 6 domains — không lặp lại Execution/State/Event
  của Runtime (SPEC-001). Mirror S005 (SPEC-001).
agent: general
---

# W005 — Workflow Architecture

> **SPEC-002**: Workflow Engine · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Workflow Engine được cấu trúc như thế nào?**

Không mô tả implementation — chỉ mô tả kiến trúc logic.

## Architectural Decisions

- Workflow Engine là **Declarator**, không phải Executor.
- Workflow Engine ưu tiên Metadata hơn Configuration.
- Workflow Engine chỉ phụ thuộc Abstraction.
- Workflow Engine không biết Implementation.
- Workflow Engine không chứa Domain Logic.
- Workflow Engine được thiết kế để Evolution mà không phá vỡ Core.
- **Execution/State/Event thuộc Runtime (SPEC-001) — không lặp lại.**

## Layers (7)

```text
Level 1  Command         → Nhận Workflow Command
Level 2  Declaration     → Nhận khai báo YAML, schema check
Level 3  Definition      → Workflow Model + Version + Registry Entry
Level 4  Validation      → Validate cấu trúc + tham chiếu + Normalize (EF006)
Level 5  Resolution      → Resolve step qua Registry (S014)
Level 6  Orchestration   → Sequential/Parallel/Barrier/Gate/Retry/Timeout/Compensation
Level 7  Publication     → Publish Event/Metrics/Trace/Audit (S011)
```

| Layer | Domain | Input → Output | Invariant | Principle |
|-------|--------|----------------|-----------|-----------|
| Command | Execution | User Request → Workflow Command | Không chứa nghiệp vụ | P001 |
| Declaration | Definition | YAML → Workflow Definition | Không nhận code (WB001) | P003 |
| Definition | Definition | Definition → Versioned Workflow | Không thực thi (WB004) | P011 |
| Validation | Validation | Definition → Normalized Workflow | Validate trước khi chạy (WB003) | P011 |
| Resolution | Capability | Step Request → Resolved Capability | Không biết Agent (WB006) | P007 |
| Orchestration | Coordination | Normalized → Runtime Request | Không tự chạy — giao Runtime (WB004) | P001 |
| Publication | Observability | State Change → Workflow Event | Không chứa Business Data | P014 |

> **Điểm khác biệt cốt lõi so với S005:** Workflow Engine có 7 layers (không có Execution/State/Event layers) — 3 layer đó thuộc Runtime (SPEC-001). Orchestration **delegate** toàn bộ cho Runtime.

## Domains (6)

| Domain | Owner |
|--------|-------|
| Definition | Workflow |
| Validation | Workflow |
| Execution | Runtime (SPEC-001) |
| Coordination | Runtime (SPEC-001) |
| Capability | Runtime (S014) |
| Observability | Runtime (S011) |

Mọi domain: `contains_business_logic: false`.

## Dependency Rules

- Layer N → Layer N+1: được phép.
- Layer N → Layer N+2: không được phép.
- Không Circular Dependency.
- Không Skip Layer.
- Orchestration → Runtime: được phép (delegate).

## Communication Rules

- Contract · Context · Event.
- Ngoài ra đều bị cấm.

## Invariants

- Workflow Engine luôn Metadata Driven.
- Workflow Engine không biết Agent cụ thể.
- Workflow Engine không biết Plugin cụ thể.
- Workflow Engine không phụ thuộc Framework.
- Workflow Engine luôn Declarative.
- Workflow Engine luôn Event Driven.
- Workflow Engine luôn Contract First.

## Views

- **Layer view**: Command → Declaration → Definition → Validation → Resolution → Orchestration → Publication.
- **Dependency view**: Definition → Validation → Resolution → Orchestration → Runtime.
- **Data flow view**: Workflow Definition → Context → Artifact.
- **Event flow view**: Orchestration → Runtime → Event → Metrics → Dashboard.

## Quality

| Attribute | Mức |
|-----------|-----|
| Modularity | Cao |
| Coupling | Thấp |
| Cohesion | Cao |
| Extensibility | Rất cao |
| Testability | Cao |
| Evolvability | Rất cao |
| Determinism | 100% |

## Constraints (đều CẤM)

- Circular Dependency · Hidden Dependency · Shared Mutable State
- Code trong Workflow · Direct Agent Coupling · Direct Plugin Coupling
- Business Logic trong Workflow Engine

## Stability

- **Stable**: Layers, Domains.
- **Evolvable**: Workflow Schema, Contracts, Capabilities.
- **Replaceable**: Agents, Plugins, Workflows.

## Validation

Layering · Dependency · Coupling · Circular Dependency · Contract Compliance · Boundary Compliance (W004) · Principle Compliance.

## Machine-readable

```text
architecture.yaml
layer-model.yaml
domain-model.yaml
dependency-rules.yaml
communication-rules.yaml
architecture-matrix.yaml
architecture-decision-log.yaml
architecture-registry.yaml
architecture.schema.json
```

## Tham chiếu

- W001: `../W001-vision.md`
- W004: `../W004/boundaries.md`
- S005: `../../SPEC-001/S005/architecture.yaml` (mẫu cấu trúc)
- S010: `../../SPEC-001/S010/execution-flow.md`
- S011: `../../SPEC-001/S011/observability.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
