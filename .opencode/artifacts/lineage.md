---
name: artifact-lineage
description: Artifact Lineage — DAG traceability từ requirement tới test; parent, derived_from, consumed_by, superseded_by.
agent: general
---

# Artifact Lineage

## 1. Khái niệm

Lineage = **nguồn gốc + quan hệ** của artifact. Không cần đọc nội dung.

## 2. Fields

| Field | Mô tả |
|-------|-------|
| `parent` | artifact cha trực tiếp |
| `derived_from` | danh sách artifact dẫn xuất |
| `created_by` | agent tạo |
| `consumed_by` | agent đã tiêu thụ |
| `superseded_by` | artifact thay thế (version mới/refactor) |
| `workflow` | WF-ID |
| `phase` | phase trong workflow |

## 3. DAG

```
REQ-001
  ↓ parent
PLAN-001
  ↓ parent
CODE-001
  ↓ parent
REV-001
  ↓ parent
TEST-001
```

Ai cũng traceable:

- `derived_from`: PLAN-001 → REQ-001.
- `consumed_by`: PLAN-001 → [CODE-001] (builder đọc).

## 4. Rule

- Không cycle (validate khi save).
- Một artifact có nhiều `consumed_by` (nhiều agent dùng).
- `parent` là 1 (hoặc null cho root).
- Khi supersede → artifact cũ đánh dấu `superseded_by` tham chiếu artifact mới.

## 5. Ứng dụng

- **Context Engine**: traverse lineage ngược để lấy context liên quan (REQ → PLAN → CODE).
- **Doctor**: phát hiện artifact mồ côi (không consumed_by, không derived_from).
- **Simulation (Phase 7)**: mô phỏng toàn bộ pipeline mà không chạy agent.
- **Knowledge Graph (Phase 9)**: chỉ lập index từ lineage.