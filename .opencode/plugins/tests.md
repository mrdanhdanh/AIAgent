---
name: plugin-tests
description: Plugin Tests — install, update, dependency, compatibility, permission, unload.
agent: general
---

# Plugin Tests

## 1. Test cases

| # | Scenario | Expected |
|---|----------|----------|
| 1 | Install plugin | validated + registered exports |
| 2 | Update plugin | version bump, re-certify |
| 3 | Dependency missing | không enable |
| 4 | Framework incompatible | reject |
| 5 | Permission denied | SDK trả PermissionDenied |
| 6 | Unload plugin | exports removed, state clean |
| 7 | Capability conflict | detect + block |
| 8 | Manifest mismatch | PLG-007 warning |
| 9 | Malicious script | sandbox block |
| 10 | Certification fail | không enable |

## 2. Cách chạy

- Unit test Plugin Manager với mock plugin package.
- Integration test install/enable/unload.
- `plugins-validator.ps1` — gate Phase 11 (structure).

## 3. Target

- Coverage: install/update/dependency/compat/permission/unload.
- Sandbox + security enforcement.