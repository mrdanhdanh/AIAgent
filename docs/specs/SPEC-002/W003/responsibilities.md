---
name: spec-002-w003-responsibilities
description: >
  SPEC-002 W003 — Workflow Responsibilities. Trả lời: Workflow Engine phải
  chịu trách nhiệm gì? 18 WRR, mỗi responsibility đúng một Owner.
  Mirror S003 (SPEC-001).
agent: general
---

# W003 — Workflow Responsibilities

> **SPEC-002**: Workflow Engine · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Workflow Engine phải chịu trách nhiệm gì?**

## Invariants

- Một Responsibility chỉ có một Owner.
- Một Responsibility có thể delegate.
- Owner không đổi trong một Workflow chạy.
- Không Responsibility nào phụ thuộc vòng.

## Delegation

| Responsibility | Delegate cho |
|----------------|--------------|
| Capability Resolution | Runtime (S014) |
| Step Execution | Runtime (SPEC-001) |
| Business Logic | Agent |

## Responsibilities (18)

### Core

| ID | Responsibility | Priority | Authority | Metric |
|----|----------------|----------|-----------|--------|
| WRR-001 | Định nghĩa Workflow | Critical | Nhận khai báo (YAML) | Workflow Define Rate |
| WRR-002 | Nạp Workflow | Critical | Đọc Registry (S014) | Workflow Load Rate |
| WRR-004 | Chuẩn hóa Workflow | High | Chuẩn hóa cấu trúc (EF006) | Normalization Coverage |

### Validation

| ID | Responsibility | Priority | Authority | Metric |
|----|----------------|----------|-----------|--------|
| WRR-003 | Validate Workflow | Critical | Kiểm tra Workflow | Invalid Workflows |

### Execution

| ID | Responsibility | Priority | Authority | Metric |
|----|----------------|----------|-----------|--------|
| WRR-005 | Resolve Step Capability | Critical | Đọc Registry | Resolution Rate |
| WRR-006 | Chạy step tuần tự | Critical | Điều phối thứ tự | Sequential Coverage |
| WRR-007 | Chạy step song song | High | Scatter/Gather (EF021) | Parallel Coverage |
| WRR-008 | Quản lý Barrier | High | Chờ step con (EF021) | Barrier Coverage |
| WRR-010 | Điều phối Retry | High | POL-RETRY-001 | Retry Success Rate |
| WRR-011 | Quản lý Timeout | High | POL-TIMEOUT-001 | Timeout Coverage |
| WRR-012 | Quản lý Compensation | Medium | Rollback (EF022) | Compensation Coverage |
| WRR-013 | Đánh giá Branch | High | Rẽ nhánh theo điều kiện | Branch Correctness |

### Context

| ID | Responsibility | Priority | Authority | Metric |
|----|----------------|----------|-----------|--------|
| WRR-014 | Chuyển Context giữa step | Critical | Cấp/chuyển Context (EF008) | Context Coverage |

### Data

| ID | Responsibility | Priority | Authority | Metric |
|----|----------------|----------|-----------|--------|
| WRR-015 | Đăng ký Workflow | High | Ghi Registry (S014) | Registration Rate |

### Observability

| ID | Responsibility | Priority | Authority | Metric |
|----|----------------|----------|-----------|--------|
| WRR-016 | Phát Workflow Events | High | Ghi Event Store (S011) | Event Coverage |

### Governance

| ID | Responsibility | Priority | Authority | Metric |
|----|----------------|----------|-----------|--------|
| WRR-009 | Quản lý Approval Gate | Medium | Chặn/duyệt Gate | Gate Compliance |
| WRR-017 | Thực thi Workflow Governance | Critical | Thực thi (S013) | Governance Violations |
| WRR-018 | Từ chối Workflow không hợp lệ | Critical | Từ chối + Audit | Rejection Rate |

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

- W001: `../W001-vision.md`
- W002: `../W002/requirements.md`
- S003: `../../SPEC-001/S003/responsibilities.yaml` (mẫu cấu trúc)
- S010: `../../SPEC-001/S010/execution-flow.md`
- S012: `../../SPEC-001/S012/policies.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
