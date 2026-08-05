---
name: sdk-artifact
description: Artifact SDK — CRUD, version, lineage, query artifact.
agent: general
---

# Artifact SDK

## 1. Vai trò

Giao diện Artifact Store.

## 2. API

| Method | Mô tả |
|--------|-------|
| `Artifact.Get(id)` | get artifact |
| `Artifact.Save(artifact)` | create/update |
| `Artifact.Version(id, v)` | get version |
| `Artifact.History(id)` | version history |
| `Artifact.Archive(id)` | archive |
| `Artifact.Query(filter)` | tìm theo type/workflow/tag |
| `Artifact.Lineage(id)` | lineage chain |

## 3. DTO

```yaml
Artifact:
  id, type, version, status, metadata, lineage
```

## 4. Permission

- Get/Query/History/Lineage: `artifact.read`.
- Save/Archive: `artifact.write`.

## 5. Tương tác

- `artifacts/` (Phase 5).
- Context engine dùng artifact-sdk resolve.