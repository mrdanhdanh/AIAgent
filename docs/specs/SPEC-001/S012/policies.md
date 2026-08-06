---
name: spec-001-s012-policies
description: >
  SPEC-001 S012 — Runtime Policies. Trả lời: Runtime áp dụng những chính sách
  nào để điều khiển Execution? Chuẩn hóa Retry, Timeout, Approval,
  Resource, Parallel, Compensation... Không mô tả implementation.
  Chuỗi trách nhiệm: S010 apply · S012 define · S013 enforce.
  17 sections RP001-RP017.
agent: general
---

# S012 — Runtime Policies

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: Draft
> **Vai trò**: Nơi duy nhất **định nghĩa (define)** Policy — thống nhất model chuẩn từ S010 EF025, tránh chồng chéo với S010 (apply) và S013 (enforce).

## Mục tiêu

> **Runtime áp dụng những chính sách nào để điều khiển Execution?**

Chuỗi trách nhiệm:

```text
S010 Execution Flow
        │
        ▼
Apply Policy
        │
        ▼
S012 Runtime Policies   ← bạn đang đọc
        │
        ▼
S013 Runtime Governance
        │
        ▼
Enforce Policy
```

- **S010** chỉ **áp dụng (apply)** Policy trong Execution Flow.
- **S012** mới **định nghĩa (define)** Policy.
- **S013** sẽ **thực thi (enforce)** Policy trong Governance.

## RP001 — Policy Philosophy

- Policy là luật, không phải code.
- Policy không chứa Business Logic.
- Policy có thể thay đổi mà không sửa Runtime.
- Mọi policy đều xác định được trigger, guard, action.

## RP002 — Policy Principles

- **Declarative** — policy khai báo, không lập trình.
- **Guarded** — action chỉ chạy khi guard đúng.
- **Priority** — policy có thứ tự ưu tiên.
- **Versioned** — mọi thay đổi là version mới.
- **Traceable** — mọi policy instance truy vết về định nghĩa.
- **Non-invasive** — áp dụng không thay đổi Execution chi phí.

## RP003 — Policy Categories

- Recovery
- Control
- Governance
- Resource
- Orchestration
- Security

## RP004 — Retry Policy

| Field | Giá trị |
|-------|---------|
| id | POL-RETRY-001 |
| category | Recovery |
| trigger | Failed (ST-009) |
| guard | retry_count < max_retry |
| action | Retry (S009 TR-015) |
| priority | 20 |
| version | 1.0 |

Điều khiển: **Retry Flow** (S010 EF012).

## RP005 — Timeout Policy

| Field | Giá trị |
|-------|---------|
| id | POL-TIMEOUT-001 |
| category | Control |
| trigger | Running (ST-004) |
| guard | timeout exceeded (S009 TR-013) |
| action | TimedOut (ST-011) |
| priority | 10 |
| version | 1.0 |

Điều khiển: **Timeout Flow** (S010 EF014).

## RP006 — Approval Policy

| Field | Giá trị |
|-------|---------|
| id | POL-APPROVAL-001 |
| category | Governance |
| trigger | Approval gate (S009 TR-005/006) |
| guard | approval required |
| action | Waiting (ST-006) |
| priority | 50 |
| version | 1.0 |

Điều khiển: **Approval Gate** (S010 EF015).

## RP007 — Resource Policy

| Field | Giá trị |
|-------|---------|
| id | POL-RES-001 |
| category | Resource |
| trigger | Allocate (S003 RR-001) |
| guard | resource available |
| action | Allocate / Queue |
| priority | 30 |
| version | 1.0 |

Điều khiển: **Resource Allocation** (S010 EF020).

## RP008 — Parallel Policy

| Field | Giá trị |
|-------|---------|
| id | POL-PARALLEL-001 |
| category | Orchestration |
| trigger | Parallel tasks (S010 EF021) |
| guard | join policy (ALL/ANY/QUORUM/CUSTOM) |
| action | Scatter/Gather |
| priority | 40 |
| version | 1.0 |

Điều khiển: **Fan-out / Fan-in / Join** (S010 EF021).

## RP009 — Compensation Policy

| Field | Giá trị |
|-------|---------|
| id | POL-COMP-001 |
| category | Recovery |
| trigger | Failure (ST-009) |
| guard | completed steps exist (S010 EF022) |
| action | Compensate (rollback) |
| priority | 60 |
| version | 1.0 |

Điều khiển: **Rollback** (S010 EF022).

## RP010 — Scheduling Policy

| Field | Giá trị |
|-------|---------|
| id | POL-SCHED-001 |
| category | Orchestration |
| trigger | Execution start |
| guard | ordering constraints |
| action | Order execution |
| priority | 40 |
| version | 1.0 |

Điều khiển: **Thứ tự thực thi**.

## RP011 — Isolation Policy

| Field | Giá trị |
|-------|---------|
| id | POL-ISOL-001 |
| category | Security |
| trigger | Execution start |
| guard | isolation required |
| action | Isolate Context & Execution |
| priority | 90 |
| version | 1.0 |

Điều khiển: **Context & Execution Isolation** (S010 EF008).

## RP012 — Security Policy

| Field | Giá trị |
|-------|---------|
| id | POL-SEC-001 |
| category | Security |
| trigger | Access attempt |
| guard | permission granted (least privilege) |
| action | Allow / Deny |
| priority | 100 |
| version | 1.0 |

Điều khiển: **Permission / Least Privilege**.

## RP013 — Policy Resolution

Runtime chọn policy nào để áp dụng (S010 timeline: sau Validation):

```text
Validate Execution
    ↓
Collect applicable policies (theo trigger)
    ↓
Sort theo priority
    ↓
Kiểm tra guard
    ↓
Áp dụng action
```

**Rules:**

- Chỉ policy có trigger khớp mới được xét.
- Policy có priority cao hơn thắng.
- Guard sai → bỏ qua policy, không báo lỗi.

## RP014 — Policy Validation

Policy phải hợp lệ trước khi áp dụng:

- **Schema** — đủ id/category/trigger/guard/action/priority/version.
- **Reference** — trigger/action tham chiếu State/Transition tồn tại (S009).
- **Uniqueness** — id duy nhất.
- **Priority** — số nguyên, không trùng trong cùng category.
- **Version** — semver.

**Result:** Valid → được áp dụng. Invalid → bị từ chối, có Invalid Audit.

## RP015 — Policy Traceability

Mỗi lần áp dụng policy đều ghi lại (S011):

```yaml
records:
  fields: [policy_id, execution_id, correlation_id, trigger, guard_result, action_taken, timestamp]
```

**Rules:**

- Mỗi áp dụng sinh Event policy (S011 events.yaml).
- Mỗi áp dụng ghi Audit (S011 audit.yaml).
- Truy vết được: policy instance → định nghĩa policy → version.

## RP016 — Machine-readable

```text
policies.yaml
retry-policy.yaml
timeout-policy.yaml
approval-policy.yaml
resource-policy.yaml
parallel-policy.yaml
compensation-policy.yaml
scheduling-policy.yaml
isolation-policy.yaml
security-policy.yaml
policy-resolution.yaml
policy-validation.yaml
policy-traceability.yaml
policies.schema.json
```

## RP017 — Success Criteria

- 9 policies được định nghĩa theo model chuẩn (S010 EF025).
- Policy model gồm đủ 7 field: id/category/trigger/guard/action/priority/version.
- Chuỗi trách nhiệm rõ: S010 apply · S012 define · S013 enforce.
- Mọi policy truy vết được qua Event + Audit (S011).
- Không chứa Business Logic.
- Không mô tả implementation.

## Tham chiếu

- `policies.yaml` — nguồn dữ liệu chuẩn
- `retry-policy.yaml` · `timeout-policy.yaml` · `approval-policy.yaml`
- `resource-policy.yaml` · `parallel-policy.yaml` · `compensation-policy.yaml`
- `scheduling-policy.yaml` · `isolation-policy.yaml` · `security-policy.yaml`
- `policy-resolution.yaml` · `policy-validation.yaml` · `policy-traceability.yaml`
- `policies.schema.json`
- S010 EF025: `../S010/execution-flow.md`
- S009: `../S009/state-machine.yaml`
- S011: `../S011/observability.md`
- Constitution: `docs/specs/SPEC-000/`
