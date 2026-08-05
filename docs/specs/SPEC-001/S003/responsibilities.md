---
name: spec-001-s003-responsibilities
description: >
  SPEC-001 S003 — Runtime Responsibilities. Trả lời: Runtime chịu trách nhiệm
  về những gì và không chịu trách nhiệm về những gì. 35 trách nhiệm (RR-001..035),
  8 nhóm. Không nói component/class/implementation.
agent: general
---

# S003 — Runtime Responsibilities

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Runtime chịu trách nhiệm về những gì?**

Không nói component.

Không nói class.

Không nói implementation.

Không nói workflow chi tiết.

## Mục tiêu

Xác định **ownership** của Runtime.

Một Responsibility phải có đúng **một Owner**.

Không Responsibility nào được giao cho hai thành phần.

## Nguyên tắc quan trọng

### Responsibility ≠ Capability ≠ Component

Ba khái niệm phải tách biệt tuyệt đối:

| Khái niệm | Vai trò |
|-----------|---------|
| **Responsibility** | Runtime **phải chịu trách nhiệm** về điều gì (S003) |
| **Capability** | Runtime **cần khả năng** gì để hoàn thành trách nhiệm (SPEC-003) |
| **Component** | Runtime **được cấu thành bởi những phần nào** (S006) |

Chuỗi quan hệ:

```text
Requirement
      ↓
Responsibility
      ↓
Capability
      ↓
Component
      ↓
Contract
      ↓
Implementation
```

> Giữ chuỗi này xuyên suốt AIOS → tránh lẫn lộn giữa "việc phải làm", "khả năng cần có" và "cách hiện thực".

## R001 — Core Responsibilities

| ID | Responsibility | Owner | Priority |
|----|----------------|-------|----------|
| RR-001 | Khởi tạo Execution | Runtime | Critical |
| RR-002 | Kết thúc Execution | Runtime | Critical |
| RR-003 | Quản lý Execution Lifecycle | Runtime | Critical |
| RR-004 | Điều phối luồng thực thi | Runtime | Critical |

## R002 — Execution Responsibilities

| ID | Responsibility | Priority |
|----|----------------|----------|
| RR-005 | Đọc Workflow Definition | Critical |
| RR-006 | Resolve Capability | Critical |
| RR-007 | Chọn Agent phù hợp | Critical |
| RR-008 | Điều phối thứ tự thực thi | High |
| RR-009 | Theo dõi tiến trình Execution | High |
| RR-010 | Dừng Execution khi cần | High |

> Runtime điều phối, không thực hiện nghiệp vụ.

## R003 — Context Responsibilities

| ID | Responsibility | Priority |
|----|----------------|----------|
| RR-011 | Tạo Execution Context | Critical |
| RR-012 | Cấp Context cho Agent | Critical |
| RR-013 | Thu hồi Context | High |
| RR-014 | Cô lập Context giữa các Execution | Critical |

## R004 — State Responsibilities

| ID | Responsibility | Priority |
|----|----------------|----------|
| RR-015 | Khởi tạo State | Critical |
| RR-016 | Theo dõi State | High |
| RR-017 | Chuyển State hợp lệ | High |
| RR-018 | Kết thúc bằng Terminal State | Critical |

## R005 — Coordination Responsibilities

| ID | Responsibility | Priority |
|----|----------------|----------|
| RR-019 | Điều phối Agent | Critical |
| RR-020 | Điều phối Capability | Critical |
| RR-021 | Đồng bộ Execution | Medium |
| RR-022 | Điều phối Retry | High |
| RR-023 | Điều phối Cancellation | High |
| RR-024 | Điều phối Approval Gate | Medium |

## R006 — Observability Responsibilities

| ID | Responsibility | Priority |
|----|----------------|----------|
| RR-025 | Phát Event | High |
| RR-026 | Thu Metrics | High |
| RR-027 | Sinh Trace | Medium |
| RR-028 | Ghi Audit Trail | High |

## R007 — Artifact Responsibilities

| ID | Responsibility | Priority |
|----|----------------|----------|
| RR-029 | Sinh Artifact | High |
| RR-030 | Publish Artifact Metadata | High |
| RR-031 | Không sửa Artifact đã sinh | Critical |

## R008 — Governance Responsibilities

| ID | Responsibility | Priority |
|----|----------------|----------|
| RR-032 | Thực thi Constitution | Critical |
| RR-033 | Kiểm tra Contract | Critical |
| RR-034 | Áp dụng Policy | Medium |
| RR-035 | Từ chối Execution vi phạm | Critical |

## Runtime không chịu trách nhiệm

Runtime **không được**:

- Thực thi Business Logic.
- Hiểu Domain.
- Biết Agent cụ thể.
- Chứa Skill.
- Truy cập Database trực tiếp.
- Gọi LLM trực tiếp.
- Chỉnh sửa Workflow.
- Ghi Knowledge.
- Quản lý Plugin.
- Quyết định nghiệp vụ.

## Responsibility Ownership

| Responsibility Group | Owner |
|----------------------|-------|
| Execution | Runtime |
| Context | Runtime |
| State | Runtime |
| Coordination | Runtime |
| Observability | Runtime |
| Artifact Publishing | Runtime |
| Governance Enforcement | Runtime |

Không nhóm nào có nhiều hơn một Owner.

## Responsibility Boundaries

Runtime chịu trách nhiệm:

```text
Execution
Context
State
Coordination
Events
Metrics
Artifacts
```

Runtime không chịu trách nhiệm:

```text
Workflow Authoring
Business Logic
Skill Content
Knowledge
UI
Database
Plugin Implementation
```

## Responsibility Principles Mapping

| Responsibility | Principle |
|----------------|-----------|
| Execution | P001 |
| Capability Resolution | P007 |
| Event Publishing | P005 |
| Artifact Publishing | P010 |
| Constitution Enforcement | P020 |

## Success Criteria

S003 được xem là hoàn thành khi:

- Mỗi Responsibility có đúng một Owner.
- Không Responsibility nào chồng chéo.
- Không Responsibility nào mâu thuẫn với Constitution.
- Runtime không đảm nhận trách nhiệm thuộc Workflow, Agent, Plugin hoặc Knowledge.
- Mọi Responsibility đều truy vết được tới Requirement trong S002.

## Tham chiếu

- `responsibilities.yaml` — nguồn dữ liệu chuẩn (35 RR).
- `responsibility-registry.yaml` — registry tổng hợp (Doctor đọc một file).
- `responsibility-mapping.yaml` — RR → Requirement → Principle → Rule.
- `responsibility-matrix.yaml` — groups × owner × boundary.
- `ownership.yaml` — Runtime owns / not owns.
- `responsibilities.schema.json` — validate cấu trúc.
- S002: `../S002/requirements.yaml`
- Constitution: `docs/specs/SPEC-000/`
