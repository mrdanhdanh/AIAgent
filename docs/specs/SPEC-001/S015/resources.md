---
name: spec-001-s015-resources
description: >
  SPEC-001 S015 — Runtime Resources. Trả lời: Runtime quản lý và cấp phát
  tài nguyên như thế nào? Tài nguyên mà Registry (S014) tham chiếu —
  Allocation qua Policy (S012 POL-RES-001) và Governance (S013).
  17 sections RS001-RS017.
agent: general
---

# S015 — Runtime Resources

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: Draft
> **Vai trò**: Định nghĩa tài nguyên Runtime — mắt xích giữa **Registry (S014)** (metadata) và **Execution (S010)** (sử dụng).

## Mục tiêu

> **Runtime quản lý và cấp phát tài nguyên như thế nào?**

Không mô tả:

- database
- storage engine
- API
- implementation
- code

Chỉ mô tả **Resource Model**.

Vị trí trong chuỗi:

```text
Registry (S014) — metadata
        │
        ▼
Resources (S015) — tài nguyên
        │
        ▼
Allocation (S012 POL-RES-001)
        │
        ▼
Execution (S010)
```

## RS001 — Resource Philosophy

- Resource là tài nguyên của Runtime.
- Runtime không hardcode tài nguyên.
- Mọi Allocation đi qua Policy (S012) và Governance (S013).
- Không Resource nào bị Leak.

## RS002 — Resource Principles

- **Allocated** — mọi tài nguyên phải cấp phát tường minh.
- **Released** — mọi tài nguyên phải giải phóng.
- **Owned** — mỗi tài nguyên có đúng một owner.
- **Bounded** — giới hạn quota.
- **Observable** — mọi tài nguyên quan sát được (S011).
- **Traceable** — mọi allocation truy vết được.

## RS003 — Resource Categories

- Capability
- Execution
- Context
- Memory
- Storage
- Compute
- Network
- Quota
- Token
- Time

## RS004 — Canonical Resource Model

Mọi Resource Entry theo model chuẩn:

```yaml
resource:
  id:
  type:
  category:
  owner:
  status:
  capacity:
  allocated:
  quota:
  references:
  metadata:
```

**Rules:** Thiếu bất kỳ field nào → Invalid Resource; `allocated` không được vượt `capacity` và `quota`.

## RS005 — Resource Lifecycle

```text
Draft
    ↓
Available
    ↓
Allocated
    ↓
In Use
    ↓
Released
    ↓
Depleted
```

**Rules:** Chỉ Available mới Allocated; Release trên Terminal State (S009); Depleted → không cấp phát mới, giữ traceability.

## RS006 — Resource Allocation

```text
Request
    ↓
Policy Check (S012 POL-RES-001: guard resource available)
    ↓
Allocate (hoặc Queue khi không có sẵn)
    ↓
Bind to Execution
    ↓
Track (S011: Event + Metric + Trace)
```

**Rules:** Không Double Allocation; Release bắt buộc trên Terminal State (S009); Queue khi không có sẵn (S012 POL-RES-001 action).

> Tham chiếu S010 EF004 (Resource Allocation).

## RS007 — Resource Access

```text
Request
    ↓
Policy Check (S012 POL-RESACC-001: permission + isolation)
    ↓
Grant / Deny
```

**Rules:** Deny mặc định khi không xác định permission (S013); mọi truy cập sinh Event + Audit (S011).

## RS008 — Resource Ownership

| Resource | Owner |
|----------|-------|
| Capability | Runtime |
| Execution | Execution Owner |
| Plugin | Plugin Owner |
| Quota | Runtime |

## RS009 — Resource Constraints

Không được:

- Double Allocation
- Resource Leak
- Vi phạm quota
- Orphan Resource
- Giữ Resource sau Terminal State (S009)

## RS010 — Resource Registry

- Resource đăng ký trong Registry (S014).
- Resource Entry tham chiếu Contract (S007).
- Resolution đi qua Registry trước khi Allocation.

## RS011 — Resource Events

- RESOURCE_ALLOCATED
- RESOURCE_RELEASED
- RESOURCE_EXHAUSTED
- RESOURCE_LEAKED
- RESOURCE_DENIED
- RESOURCE_QUEUED
- RESOURCE_DEPLETED

> S015 định nghĩa 7 event types (RS011) — S011 cung cấp event model (fields, correlation_id).

## RS012 — Resource Metrics

- allocation_count
- release_count
- active_resources
- leak_count
- exhaustion_count
- utilization
- wait_time
- queue_depth
- denied_count

> Thuộc nhóm **Resource Metrics** trong phân cấp S011 OB005.

## RS013 — Resource Governance

- Allocation qua Governance (S013): Policy Check + Governance Check.
- Isolation theo S012 POL-ISOL-001.
- Violation → Deny + Invalid Audit (S013).

## RS014 — Resource Validation

Doctor kiểm tra:

- Double Allocation
- Resource Leak
- Orphan Resource
- Invalid Owner
- Quota Violation
- Undefined Resource

**Result:** Valid → Runtime không leak, không double allocation. Invalid → Resource bị chặn, có Invalid Audit (S013).

## RS015 — Machine-readable

```text
resources.yaml
resource-model.yaml
resource-categories.yaml
resource-lifecycle.yaml
resource-allocation.yaml
resource-access.yaml
resource-events.yaml
resource-metrics.yaml
resource-validation.yaml
resources.schema.json
```

## RS016 — Traceability

```text
Resource
    ↓
Allocation
    ↓
Execution
    ↓
Artifact
```

## RS017 — Success Criteria

- Mọi Resource đều có đúng một Owner.
- Không Resource nào bị Leak.
- Không Double Allocation.
- Mọi Allocation đi qua Policy (S012) và Governance (S013).
- Mọi Resource đều quan sát được (S011).
- Mọi Resource đều đăng ký trong Registry (S014).
- Doctor xác minh toàn bộ Resource từ machine-readable.

## Tham chiếu

- `resources.yaml` — nguồn dữ liệu chuẩn
- `resource-model.yaml` · `resource-categories.yaml` · `resource-lifecycle.yaml`
- `resource-allocation.yaml` · `resource-access.yaml`
- `resource-events.yaml` · `resource-metrics.yaml` · `resource-validation.yaml`
- `resources.schema.json`
- S009: `../S009/state-machine.yaml`
- S010: `../S010/execution-flow.md`
- S011: `../S011/observability.md`
- S012: `../S012/policies.md`
- S013: `../S013/governance.md`
- S014: `../S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
