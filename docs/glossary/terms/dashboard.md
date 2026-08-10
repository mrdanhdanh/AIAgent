---
id: TERM-020
name: Dashboard
version: "1.0"
since: "1.0"
status: Approved
category: Platform
owner: Dashboard
stability: Stable
tags: [platform, dashboard, observability, view]
aliases: [Observability View, Monitoring]
deprecated_aliases: [Console]
summary: Giao diện quan sát AIOS; doc dữ liệu từ S011.
definition: >
  Dashboard là giao diện quan sát AIOS.
  Dashboard doc dữ liệu từ S011 metrics/events — không tạo nguồn mới.
purpose: Hiển thị sức khỏe và hoạt động AIOS trên một màn hình.
entity_type: Service
normative:
  MUST:
    - Read from S011 metrics/events
    - Be read-only
    - Not contain Business Data
  MUST NOT:
    - Thay đổi hệ thống
    - Tạo nguồn dữ liệu mới
responsibilities:
  - Widget + Panel + View
  - Filter + Refresh + Export
does_not_responsible:
  - Thay đổi hệ thống
  - Tạo nguồn dữ liệu mới
owned_by: Dashboard
used_by:
  - User
  - Doctor
  - Operator
depends_on:
  - TERM-001 Runtime
  - TERM-012 Event
inputs:
  - S011 metrics/events
outputs:
  - Dashboard View
  - Export
lifecycle: Created → Rendered → Filtered → Archived
states: [Created, Rendered, Filtered, Archived]
invariants:
  - Dashboard không thay đổi hệ thống.
related:
  - TERM-001
  - TERM-012
references:
  - SPEC-014 Dashboard
---

# Dashboard

Giao diện quan sát AIOS.

## Normative

- **MUST** Read from S011 metrics/events.
- **MUST** Be read-only.
- **MUST NOT** Thay đổi hệ thống.

## Responsibilities

- Widget + Panel + View
- Filter + Refresh + Export

## Invariant

> Dashboard không thay đổi hệ thống.
