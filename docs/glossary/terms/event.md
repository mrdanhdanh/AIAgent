---
id: TERM-012
name: Event
version: "1.0"
since: "1.0"
status: Approved
category: Platform
owner: Event Bus
stability: Stable
tags: [platform, event, messaging]
aliases: [Notification, Message]
deprecated_aliases: [Signal]
summary: Thông báo bất biến về state change, có lineage.
definition: >
  Event là thông báo bất biến về một state change.
  Event immutable.
purpose: Ghi lại mọi thay đổi để replay/simulate/audit.
entity_type: Message
normative:
  MUST:
    - Be immutable
    - Carry lineage (event chain)
    - Be published qua Event Bus
  MUST NOT:
    - Be modified sau publish
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
depends_on:
  - TERM-001 Runtime
inputs:
  - State change
outputs:
  - Event immutable
lifecycle: Created → Published → Immutable
states: [Created, Published, Immutable]
invariants:
  - Event immutable.
related:
  - TERM-001
  - TERM-008
  - TERM-009
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

## Normative

- **MUST** Be immutable.
- **MUST NOT** Be modified sau publish.

## Responsibilities

- Thông báo state change
- Lưu lineage (event chain)

## Invariant

> Event immutable.
