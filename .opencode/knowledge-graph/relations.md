---
name: knowledge-relations
description: Relations — 12 relation types chuẩn + relation builder từ entity pairs.
agent: general
---

# Relations

## 1. 12 Relation Types

| Type | Ví dụ |
|------|-------|
| uses | Blazor --uses--> FluentUI |
| depends_on | builder --depends_on--> planning.task |
| creates | planner --creates--> plan |
| consumes | builder --consumes--> plan |
| implements | builder --implements--> code |
| extends | component --extends--> base-component |
| inherits | service --inherits--> interface |
| requires | capability --requires--> context |
| references | doc --references--> entity |
| similar_to | pattern-a --similar_to--> pattern-b |
| conflicts_with | agent-a --conflicts_with--> agent-b |
| part_of | capability --part_of--> category |

## 2. Relation object

```yaml
id: REL-001
type: creates
source: ENT-planner
target: ENT-plan
weight: 1.0
confidence: 1.0
source_ref: agents/metadata/planner.yaml:3
```

## 3. Relation builder rules

- **Dependency**: workflow definition `depends_on` → relation.
- **Capability graph**: capability → agent/skill/command (registry).
- **Artifact lineage**: parent/derived_from → relation.
- **Agent behavior**: creates/consumes artifact type.
- **Knowledge**: keyword co-occurrence → uses/similar_to.

## 4. Ví dụ build

```text
Registry:
  capability: implementation.code
  agent: builder (supports)
→ REL: builder --implements--> implementation.code

Workflow:
  phase planning depends_on analysis
→ REL: planning --depends_on--> analysis

Artifact:
  PLAN-001 parent REQ-001
→ REL: PLAN-001 --derives_from--> REQ-001
```

## 5. Tương tác

- `indexer.md` — builder.
- `relation.schema.yaml` — contract.
- `ranking.md` — weight → rank.