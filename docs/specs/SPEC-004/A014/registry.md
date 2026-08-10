---
name: spec-004-a014-registry
description: >
  SPEC-004 A014 — Agent Registry. Trả lời: Agent được đăng ký và phân giải như
  thế nào? Agent đăng ký trong Registry của Runtime (S014 agent-registry).
  Mirror C014 (SPEC-003).
agent: general
---

# A014 — Agent Registry

> **SPEC-004**: Agent System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Agent được đăng ký và phân giải như thế nào?**

## AR001 — Registry Philosophy

- Agent Registry là SSOT cho Agent Metadata.
- Agent không hardcode — mọi Agent đăng ký trong S014.
- Mọi Resolution đều đi qua Registry.
- Registry không chứa Business Logic.

## AR002 — Registry Principles

- Metadata First · Contract First (A007) · Versioned · Discoverable · Immutable (Published) · Traceable.

## AR003 — Registry Categories

Agent Registry là 1 category của S014 (`agent-registry`):

- Agent Definition
- Agent Version
- Agent Binding (A012)

## AR003A — Registry Domains

- Agent Domain · Definition Domain · Binding Domain.

## AR004 — Canonical Agent Registry Entry

```yaml
entry:
  fields: [id, type, category, version, status, owner, references, compatibility, lifecycle, metadata]
```

(S014 RG004) — thiếu bất kỳ field nào → Invalid Entry.

## AR005 — Registry Resolution

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
Policy Binding Check (A012)
    ↓
Governance Check (S013)
    ↓
Resolved
```

## AR005A — Resolution Failure

- NotFound · Invalid · Deprecated · Incompatible · Forbidden · Ambiguous (S014 RG005A).

## AR005B — Resolution Priority

```text
Exact → Compatible → Latest Stable → Latest → Failure
```

(S014 RG005B)

## AR006 — Resolution Rules

- Resolve theo ID (S014).
- Nhiều Version → Resolution Priority.
- Không Resolve Entry Deprecated nếu có bản Active.
- Không Resolve Entry Invalid.

## AR007 — Version Resolution

1. Exact Version · 2. Compatible Version · 3. Latest Compatible · 4. Failure (S014 RG007).

## AR008 — Registry Relationships

```text
Agent → Definition → Version
Agent → Mapping → Capability (SPEC-003)
Agent → Binding → Policy (S012)
```

## AR008A — Registry Dependency

```text
Agent → Definition → Registry (S014)
Mapping → Capability (SPEC-003)
Binding → Policy (S012)
```

Không circular — DAG (S014 RG008A).

## AR009 — Registry Ownership

| Entry | Owner |
|-------|-------|
| Agent Entry | Agent Team |
| Binding Entry | Agent Team |
| Registry (S014) | Runtime |

## AR009A — Registry Constraints

- Không Duplicate Agent ID · Không Duplicate Version · Không Broken Reference (S014) · Không Circular Reference (S014) · Không Orphan Entry (S014) · Không Multiple Active Version · **Không Hardcode Capability Mapping (AB007)**.

## AR010 — Registry Lifecycle

```text
Draft → Published → Deprecated → Retired
```

(S014 RG010) — Published → Immutable.

## AR010A — Registry Governance

```text
Published → Immutable → Governance (S013) → Deprecated → Retired
```

(S014 RG010A)

## AR011 — Registry Validation

Doctor kiểm tra: Duplicate Agent ID · Broken Reference (S014) · Circular Reference (S014) · Orphan Entry (S014) · Duplicate Active Version · Missing Compatibility · **Hardcode Capability Mapping (AB007)**.

## AR012 — Registry Events

- AGENT_REGISTERED · AGENT_UPDATED · AGENT_REGISTRY_DEPRECATED · AGENT_REGISTRY_RETIRED · AGENT_RESOLUTION_FAILED · AGENT_REGISTRY_COMPATIBILITY_FAILED.

> S011 reuse trực tiếp.

## AR013 — Registry Metrics

- agent_entries · active_agents · deprecated_agents · resolution_success_rate · resolution_time · failed_resolution.

## AR014 — Machine-readable

```text
agent-registry.yaml
agent-registry-model.yaml
agent-registry-domains.yaml
agent-registry-resolution.yaml
agent-registry-events.yaml
agent-registry-lifecycle.yaml
agent-registry-constraints.yaml
agent-registry-traceability.yaml
agent-registry-metrics.yaml
agent-registry-validation.yaml
agent-registry-registry.yaml
agent-registry.schema.json
```

> `agent-registry-registry.yaml` — Dashboard chỉ cần đọc một file.

## AR015 — Success Criteria

- Mọi Agent đăng ký trong S014.
- Mọi Resolution qua Registry — không hardcode.
- Mọi Entry versioned.
- Mọi Resolution truy vết được.
- Không hardcode capability mapping (AB007).
- Doctor xác minh từ machine-readable.
- Agent Registry không định nghĩa lại S014.

## Tham chiếu

- A009: `../A009/state-machine.md`
- A012: `../A012/policies.md`
- C014: `../../SPEC-003/C014/registry.md` (mẫu)
- S008: `../../SPEC-001/S008/runtime-data-model.yaml`
- S011: `../../SPEC-001/S011/observability.md`
- S013: `../../SPEC-001/S013/governance.md`
- S014: `../../SPEC-001/S014/registry.md` (registry chính)
- Constitution: `docs/specs/SPEC-000/`