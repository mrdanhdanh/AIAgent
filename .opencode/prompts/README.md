---
name: prompt-registry
description: >
  Prompt Registry v18.0 — tách prompt khỏi agent. Agent tham chiếu prompt id/version.
  Sửa prompt không sửa agent.
agent: general
---

# Prompt Registry v18.0

## 1. Vai trò

Tách prompt ra khỏi agent metadata.

```text
Agent → Prompt ID → Prompt Registry → Prompt Version → Runtime
```

## 2. Agent tham chiếu

```yaml
# agent.yaml
behavior:
  prompt: planner.v7
```

Không nhúng prompt — chỉ ref id.

## 3. Lợi ích

- Sửa prompt → không sửa agent.
- Version prompt riêng.
- A/B test prompt.
- Plugin override prompt (Phase 11).

## 4. Tương tác

- `prompts/` directory chứa prompt files.
- `prompt-registry.yaml` — index.
- `agents/metadata/` (Phase 3) — ref prompt id.
- `evaluation/` (Phase 21) — A/B test prompt.