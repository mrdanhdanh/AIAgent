---
name: spec-014-x001-vision
version: "1.0.0"
description: >
  SPEC-014 X001 — Dashboard Vision. Trả lời: Dashboard tồn tại để làm gì?
  Không nói implementation, không nói class, không nói code.
agent: general
---

# X001 — Dashboard Vision

> **SPEC-014**: Dashboard · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Dashboard tồn tại để làm gì?**

Không nói implementation.

Không nói class.

Không nói code.

## Mission

```text
Dashboard là lớp quan sát hoạt động của toàn bộ AIOS.

Mọi hoạt động của AIOS đều hiển thị trên Dashboard: widget cho từng
khía cạnh, panel tổng hợp, view theo vai trò, filter theo thời gian/scope,
refresh định kỳ, và export để chia sẻ — theo S011 metrics/events.

Không có hoạt động nào mà Dashboard không quan sát được.
```

## Vision

```text
Dashboard trở thành giao diện quan sát thống nhất cho toàn bộ AIOS.

Mọi Workflow, Agent, Capability, Artifact hiển thị trạng thái qua Dashboard
thay vì truy vấn riêng.
```

## Position

Dashboard là **observability view layer** của AIOS.

Dashboard **không phải** Runtime.

Dashboard **không phải** Database.

Dashboard là **lớp hiển thị quan sát** — widget, panel, view, filter, refresh, export.

## Design Philosophy

Dashboard được thiết kế theo các nguyên tắc:

- **Read-only source.** Dashboard doc TỪ S011 — không tạo nguồn dữ liệu mới (P005).
- **Metrics first.** Mọi widget dựa trên metrics/events S011.
- **Observable, never hidden.** Không có dashboard → không debug được (P005).
- **Non-invasive.** Dashboard không thay đổi hệ thống.
- **Safe.** Dashboard không chứa Business Data (S011 OB003A).
- **Extensible.** Widget/panel mở rộng qua extension.

## Invariants

1. Dashboard doc dữ liệu TỪ S011 — không tạo nguồn mới (P005).
2. Dashboard không thay đổi hệ thống — read-only.
3. Dashboard không chứa Business Data (S011 OB003A).
4. Mọi widget dựa trên metrics/events S011.
5. Dashboard theo dõi Health Score (SPEC-011).
6. Mọi view quan sát được qua S011.

## Scope

Dashboard bao gồm:

- Widget (từng khía cạnh).
- Panel (tổng hợp).
- View (theo vai trò).
- Filter (thời gian/scope).
- Refresh (định kỳ).
- Export (JSON/markdown).
- Dashboard Registry (SPEC-005).
- Observability (S011).

Dashboard không bao gồm:

- Runtime (SPEC-001).
- Business Data.
- Chỉnh sửa hệ thống (read-only).
- Quyết định chính sách (S013).

## Relation to SPEC-001/005/008/011

Dashboard **hiển thị observability**:

```text
Dashboard (SPEC-014)
    │
    ├── S011 — Metrics/events (nguồn dữ liệu)
    ├── SPEC-008 — Event Bus (event streams)
    ├── SPEC-011 — Doctor (health score)
    ├── Registry (SPEC-005) — Dashboard Registry
    ├── Constitution (SPEC-000) — nguyên tắc, luật
    └── Hiển thị quan sát
```

Dashboard không định nghĩa lại bất kỳ khái niệm nào của S011.

## Tham chiếu

- Constitution: `docs/specs/SPEC-000/`
- Runtime Kernel: `../SPEC-001/` (S011 metrics)
- Registry: `../SPEC-005/`
- Event Bus: `../SPEC-008/`
- Doctor: `../SPEC-011/`
