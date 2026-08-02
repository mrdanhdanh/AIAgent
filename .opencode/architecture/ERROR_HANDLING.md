---
name: architecture-error-handling
description: ERROR_HANDLING — chuẩn hóa mã lỗi và chiến lược xử lý lỗi cho Agent Framework v4.
agent: general
---

# ERROR_HANDLING.md — Mã Lỗi & Chiến Lược

> Chuẩn hóa lỗi. Doctor và các phase sau dùng chung bộ mã lỗi này.

## 1. Format mã lỗi

```
<PREFIX>-<NNN>
```

| Prefix | Nhóm |
|--------|------|
| WF | Workflow |
| AG | Agent |
| CAP | Capability |
| CTX | Context |
| ART | Artifact |
| EVT | Event |
| CFG | Configuration |
| SEC | Security |
| INF | Infrastructure |

## 2. Bảng mã lỗi

| Mã | Tên | Nhóm | Mô tả |
|----|-----|------|-------|
| WF-001 | Workflow Invalid | Workflow | definition không hợp lệ |
| WF-002 | Workflow Not Found | Workflow | không tìm thấy definition |
| WF-003 | Invalid Transition | Workflow | chuyển trạng thái sai |
| WF-004 | Phase Failed | Workflow | phase lỗi hết retry |
| WF-005 | Rollback Failed | Workflow | rollback thất bại |
| AG-001 | Agent Missing | Agent | agent không tồn tại |
| AG-002 | Agent Busy | Agent | agent đang bận |
| AG-003 | Agent Contract Violated | Agent | output sai contract |
| CAP-001 | Capability Not Found | Capability | không có capability |
| CAP-002 | No Provider | Capability | capability không có agent provider |
| CAP-003 | Registry Invalid | Capability | registry lỗi (CR-00x) |
| CTX-001 | Context Missing | Context | context không có |
| CTX-002 | Context Limit Exceeded | Context | vượt token giới hạn |
| CTX-003 | Scope Violation | Context | truy cập scope trái phép |
| ART-001 | Artifact Missing | Artifact | artifact dependency thiếu |
| ART-002 | Checksum Mismatch | Artifact | checksum không khớp |
| ART-003 | Artifact Invalid | Artifact | artifact sai format |
| EVT-001 | Event Unhandled | Event | không có handler |
| EVT-002 | Event Loop Detected | Event | phát hiện vòng lặp sự kiện |
| CFG-001 | Config Missing | Config | thiếu cấu hình bắt buộc |
| CFG-002 | Config Invalid | Config | cấu hình sai |
| SEC-001 | Permission Denied | Security | không có quyền |
| SEC-002 | Dangerous Command | Security | lệnh nguy hiểm chặn |
| SEC-003 | Untrusted Script | Security | script không tin cậy |
| INF-001 | Storage Unavailable | Infrastructure | lưu trữ lỗi |
| INF-002 | Model Unavailable | Infrastructure | model lỗi |

## 3. Severity

| Mức | Ý nghĩa | Hành động |
|-----|---------|-----------|
| FATAL | không thể tiếp tục | dừng, rollback |
| ERROR | lỗi phase/component | retry, nếu hết → Failed |
| WARN | không nghiêm trọng | ghi log, tiếp tục |
| INFO | thông tin | log thôi |

## 4. Chiến lược xử lý

- **Retry**: WF-004, AG-003, INF-002 (tạm thời) → retry theo definition.
- **Rollback**: FATAL (WF-005) → về trạng thái an toàn.
- **Skip**: phase không bắt buộc lỗi → Skipped.
- **Composition**: lỗi trong skill → wrap thành lỗi capability của agent đang chạy, giữ root cause.

## 5. Logging

Mọi lỗi ghi theo format:

```text
[<timestamp>] <SEVERITY> <ERROR_CODE> <workflow_id> <phase_id> <message>
```

Doctor đọc log này để tính failure rate.

## 6. Lỗi không recover được

- CFG-001, SEC-001, ART-002 (checksum lệch nghiêm trọng) → không retry, báo người dùng.
- Ghi failure record vào `.opencode/memory/` để learning-agent phân tích.