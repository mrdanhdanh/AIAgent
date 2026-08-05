---
name: prompt-registry-architecture
description: Kiến trúc Prompt Registry — registry index, versioning, resolution.
agent: general
---

# Prompt Registry — Architecture

## 1. Components

```text
Prompt Store (prompts/*.md)
        │
        ▼
Prompt Registry (prompt-registry.yaml)
  id → { file, version }
        │
        ▼
Resolver (agent prompt id → prompt content)
```

## 2. Registry entry

```yaml
planner.v7:
  file: prompts/planner/v7.md
  version: 7
  status: active
  supersedes: planner.v6
```

## 3. Resolution

```text
Agent.Behavior.prompt = "planner.v7"
  → Registry.Resolve("planner.v7")
  → load prompts/planner/v7.md
  → inject vào runtime
```

## 4. Versioning

- Semantic: v7 = version 7.
- Immutable: không sửa prompt cũ, tạo version mới.
- Active/superseded status.

## 5. Tương tác

- `prompt-registry.yaml` — index.
- `agents/` (Phase 3) — ref.
- `plugins/` (Phase 11) — override.