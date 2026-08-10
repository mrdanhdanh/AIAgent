---
name: spec-003-c003-responsibilities
description: >
  SPEC-003 C003 — Capability Responsibilities. Trả lời: Capability System phải
  chịu trách nhiệm gì? 18 CRR, mỗi responsibility đúng một Owner.
  Mirror W003 (SPEC-002).
agent: general
---

# C003 — Capability Responsibilities

> **SPEC-003**: Capability System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Capability System phải chịu trách nhiệm gì?**

## Invariants

- Một Responsibility chỉ có một Owner.
- Một Responsibility có thể delegate.
- Owner không đổi trong một Capability vòng đời.
- Không Responsibility nào phụ thuộc vòng.

## Delegation

| Responsibility | Delegate cho |
|----------------|--------------|
| Capability Resolution | Runtime (S010 EF007) |
| Registry | Runtime (S014) |
| Policy | Runtime (S012) |

## Responsibilities (18)

### Core

| ID | Responsibility | Priority | Metric |
|----|----------------|----------|--------|
| CRR-001 | Khai báo Capability | Critical | Capability Declare Rate |
| CRR-002 | Đăng ký Capability | Critical | Registration Rate |
| CRR-015 | Quản lý Capability Groups | Medium | Group Coverage |

### Validation

| ID | Responsibility | Priority | Metric |
|----|----------------|----------|--------|
| CRR-003 | Validate Capability | Critical | Invalid Capabilities |
| CRR-009 | Kiểm tra Compatibility | High | Compatibility Coverage |

### Execution

| ID | Responsibility | Priority | Metric |
|----|----------------|----------|--------|
| CRR-005 | Resolve Capability | Critical | Resolution Rate |
| CRR-016 | Điều phối Fallback | Medium | Fallback Coverage |

### Mapping

| ID | Responsibility | Priority | Metric |
|----|----------------|----------|--------|
| CRR-006 | Map Agent | Critical | Mapping Coverage |
| CRR-007 | Map Plugin | High | Mapping Coverage |

### Data

| ID | Responsibility | Priority | Metric |
|----|----------------|----------|--------|
| CRR-004 | Version Capability | High | Version Coverage |
| CRR-013 | Hỗ trợ Discovery | High | Discovery Rate |
| CRR-014 | Quản lý Deprecation | Medium | Deprecation Coverage |

### Observability

| ID | Responsibility | Priority | Metric |
|----|----------------|----------|--------|
| CRR-011 | Theo dõi Usage | High | Usage Coverage |
| CRR-012 | Phát Capability Events | High | Event Coverage |

### Governance

| ID | Responsibility | Priority | Metric |
|----|----------------|----------|--------|
| CRR-008 | Bind Policy | High | Binding Coverage |
| CRR-010 | Thực thi Permission | Critical | Permission Violations |
| CRR-017 | Thực thi Capability Governance | Critical | Governance Violations |
| CRR-018 | Từ chối Capability không hợp lệ | Critical | Rejection Rate |

## Machine-readable

```text
responsibilities.yaml
ownership.yaml
responsibility-mapping.yaml
responsibility-matrix.yaml
responsibility-registry.yaml
responsibilities.schema.json
```

## Tham chiếu

- C001: `../C001-vision.md`
- C002: `../C002/requirements.md`
- W003: `../../SPEC-002/W003/responsibilities.yaml` (mẫu cấu trúc)
- S010 EF007: `../../SPEC-001/S010/execution-flow.md`
- S012: `../../SPEC-001/S012/policies.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
