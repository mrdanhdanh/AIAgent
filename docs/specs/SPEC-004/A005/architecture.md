---
name: spec-004-a005-architecture
description: >
  SPEC-004 A005 — Agent Architecture. Trả lời: Agent System được cấu trúc
  như thế nào? 7 layers, 6 domains — không lặp lại Execution/State/Event của
  Runtime (SPEC-001). Mirror C005 (SPEC-003).
agent: general
---

# A005 — Agent Architecture

> **SPEC-004**: Agent System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Agent System được cấu trúc như thế nào?**

Không mô tả implementation — chỉ mô tả kiến trúc logic.

## Architectural Decisions

- Agent System là **Declarator + Orchestrator**, không phải Executor.
- Agent System ưu tiên Metadata hơn Configuration.
- Agent System chỉ phụ thuộc Abstraction.
- Agent System không biết Implementation.
- Agent System không chứa Domain Logic.
- Agent System được thiết kế để Evolution mà không phá vỡ Core.
- **Execution thuộc Runtime (SPEC-001) — không lặp lại.**
- **Orchestration qua Workflow (SPEC-002) — không tự điều phối.**

## Layers (7)

```text
Level 1  Command        → Nhận Agent Request
Level 2  Declaration    → Nhận khai báo metadata, schema check
Level 3  Definition     → Agent Model + Version + Group
Level 4  Validation     → Validate cấu trúc + Compatibility (S013 GV010)
Level 5  Registration   → Đăng ký S014 + Capability Mapping (SPEC-003)
Level 6  Orchestration  → Điều phối qua Workflow (SPEC-002) + delegate Runtime (SPEC-001)
Level 7  Publication    → Publish Event/Metrics/Trace/Audit (S011)
```

| Layer | Domain | Input → Output | Invariant | Principle |
|-------|--------|----------------|-----------|-----------|
| Command | Execution | Request → Command | Không chứa nghiệp vụ | P001 |
| Declaration | Definition | metadata → Definition | Không nhận code (AB001) | P003 |
| Definition | Definition | Definition → Versioned | Không đăng ký trực tiếp (AB002) | P011 |
| Validation | Validation | Definition → Validated | Validate trước khi đăng ký (AB003) | P011 |
| Registration | Mapping | Validated → Registry Entry + Capability Mapping | Không hardcode mapping (AB007) | P003 |
| Orchestration | Orchestration | Request → Workflow Request | Không tự chạy — giao Runtime (AB004) | P001 |
| Publication | Observability | State Change → Event | Không chứa Business Data | P014 |

> **Điểm khác biệt so với C005:** Có **Orchestration layer** (điều phối qua Workflow SPEC-002 + delegate Runtime SPEC-001) — đặc thù của Agent System.

## Domains (6)

| Domain | Owner |
|--------|-------|
| Definition | Agent |
| Validation | Agent |
| Mapping | Agent |
| Orchestration | Workflow Engine (SPEC-002) |
| Execution | Runtime (SPEC-001) |
| Observability | Runtime (S011) |

Mọi domain: `contains_business_logic: false`.

## Dependency Rules

- Layer N → Layer N+1: được phép.
- Layer N → Layer N+2: không được phép.
- Không Circular Dependency.
- Không Skip Layer.
- Orchestration → Workflow: được phép (delegate SPEC-002).
- Orchestration → Runtime: được phép (delegate SPEC-001).

## Communication Rules

- Contract · Context · Event.
- Ngoài ra đều bị cấm.

## Invariants

- Agent System luôn Metadata Driven.
- Agent System không biết Agent cụ thể.
- Agent System không biết Plugin cụ thể.
- Agent System không phụ thuộc Framework.
- Agent System luôn Declarative.
- Agent System luôn Event Driven.
- Agent System luôn Contract First.

## Views

- **Layer view**: Command → Declaration → Definition → Validation → Registration → Orchestration → Publication.
- **Dependency view**: Definition → Validation → Registration → Orchestration → Workflow → Runtime.
- **Data flow view**: Agent Definition → Registry Entry → Capability Mapping.
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
- Code trong Agent · Direct Agent Coupling · Direct Plugin Coupling
- Business Logic trong Agent System

## Stability

- **Stable**: Layers, Domains.
- **Evolvable**: Agent Schema, Contracts, Groups.
- **Replaceable**: Agents, Plugins, Capabilities.

## Validation

Layering · Dependency · Coupling · Circular Dependency · Contract Compliance · Boundary Compliance (A004) · Principle Compliance.

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

- A001: `../A001-vision.md`
- A004: `../A004/boundaries.md`
- C005: `../../SPEC-003/C005/architecture.yaml` (mẫu cấu trúc)
- S011: `../../SPEC-001/S011/observability.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
