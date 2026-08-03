---
id: P011
name: Explicit Dependency
status: Draft
category: Architecture
severity: high
breaking_change: true
enforced_by:
  - doctor
  - validator
implemented_in:
  - SPEC-002
related:
  - P001
  - P013
statement: >
  Không dependency ẩn. Mọi phụ thuộc khai báo rõ ràng.
rationale: >
  Dependency ẩn → khó hiểu, khó mô phỏng, khó kiểm soát thứ tự.
  Khai báo rõ → Simulation/Doctor dự đoán chính xác.
rules:
  - Mọi phụ thuộc khai báo trong metadata (depends_on).
  - Không phụ thuộc ngầm định vào trạng thái bên ngoài.
implications:
  - Workflow khai báo depends_on: planner, reviewer.
  - Simulation đọc depends_on để dựng đồ thị.
anti_patterns:
  - Phụ thuộc ngầm vào thứ tự chạy.
  - Đọc dữ liệu không khai báo.
exceptions:
  - Không có.
examples:
  - depends_on: [planner, reviewer].
references:
  - P001 Runtime First
  - P013 Simulation Before Execution
---

# P011 — Explicit Dependency

## Statement

> Không dependency ẩn.

## Rules

```text
depends_on:
  - planner
  - reviewer
```

## Implications

- Mọi phụ thuộc khai báo rõ.
- Simulation/Doctor đọc được đồ thị phụ thuộc.

## Anti Pattern

❌ Dependency ngầm / đọc dữ liệu không khai báo.
