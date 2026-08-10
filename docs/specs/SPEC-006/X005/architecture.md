---
name: spec-006-x005-architecture
description: SPEC-006 X005 — Context Architecture. 7 layers.
agent: general
---

# X005 — Context Architecture

> **SPEC-006**: Context Engine · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Context Engine được cấu trúc như thế nào?**

## Architectural Decisions

- Context Engine là context management layer, không phải Database.
- Context transient — chỉ tồn tại trong vòng đời Execution.
- Context luôn isolated.
- Context Engine thực thi S010 EF008 — không định nghĩa lại flow.

## Layers (7)

| Layer | Domain | Invariant | Principle |
|-------|--------|-----------|-----------|
| Command | Execution | Không chứa nghiệp vụ | P001 |
| Allocation | Definition | Allocate ngoài Execution (XB001) | P009 |
| Population | Definition | Không chứa Business Data (XB006) | P009 |
| Validation | Validation | Cap Context không hợp lệ (XB003) | P011 |
| Distribution | Execution | Cap trực tiếp (XB004) | P002 |
| Collection | Execution | Giữ Context sau kết thúc (XB007) | P009 |
| Publication | Observability | Không chứa Business Data | P014 |

## Domains (4)

| Domain | Owner |
|--------|-------|
| Definition | Context |
| Validation | Context |
| Execution | Runtime (SPEC-001) |
| Observability | Runtime (S011) |

Mọi domain: `contains_business_logic: false`.

## Dependency Rules

- Layer N → Layer N+1: được phép.
- Layer N → Layer N+2: không được phép.
- Không Circular Dependency.

## Communication Rules

- Contract · Context · Event. Ngoài ra đều bị cấm.

## Invariants

- Context luôn Metadata Driven.
- Context luôn isolated.
- Context luôn Contract First.
- Context luôn Event Driven.

## Views

- **Layer view**: Command → Allocation → Population → Validation → Distribution → Collection → Publication.
- **Dependency view**: Allocation → Population → Validation → Distribution → Collection.
- **Data flow view**: Context → Context Grant → Context Result.
- **Event flow view**: Context → Event → Metrics → Dashboard.

## Quality

Modularity: Cao · Coupling: Thấp · Cohesion: Cao · Extensibility: Rất cao · Testability: Cao · Determinism: 100%.

## Constraints (đều CẤM)

- Circular Dependency · Hidden Dependency · Shared Mutable State · Business Data trong Context · Shared Context.

## Stability

- **Stable**: Layers, Domains.
- **Evolvable**: Context Schema, Contracts.
- **Replaceable**: Context Store, Distribution Strategy.

## Validation

Layering · Dependency · Coupling · Boundary Compliance (X004) · Principle Compliance.

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

- X001: `../X001-vision.md`
- X004: `../X004/boundaries.md`
- S010 EF008: `../../SPEC-001/S010/execution-flow.md`
- S011: `../../SPEC-001/S011/observability.md`
- Constitution: `docs/specs/SPEC-000/`
