---
name: spec-002-w013-governance
description: >
  SPEC-002 W013 — Workflow Governance. Trả lời: Workflow được thực thi luật
  như thế nào? Workflow chịu Governance của Runtime (S013) — chỉ thêm
  Workflow-level (binding enforcement). Mirror S013 (SPEC-001).
agent: general
---

# W013 — Workflow Governance

> **SPEC-002**: Workflow Engine · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Workflow được thực thi luật như thế nào?**

## WG001 — Governance Philosophy

- Governance là cơ chế thực thi luật.
- Workflow không quyết định luật.
- Workflow chỉ thực thi luật đã được định nghĩa (S012/S013).
- Governance độc lập Business Logic.

## WG002 — Governance Principles

- Constitution First · Policy Binding First (W012) · Contract First (W007) · Boundary First (W004) · Least Privilege · Deterministic · Auditable · Versioned.

## WG003 — Governance Scope

**Thực thi:**

- Constitution (SPEC-000)
- Policy Binding (W012)
- Contract (W007)
- Boundary (W004)
- Permission (S013)
- Version Compatibility

**Không thực thi:**

- Business Rule
- Domain Rule

## WG003A — Governance Stack

```text
Constitution
    ↓
Boundary (W004)
    ↓
Contract (W007)
    ↓
Policy Binding (W012)
    ↓
Permission
    ↓
Execution Decision
```

## WG004 — Constitution Enforcement

- Tham chiếu S013 GV004 — Runtime thực thi.
- Vi phạm Constitution → Aborted (ST-014).

## WG005 — Policy Binding Enforcement

- Resolve binding (W012 WP013).
- Validate binding (W012 WP014).
- Apply (S013 enforce).
- Audit (S011).

**Rules:** Chỉ enforce binding Active (W012 WP002B); Binding Invalid → Workflow không chạy (Validation Failure).

## WG005A — Conflict Resolution

- Tham chiếu S013 GV005A: Highest Priority → Most Specific → Newest Version → **Deny Wins**.

## WG006 — Contract Enforcement

- Tham chiếu W007 + S013 GV006.
- Contract failure → Failed (ST-009).

## WG007 — Boundary Enforcement

- Tham chiếu W004 + S013 GV007.
- Boundary violation → Deny + Event.

## WG008 — Permission Enforcement

- Tham chiếu S013 GV008 — Deny mặc định.

## WG009 — Version Governance

- SemVer · Compatibility · Deprecated · Breaking Change (S013 GV009).

## WG010 — Compatibility Governance

- Contract · Capability · Plugin · Workflow (S013 GV010).

## WG011 — Validation Pipeline

```text
Constitution
    ↓
Boundary (W004)
    ↓
Contract (W007)
    ↓
Policy Binding (W012)
    ↓
Execution (Runtime S010)
```

## WG011A — Governance Modes

- **Strict** · **Compatible** · **Simulation** · **Audit Only** (S013 GV011A).

## WG012 — Governance Decision

**Model:** `id/workflow/rule/result/reason/timestamp/severity`.

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
| Binding Invalid | Ignore (Workflow không chạy) |
| Permission Fail | Deny |
| Compatibility Fail | Suspend |

## WG012A — Governance Lifecycle

```text
Resolved → Validated → Applied → Audited → Archived
```

(S013 GV012A)

## WG013 — Governance Events

- WORKFLOW_GOVERNANCE_VALIDATED · WORKFLOW_BOUNDARY_DENIED · WORKFLOW_BINDING_APPLIED · WORKFLOW_CONTRACT_VALIDATED · WORKFLOW_PERMISSION_DENIED · WORKFLOW_VERSION_CONFLICT · WORKFLOW_COMPATIBILITY_FAILED.
- W013 định nghĩa 7 event types WORKFLOW_* — S011 cung cấp event model (fields, correlation_id).

## WG014 — Governance Traceability

```text
Workflow
    ↓
Policy Binding (W012)
    ↓
Contract (W007)
    ↓
Boundary (W004)
    ↓
Constitution
```

## WG014A — Governance Mapping

```text
Workflow Governance
    ↓
Binding (W012) → Contract (W007) → Boundary (W004)
    ↓
Requirement (W002) → Principle → Constitution
```

## WG015 — Governance Metrics

- violations · denied · warnings · binding_usage · contract_failures · boundary_failures · version_conflicts.

## WG016 — Machine-readable

```text
workflow-governance.yaml
workflow-governance-stack.yaml
workflow-binding-enforcement.yaml
workflow-governance-matrix.yaml
workflow-governance-events.yaml
workflow-governance-decisions.yaml
workflow-governance-lifecycle.yaml
workflow-governance-metrics.yaml
workflow-governance-registry.yaml
workflow-governance.schema.json
```

## WG017 — Governance Validation

Doctor kiểm tra:

- Missing Enforcement
- Invalid Binding (W012)
- Invalid Contract (W007)
- Boundary Violation (W004)
- Constitution Violation
- Version Conflict

## WG018 — Success Criteria

- Workflow luôn chịu Governance của Runtime (S013).
- Mọi binding được enforce (W012).
- Mọi contract được validate (W007).
- Không Workflow nào vượt Boundary (W004).
- Workflow không bypass Governance (WB009).
- Doctor xác minh từ machine-readable.

## Tham chiếu

- W004: `../W004/boundaries.md`
- W007: `../W007/contracts.md`
- W012: `../W012/policies.md`
- S013: `../../SPEC-001/S013/governance.md` (mẫu + enforce)
- S011: `../../SPEC-001/S011/observability.md`
- Constitution: `docs/specs/SPEC-000/`
