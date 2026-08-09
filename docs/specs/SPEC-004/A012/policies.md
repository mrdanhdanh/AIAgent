---
name: spec-004-a012-policies
description: >
  SPEC-004 A012 — Agent Policies. Trả lời: Agent khai báo binding với Policy
  như thế nào? Agent KHÔNG định nghĩa policy (AB008) — chỉ binding tới S012.
  Mirror C012 (SPEC-003).
agent: general
---

# A012 — Agent Policies

> **SPEC-004**: Agent System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Agent khai báo binding với Policy như thế nào?**

## AP001 — Policy Philosophy

- Policy là luật của Runtime (S012) — Agent không định nghĩa lại (AB008).
- Agent khai báo **Binding**: policy_ref + parameters + scope.
- Binding hợp lệ thì mới được apply.
- Agent không chứa Policy Logic.

## AP002 — Policy Principles

- **Reference Only** — chỉ trỏ đến POL-* (S012).
- **Parameterized** — khai báo tham số, không định nghĩa hành vi.
- **Scoped** — binding theo Agent hoặc Execution.
- **Versioned** — binding theo version policy (S012).
- **Validated** — binding phải hợp lệ trước khi chạy.
- **Traceable** — mọi binding apply có Event + Audit (S011).

## AP002A — Canonical Binding Model

```yaml
binding:
  id:
  agent:
  execution:
  policy_ref:
  parameters:
  scope:
  version:
  status:
  lifecycle:
  metadata:
```

**Rules:** policy_ref bắt buộc trỏ đến POL-* tồn tại (S012); thiếu bất kỳ field nào → Invalid Binding.

## AP002B — Binding Lifecycle

```text
Draft → Validated → Published → Active → Deprecated → Retired
```

(S012 RP002B) — chỉ Active mới được apply.

## AP003 — Policy Categories

Dùng 7 categories của S012 RP003: Recovery · Control · Orchestration · Resource · Governance · Security · Lifecycle.

## AP004 — Retry Binding

| Field | Giá trị |
|-------|---------|
| id | APB-001 |
| policy_ref | POL-RETRY-001 (S012) |
| scope | Execution |
| parameters | max_retry: 3, backoff: exponential |

## AP005 — Timeout Binding

| Field | Giá trị |
|-------|---------|
| id | APB-002 |
| policy_ref | POL-TIMEOUT-001 (S012) |
| scope | Execution |
| parameters | timeout_ms: 30000 |

## AP006 — Approval Binding

| Field | Giá trị |
|-------|---------|
| id | APB-003 |
| policy_ref | POL-APPROVAL-001 (S012) |
| scope | Agent |
| parameters | approver: owner |

## AP007 — Resource Binding

- APB-004 → POL-RES-001 (S012) — scope: Agent — parameters: quota.

## AP008 — Parallel Binding

- APB-005 → POL-PARALLEL-001 (S012) — scope: Execution — parameters: join_policy.

## AP009 — Compensation Binding

- APB-006 → POL-COMP-001 (S012) — scope: Agent — parameters: LIFO.

## AP010 — Scheduling Binding

- APB-007 → POL-SCHED-001 (S012) — scope: Agent — parameters: order.

## AP011 — Isolation Binding

- APB-008 → POL-ISOL-001 (S012) — scope: Agent — parameters: isolated: true.

## AP012 — Security Binding

- APB-009 → POL-SEC-001 (S012) — scope: Agent — parameters: least_privilege.
- APB-010 → POL-RESACC-001 (S012) — scope: Execution — parameters: access.

## AP013 — Policy Resolution

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

## AP014 — Policy Validation

- policy_ref trỏ đến POL-* tồn tại (S012).
- parameters đúng schema của policy.
- scope hợp lệ (Agent | Execution).
- version policy tồn tại (S012).
- Không trùng binding cùng scope + policy.

## AP015 — Policy Traceability

```yaml
records:
  fields: [binding_id, policy_ref, agent_id, execution_id, correlation_id, parameters, result, timestamp]
```

- Mỗi apply sinh Event + Audit (S011).
- Truy vết: binding → policy (S012) → version.

## AP016 — Machine-readable

```text
agent-policies.yaml
agent-policy-model.yaml
agent-policy-lifecycle.yaml
agent-policy-categories.yaml
agent-policy-resolution.yaml
agent-policy-validation.yaml
agent-policy-traceability.yaml
retry-binding.yaml
timeout-binding.yaml
approval-binding.yaml
agent-policies.schema.json
```

## AP017 — Success Criteria

- 10 bindings (APB-001..010) đầy đủ — mỗi binding trỏ đến POL-* (S012).
- Agent không định nghĩa policy nào (AB008).
- Mọi binding có lifecycle + validation.
- Mọi apply truy vết được (S011).
- Doctor xác minh từ machine-readable.

## Tham chiếu

- A010: `../A010/execution-flow.md`
- C012: `../../SPEC-003/C012/policies.md` (mẫu)
- S012: `../../SPEC-001/S012/policies.md` (policy source)
- S013: `../../SPEC-001/S013/governance.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`