---
name: governance-architecture
description: Kiến trúc Governance — rule store, auditor, compliance checker.
agent: general
---

# Governance — Architecture

## 1. Components

```text
Governance Rules (governance.rules.yaml)
        │
        ▼
Rule Checker (validate object vs rule)
        │
        ▼
Auditor (log hành động)
        │
        ▼
Compliance Report
```

## 2. Rule model

```yaml
rules:
  naming:
    agent_id: "^[a-z][a-z0-9-]*$"
    capability_id: "^[a-z]+\.[a-z0-9-]+$"
  lifecycle:
    deprecated_requires_replacement: true
  approval:
    delete_gt_100_files: required
  security:
    plugin_signed: true
```

## 3. Enforcement points

| Point | Check |
|-------|-------|
| Registry register | naming + owner |
| Agent create | metadata đầy đủ |
| Workflow save | version bắt buộc |
| Plugin install | signed |
| Artifact save | checksum |

## 4. Audit

- Mọi hành động ghi audit (who/what/when).
- Immutable audit log.
- Doctor đọc compliance.

## 5. Tương tác

- `governance.schema.yaml`.
- `audit.md`.
- `policy/` — enforce.
- `doctor/` — score.