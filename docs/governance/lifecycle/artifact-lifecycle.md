---
name: lifecycle-artifact
description: >
  Artifact Lifecycle — Created → Indexed → Consumed → Archived.
agent: general
---

# Artifact Lifecycle

> D005 — Vòng đời Artifact (P010 Immutable).

## States

```text
Created
   │
Indexed
   │
Consumed
   │
Archived
```

## Transitions

| From | To | Điều kiện |
|------|-----|-----------|
| Created | Indexed | Artifact Store index (checksum) |
| Indexed | Consumed | Được Agent/Doctor đọc |
| Consumed | Archived | Hết hạn / không dùng |

## Quy tắc

- Artifact **immutable** — không overwrite (P010, RULE-009).
- Thay đổi → version mới.
- Mọi transition phát Event (ArtifactCreated).

## Tham chiếu

- P010 Immutable Artifact
- RULE-009 Versioning
