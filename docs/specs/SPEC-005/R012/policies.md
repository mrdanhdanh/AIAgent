---
name: spec-005-r012-policies
description: SPEC-005 R012 — Registry Policies. 10 bindings RPB-001..010.
agent: general
---

# R012 — Registry Policies

> **SPEC-005**: Registry · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Registry khai báo binding với Policy như thế nào?**

## RPO001 — Policy Philosophy

- Policy là luật của Runtime (S012) — Registry không định nghĩa lại (RB008).
- Registry khai báo **Binding**: policy_ref + parameters + scope.
- Binding hợp lệ thì mới được apply.

## RPO002 — Policy Principles

- Reference Only · Parameterized · Scoped (Entry | Resolution) · Versioned · Validated · Traceable.

## RPO002A — Canonical Binding Model

```yaml
binding:
  fields: [id, entry, resolution, policy_ref, parameters, scope, version, status, lifecycle, metadata]
```

policy_ref bắt buộc trỏ đến POL-* tồn tại (S012).

## RPO002B — Binding Lifecycle

```text
Draft → Validated → Published → Active → Deprecated → Retired
```

## RPO003 — Policy Categories

7 categories của S012 RP003.

## RPO004 — Retry Binding

- RPB-001 → POL-RETRY-001 (S012) — scope: Resolution.

## RPO005 — Timeout Binding

- RPB-002 → POL-TIMEOUT-001 (S012) — scope: Resolution.

## RPO006 — Approval Binding

- RPB-003 → POL-APPROVAL-001 (S012) — scope: Entry.

## RPO007 — Resource Binding

- RPB-004 → POL-RES-001 (S012) — scope: Entry — quota.

## RPO008 — Parallel Binding

- RPB-005 → POL-PARALLEL-001 (S012) — scope: Resolution — join_policy.

## RPO009 — Compensation Binding

- RPB-006 → POL-COMP-001 (S012) — scope: Entry — LIFO.

## RPO010 — Scheduling Binding

- RPB-007 → POL-SCHED-001 (S012) — scope: Entry — order.

## RPO011 — Isolation Binding

- RPB-008 → POL-ISOL-001 (S012) — scope: Entry — isolated.

## RPO012 — Security Binding

- RPB-009 → POL-SEC-001 (S012) · RPB-010 → POL-RESACC-001 (S012).

## RPO013 — Policy Resolution

```text
Collect binding → Active check → Resolve policy_ref (S014) → parameters → Apply (S013)
```

## RPO014 — Policy Validation

- policy_ref trỏ đến POL-* (S012). · parameters đúng schema. · scope hợp lệ (Entry | Resolution). · version tồn tại. · Không trùng binding.

## RPO015 — Policy Traceability

```yaml
records:
  fields: [binding_id, policy_ref, entry_id, execution_id, correlation_id, parameters, result, timestamp]
```

## RPO016 — Machine-readable

```text
registry-policies.yaml
registry-policy-model.yaml
registry-policy-lifecycle.yaml
registry-policy-categories.yaml
registry-policy-resolution.yaml
registry-policy-validation.yaml
registry-policy-traceability.yaml
retry-binding.yaml
timeout-binding.yaml
approval-binding.yaml
registry-policies.schema.json
```

## RPO017 — Success Criteria

- 10 bindings (RPB-001..010) đầy đủ. · Registry không định nghĩa policy (RB008). · Mọi binding lifecycle + validation. · Mọi apply truy vết (S011).

## Tham chiếu

- R010: `../R010/execution-flow.md`
- S012: `../../SPEC-001/S012/policies.md`
- Constitution: `docs/specs/SPEC-000/`
