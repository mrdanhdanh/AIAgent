---
name: spec-002-w012-policies
description: >
  SPEC-002 W012 — Workflow Policies. Trả lời: Workflow khai báo binding với
  Policy như thế nào? Workflow KHÔNG định nghĩa policy (WB008) — chỉ binding
  tới S012. Mirror S012 (SPEC-001).
agent: general
---

# W012 — Workflow Policies

> **SPEC-002**: Workflow Engine · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Workflow khai báo binding với Policy như thế nào?**

## WP001 — Policy Philosophy

- Policy là luật của Runtime (S012) — Workflow không định nghĩa lại (WB008).
- Workflow khai báo **Binding**: policy_ref + parameters + scope.
- Binding hợp lệ thì mới được apply.
- Workflow không chứa Policy Logic.

## WP002 — Policy Principles

- **Reference Only** — chỉ trỏ đến POL-* (S012).
- **Parameterized** — khai báo tham số, không định nghĩa hành vi.
- **Scoped** — binding theo Workflow hoặc Step.
- **Versioned** — binding theo version policy (S012).
- **Validated** — binding phải hợp lệ trước khi chạy.
- **Traceable** — mọi binding apply có Event + Audit (S011).

## WP002A — Canonical Binding Model

```yaml
binding:
  id:
  workflow:
  step:
  policy_ref:
  parameters:
  scope:
  version:
  status:
  lifecycle:
  metadata:
```

**Rules:** policy_ref bắt buộc trỏ đến POL-* tồn tại (S012); thiếu bất kỳ field nào → Invalid Binding.

## WP002B — Binding Lifecycle

```text
Draft → Validated → Published → Active → Deprecated → Retired
```

(S012 RP002B) — chỉ Active mới được apply.

## WP003 — Policy Categories

Dùng 7 categories của S012 RP003: Recovery · Control · Orchestration · Resource · Governance · Security · Lifecycle.

## WP004 — Retry Binding

| Field | Giá trị |
|-------|---------|
| id | WPB-001 |
| policy_ref | POL-RETRY-001 (S012) |
| scope | Step |
| parameters | max_retry: 3, backoff: exponential |

## WP005 — Timeout Binding

| Field | Giá trị |
|-------|---------|
| id | WPB-002 |
| policy_ref | POL-TIMEOUT-001 (S012) |
| scope | Step |
| parameters | timeout_ms: 30000 |

## WP006 — Approval Binding

| Field | Giá trị |
|-------|---------|
| id | WPB-003 |
| policy_ref | POL-APPROVAL-001 (S012) |
| scope | Workflow |
| parameters | approver: owner, timeout_ms: 86400000 |

## WP007 — Resource Binding

- WPB-004 → POL-RES-001 (S012) — scope: Workflow — parameters: quota.

## WP008 — Parallel Binding

- WPB-005 → POL-PARALLEL-001 (S012) — scope: Step — parameters: join_policy (ALL/ANY/QUORUM/CUSTOM).

## WP009 — Compensation Binding

- WPB-006 → POL-COMP-001 (S012) — scope: Workflow — parameters: LIFO.

## WP010 — Scheduling Binding

- WPB-007 → POL-SCHED-001 (S012) — scope: Workflow — parameters: order.

## WP011 — Isolation Binding

- WPB-008 → POL-ISOL-001 (S012) — scope: Workflow — parameters: isolated: true.

## WP012 — Security Binding

- WPB-009 → POL-SEC-001 (S012) — scope: Workflow — parameters: least_privilege.
- WPB-010 → POL-RESACC-001 (S012) — scope: Step — parameters: access.

## WP013 — Policy Resolution

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

## WP014 — Policy Validation

- policy_ref trỏ đến POL-* tồn tại (S012).
- parameters đúng schema của policy.
- scope hợp lệ (Workflow | Step).
- version policy tồn tại (S012).
- Không trùng binding cùng scope + policy.

## WP015 — Policy Traceability

```yaml
records:
  fields: [binding_id, policy_ref, workflow_id, execution_id, correlation_id, parameters, result, timestamp]
```

- Mỗi apply sinh Event + Audit (S011).
- Truy vết: binding → policy (S012) → version.

## WP016 — Machine-readable

```text
workflow-policies.yaml
workflow-policy-model.yaml
workflow-policy-lifecycle.yaml
workflow-policy-categories.yaml
workflow-policy-resolution.yaml
workflow-policy-validation.yaml
workflow-policy-traceability.yaml
retry-binding.yaml
timeout-binding.yaml
approval-binding.yaml
workflow-policies.schema.json
```

## WP017 — Success Criteria

- 10 bindings (WPB-001..010) đầy đủ — mỗi binding trỏ đến POL-* (S012).
- Workflow không định nghĩa policy nào (WB008).
- Mọi binding có lifecycle + validation.
- Mọi apply truy vết được (S011).
- Doctor xác minh từ machine-readable.

## Tham chiếu

- W010: `../W010/execution-flow.md`
- S012: `../../SPEC-001/S012/policies.md` (mẫu + policy source)
- S013: `../../SPEC-001/S013/governance.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
