---
id: event
name: Event
status: Draft
category: eventing
summary: Thông báo bất biến về state change, có lineage.
definition: >
  Event là thông báo bất biến về một state change.
  Event immutable.
purpose: Ghi lại mọi thay đổi để replay/simulate/audit.
responsibilities:
  - Thông báo state change
  - Lưu lineage (event chain)
does_not_responsible:
  - Chứa state (chỉ thông báo thay đổi)
  - Thực thi
owned_by: Event Bus
used_by:
  - Runtime
  - Doctor
  - Dashboard
  - Simulation
inputs:
  - State change
outputs:
  - Event immutable
lifecycle: Created → Published → Immutable
related:
  - runtime
  - artifact
  - context
examples:
  - PLAN_READY
  - BUILD_FINISHED
  - TEST_FAILED
  - DOCTOR_COMPLETED
references:
  - P005 Event Driven
---

# Event

Ví dụ:

- PLAN_READY
- BUILD_FINISHED
- TEST_FAILED
- DOCTOR_COMPLETED

Event immutable.

## Responsibilities

- Thông báo state change
- Lưu lineage (event chain)

## Not Responsible

- Chứa state (chỉ thông báo thay đổi)
- Thực thi

## Owner

Event Bus

## Used By

- Runtime
- Doctor
- Dashboard
- Simulation

## Input

- State change

## Output

- Event immutable
