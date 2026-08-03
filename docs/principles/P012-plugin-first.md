---
id: P012
name: Plugin First
status: Draft
category: Architecture
severity: critical
breaking_change: true
enforced_by:
  - doctor
  - runtime
implemented_in:
  - SPEC-018
related:
  - P001
  - P007
  - P019
statement: >
  Core không sửa. Muốn mở rộng → Plugin.
rationale: >
  Core bất biến → ổn định, ít bug. Mở rộng qua Plugin → không đụng core.
  Plugin chạy trong sandbox theo permission (P016 liên quan).
rules:
  - Không sửa core để thêm tính năng.
  - Mở rộng qua Plugin/SDK/Capability/Metadata.
  - Plugin không truy cập ngoài permission.
implications:
  - Muốn capability mới → Plugin cung cấp.
  - Plugin đăng ký vào Registry.
anti_patterns:
  - Sửa core để thêm tính năng.
  - Plugin truy cập trực tiếp core internals.
exceptions:
  - Không có.
examples:
  - External Plugin cung cấp capability Code Review.
references:
  - P001 Runtime First
  - P007 Capability Driven
  - P019 Open Extension, Closed Core
---

# P012 — Plugin First

## Statement

> Core không sửa. Muốn mở rộng → Plugin.

## Rules

```text
Core
không sửa.

Muốn mở rộng
    ↓
Plugin.
```

## Implications

- Plugin cung cấp capability mới.
- Plugin đăng ký vào Registry.

## Anti Pattern

❌ Sửa core để thêm tính năng.
