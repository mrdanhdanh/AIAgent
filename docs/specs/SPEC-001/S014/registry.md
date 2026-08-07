---
name: spec-001-s014-registry
description: >
  SPEC-001 S014 — Runtime Registry. Trả lời: Runtime quản lý, khám phá và
  phân giải (resolve) các đối tượng như thế nào? SSOT cho Runtime Metadata.
  Canonical Registry Model — nguồn chuẩn duy nhất cho Registry AIOS.
  21 sections RG001-RG015 (kèm RG003A, RG005A, RG005B, RG008A, RG009A, RG010A).
agent: general
---

# S014 — Runtime Registry

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: Draft
> **Vai trò**: Mắt xích còn thiếu — mọi SPEC trước đều tham chiếu Registry (S006 Resolver, S007 Contract, S008 Reference, S010 Resolution, S013 Compatibility) nhưng chưa ai định nghĩa.

## Câu hỏi duy nhất

> **Runtime quản lý, khám phá và phân giải (resolve) các đối tượng như thế nào?**

Không mô tả:

- database
- storage
- API
- implementation
- package
- code

Chỉ mô tả **Registry Model**.

Vai trò — cầu nối giữa **Capability** và **Execution**:

```text
Capability
        │
        ▼
Registry (S014)
        │
        ▼
Resolution
        │
        ▼
Execution (S010)
```

## RG001 — Registry Philosophy

- Registry là nguồn sự thật duy nhất (Single Source of Truth) cho Runtime Metadata.
- Runtime không hardcode bất kỳ Capability hay Plugin nào.
- Mọi Resolution đều đi qua Registry.
- Registry không chứa Business Logic.

## RG002 — Registry Principles

- Metadata First
- Contract First
- Versioned
- Discoverable
- Immutable (Published)
- Traceable

## RG003 — Registry Categories

- Capability Registry
- Workflow Registry
- Contract Registry
- Component Registry
- Policy Registry
- Plugin Registry
- Agent Registry
- Schema Registry
- Template Registry

## RG003A — Registry Domains

Phân tầng:

```text
Runtime Registry
        │
        ├── Runtime Domain
        ├── Workflow Domain
        ├── Capability Domain
        ├── Plugin Domain
        ├── Policy Domain
        └── Schema Domain
```

> Dashboard nhóm theo domain.

## RG004 — Registry Entries (Canonical Registry Model)

Mọi Entry theo **Canonical Registry Model** (chuẩn hóa giống Contract Model S007):

```yaml
registry_entry:
  id:
  type:
  category:
  version:
  status:
  owner:
  references:
  compatibility:
  lifecycle:
  metadata:
```

**Rules:** Thiếu bất kỳ field nào → Invalid Entry; metadata mở rộng được, không thay đổi model.

## RG005 — Registry Resolution (Pipeline)

```text
Request
    ↓
Normalize
    ↓
Lookup
    ↓
Candidate Selection
    ↓
Compatibility Check
    ↓
Policy Check
    ↓
Governance Check
    ↓
Resolved
```

> Liên kết trực tiếp: **S012** (Policy Check) · **S013** (Governance Check).

## RG005A — Resolution Failure

| Failure | Meaning |
|---------|---------|
| NotFound | không tồn tại |
| Invalid | schema lỗi |
| Deprecated | hết hỗ trợ |
| Incompatible | version |
| Forbidden | governance |
| Ambiguous | nhiều candidate |

> Dashboard hiển thị theo loại.

## RG005B — Resolution Priority

Nhiều Candidate (vd Capability A v1/v2/v3) — ai thắng?

```text
Exact
    ↓
Compatible
    ↓
Latest Stable
    ↓
Latest
    ↓
Failure
```

## RG006 — Resolution Rules

- Resolve theo ID.
- Nếu nhiều Version → áp dụng Resolution Priority (RG005B).
- Không Resolve Entry Deprecated nếu có bản Active.
- Không Resolve Entry Invalid.

## RG007 — Version Resolution

Ưu tiên:

1. Exact Version
2. Compatible Version
3. Latest Compatible
4. Failure

## RG008 — Registry Relationships

Graph đầy đủ (Doctor kiểm tra graph):

```text
Workflow
      │
      ▼
Capability
      │
      ▼
Contract
      │
      ▼
Policy
      │
      ▼
Plugin
```

## RG008A — Registry Dependency

```text
Workflow
    ↓
Capability
    ↓
Contract
    ↓
Schema
```

**Rules:** Không circular — mọi Dependency tạo thành **DAG**.

## RG009 — Registry Ownership

| Registry   | Owner   |
|------------|---------|
| Capability | Runtime |
| Contract   | Runtime |
| Policy     | Runtime |
| Workflow   | Runtime |
| Plugin     | Runtime |
| Agent      | Runtime |

## RG009A — Registry Constraints

Không được:

- Duplicate ID
- Duplicate Version
- Broken Reference
- Circular Reference
- Orphan Entry
- Multiple Active Version
- Invalid Metadata

## RG010 — Registry Lifecycle

```text
Draft
    ↓
Published
    ↓
Deprecated
    ↓
Retired
```

> Published → Immutable.

## RG010A — Registry Governance

Registry cũng phải chịu Governance:

```text
Published
    ↓
Immutable
    ↓
Governance (S013)
    ↓
Deprecated
    ↓
Retired
```

**Rules:** Deprecated chỉ khi qua Governance (S013); Retired giữ traceability.

## RG011 — Registry Validation

Doctor kiểm tra (11 checks):

- Missing Entry
- Duplicate ID
- Broken Reference
- Invalid Version
- Circular Reference
- Invalid Owner
- Orphan Entry
- Dangling Reference
- Duplicate Active Version
- Missing Compatibility
- Invalid Lifecycle

**Result:** Valid → sẵn sàng Resolve. Invalid → Entry bị chặn, có Invalid Audit (S013).

## RG012 — Registry Resolution Events

Sinh Event (10 loại):

- REGISTRY_LOOKUP
- REGISTRY_RESOLVED
- REGISTRY_FAILED
- REGISTRY_DEPRECATED
- ENTRY_REGISTERED
- ENTRY_UPDATED
- ENTRY_DEPRECATED
- ENTRY_RETIRED
- RESOLUTION_FAILED
- COMPATIBILITY_FAILED

> S011 reuse trực tiếp.

## RG013 — Registry Metrics

- registry_entries
- lookup_count
- cache_hit
- resolution_time
- failed_resolution
- deprecated_usage
- active_entries
- deprecated_entries
- resolution_success_rate
- average_lookup_time
- broken_reference
- orphan_entries
- duplicate_entries

## RG014 — Machine-readable

```text
registry.yaml
registry-model.yaml
registry-domains.yaml
registry-events.yaml
registry-lifecycle.yaml
registry-constraints.yaml
registry-traceability.yaml
registry-metrics.yaml
registry-registry.yaml
capability-registry.yaml
workflow-registry.yaml
contract-registry.yaml
policy-registry.yaml
plugin-registry.yaml
agent-registry.yaml
registry-validation.yaml
registry-resolution.yaml
registry.schema.json
```

> `registry-registry.yaml` — Dashboard chỉ cần đọc một file.

## RG015 — Success Criteria

- Runtime chỉ Resolve thông qua Registry.
- Không có Hardcoded Resolution.
- Mọi Registry Entry đều versioned.
- Mọi Resolution đều truy vết được.
- Doctor xác minh toàn bộ Registry từ machine-readable.
- Mỗi Registry Entry có đúng một Owner.
- Không tồn tại Registry Entry mồ côi (Orphan).
- Mọi Resolution đều xác định duy nhất một kết quả hoặc một loại lỗi chuẩn hóa.
- Mọi Dependency giữa Registry Entries tạo thành DAG.
- Dashboard và Doctor dựng được Registry Graph chỉ từ machine-readable.

## Nền tảng cho các SPEC sau

- **S015 — Runtime Resources**: quản lý tài nguyên mà Registry có thể tham chiếu.
- **S016 — Runtime Compliance**: kiểm tra Registry tuân thủ Constitution, Contract, Policy, Governance.
- **S017+**: Plugin, Evolution, Doctor, Dashboard sử dụng Registry như nguồn metadata thống nhất.

## Tham chiếu

- `registry.yaml` — nguồn dữ liệu chuẩn
- `registry-model.yaml` · `registry-domains.yaml` · `registry-events.yaml`
- `registry-lifecycle.yaml` · `registry-constraints.yaml` · `registry-traceability.yaml`
- `registry-metrics.yaml` · `registry-registry.yaml`
- `capability-registry.yaml` · `workflow-registry.yaml` · `contract-registry.yaml`
- `policy-registry.yaml` · `plugin-registry.yaml` · `agent-registry.yaml`
- `registry-resolution.yaml` · `registry-validation.yaml`
- `registry.schema.json`
- S006: `../S006/components.md`
- S007: `../S007/contracts.md`
- S008: `../S008/data-model.md`
- S010: `../S010/execution-flow.md`
- S012: `../S012/policies.md`
- S013: `../S013/governance.md`
- Constitution: `docs/specs/SPEC-000/`
