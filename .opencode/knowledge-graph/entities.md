---
name: knowledge-entities
description: Entities — 15 entity types chuẩn + quy trình entity extraction từ sources.
agent: general
---

# Entities

## 1. 15 Entity Types

| Type | Ví dụ | Nguồn |
|------|-------|-------|
| framework | Blazor, FluentUI | knowledge, docs |
| language | C#, TypeScript | knowledge |
| pattern | cache-first, DI | knowledge |
| component | FluentButton | docs |
| service | CharService | source, docs |
| capability | implementation.code | registry |
| workflow | feature, bugfix | workflows |
| artifact | PLAN-001 | artifacts |
| agent | planner, builder | agents/metadata |
| command | team-build | commands |
| skill | impeccable | skills |
| contract | planning-output | contracts |
| rule | UTF-8 no-BOM | AGENTS.md |
| lesson | lesson-041 | knowledge |
| failure | failure-042 | memory |

## 2. Entity object

```yaml
id: ENT-001
type: framework
name: blazor
source: knowledge/blazor.md
version: "1.0"
tags: [ui, component, microsoft]
properties: { dotnet: 10, wasm: true }
```

## 3. Extraction rules

- Mỗi source file → 1+ entity.
- Tên entity = title/name rõ ràng.
- Type theo 15 chuẩn.
- Tags trích từ heading/keyword.

## 4. Ví dụ extraction

File `Blazor Component Lifecycle`:

```text
Entity: { type: framework, name: Blazor }
Entity: { type: pattern, name: Component Lifecycle }
Relation: Blazor --uses--> Component Lifecycle
```

## 5. Tương tác

- `indexer.md` — extractor pipeline.
- `entity.schema.yaml` — contract.
- `relations.md` — build edges.