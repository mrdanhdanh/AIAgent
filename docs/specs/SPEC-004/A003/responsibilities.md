---
name: spec-004-a003-responsibilities
description: >
  SPEC-004 A003 — Agent Responsibilities. Trả lời: Agent System phải chịu
  trách nhiệm gì? 18 ARR, mỗi responsibility đúng một Owner.
  Mirror C003 (SPEC-003).
agent: general
---

# A003 — Agent Responsibilities

> **SPEC-004**: Agent System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Agent System phải chịu trách nhiệm gì?**

## Invariants

- Một Responsibility chỉ có một Owner.
- Một Responsibility có thể delegate.
- Owner không đổi trong một Agent vòng đời.
- Không Responsibility nào phụ thuộc vòng.

## Delegation

| Responsibility | Delegate cho |
|----------------|--------------|
| Agent Execution | Runtime (SPEC-001) |
| Capability Mapping | Capability System (SPEC-003) |
| Orchestration | Workflow Engine (SPEC-002) |
| Policy | Runtime (S012) |

## Responsibilities (18)

### Core

| ID | Responsibility | Priority | Metric |
|----|----------------|----------|--------|
| ARR-001 | Khai báo Agent | Critical | Agent Declare Rate |
| ARR-002 | Đăng ký Agent | Critical | Registration Rate |
| ARR-015 | Quản lý Agent Groups | Medium | Group Coverage |

### Validation

| ID | Responsibility | Priority | Metric |
|----|----------------|----------|--------|
| ARR-003 | Validate Agent | Critical | Invalid Agents |
| ARR-009 | Kiểm tra Compatibility | High | Compatibility Coverage |

### Mapping

| ID | Responsibility | Priority | Metric |
|----|----------------|----------|--------|
| ARR-005 | Map Capability (SPEC-003) | Critical | Mapping Coverage |

### Execution

| ID | Responsibility | Priority | Metric |
|----|----------------|----------|--------|
| ARR-006 | Chạy Agent (SPEC-001) | Critical | Agent Run Rate |
| ARR-007 | Điều phối Agent (SPEC-002) | High | Orchestration Coverage |
| ARR-016 | Quản lý Agent Lifecycle | Critical | Lifecycle Coverage |

### Data

| ID | Responsibility | Priority | Metric |
|----|----------------|----------|--------|
| ARR-004 | Version Agent | High | Version Coverage |
| ARR-013 | Hỗ trợ Discovery | High | Discovery Rate |
| ARR-014 | Quản lý Deprecation | Medium | Deprecation Coverage |

### Observability

| ID | Responsibility | Priority | Metric |
|----|----------------|----------|--------|
| ARR-011 | Theo dõi Usage | High | Usage Coverage |
| ARR-012 | Phát Agent Events | High | Event Coverage |

### Governance

| ID | Responsibility | Priority | Metric |
|----|----------------|----------|--------|
| ARR-008 | Bind Policy | High | Binding Coverage |
| ARR-010 | Thực thi Permission | Critical | Permission Violations |
| ARR-017 | Thực thi Agent Governance | Critical | Governance Violations |
| ARR-018 | Từ chối Agent không hợp lệ | Critical | Rejection Rate |

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

- A001: `../A001-vision.md`
- A002: `../A002/requirements.md`
- C003: `../../SPEC-003/C003/responsibilities.yaml` (mẫu cấu trúc)
- S012: `../../SPEC-001/S012/policies.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
