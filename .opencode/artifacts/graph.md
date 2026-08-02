---
name: artifact-graph
description: Artifact Graph — visualization artifact DAG; Knowledge Graph reuse lineage + dependency.
agent: general
---

# Artifact Graph

## 1. Khái niệm

Graph = visualization của Lineage + Dependency DAG. Mỗi node là artifact, mỗi edge là quan hệ.

## 2. Edge types

| Edge | Từ | Đến | Ý nghĩa |
|------|----|-----|---------|
| parent | artifact | parent | cha con lineage |
| derived | artifact | derived_from | dẫn xuất từ |
| consumes | agent artifact | consumed artifact | agent dùng artifact |
| supersedes | old | new | phiên bản thay thế |
| depends | artifact | depends_on | phụ thuộc |

## 3. Mermaid

```mermaid
graph TD
  REQ_001[REQ-001 Requirement] --> PLAN_001[PLAN-001 Plan]
  PLAN_001 --> CODE_001[CODE-001 Code]
  CODE_001 --> REV_001[REV-001 Review]
  REV_001 --> TEST_001[TEST-001 Test]
  CODE_001 --> REV_002[REV-002 Security Review]
```

## 4. Graph query

- `trace(id)` — full lineage forward + backward.
- `impact(id)` — artifact nào bị ảnh hưởng nếu id thay đổi.
- `orphans()` — artifact không có edge vào/ra.

## 5. Tương tác

- `lineage.md` + `dependency.md` → data cho graph.
- Phase 9 (Knowledge Graph) — mở rộng thành full graph có tag + type + agent.
- Simulation (Phase 7) — traverse graph để mô phỏng.