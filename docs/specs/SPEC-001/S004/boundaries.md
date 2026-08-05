---
name: spec-001-s004-boundaries
description: >
  SPEC-001 S004 — Runtime Boundaries (Firewall của Runtime). Trả lời: ranh giới
  tuyệt đối của Runtime là gì? 9 boundary B001-B009. Không mô tả implementation.
agent: general
---

# S004 — Runtime Boundaries

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Ranh giới tuyệt đối của Runtime là gì?**

S004 **không mô tả implementation**.

S004 **không mô tả component**.

S004 **không mô tả class**.

S004 chỉ định nghĩa **ranh giới kiến trúc**.

## Mục tiêu

Định nghĩa chính xác:

- Runtime sở hữu gì.
- Runtime không sở hữu gì.
- Runtime được phép làm gì.
- Runtime bị cấm làm gì.
- Runtime phụ thuộc vào gì.
- Runtime cung cấp gì.
- Runtime ủy quyền gì.

> Mọi SPEC sau phải tuân thủ các ranh giới này.

## B001 — Ownership Boundary

### Runtime sở hữu

- Execution
- Execution Context
- Execution State
- Execution Lifecycle
- Coordination
- Event Publishing
- Metrics Collection
- Artifact Publication

> Chỉ Runtime được quyền thay đổi các thực thể này trong quá trình thực thi.

### Runtime không sở hữu

- Workflow Definition
- Agent
- Skill
- Plugin
- Knowledge
- Business Data
- UI
- Infrastructure Resource

## B002 — Permission Boundary

### Runtime được phép

- Khởi tạo Execution.
- Kết thúc Execution.
- Resolve Capability.
- Đọc Workflow Definition.
- Đọc Registry.
- Điều phối Agent.
- Phát Event.
- Thu Metrics.
- Sinh Artifact Metadata.
- Áp dụng Policy.

### Runtime không được phép

- Thực thi Business Logic.
- Chỉnh sửa Workflow Definition.
- Gọi Agent theo tên cụ thể.
- Gọi Database trực tiếp.
- Gọi LLM trực tiếp.
- Truy cập Knowledge trực tiếp.
- Tự ý thay đổi Plugin.
- Bỏ qua Contract.
- Bỏ qua Constitution.

## B003 — Delegation Boundary

Runtime chỉ điều phối, các trách nhiệm sau phải được ủy quyền:

| Chức năng | Delegate đến |
|-----------|--------------|
| Business Logic | Agent |
| Tri thức chuyên môn | Skill |
| Lưu trữ | Infrastructure |
| Định nghĩa Workflow | Workflow |
| Đăng ký Capability | Registry |
| Chính sách phát hành | Governance |
| Giao diện người dùng | Presentation |

## B004 — Dependency Boundary

### Runtime được phụ thuộc

- Constitution
- Workflow Definition
- Capability Registry
- Contract
- Event Schema
- Artifact Schema

### Runtime không được phụ thuộc

- Agent cụ thể
- Plugin cụ thể
- Domain cụ thể
- Framework cụ thể
- Database cụ thể
- LLM cụ thể

## B005 — Interface Boundary

Runtime chỉ công khai các giao diện sau:

| Interface | Purpose |
|-----------|---------|
| Execution API | Khởi tạo và quản lý Execution |
| Context API | Quản lý Execution Context |
| Event API | Publish Event |
| Artifact API | Publish Artifact |
| Metrics API | Publish Metrics |

> Runtime không công khai API nội bộ.

## B006 — State Boundary

Runtime quản lý:

- Execution State
- Lifecycle State
- Context State

Runtime không quản lý:

- Business State
- Domain State
- Plugin State
- Knowledge State

## B007 — Data Boundary

Runtime chỉ xử lý:

- Metadata
- Context
- Event
- Artifact Metadata
- Execution State

Runtime không xử lý:

- Business Object
- Domain Model
- User Data
- Knowledge Content

## B008 — Failure Boundary

Runtime chịu trách nhiệm:

- Phát hiện lỗi.
- Cô lập lỗi.
- Dừng Execution an toàn.
- Publish Failure Event.
- Sinh Failure Artifact.

> Runtime không sửa lỗi nghiệp vụ.

## B009 — Security Boundary

Runtime được phép:

- Kiểm tra Contract.
- Kiểm tra Policy.
- Kiểm tra Permission.

Runtime không:

- Quản lý Identity.
- Quản lý Authentication.
- Quản lý Authorization của hệ thống.

## Boundary Invariants

Các nguyên tắc bất biến:

- Runtime không vượt quá Boundary.
- Runtime không mở rộng Responsibility nếu chưa cập nhật Constitution.
- Runtime chỉ giao tiếp qua Contract.
- Runtime chỉ phụ thuộc vào Abstraction.
- Runtime không biết implementation của Agent.
- Runtime không biết implementation của Plugin.

## Boundary Validation

Doctor phải kiểm tra:

- Có Business Logic trong Runtime không?
- Runtime có gọi Agent cụ thể không?
- Runtime có phụ thuộc Plugin cụ thể không?
- Runtime có truy cập Database trực tiếp không?
- Runtime có ghi Knowledge không?
- Runtime có vi phạm Layering không?
- Runtime có giao tiếp ngoài Contract không?

## Boundary Mapping

| Boundary | Principle | Rule |
|----------|-----------|------|
| Ownership | P001 | RULE-001 |
| Permission | P002 | RULE-003 |
| Delegation | P007 | RULE-006 |
| Dependency | P011 | RULE-002 |
| State | P009 | RULE-005 |
| Data | P010 | RULE-009 |
| Security | P016 | RULE-008 |

## Success Criteria

S004 được coi là hoàn thành khi:

- Mỗi tài nguyên của Runtime có đúng một Owner.
- Mọi quyền hạn của Runtime được định nghĩa rõ.
- Mọi phần ngoài Runtime được phân loại là Dependency hoặc Delegation.
- Không tồn tại vùng trách nhiệm chồng chéo giữa Runtime và Agent.
- Doctor có thể tự động kiểm tra mọi Boundary qua quy tắc machine-readable.

## Tham chiếu

- `boundaries.yaml` — nguồn dữ liệu chuẩn (9 boundary).
- `boundary-registry.yaml` — registry tổng hợp.
- `ownership-boundary.yaml` — B001.
- `delegation-boundary.yaml` — B003.
- `dependency-boundary.yaml` — B004.
- `interface-boundary.yaml` — B005.
- `boundary-matrix.yaml` — Boundary × Principle × Rule.
- `boundaries.schema.json` — validate cấu trúc.
- Constitution: `docs/specs/SPEC-000/`
