---
name: spec-003-c012-policies
description: >
  SPEC-003 C012 — Capability Policies. Trả lời: Capability khai báo binding
  với Policy như thế nào? Capability KHÔNG định nghĩa policy (CB008) — chỉ
  binding tới S012. Mirror W012 (SPEC-002).
agent: general
---

# C012 — Capability Policies

> **SPEC-003**: Capability System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Capability khai báo binding với Policy như thế nào?**

## CP001 — Policy Philosophy

- Policy là luật của Runtime (S012) — Capability không định nghĩa lại (CB008).
- Capability khai báo **Binding**: policy_ref + parameters + scope.
- Binding hợp lệ thì mới được apply.
- Capability không chứa Policy Logic.

## CP002 — Policy Principles

- **Reference Only** — chỉ trỏ đến POL-* (S012).
- **Parameterized** — khai báo tham số, không định nghĩa hành vi.
- **Scoped** — binding theo Capability hoặc Resolution.
- **Versioned** — binding theo version policy (S012).
- **Validated** — binding phải hợp lệ trước khi chạy.
- **Traceable** — mọi binding apply có Event + Audit (S011).

## CP002A — Canonical Binding Model

```yaml
binding:
  id:
  capability:
  resolution:
  policy_ref:
  parameters:
  scope:
  version:
  status:
  lifecycle:
  metadata:
```

**Rules:** policy_ref bắt buộc trỏ đến POL-* tồn tại (S012); thiếu bất kỳ field nào → Invalid Binding.

## CP002B — Binding Lifecycle

```text
Draft → Validated → Published → Active → Deprecated → Retired
```

(S012 RP002B) — chỉ Active mới được apply.

## CP003 — Policy Categories

Dùng 7 categories của S012 RP003: Recovery · Control · Orchestration · Resource · Governance · Security · Lifecycle.

## CP004 — Retry Binding

| Field | Giá trị |
|-------|---------|
| id | CPB-001 |
| policy_ref | POL-RETRY-001 (S012) |
| scope | Resolution |
| parameters | max_retry: 3, backoff: exponential |

## CP005 — Timeout Binding

| Field | Giá trị |
|-------|---------|
| id | CPB-002 |
| policy_ref | POL-TIMEOUT-001 (S012) |
| scope | Resolution |
| parameters | timeout_ms: 30000 |

## CP006 — Approval Binding

| Field | Giá trị |
|-------|---------|
| id | CPB-003 |
| policy_ref | POL-APPROVAL-001 (S012) |
| scope | Capability |
| parameters | approver: owner |

## CP007 — Resource Binding

- CPB-004 → POL-RES-001 (S012) — scope: Capability — parameters: quota.

## CP008 — Parallel Binding

- CPB-005 → POL-PARALLEL-001 (S012) — scope: Resolution — parameters: join_policy.

## CP009 — Compensation Binding

- CPB-006 → POL-COMP-001 (S012) — scope: Capability — parameters: LIFO.

## CP010 — Scheduling Binding

- CPB-007 → POL-SCHED-001 (S012) — scope: Capability — parameters: order.

## CP011 — Isolation Binding

- CPB-008 → POL-ISOL-001 (S012) — scope: Capability — parameters: isolated: true.

## CP012 — Security Binding

- CPB-009 → POL-SEC-001 (S012) — scope: Capability — parameters: least_privilege.
- CPB-010 → POL-RESACC-001 (S012) — scope: Resolution — parameters: access.

## CP013 — Policy Resolution

```text
Collect binding (trigger khớp)
    ↓
Kiểm tra binding Active (lifecycle)
    ↓
Resolve policy_ref (S014 Registry)
    ↓
Áp dụng parameters
    ↓
Apply (S013 enforce)
```

**Rules:** Binding không Active → bỏ qua; policy_ref không resolve được → Validation Failure.

## CP014 — Policy Validation

- policy_ref trỏ đến POL-* tồn tại (S012).
- parameters đúng schema của policy.
- scope hợp lệ (Capability | Resolution).
- version policy tồn tại (S012).
- Không trùng binding cùng scope + policy.

## CP015 — Policy Traceability

```yaml
records:
  fields: [binding_id, policy_ref, capability_id, execution_id, correlation_id, parameters, result, timestamp]
```

- Mỗi apply sinh Event + Audit (S011).
- Truy vết: binding → policy (S012) → version.

## CP016 — Machine-readable

```text
capability-policies.yaml
capability-policy-model.yaml
capability-policy-lifecycle.yaml
capability-policy-categories.yaml
capability-policy-resolution.yaml
capability-policy-validation.yaml
capability-policy-traceability.yaml
retry-binding.yaml
timeout-binding.yaml
approval-binding.yaml
capability-policies.schema.json
```

## CP017 — Success Criteria

- 10 bindings (CPB-001..010) đầy đủ — mỗi binding trỏ đến POL-* (S012).
- Capability không định nghĩa policy nào (CB008).
- Mọi binding có lifecycle + validation.
- Mọi apply truy vết được (S011).
- Doctor xác minh từ machine-readable.

## Tham chiếu

- C010: `../C010/execution-flow.md`
- W012: `../../SPEC-002/W012/policies.md` (mẫu)
- S012: `../../SPEC-001/S012/policies.md` (policy source)
- S013: `../../SPEC-001/S013/governance.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
