---
name: system-knowledge-graph
description: >
  System Knowledge Graph v9.0 — source of truth của toàn bộ framework.
  Entity + Relation cho mọi thực thể: workflow, capability, agent, skill, artifact, knowledge.
  Đổi tên kiến trúc thành AI Operating System (AIOS).
agent: general
---

# System Knowledge Graph v9.0

## 1. Đổi tên: AI Agent Framework → AIOS

Đến Phase 9, hệ thống đủ thành phần một "hệ điều hành cho AI":

| Thành phần | Vai trò AIOS |
|------------|--------------|
| Runtime | Kernel |
| Registry | Service Discovery |
| Context Engine | Memory Manager |
| Artifact Store | File System |
| Event Bus | Message Bus |
| Simulation | Sandbox |
| Doctor | Diagnostics |
| Knowledge Graph | System Database |

> Agent chỉ còn là **một loại ứng dụng chạy trên AIOS** — không còn là trung tâm kiến trúc.

## 2. Knowledge → System Knowledge Graph

**Trước**: `knowledge/blazor.md`, `knowledge/pattern.md` — agent đọc file.

**Sau**: Graph — mọi thứ là Entity + Relation. Không đọc thư mục.

```text
Workflow → Capability → Agent → Skill → Artifact → Knowledge
```

## 3. Kiến trúc

```text
        Knowledge Sources (knowledge/, memory/, workflows/, contracts/, artifacts/, registry/)
                          │
                  Knowledge Indexer
                          │
                  Entity Extractor
                          │
                  Relation Builder
                          │
                  System Knowledge Graph
                          │
          ┌───────────────┼────────────────┐
          │               │                │
      Context         Capability       Doctor
          │               │                │
      Evolution          Dashboard
```

## 4. Entity + Relation

- **Entity**: node — framework, language, pattern, capability, workflow, agent, skill, artifact, lesson...
- **Relation**: edge — uses, depends_on, creates, consumes, implements, requires, references...

```text
Builder --creates--> Code
Code    --consumed by--> Reviewer
Blazor  --uses--> FluentUI
```

## 5. Lợi ích

- **Context Engine**: query graph thay vì scan thư mục.
- **Doctor**: phát hiện agent/capability mồ côi.
- **Dashboard**: trực quan hóa toàn bộ hệ thống.
- **Evolution**: biết module nào ảnh hưởng module nào.
- **Plugin**: thêm node + relation, không sửa lõi.

## 6. File hệ thống

| File | Vai trò |
|------|---------|
| `graph.schema.yaml` | Graph schema |
| `entity.schema.yaml` | Entity schema |
| `relation.schema.yaml` | Relation schema |
| `architecture.md` | Kiến trúc AIOS + graph |
| `graph.md` | Graph operations |
| `entities.md` | Entity types + extract |
| `relations.md` | Relation types + build |
| `indexer.md` | Indexer pipeline |
| `query.md` | Query API |
| `ranking.md` | Ranking + semantic link |
| `validator.md` | Validation checks |
| `metrics.md` | Metrics |