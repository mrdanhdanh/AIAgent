---
name: spec-003-c014-registry
description: >
  SPEC-003 C014 — Capability Registry. Trả lời: Capability được đăng ký và
  phân giải như thế nào? Capability đăng ký trong Registry của Runtime (S014
  capability-registry). Mirror W014 (SPEC-002).
agent: general
---

# C014 — Capability Registry

> **SPEC-003**: Capability System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Capability được đăng ký và phân giải như thế nào?**

## CR001 — Registry Philosophy

- Capability Registry là SSOT cho Capability Metadata.
- Capability không hardcode — mọi năng lực đăng ký trong S014.
- Mọi Resolution đều đi qua Registry.
- Registry không chứa Business Logic.

## CR002 — Registry Principles

- Metadata First · Contract First (C007) · Versioned · Discoverable · Immutable (Published) · Traceable.

## CR003 — Registry Categories

Capability Registry là 1 category của S014 (`capability-registry`):

- Capability Definition
- Capability Version
- Capability Binding (C012)

## CR003A — Registry Domains

- Capability Domain · Definition Domain · Binding Domain.

## CR004 — Canonical Capability Registry Entry

```yaml
entry:
  fields: [id, type, category, version, status, owner, references, compatibility, lifecycle, metadata]
```

(S014 RG004) — thiếu bất kỳ field nào → Invalid Entry.

## CR005 — Registry Resolution

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
Policy Binding Check (C012)
    ↓
Governance Check (S013)
    ↓
Resolved
```

## CR005A — Resolution Failure

- NotFound · Invalid · Deprecated · Incompatible · Forbidden · Ambiguous (S014 RG005A).

## CR005B — Resolution Priority

```text
Exact → Compatible → Latest Stable → Latest → Failure
```

(S014 RG005B)

## CR006 — Resolution Rules

- Resolve theo ID (S014).
- Nhiều Version → Resolution Priority.
- Không Resolve Entry Deprecated nếu có bản Active.
- Không Resolve Entry Invalid.

## CR007 — Version Resolution

1. Exact Version · 2. Compatible Version · 3. Latest Compatible · 4. Failure (S014 RG007).

## CR008 — Registry Relationships

```text
Capability → Definition → Version
Capability → Mapping → Agent (SPEC-004) / Plugin (S017)
Capability → Binding → Policy (S012)
```

## CR008A — Registry Dependency

```text
Capability → Definition → Registry (S014)
Mapping → Agent (SPEC-004)
Binding → Policy (S012)
```

Không circular — DAG (S014 RG008A).

## CR009 — Registry Ownership

| Entry | Owner |
|-------|-------|
| Capability Entry | Capability Team |
| Binding Entry | Capability Team |
| Registry (S014) | Runtime |

## CR009A — Registry Constraints

- Không Duplicate Capability ID · Không Duplicate Version · Không Broken Reference (S014) · Không Circular Reference (S014) · Không Orphan Entry (S014) · Không Multiple Active Version · **Không Hardcode Mapping (CB007)**.

## CR010 — Registry Lifecycle

```text
Draft → Published → Deprecated → Retired
```

(S014 RG010) — Published → Immutable.

## CR010A — Registry Governance

```text
Published → Immutable → Governance (S013) → Deprecated → Retired
```

(S014 RG010A)

## CR011 — Registry Validation

Doctor kiểm tra: Duplicate Capability ID · Broken Reference (S014) · Circular Reference (S014) · Orphan Entry (S014) · Duplicate Active Version · Missing Compatibility · **Hardcode Mapping (CB007)**.

## CR012 — Registry Events

- CAPABILITY_REGISTERED · CAPABILITY_UPDATED · CAPABILITY_DEPRECATED · CAPABILITY_RETIRED · CAPABILITY_RESOLUTION_FAILED · CAPABILITY_COMPATIBILITY_FAILED.

> S011 reuse trực tiếp.

## CR013 — Registry Metrics

- capability_entries · active_capabilities · deprecated_capabilities · resolution_success_rate · resolution_time · failed_resolution.

## CR014 — Machine-readable

```text
capability-registry.yaml
capability-registry-model.yaml
capability-registry-domains.yaml
capability-registry-resolution.yaml
capability-registry-events.yaml
capability-registry-lifecycle.yaml
capability-registry-constraints.yaml
capability-registry-traceability.yaml
capability-registry-metrics.yaml
capability-registry-validation.yaml
capability-registry-registry.yaml
capability-registry.schema.json
```

> `capability-registry-registry.yaml` — Dashboard chỉ cần đọc một file.

## CR015 — Success Criteria

- Mọi Capability đăng ký trong S014.
- Mọi Resolution qua Registry — không hardcode.
- Mọi Entry versioned.
- Mọi Resolution truy vết được.
- Không hardcode mapping (CB007).
- Doctor xác minh từ machine-readable.
- Capability Registry không định nghĩa lại S014.

## Tham chiếu

- C009: `../C009/state-machine.md`
- C012: `../C012/policies.md`
- W014: `../../SPEC-002/W014/registry.md` (mẫu)
- S008: `../../SPEC-001/S008/runtime-data-model.yaml`
- S011: `../../SPEC-001/S011/observability.md`
- S013: `../../SPEC-001/S013/governance.md`
- S014: `../../SPEC-001/S014/registry.md` (registry chính)
- Constitution: `docs/specs/SPEC-000/`
