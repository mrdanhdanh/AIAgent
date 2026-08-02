---
name: plugin-compatibility
description: Plugin Compatibility — kiểm tra framework version, dependency, capability trước khi enable.
agent: general
---

# Plugin Compatibility

## 1. Checks

| # | Kiểm tra | Điều kiện pass |
|---|----------|----------------|
| 1 | Framework | framework version khớp (>=4.0) |
| 2 | Dependency | depends plugin đã install + enable |
| 3 | Capability | export capability id không conflict |
| 4 | Contract | plugin contract khớp AIOS contract |
| 5 | Runtime | plugin SDK version tương thích runtime |

## 2. Framework compat

```yaml
framework: ">=4.0"
```

Framework `3.5` → Reject.

## 3. Dependency check

```yaml
depends:
  - blazor-plugin
  - oracle-plugin
```

Thiếu `blazor-plugin` → không enable.

## 4. Conflict detection

- Plugin export capability `implementation.code` (trùng core) → warning/block.
- Namespace riêng (`oracle.*`) → an toàn.

## 5. Version policy

- MAJOR bump plugin → re-certify.
- MINOR/PATCH → backward compatible.

## 6. Tương tác

- `validator.md` — gọi compat checks.
- `certification.md` — compat gate.
- `lifecycle.md` — validated state.