---
name: plugin-validator
description: Plugin Validator — kiểm tra schema, dependency, version, capability, contract, permission.
agent: general
---

# Plugin Validator

## 1. Checks

| # | Mã | Kiểm tra |
|---|-----|----------|
| 1 | PLG-001 | Schema đủ required (plugin.schema.yaml) |
| 2 | PLG-002 | Dependency đủ (depends tồn tại) |
| 3 | PLG-003 | Version hợp lệ semver |
| 4 | PLG-004 | Capability export id hợp lệ |
| 5 | PLG-005 | Contract khớp |
| 6 | PLG-006 | Permission hợp lệ (catalog) |
| 7 | PLG-007 | Manifest exports count khớp thực tế |
| 8 | PLG-008 | Compat framework (compatibility.md) |

## 2. Validation flow

```text
Schema (PLG-001)
  → Permission (PLG-006)
  → Capability (PLG-004)
  → Contract (PLG-005)
  → Dependency (PLG-002)
  → Compat (PLG-008)
  → Manifest (PLG-007)
  → PASS → certify
```

## 3. Error level

- PLG-001/002/006/008 → CRITICAL (block install).
- PLG-004/005 → WARNING.
- PLG-007 → WARNING (mismatch).

## 4. Tương tác

- `manager.md` — gate install/enable.
- `plugins-validator.ps1` — gate Phase 11 (structure + schemas).
- Doctor — static check.