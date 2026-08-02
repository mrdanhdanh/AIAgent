---
name: architecture-readme
description: README — mục lục và cách sử dụng Architecture Specification Package (ASP v4).
agent: general
---

# Architecture Specification Package — ASP v4

> Phase 0.2 — Đặc tả kiến trúc chuẩn của Agent Framework v4.
> Sau Phase này: **khóa kiến trúc**. Mọi Agent/Command/Skill mới phải tuân theo đặc tả.

## 1. Trạng thái

| Field | Value |
|-------|-------|
| Package | ASP v4 |
| Phase | 0.2 (Architecture Specification) |
| Trạng thái | LOCKED (sau khi hoàn tất) |
| Cách thay đổi | Chỉ qua ADR mới |
| Nguồn | roadmap Upgrade_System_v2.md + Sprint 1/2 |

## 2. Mục lục

| File | Nội dung | Bắt buộc |
|------|----------|----------|
| `ARCHITECTURE.md` | Kiến trúc tổng thể, layers, mục tiêu framework | ⭐⭐⭐⭐⭐ |
| `PRINCIPLES.md` | Nguyên tắc bắt buộc (10) | ⭐⭐⭐⭐⭐ |
| `COMPONENTS.md` | Định nghĩa từng component | ⭐⭐⭐⭐⭐ |
| `DATA_MODEL.md` | Data model mọi object | ⭐⭐⭐⭐⭐ |
| `LIFECYCLE.md` | Lifecycle Workflow/Agent/Artifact | ⭐⭐⭐⭐☆ |
| `SEQUENCE.md` | Sequence diagram (mô tả) | ⭐⭐⭐⭐⭐ |
| `STATE_MACHINE.md` | State machine chuẩn hóa | ⭐⭐⭐⭐⭐ |
| `VERSIONING.md` | Quy ước version | ⭐⭐⭐⭐☆ |
| `DIRECTORY_STANDARD.md` | Chuẩn thư mục + naming | ⭐⭐⭐⭐☆ |
| `ERROR_HANDLING.md` | Mã lỗi + chiến lược xử lý | ⭐⭐⭐⭐⭐ |
| `SECURITY.md` | Bảo mật: permission/sandbox/approval | ⭐⭐⭐⭐⭐ |
| `PERFORMANCE.md` | KPI hiệu năng | ⭐⭐⭐⭐☆ |
| `OBSERVABILITY.md` | Metric quan sát | ⭐⭐⭐⭐☆ |
| `COMPATIBILITY.md` | Backward compatibility v3→v4 | ⭐⭐⭐⭐☆ |
| `GLOSSARY.md` | Thuật ngữ thống nhất | ⭐⭐⭐⭐☆ |
| `CONTRACTS.md` | Quy ước Input/Output Contract + versioning/validation | ⭐⭐⭐⭐⭐ |
| `NAMING_CONVENTIONS.md` | Quy ước tên ID/file/workflow/capability/event/artifact/mã lỗi | ⭐⭐⭐⭐⭐ |
| `adr/` | ADR-001..005 | ⭐⭐⭐⭐⭐ |

## 3. Cách sử dụng

1. **Phase 1 (Workflow Runtime)** → đọc `ARCHITECTURE.md`, `DATA_MODEL.md`, `STATE_MACHINE.md`, `CONTRACTS.md`, `ERROR_HANDLING.md`.
2. **Phase 2 (Capability Registry)** → đọc `COMPONENTS.md`, `NAMING_CONVENTIONS.md`, `DATA_MODEL.md` (Capability).
3. **Phase 3+** → đọc `DATA_MODEL.md`, `LIFECYCLE.md`, `CONTRACTS.md` tương ứng component.
4. Mọi quyết định thay đổi kiến trúc → tạo ADR mới trong `adr/`, cập nhật `DECISION_LOG.md` ở baseline.

## 4. Quy tắc LOCKED

Sau Phase 0.2, **không được thay đổi**:
- Layer architecture
- Data model
- Lifecycle
- State machine
- Capability definition

Nếu muốn đổi → phải tạo ADR mới, qua approval, rồi mới sửa đặc tả.