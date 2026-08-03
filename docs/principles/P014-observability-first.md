---
id: P014
name: Observability First
status: Draft
category: Quality
severity: high
breaking_change: true
enforced_by:
  - doctor
  - observability
implemented_in:
  - SPEC-008
related:
  - P005
  - P009
statement: >
  Mọi hoạt động đều sinh Event, Metrics, Logs, Artifacts.
rationale: >
  Không đo được thì không kiểm soát được. Observability cho phép audit, debug, tối ưu.
rules:
  - Mọi hoạt động sinh dữ liệu quan sát.
  - Event cho state change (P005).
  - Metrics cho hiệu năng.
  - Artifacts cho output.
implications:
  - Doctor đọc được trạng thái.
  - Dashboard hiển thị tuân thủ.
anti_patterns:
  - Hoạt động không để lại vết.
  - Không có log/metrics/event.
exceptions:
  - Không có.
examples:
  - Mỗi Task sinh event + metrics + artifact.
references:
  - P005 Event Driven
  - P009 Single Source of Truth
---

# P014 — Observability First

## Statement

> Mọi hoạt động đều sinh Event, Metrics, Logs, Artifacts.

## Rules

- Event cho state change.
- Metrics cho hiệu năng.
- Logs cho debug.
- Artifacts cho output.

## Implications

- Doctor đọc được trạng thái.
- Dashboard hiển thị tuân thủ.

## Anti Pattern

❌ Hoạt động không để lại vết.
