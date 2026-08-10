---
name: spec-008-x010-execution-flow
description: SPEC-008 X010 - Event Execution Flow. 8 stages S011, failure, lineage.
agent: general
---

# X010 - Event Execution Flow

> **SPEC-008**: Event Bus - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Event chay nhu the nao trong Runtime?**

## XF001 - Flow Philosophy

- Event chay nhu Execution cua Runtime (SPEC-001).
- Event Bus thuc thi S011 - khong dinh nghia lai flow.
- Khong buoc nao thieu Event (RULE-007).
- Event luon immutable sau publish (P010).

## XF002 - Flow Principles

- **S011** - Publish -> Validate -> Lineage -> Store -> Route -> Deliver -> Replay -> Archive.
- **Validate truoc khi publish** (XFR-008).
- **Append-only** - khong xoa, khong overwrite (P005).
- Moi buoc co trace + event (S011).

## XF003 - Execution Stages (8)

```text
Publish -> Validate -> Lineage -> Store -> Route -> Deliver -> Replay -> Archive
```

(S011 Event Model - Event Bus thuc thi)

## XF004 - Canonical Event Flow

```text
Producer state change
  -> Publish (event_id sinh) [EVENT_CREATED]
  -> Validate (schema + invariants) [EVENT_VALIDATING]
  -> Lineage (event chain) [EVENT_LINEAGED]
  -> Store (append log) [EVENT_STORED]
  -> Route (theo topic) [EVENT_ROUTED]
  -> Deliver (subscriber) [EVENT_DELIVERED]
Simulate/Audit
  -> Replay (tu log) [EVENT_REPLAYED]
Het retention
  -> Archive [EVENT_ARCHIVED]
```

## XF005 - Stage Detail

| Stage | Actor | Input | Output | Event |
|-------|-------|-------|--------|-------|
| Publish | Event Bus | state change | Event | EVENT_CREATED |
| Validate | Event Bus | event | Validated Event | EVENT_VALIDATING |
| Lineage | Event Bus | parent chain | Lineaged Event | EVENT_LINEAGED |
| Store | Event Bus | event | Log entry | EVENT_STORED |
| Route | Router | event + topic | Routed Event | EVENT_ROUTED |
| Deliver | Event Bus | routed | Delivered | EVENT_DELIVERED |
| Replay | ReplayEngine | log | Replayed Event | EVENT_REPLAYED |
| Archive | Event Bus | - | Archived | EVENT_ARCHIVED |

## XF006 - Failure Modes

- Publish fail -> khong tao Event + error.
- Validate fail -> EVENT_REJECTED + cleanup.
- Lineage fail -> khong publish + event.
- Store fail -> retry (S012).
- Route fail -> giu Event, retry.
- Deliver fail -> redeliver (at-least-once).
- Replay fail -> dung replay + event.

## XF007 - Lineage

- Root Event: parent = null.
- Chain Event: parent = event_id truoc (RULE-007).

## XF008 - Query Ops

GetEvent / GetStream / SearchEvents / ListByExecution / GetLineage.
Query khong can grant, khong thay doi Event.

## XF009 - Storage

- Append-only log (P005), persistent.
- Quota theo policy (X012).
- Snapshot optional cho Doctor.

## XF010 - Validation

- Stage order dung S011.
- Moi stage co event.
- Khong mutate/delete (Doctor X019).

## Tham chieu

- S011 Event Model - SPEC-001
- RULE-007 Event
- S012 Policies - SPEC-001
