---
name: spec-005-r005-architecture
description: SPEC-005 R005 — Registry Architecture. 7 layers.
agent: general
---

# R005 — Registry Architecture

> **SPEC-005**: Registry · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Registry được cấu trúc như thế nào?**

## Architectural Decisions

- Registry là metadata system, không phải Database.
- Registry thực thi S014 — không định nghĩa lại model.
- Storage-agnostic.
- Registry không chứa Domain Logic.

## Layers (7)

| Layer | Domain | Invariant | Principle |
|-------|--------|-----------|-----------|
| Command | Execution | Không chứa nghiệp vụ | P001 |
| Declaration | Definition | Không nhận code (RB001) | P003 |
| Storage | Definition | Không lưu Business Data (RB002) | P009 |
| Validation | Validation | Validate trước khi lưu (RB003) | P011 |
| Resolution | Capability | Không tự resolve (RB004) | P007 |
| Query | Data | Không phụ thuộc Storage cụ thể (RB006) | P003 |
| Publication | Observability | Không chứa Business Data | P014 |

## Domains (6)

| Domain | Owner |
|--------|-------|
| Definition | Registry |
| Validation | Registry |
| Capability | Runtime (S014) |
| Data | Registry |
| Execution | Runtime (SPEC-001) |
| Observability | Runtime (S011) |

Mọi domain: `contains_business_logic: false`.

## Dependency Rules

- Layer N → Layer N+1: được phép.
- Layer N → Layer N+2: không được phép.
- Không Circular Dependency.
- Resolution → Runtime: được phép (delegate S014).

## Communication Rules

- Contract · Event. Ngoài ra đều bị cấm.

## Invariants

- Registry luôn Metadata Driven.
- Registry không biết Storage implementation.
- Registry luôn Contract First.
- Registry luôn Event Driven.

## Views

- **Layer view**: Command → Declaration → Storage → Validation → Resolution → Query → Publication.
- **Dependency view**: Storage → Validation → Resolution → Runtime.
- **Event flow view**: Registry → Event → Metrics → Dashboard.

## Quality

Modularity: Cao · Coupling: Thấp · Cohesion: Cao · Extensibility: Rất cao · Testability: Cao · Determinism: 100%.

## Constraints (đều CẤM)

- Circular Dependency · Hidden Dependency · Shared Mutable State · Business Data trong Registry · Direct Storage Coupling.

## Stability

- **Stable**: Layers, Domains.
- **Evolvable**: Entry Schema, Contracts, Domains.
- **Replaceable**: Storage, Cache.

## Validation

Layering · Dependency · Coupling · Boundary Compliance (R004) · Principle Compliance.

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

- R001: `../R001-vision.md`
- R004: `../R004/boundaries.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
