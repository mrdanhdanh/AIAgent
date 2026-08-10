---
name: spec-003-c005-architecture
description: >
  SPEC-003 C005 — Capability Architecture. Trả lời: Capability System được
  cấu trúc như thế nào? 7 layers, 6 domains — không lặp lại Execution/State/
  Event của Runtime (SPEC-001). Mirror W005 (SPEC-002).
agent: general
---

# C005 — Capability Architecture

> **SPEC-003**: Capability System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Capability System được cấu trúc như thế nào?**

Không mô tả implementation — chỉ mô tả kiến trúc logic.

## Architectural Decisions

- Capability System là **Declarator + Resolver**, không phải Executor.
- Capability System ưu tiên Metadata hơn Configuration.
- Capability System chỉ phụ thuộc Abstraction.
- Capability System không biết Implementation.
- Capability System không chứa Domain Logic.
- Capability System được thiết kế để Evolution mà không phá vỡ Core.
- **Resolution/Execution thuộc Runtime (SPEC-001 EF007) — không lặp lại.**

## Layers (7)

```text
Level 1  Command        → Nhận Capability Request
Level 2  Declaration    → Nhận khai báo metadata, schema check
Level 3  Definition     → Capability Model + Version + Group
Level 4  Validation     → Validate cấu trúc + Compatibility (S013 GV010)
Level 5  Registration   → Đăng ký S014 + Mapping Agent/Plugin
Level 6  Resolution     → Delegate Runtime (EF007) + Fallback
Level 7  Publication    → Publish Event/Metrics/Trace/Audit (S011)
```

| Layer | Domain | Input → Output | Invariant | Principle |
|-------|--------|----------------|-----------|-----------|
| Command | Execution | Request → Command | Không chứa nghiệp vụ | P001 |
| Declaration | Definition | metadata → Definition | Không nhận code (CB001) | P003 |
| Definition | Definition | Definition → Versioned | Không đăng ký trực tiếp (CB002) | P011 |
| Validation | Validation | Definition → Validated | Validate trước khi đăng ký (CB003) | P011 |
| Registration | Mapping | Validated → Registry Entry | Không hardcode mapping (CB007) | P003 |
| Resolution | Capability | Request → Resolved | Không tự resolve — giao Runtime (CB004) | P007 |
| Publication | Observability | State Change → Event | Không chứa Business Data | P014 |

> **Điểm khác biệt so với W005:** Có **Registration layer** (đăng ký S014 + mapping Agent/Plugin) — đặc thù của Capability System.

## Domains (6)

| Domain | Owner |
|--------|-------|
| Definition | Capability |
| Validation | Capability |
| Mapping | Capability |
| Capability | Runtime (S014) |
| Execution | Runtime (SPEC-001) |
| Observability | Runtime (S011) |

Mọi domain: `contains_business_logic: false`.

## Dependency Rules

- Layer N → Layer N+1: được phép.
- Layer N → Layer N+2: không được phép.
- Không Circular Dependency.
- Không Skip Layer.
- Resolution → Runtime: được phép (delegate EF007).

## Communication Rules

- Contract · Context · Event.
- Ngoài ra đều bị cấm.

## Invariants

- Capability System luôn Metadata Driven.
- Capability System không biết Agent cụ thể.
- Capability System không biết Plugin cụ thể.
- Capability System không phụ thuộc Framework.
- Capability System luôn Declarative.
- Capability System luôn Event Driven.
- Capability System luôn Contract First.

## Views

- **Layer view**: Command → Declaration → Definition → Validation → Registration → Resolution → Publication.
- **Dependency view**: Definition → Validation → Registration → Resolution → Runtime.
- **Data flow view**: Capability Definition → Registry Entry → Agent Mapping.
- **Event flow view**: Resolution → Runtime → Event → Metrics → Dashboard.

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
- Code trong Capability · Direct Agent Coupling · Direct Plugin Coupling
- Business Logic trong Capability System

## Stability

- **Stable**: Layers, Domains.
- **Evolvable**: Capability Schema, Contracts, Groups.
- **Replaceable**: Agents, Plugins, Capabilities.

## Validation

Layering · Dependency · Coupling · Circular Dependency · Contract Compliance · Boundary Compliance (C004) · Principle Compliance.

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

- C001: `../C001-vision.md`
- C004: `../C004/boundaries.md`
- W005: `../../SPEC-002/W005/architecture.yaml` (mẫu cấu trúc)
- S010 EF007: `../../SPEC-001/S010/execution-flow.md`
- S011: `../../SPEC-001/S011/observability.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
