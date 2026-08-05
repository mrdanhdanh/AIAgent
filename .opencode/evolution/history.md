---
name: evolution-history
description: Evolution History — log proposal applied; framework version timeline.
agent: general
---

# Evolution History

## 1. Vai trò

Ghi toàn bộ proposal + version timeline — traceability.

## 2. History

```yaml
history:
  - { version: "4.0.0", baseline: true }
  - { version: "4.1.0", proposal: EVO-001, title: "Enable Context Compression", status: applied }
  - { version: "4.2.0", proposal: EVO-002, title: "Deprecate unused capability", status: applied }
  - { version: "4.2.0", proposal: EVO-003, title: "Merge duplicate profiles", status: rejected }
```

## 3. Timeline

```text
v4.0 → Proposal 1 → applied → v4.1 → Proposal 2 → ...
```

## 4. Framework version

```text
4.0.0 → 4.1.0 → 4.2.0
```

- MAJOR: breaking change.
- MINOR: proposal applied (feature/cải tiến).
- PATCH: bugfix/hotfix.

## 5. Learning data

History là input cho Predictor + Analyzer:
- Proposal nào hiệu quả → pattern tốt.
- Proposal nào fail → tránh lặp lại.

## 6. Tương tác

- `metrics.md` — outcomes.
- `predictor.md` — dữ liệu học.
- Dashboard — hiển thị timeline.