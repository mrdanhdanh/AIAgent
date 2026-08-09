---
name: spec-008-event-models
description: SPEC-008 Appendix - Event Canonical Models. 8 AM, Aggregate Root = Event.
agent: general
---

# Appendix - Event Canonical Models

> **SPEC-008**: Event Bus - **Version**: 1.0.0

## Models (8)

| AM | Name | Kind | Owner | Immutable |
|----|------|------|-------|-----------|
| AM-001 | Event | AggregateRoot | Event Bus | yes |
| AM-002 | EventDefinition | Entity | Event Bus | yes |
| AM-003 | EventStream | Entity | Event Bus | yes |
| AM-004 | EventMetadata | Entity | Event Bus | yes |
| AM-005 | EventLineage | Value | Event Bus | yes |
| AM-006 | EventState | Transient | Event Bus | - |
| AM-007 | Subscription | Entity | Event Bus | - |
| AM-008 | Topic | Value | Event Bus | yes |

`aggregate_root: AM-001 Event`

## Relationships

```text
Event (AM-001)
  +- EventDefinition (AM-002)
  +- EventStream (AM-003)
  +- EventMetadata (AM-004)
  +- EventLineage (AM-005)
  +- EventState (AM-006)
  +- Subscription (AM-007)
  +- Topic (AM-008)
```

## Validation

- Model co schema (event-models.schema.json).
- Immutable model khong doi (P010).
- Aggregate Root doc nhat: Event.

## Tham chieu

- S011 Event Model - SPEC-001
- RULE-007 Event
- TERM-012 Event
