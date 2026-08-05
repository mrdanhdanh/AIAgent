---
name: spec-001a-runtime-canonical-models
description: >
  SPEC-001A (Appendix) — Runtime Canonical Domain Model. 12 model chuẩn (RM-001..012),
  12 sections RM001-RM012. Single Source of Truth (P009) — mọi SPEC chỉ tham chiếu.
agent: general
---

# SPEC-001A — Runtime Canonical Domain Model

> **SPEC-001** Appendix · **Version**: 1.0.0 · **Trạng thái**: ✅ Frozen (2026-08-04)
> **Quy tắc bất biến**:
> **Không SPEC nào được phép tự định nghĩa lại `Execution`, `Context`, `Event`,
> `Artifact`, `Contract`, `Capability` hay các model chuẩn khác. Mọi SPEC chỉ
> được tham chiếu đến Canonical Models.**

## RM001 — Philosophy

- Một model chuẩn = một định nghĩa duy nhất (P009 Single Source of Truth).
- Mọi SPEC (S008, S009, S010...) tham chiếu, không định nghĩa lặp lại.
- Áp dụng cách của Kubernetes, OpenTelemetry, OpenAPI, CRD.

## RM002 — Model Principles

- Model **versioned** (P004).
- Model **immutable** sau Published (P010).
- Model có **owner** rõ ràng.
- Model có **lifecycle** chuẩn.
- Model có **invariants** (luật bất biến).
- Đổi model → RFC + ADR → version mới.

## RM003 — Canonical Models (12)

| ID | Model | Level | Owner |
|----|-------|-------|-------|
| RM-001 | Execution | Core | Runtime |
| RM-002 | Workflow | Core | Workflow |
| RM-003 | Phase | Core | Workflow |
| RM-004 | Task | Core | Phase |
| RM-005 | Context | Core | Runtime |
| RM-006 | State | Core | Runtime |
| RM-007 | Event | Core | Runtime |
| RM-008 | Artifact | Core | Runtime |
| RM-009 | Contract | Core | Component |
| RM-010 | Capability | Core | Registry |
| RM-011 | Metadata | Core | Varies |
| RM-012 | Execution Result | Core | Runtime |

## RM004 — Model Identity

Mỗi model có identity riêng — không dùng GUID lẫn lộn:

| Model | Identity |
|-------|----------|
| Execution | ExecutionID |
| Workflow | WorkflowID |
| Phase | PhaseID |
| Task | TaskID |
| Context | ContextID |
| State | StateID |
| Event | EventID |
| Artifact | ArtifactID |
| Contract | ContractID |
| Capability | CapabilityID |
| Metadata | MetadataID |
| Execution Result | ResultID |

## RM005 — Model Relationships

```text
Execution
    ↓
Workflow → Phase (1..N) → Task (1..N) → Capability (1)
Execution → Context (1)
Execution → State (1)
Execution → Events (N)
Execution → Artifacts (N)
Execution → Execution Result (1) → Artifacts (1..N)
```

Chi tiết cardinality: `runtime-model-relationships.yaml`

## RM006 — Model Ownership

| Model | Owner |
|-------|-------|
| Execution, Context, State, Event, Artifact, Execution Result | Runtime |
| Workflow, Phase | Workflow |
| Task | Phase |
| Contract | Component |
| Capability | Registry |
| Metadata | Varies |

> Ownership quan trọng cho Doctor.

## RM007 — Model Lifecycle

- **Execution**: Created → Running → Completed → Archived
- **Workflow**: Draft → Approved → Running → Completed → Archived
- **Artifact**: Created → Published → Consumed → Archived
- **Contract**: Draft → Published → Deprecated
- **Capability**: Registered → Available → Deprecated → Removed

> S009 (State Machine) chỉ tham chiếu.

## RM008 — Model Invariants

- **Execution**: luôn có đúng 1 Runtime, 1 Workflow, 1 Context.
- **Artifact**: Immutable.
- **Context**: Không chia sẻ.
- **Event**: Append-only.
- **State**: Thuộc Runtime.
- **Contract**: Immutable sau Published.

## RM009 — Model Mapping

```text
Execution → State Machine → Execution Flow → Metrics → Events
```

Dashboard đọc toàn bộ từ mapping này.

## RM010 — Model Validation

Doctor kiểm tra (chi tiết `runtime-model-validation.yaml`):

- Execution phải có [Workflow, Context, State].
- Context phải có [Execution].
- Event phải có [Execution, lineage].
- Artifact phải có [checksum, version].
- Contract phải có [owner, version].
- Capability phải có [implementation_ref].
- Execution Result phải có [Execution, Artifact].

## RM011 — Registry

`runtime-model-registry.yaml` — RM-### → name → owner → version → status → lifecycle. Doctor đọc một file.

## RM012 — Success Criteria

- 12 canonical models đầy đủ.
- Mọi model có purpose/owner/lifecycle/invariants/relationships/fields/constraints.
- Model Dependency Graph rõ ràng.
- Không SPEC nào định nghĩa lại model chuẩn.
- Doctor validate không lỗi.

## Model Dependency Graph

```text
Execution
 │
 ├── Workflow
 ├── Context
 ├── State
 ├── Event
 ├── Artifact
 ├── Metrics
 └── Execution Result
```

> Mọi SPEC phía sau tham chiếu sơ đồ này.

## Tham chiếu

- `runtime-models.yaml` — nguồn dữ liệu chuẩn (12 models).
- `runtime-model-registry.yaml` — RM011.
- `runtime-model-relationships.yaml` — RM005.
- `runtime-model-validation.yaml` — RM010.
- `runtime-models.schema.json` — validate cấu trúc.
- S007: `../S007/contracts.yaml`
- S008 (Data Model), S009 (State Machine), S010 (Execution Flow) tham chiếu tại đây.
- Constitution: `docs/specs/SPEC-000/`
