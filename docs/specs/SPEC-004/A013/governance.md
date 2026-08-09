---
name: spec-004-a013-governance
description: >
  SPEC-004 A013 — Agent Governance. Trả lời: Agent được thực thi luật như thế
  nào? Agent chịu Governance của Runtime (S013) — chỉ thêm Agent-level.
  Mirror C013 (SPEC-003).
agent: general
---

# A013 — Agent Governance

> **SPEC-004**: Agent System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Agent được thực thi luật như thế nào?**

## AG001 — Governance Philosophy

- Governance là cơ chế thực thi luật.
- Agent không quyết định luật.
- Agent chỉ thực thi luật đã được định nghĩa (S012/S013).
- Governance độc lập Business Logic.

## AG002 — Governance Principles

- Constitution First · Policy Binding First (A012) · Contract First (A007) · Boundary First (A004) · Least Privilege · Deterministic · Auditable · Versioned.

## AG003 — Governance Scope

**Thực thi:**

- Constitution (SPEC-000)
- Policy Binding (A012)
- Contract (A007)
- Boundary (A004)
- Permission (S013)
- Version Compatibility

**Không thực thi:**

- Business Rule
- Domain Rule

## AG003A — Governance Stack

```text
Constitution
    ↓
Boundary (A004)
    ↓
Contract (A007)
    ↓
Policy Binding (A012)
    ↓
Permission
    ↓
Execution Decision
```

## AG004 — Constitution Enforcement

- Tham chiếu S013 GV004 — Runtime thực thi.
- Vi phạm Constitution → Aborted (ST-014).

## AG005 — Policy Binding Enforcement

- Resolve binding (A012 AP013).
- Validate binding (A012 AP014).
- Apply (S013 enforce).
- Audit (S011).

**Rules:** Chỉ enforce binding Active (A012 AP002B); Binding Invalid → Agent không chạy (Validation Failure).

## AG005A — Conflict Resolution

- Tham chiếu S013 GV005A: Highest Priority → Most Specific → Newest Version → **Deny Wins**.

## AG006 — Contract Enforcement

- Tham chiếu A007 + S013 GV006.
- Contract failure → Failed (ST-009).

## AG007 — Boundary Enforcement

- Tham chiếu A004 + S013 GV007.
- Boundary violation → Deny + Event.

## AG008 — Permission Enforcement

- Tham chiếu S013 GV008 — Deny mặc định.

## AG009 — Version Governance

- SemVer · Compatibility · Deprecated · Breaking Change (S013 GV009).

## AG010 — Compatibility Governance

- Contract · Capability · Plugin · **Agent** (S013 GV010).

## AG011 — Validation Pipeline

```text
Constitution
    ↓
Boundary (A004)
    ↓
Contract (A007)
    ↓
Policy Binding (A012)
    ↓
Execution (Runtime SPEC-001)
```

## AG011A — Governance Modes

- **Strict** · **Compatible** · **Simulation** · **Audit Only** (S013 GV011A).

## AG012 — Governance Decision

**Model:** `id/agent/rule/result/reason/timestamp/severity`.

**Result:** Allow · Deny · Suspend · Retry · Escalate.

**Decision Priority:**

| Level | Priority |
|-------|----------|
| Constitution | 100 |
| Boundary | 90 |
| Contract | 80 |
| Policy Binding | 70 |
| Permission | 60 |

**Decision Matrix:**

| Validation | Decision |
|------------|----------|
| Constitution Fail | Abort |
| Boundary Fail | Deny |
| Contract Fail | Failed |
| Binding Invalid | Ignore (Agent không chạy) |
| Permission Fail | Deny |
| Compatibility Fail | Suspend |

## AG012A — Governance Lifecycle

```text
Resolved → Validated → Applied → Audited → Archived
```

(S013 GV012A)

## AG013 — Governance Events

- AGENT_GOVERNANCE_VALIDATED · AGENT_BOUNDARY_DENIED · AGENT_BINDING_APPLIED · AGENT_CONTRACT_VALIDATED · AGENT_PERMISSION_DENIED · AGENT_VERSION_CONFLICT · AGENT_COMPATIBILITY_FAILED.
- S011 reuse trực tiếp.

## AG014 — Governance Traceability

```text
Agent
    ↓
Policy Binding (A012)
    ↓
Contract (A007)
    ↓
Boundary (A004)
    ↓
Constitution
```

## AG014A — Governance Mapping

```text
Agent Governance
    ↓
Binding (A012) → Contract (A007) → Boundary (A004)
    ↓
Requirement (A002) → Principle → Constitution
```

## AG015 — Governance Metrics

- violations · denied · warnings · binding_usage · contract_failures · boundary_failures · version_conflicts.

## AG016 — Machine-readable

```text
agent-governance.yaml
agent-governance-stack.yaml
agent-binding-enforcement.yaml
agent-governance-matrix.yaml
agent-governance-events.yaml
agent-governance-decisions.yaml
agent-governance-lifecycle.yaml
agent-governance-metrics.yaml
agent-governance-registry.yaml
agent-governance.schema.json
```

## AG017 — Governance Validation

Doctor kiểm tra:

- Missing Enforcement
- Invalid Binding (A012)
- Invalid Contract (A007)
- Boundary Violation (A004)
- Constitution Violation
- Version Conflict

## AG018 — Success Criteria

- Agent luôn chịu Governance của Runtime (S013).
- Mọi binding được enforce (A012).
- Mọi contract được validate (A007).
- Không Agent nào vượt Boundary (A004).
- Agent không bypass Governance (AB009).
- Doctor xác minh từ machine-readable.

## Tham chiếu

- A004: `../A004/boundaries.md`
- A007: `../A007/contracts.md`
- A012: `../A012/policies.md`
- C013: `../../SPEC-003/C013/governance.md` (mẫu)
- S013: `../../SPEC-001/S013/governance.md` (enforce)
- S011: `../../SPEC-001/S011/observability.md`
- Constitution: `docs/specs/SPEC-000/`