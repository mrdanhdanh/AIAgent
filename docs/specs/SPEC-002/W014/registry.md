---
name: spec-002-w014-registry
description: >
  SPEC-002 W014 — Workflow Registry. Trả lời: Workflow được đăng ký và phân
  giải như thế nào? Workflow đăng ký trong Registry của Runtime (S014
  workflow-registry). Mirror S014 (SPEC-001).
agent: general
---

# W014 — Workflow Registry

> **SPEC-002**: Workflow Engine · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Workflow được đăng ký và phân giải như thế nào?**

## WR001 — Registry Philosophy

- Workflow Registry là SSOT cho Workflow Metadata.
- Workflow không hardcode — mọi Workflow đăng ký trong S014.
- Mọi Resolution đều đi qua Registry.
- Registry không chứa Business Logic.

## WR002 — Registry Principles

- Metadata First · Contract First (W007) · Versioned · Discoverable · Immutable (Published) · Traceable.

## WR003 — Registry Categories

Workflow Registry là 1 category của S014 (`workflow-registry`):

- Workflow Definition
- Workflow Version
- Workflow Binding (W012)

## WR003A — Registry Domains

- Workflow Domain · Definition Domain · Binding Domain.

## WR004 — Canonical Workflow Registry Entry

```yaml
entry:
  fields: [id, type, category, version, status, owner, references, compatibility, lifecycle, metadata]
```

(S014 RG004) — thiếu bất kỳ field nào → Invalid Entry.

## WR005 — Registry Resolution

```text
Request
    ↓
Normalize
    ↓
Lookup (S014)
    ↓
Candidate Selection
    ↓
Compatibility Check
    ↓
Policy Binding Check (W012)
    ↓
Governance Check (S013)
    ↓
Resolved
```

## WR005A — Resolution Failure

- NotFound · Invalid · Deprecated · Incompatible · Forbidden · Ambiguous (S014 RG005A).

## WR005B — Resolution Priority

```text
Exact → Compatible → Latest Stable → Latest → Failure
```

(S014 RG005B)

## WR006 — Resolution Rules

- Resolve theo ID (S014).
- Nhiều Version → Resolution Priority.
- Không Resolve Entry Deprecated nếu có bản Active.
- Không Resolve Entry Invalid.

## WR007 — Version Resolution

1. Exact Version · 2. Compatible Version · 3. Latest Compatible · 4. Failure (S014 RG007).

## WR008 — Registry Relationships

```text
Workflow → Definition → Step/Branch/Gate
Workflow → Binding → Policy (S012)
Workflow → Execution (S008)
```

## WR008A — Registry Dependency

```text
Workflow → Definition → Registry (S014)
Binding → Policy (S012)
```

Không circular — DAG (S014 RG008A).

## WR009 — Registry Ownership

| Entry | Owner |
|-------|-------|
| Workflow Entry | Workflow Team |
| Binding Entry | Workflow Team |
| Registry (S014) | Runtime |

## WR009A — Registry Constraints

- Không Duplicate Workflow ID · Không Duplicate Version · Không Broken Reference (S014) · Không Circular Reference (S014) · Không Orphan Entry (S014) · Không Multiple Active Version.

## WR010 — Registry Lifecycle

```text
Draft → Published → Deprecated → Retired
```

(S014 RG010) — Published → Immutable.

## WR010A — Registry Governance

```text
Published → Immutable → Governance (S013) → Deprecated → Retired
```

(S014 RG010A)

## WR011 — Registry Validation

Doctor kiểm tra: Duplicate Workflow ID · Broken Reference (S014) · Circular Reference (S014) · Orphan Entry (S014) · Duplicate Active Version · Missing Compatibility.

## WR012 — Registry Events

- WORKFLOW_REGISTERED · WORKFLOW_UPDATED · WORKFLOW_DEPRECATED · WORKFLOW_RETIRED · WORKFLOW_RESOLUTION_FAILED · WORKFLOW_COMPATIBILITY_FAILED.

> S011 reuse trực tiếp.

## WR013 — Registry Metrics

- workflow_entries · active_workflows · deprecated_workflows · resolution_success_rate · resolution_time · failed_resolution.

## WR014 — Machine-readable

```text
workflow-registry.yaml
workflow-registry-model.yaml
workflow-registry-domains.yaml
workflow-registry-resolution.yaml
workflow-registry-events.yaml
workflow-registry-lifecycle.yaml
workflow-registry-constraints.yaml
workflow-registry-traceability.yaml
workflow-registry-metrics.yaml
workflow-registry-validation.yaml
workflow-registry-registry.yaml
workflow-registry.schema.json
```

> `workflow-registry-registry.yaml` — Dashboard chỉ cần đọc một file.

## WR015 — Success Criteria

- Mọi Workflow đăng ký trong S014.
- Mọi Resolution qua Registry — không hardcode.
- Mọi Entry versioned.
- Mọi Resolution truy vết được.
- Doctor xác minh từ machine-readable.
- Workflow Registry không định nghĩa lại S014.

## Tham chiếu

- W009: `../W009/state-machine.md`
- W012: `../W012/policies.md`
- S008: `../../SPEC-001/S008/runtime-data-model.yaml`
- S011: `../../SPEC-001/S011/observability.md`
- S013: `../../SPEC-001/S013/governance.md`
- S014: `../../SPEC-001/S014/registry.md` (mẫu + registry chính)
- Constitution: `docs/specs/SPEC-000/`
