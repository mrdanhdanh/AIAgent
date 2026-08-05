---
name: artifact-query
description: Artifact Query — API tìm kiếm artifact theo type, workflow, agent, capability, tag, phase.
agent: general
---

# Artifact Query

## 1. API

| Method | Mô tả |
|--------|-------|
| `FindByWorkflow(wf)` | artifact trong workflow |
| `FindByAgent(agent)` | artifact tạo bởi agent |
| `FindByType(type)` | artifact cùng type |
| `FindByCapability(cap)` | artifact liên quan capability |
| `FindByPhase(phase)` | artifact trong phase |
| `FindByTag(tag)` | artifact có tag |
| `FindLineage(id)` | full lineage chain |
| `FindDependencies(id)` | dependency sub-graph |

## 2. Implementation

Dùng `artifact-index.json` + in-memory hash map → O(1) cho các query cơ bản.
Lineage/Dependency cần traverse DAG → O(n).

## 3. Ví dụ

```text
FindByPhase(implementation)
  → CODE-001, REV-002

FindLineage(PLAN-001)
  → REQ-001 → PLAN-001 → CODE-001 → REV-001 → TEST-001

FindDependencies(CODE-001)
  → depends_on: [PLAN-001], consumed_by: [REV-001]
```

## 4. Tương tác

- `indexing.md` cung cấp hash map.
- Context Engine dùng query để resolve context.
- Doctor dùng để tìm mồ côi.