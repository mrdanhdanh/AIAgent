---
name: spec-001-s013-governance
description: >
  SPEC-001 S013 — Runtime Governance. Trả lời: Runtime thực thi
  Constitution, Boundary, Contract và Policy như thế nào?
  Chuỗi trách nhiệm:
  S012 define · S013 enforce · S016 verify.
  23 sections GV001-GV018 (kèm GV003A, GV005A, GV011A, GV012A, GV014A).
agent: general
---

# S013 — Runtime Governance

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: Draft
> **Vai trò**: Nơi duy nhất **thực thi (enforce)** — Constitution, Boundary, Contract, Policy đều được định nghĩa ở nơi khác.
> **SSOT**: "Cảnh sát" của Runtime — Dashboard, Doctor, S016 chỉ cần tham chiếu, không định nghĩa lại.

## Mục tiêu

> **Runtime thực thi Constitution, Boundary, Contract và Policy như thế nào?**

Nếu S012 trả lời *"Policy là gì?"* thì S013 trả lời *"Runtime cưỡng chế Policy, Constitution và Contract như thế nào?"*

Quan hệ với các SPEC trước:

```text
S004  Runtime Boundaries
            │
            ▼
S007  Runtime Contracts
            │
            ▼
S012  Runtime Policies
            │
            ▼
S013  Runtime Governance   ← bạn đang đọc
            │
            ▼
S016  Runtime Compliance
```

Chuỗi trách nhiệm:

- **S004** định nghĩa **Boundary**.
- **S007** định nghĩa **Contract**.
- **S012** định nghĩa **Policy**.
- **S013** cưỡng chế (**Enforce**) tất cả các quy tắc trên.
- **S016** xác minh (**Verify/Compliance**) rằng Runtime đã thực thi đúng các quy tắc đó.

Kiến trúc phân lớp: **Define → Enforce → Verify**.

## GV001 — Governance Philosophy

- Governance là cơ chế thực thi luật.
- Runtime không quyết định luật.
- Runtime chỉ thực thi luật đã được định nghĩa.
- Governance độc lập Business Logic.

## GV002 — Governance Principles

- Constitution First
- Policy Driven
- Contract First
- Boundary First
- Least Privilege
- Deterministic
- Auditable
- Versioned

## GV003 — Governance Scope

Runtime thực thi:

- Constitution
- Policy
- Contract
- Boundary
- Permission
- Version Compatibility

Không thực thi:

- Business Rule
- Domain Rule
- Workflow Logic

## GV003A — Governance Stack

Kiến trúc Governance 6 tầng:

```text
Constitution
      ↓
Boundary
      ↓
Contract
      ↓
Policy
      ↓
Permission
      ↓
Execution Decision
```

**Rules:** Tầng trên quyết định tầng dưới; Doctor validate từng tầng.

## GV004 — Constitution Enforcement

Runtime luôn:

- Validate Constitution
- Reject vi phạm
- Publish Constitution Event
- Ghi Audit

**Rules:** Vi phạm Constitution → Execution Aborted (ST-014); không thể thỏa hiệp Constitution.

## GV005 — Policy Enforcement

Tham chiếu S012.

Runtime:

- Resolve Policy (S012 RP013)
- Validate (S012 RP014)
- Apply (S012 RP013A — conflict resolution)
- Audit (S012 RP015)

**Rules:** Chỉ enforce policy Active (S012 RP002B); Policy Invalid → không áp dụng, ghi Invalid Audit.

## GV005A — Governance Conflict Resolution

Khi nhiều rule conflict (Policy Allow nhưng Boundary Deny...):

```text
Highest Priority
    ↓
Most Specific
    ↓
Newest Version
    ↓
Deny
```

**Rules:**

- Priority cao hơn thắng.
- Cùng priority → most specific thắng.
- Cùng specificity → newest version thắng.
- Không xác định được → **Deny Wins** (mặc định).

## GV006 — Contract Enforcement

Runtime:

- Validate Input
- Validate Output
- Validate Preconditions
- Validate Postconditions
- Validate Invariants

**Rules:** Contract failure → Execution Failed (ST-009); không tua contract khi execution.

## GV007 — Boundary Enforcement

Kiểm tra:

- Ownership
- Dependency
- Permission
- Delegation
- Data
- State

**Rules:** Boundary violation → Deny + Boundary Failure Event; không Execution nào vượt Boundary.

Tham chiếu S004.

## GV008 — Permission Enforcement

Runtime chỉ cho phép hành động hợp lệ theo:

- Policy (S012 POL-SEC-001, POL-RESACC-001)
- Contract (S007)
- Constitution (SPEC-000)

**Rules:** Allow/Deny theo least privilege; **Deny mặc định** khi không xác định permission.

## GV009 — Version Governance

Kiểm tra:

- SemVer
- Compatibility
- Deprecated
- Breaking Change

## GV010 — Compatibility Governance

Kiểm tra:

- Contract
- Capability
- Plugin
- Workflow

## GV011 — Validation Pipeline

```text
Constitution
    ↓
Boundary
    ↓
Contract
    ↓
Policy
    ↓
Execution
```

## GV011A — Governance Modes

- **Strict** — mọi rule bắt buộc, không ngoại lệ.
- **Compatible** — chỉ chặn vi phạm breaking.
- **Simulation** — đánh giá decision không tác động Execution thực.
- **Audit Only** — ghi nhận vi phạm, không chặn.

> Simulation rất hữu ích cho Evolution.

## GV012 — Governance Decision

**Decision Model** (Dashboard đọc trực tiếp):

```yaml
decision:
  id:
  execution:
  rule:
  result:
  reason:
  timestamp:
  severity:
```

**Decision chỉ có:** Allow · Deny · Suspend · Retry · Escalate.

**Decision Priority** (khi nhiều rule conflict):

| Level | Priority |
|-------|----------|
| Constitution | 100 |
| Boundary | 90 |
| Contract | 80 |
| Policy | 70 |
| Permission | 60 |

**Rule:** Priority cao hơn thắng.

**Decision Matrix** (Doctor chỉ cần đọc matrix):

| Validation | Decision |
|------------|----------|
| Constitution Fail | Abort |
| Boundary Fail | Deny |
| Contract Fail | Failed |
| Policy Invalid | Ignore |
| Permission Fail | Deny |
| Compatibility Fail | Suspend |

**Failure Classification** (Dashboard hiển thị):

| Failure | Result |
|---------|--------|
| Constitution | Abort |
| Boundary | Deny |
| Contract | Failed |
| Policy | Skip |
| Permission | Deny |
| Compatibility | Suspend |

## GV012A — Governance Lifecycle

```text
Resolved
    ↓
Validated
    ↓
Applied
    ↓
Audited
    ↓
Archived
```

**Rules:** Chỉ Validated mới Applied; mọi decision phải qua đủ 5 trạng thái; Archived giữ traceability.

## GV013 — Governance Events

Sinh:

- Governance Event
- Audit
- Metrics

**Governance Event Types** (S011 reuse trực tiếp):

- CONSTITUTION_VALIDATED
- BOUNDARY_DENIED
- POLICY_APPLIED
- CONTRACT_VALIDATED
- PERMISSION_DENIED
- VERSION_CONFLICT
- COMPATIBILITY_FAILED

## GV014 — Governance Traceability

```text
Execution
    ↓
Governance Decision
    ↓
Policy Instance
    ↓
Rule
    ↓
Constitution
```

## GV014A — Governance Mapping

```text
Governance
    ↓
Policy
    ↓
Contract
    ↓
Boundary
    ↓
Requirement
    ↓
Principle
    ↓
Constitution
```

> Mỗi Governance rule truy vết được về Requirement + Principle + Constitution.

## GV015 — Governance Metrics

- violations
- denied
- warnings
- policy_usage
- constitution_failures
- boundary_failures
- contract_failures
- policy_conflicts
- permission_denied
- version_conflicts
- avg_validation_time

## GV016 — Machine-readable

```text
governance.yaml
governance-stack.yaml
governance-matrix.yaml
governance-events.yaml
governance-registry.yaml
governance-decisions.yaml
governance-lifecycle.yaml
constitution-enforcement.yaml
policy-enforcement.yaml
contract-enforcement.yaml
boundary-enforcement.yaml
permission-enforcement.yaml
governance-metrics.yaml
governance.schema.json
```

> `governance-registry.yaml` — Dashboard chỉ cần đọc một file để có toàn bộ Governance.

## GV017 — Governance Validation

Doctor kiểm tra:

- Missing Enforcement
- Invalid Policy
- Invalid Contract
- Boundary Violation
- Constitution Violation
- Version Conflict

## GV018 — Success Criteria

- Constitution luôn được thực thi.
- Mọi Policy đều được enforce.
- Mọi Contract đều được validate.
- Không Execution nào vượt Boundary.
- Doctor xác minh toàn bộ Governance bằng machine-readable.
- Không chứa Business Logic.
- Mọi Decision đều truy vết được về Constitution.
- Mọi Governance Decision đều sinh Event và Audit.
- Conflict Resolution luôn xác định được một kết quả duy nhất.
- Không tồn tại Decision mơ hồ hoặc không xác định.
- Dashboard và Doctor dựng đầy đủ Governance Graph chỉ từ machine-readable.

## Tham chiếu

- `governance.yaml` — nguồn dữ liệu chuẩn
- `governance-stack.yaml` · `governance-matrix.yaml` · `governance-events.yaml`
- `governance-registry.yaml` · `governance-decisions.yaml` · `governance-lifecycle.yaml`
- `constitution-enforcement.yaml` · `policy-enforcement.yaml` · `contract-enforcement.yaml`
- `boundary-enforcement.yaml` · `permission-enforcement.yaml` · `governance-metrics.yaml`
- `governance.schema.json`
- S004: `../S004/boundaries.md`
- S007: `../S007/contracts.md`
- S012: `../S012/policies.md`
- S011: `../S011/observability.md`
- Constitution: `docs/specs/SPEC-000/`
