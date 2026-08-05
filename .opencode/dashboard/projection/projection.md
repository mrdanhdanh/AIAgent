---
name: dashboard-projection
description: Projection — Read Model builder; event → snapshot; dashboard không đọc Core.
agent: general
---

# Dashboard Projection

## 1. Vai trò

Biến event stream thành **Dashboard Snapshot** (Read Model). Dashboard chỉ đọc snapshot.

## 2. Pipeline

```text
Event Bus
  → per-module projection
  → update read model (in-memory)
  → rebuild Dashboard Snapshot
  → persist snapshot.json (optional)
```

## 3. Projections

| Projection | Nguồn event | Read model |
|------------|-------------|------------|
| WorkflowProjection | WORKFLOW_*, PHASE_* | workflow states |
| AgentProjection | AGENT_* | agent status |
| ContextProjection | CONTEXT_* | context metrics |
| ArtifactProjection | ARTIFACT_* | artifact stats |
| EventProjection | all | event log |
| DoctorProjection | DIAGNOSTIC_* | health scores |
| EvolutionProjection | EVO_* | proposals |

## 4. Example

```text
BUILD_COMPLETED event
  → WorkflowProjection.update(WF-101, build=completed)
  → AgentProjection.update(builder, completed)
  → Snapshot.workflows[WF-101].state = build-completed
```

## 5. Snapshot

- Build theo `dashboard.schema.yaml`.
- Rebuild on each event (incremental).
- Query nhanh (in-memory hash maps).

## 6. Tương tác

- `events/` — nguồn.
- `api/` — đọc snapshot.
- `dashboard.schema.yaml` — format.