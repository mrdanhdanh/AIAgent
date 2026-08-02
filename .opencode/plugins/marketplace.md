---
name: plugin-marketplace
description: Plugin Marketplace — search, install, update plugins; chuẩn bị ecosystem.
agent: general
---

# Plugin Marketplace

## 1. Vai trò

Nơi tìm kiếm + cài plugin — không cần thay đổi Core.

## 2. Flow

```text
Search (query, category)
  → Browse plugin metadata
  → Install (installer)
  → Update (installer)
```

## 3. Marketplace index

```text
marketplace.json:
  plugins:
    - { id: oracle, version: 1.0.0, author: OpenCode, downloads: 120, certified: true }
    - { id: blazor, version: 2.0.0, ... }
```

## 4. Categories

- AI/Agent, Database, Frontend, Testing, DevOps, Knowledge, Utility.

## 5. Trust

- Certified badge (certification.md).
- Author verified.
- Downloads/rating.

## 6. Tương tác

- `installer.md` — install/update.
- `certification.md` — trust.
- Dashboard (Phase 12) — marketplace UI.