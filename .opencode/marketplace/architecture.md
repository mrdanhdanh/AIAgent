---
name: marketplace-architecture
description: Kiến trúc AI Marketplace — package registry, install pipeline, trust.
agent: general
---

# AI Marketplace — Architecture

## 1. Components

```text
Package Index (marketplace.yaml)
        │
        ▼
Package Manager (search/install/update)
        │
        ▼
Validator + Certifier
        │
        ▼
Registry integration (agent/workflow/prompt/...)
```

## 2. Package entry

```yaml
- { id: planner-pro, type: agent, version: 1.0.0, author: ..., certified: true }
- { id: prompt-v8, type: prompt, version: 8, supersedes: v7 }
- { id: blazor-kb, type: knowledge, version: 2.0 }
```

## 3. Install destinations

| Type | Vào đâu |
|------|---------|
| agent | agents/ + registry |
| workflow | workflows/ |
| prompt | prompts/ (registry P18) |
| policy | policy/ (P15) |
| knowledge | knowledge-graph/ + memory |
| doctor-rules | doctor/rules/ |
| simulation-pack | simulation/ |

## 4. Trust

- Certified badge.
- Author verified.
- Checksum + dependency check.

## 5. Tương tác

- `marketplace.schema.yaml`.
- `plugins/marketplace.md`.
- `plugins/certification.md`.
- `release/` (Phase 22) — version.