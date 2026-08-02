---
name: spec-000-object-model
description: SPEC-000 object model — entity/event base cho mọi SPEC.
agent: general
---

# SPEC-000 — Object Model

## 1. Entity (base — P3)

```yaml
Entity:
  id: string              # unique
  type: string            # agent/workflow/artifact/capability...
  version: integer        # tăng dần, immutable
  status: string          # created/validated/published/archived
  metadata: map           # thông tin quản lý
  created_at: timestamp
  updated_at: timestamp
```

## 2. Event (base — P4)

```yaml
Event:
  id: string
  type: string            # WORKFLOW_STARTED...
  version: integer
  timestamp: timestamp
  source: string          # agent/module phát
  payload: map            # theo event contract
  parent_event: string    # lineage
  correlation_id: string  # xuyên suốt workflow
```

## 3. Contract (base — P2)

```yaml
Contract:
  id: string
  direction: input | output
  fields:
    - { name, type, required }
```

## 4. Quan hệ

```text
Workflow ──has──> Phase
Workflow ──runs──> Agent (qua capability)
Agent ──produces──> Artifact
Agent ──emits──> Event
Runtime ──owns──> State
```

## 5. Metadata-first

- Mọi thực thể đều là metadata (P3).
- Runtime/resolver/doctor đọc metadata, không hard-code.