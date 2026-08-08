---
name: spec-003-c013-governance
description: >
  SPEC-003 C013 — Capability Governance. Trả lời: Capability được thực thi
  luật như thế nào? Capability chịu Governance của Runtime (S013) — chỉ thêm
  Capability-level (binding enforcement). Mirror W013 (SPEC-002).
agent: general
---

# C013 — Capability Governance

> **SPEC-003**: Capability System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Capability được thực thi luật như thế nào?**

## CG001 — Governance Philosophy

- Governance là cơ chế thực thi luật.
- Capability không quyết định luật.
- Capability chỉ thực thi luật đã được định nghĩa (S012/S013).
- Governance độc lập Business Logic.

## CG002 — Governance Principles

- Constitution First · Policy Binding First (C012) · Contract First (C007) · Boundary First (C004) · Least Privilege · Deterministic · Auditable · Versioned.

## CG003 — Governance Scope

**Thực thi:**

- Constitution (SPEC-000)
- Policy Binding (C012)
- Contract (C007)
- Boundary (C004)
- Permission (S013)
- Version Compatibility

**Không thực thi:**

- Business Rule
- Domain Rule

## CG003A — Governance Stack

```text
Constitution
    ↓
Boundary (C004)
    ↓
Contract (C007)
    ↓
Policy Binding (C012)
    ↓
Permission
    ↓
Execution Decision
```

## CG004 — Constitution Enforcement

- Tham chiếu S013 GV004 — Runtime thực thi.
- Vi phạm Constitution → Aborted (ST-014).

## CG005 — Policy Binding Enforcement

- Resolve binding (C012 CP013).
- Validate binding (C012 CP014).
- Apply (S013 enforce).
- Audit (S011).

**Rules:** Chỉ enforce binding Active (C012 CP002B); Binding Invalid → Capability không chạy (Validation Failure).

## CG005A — Conflict Resolution

- Tham chiếu S013 GV005A: Highest Priority → Most Specific → Newest Version → **Deny Wins**.

## CG006 — Contract Enforcement

- Tham chiếu C007 + S013 GV006.
- Contract failure → Failed (ST-009).

## CG007 — Boundary Enforcement

- Tham chiếu C004 + S013 GV007.
- Boundary violation → Deny + Event.

## CG008 — Permission Enforcement

- Tham chiếu S013 GV008 — Deny mặc định.

## CG009 — Version Governance

- SemVer · Compatibility · Deprecated · Breaking Change (S013 GV009).

## CG010 — Compatibility Governance

- Contract · Capability · Plugin · **Agent** (S013 GV010).

## CG011 — Validation Pipeline

```text
Constitution
    ↓
Boundary (C004)
    ↓
Contract (C007)
    ↓
Policy Binding (C012)
    ↓
Resolution (Runtime EF007)
```

## CG011A — Governance Modes

- **Strict** · **Compatible** · **Simulation** · **Audit Only** (S013 GV011A).

## CG012 — Governance Decision

**Model:** `id/capability/rule/result/reason/timestamp/severity`.

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
| Binding Invalid | Ignore (Capability không chạy) |
| Permission Fail | Deny |
| Compatibility Fail | Suspend |

## CG012A — Governance Lifecycle

```text
Resolved → Validated → Applied → Audited → Archived
```

(S013 GV012A)

## CG013 — Governance Events

- CAPABILITY_GOVERNANCE_VALIDATED · CAPABILITY_BOUNDARY_DENIED · CAPABILITY_BINDING_APPLIED · CAPABILITY_CONTRACT_VALIDATED · CAPABILITY_PERMISSION_DENIED · CAPABILITY_VERSION_CONFLICT · CAPABILITY_COMPATIBILITY_FAILED.
- S011 reuse trực tiếp.

## CG014 — Governance Traceability

```text
Capability
    ↓
Policy Binding (C012)
    ↓
Contract (C007)
    ↓
Boundary (C004)
    ↓
Constitution
```

## CG014A — Governance Mapping

```text
Capability Governance
    ↓
Binding (C012) → Contract (C007) → Boundary (C004)
    ↓
Requirement (C002) → Principle → Constitution
```

## CG015 — Governance Metrics

- violations · denied · warnings · binding_usage · contract_failures · boundary_failures · version_conflicts.

## CG016 — Machine-readable

```text
capability-governance.yaml
capability-governance-stack.yaml
capability-binding-enforcement.yaml
capability-governance-matrix.yaml
capability-governance-events.yaml
capability-governance-decisions.yaml
capability-governance-lifecycle.yaml
capability-governance-metrics.yaml
capability-governance-registry.yaml
capability-governance.schema.json
```

## CG017 — Governance Validation

Doctor kiểm tra:

- Missing Enforcement
- Invalid Binding (C012)
- Invalid Contract (C007)
- Boundary Violation (C004)
- Constitution Violation
- Version Conflict

## CG018 — Success Criteria

- Capability luôn chịu Governance của Runtime (S013).
- Mọi binding được enforce (C012).
- Mọi contract được validate (C007).
- Không Capability nào vượt Boundary (C004).
- Capability không bypass Governance (CB009).
- Doctor xác minh từ machine-readable.

## Tham chiếu

- C004: `../C004/boundaries.md`
- C007: `../C007/contracts.md`
- C012: `../C012/policies.md`
- W013: `../../SPEC-002/W013/governance.md` (mẫu)
- S013: `../../SPEC-001/S013/governance.md` (enforce)
- S011: `../../SPEC-001/S011/observability.md`
- Constitution: `docs/specs/SPEC-000/`
