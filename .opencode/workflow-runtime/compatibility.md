---
name: workflow-runtime-compatibility
description: compatibility — Phase 1.21: Runtime Compatibility Layer. Framework v4 nhận workflow v3 → Convert → Execute, không bắt user migrate ngay.
agent: general
---

# compatibility.md — Runtime Compatibility Layer

> Framework v4 nhưng workflow v3 → Runtime **biết Convert → Execute**, không bắt migrate ngay.

## 1. Vấn đề

```text
Framework v4
   ↓
Workflow v3 (definition cũ)
   ↓
Runtime phải xử lý được
```

## 2. Compatibility Layer

```text
Workflow v3 definition
   ↓
Converter (v3 → v4)
   ↓
Compiled Workflow (v4)
   ↓
Execute
```

| Layer | Việc |
|-------|------|
| Detect | nhận biết schema/version definition |
| Convert | map field v3 → v4 schema |
| Validate | đảm bảo output hợp lệ v4 |
| Execute | chạy như workflow v4 |

## 3. Bảng convert v3 → v4

| v3 | v4 |
|----|-----|
| steps (list) | phases + depends_on (DAG) |
| agent (trực tiếp) | capability/agent (adapter) |
| không manifest | manifest bắt buộc |
| retry mặc định 0 | retry từ config |

## 4. Quy tắc

- Không sửa file v3 gốc.
- Convert tại load time (lazy), cache lại.
- Nếu không convert được → trả lỗi rõ (WF-001) + hướng dẫn migrate.

## 5. Tương tác

- `compiler.md` (tiêu thụ output converted)
- `loader.md` (phát hiện version)
- `manifest.md` (so khớp framework vs workflow)
- `VERSIONING.md` (versioning chung)