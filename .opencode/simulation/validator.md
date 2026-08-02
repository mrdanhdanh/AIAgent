---
name: simulation-validator
description: Simulation Validator — kiểm tra simulation hợp lệ: schema, context, artifact, capability, conflict.
agent: general
---

# Simulation Validator

## 1. Checks

| # | Mã | Kiểm tra |
|---|-----|----------|
| 1 | SIM-001 | Simulation object đủ schema |
| 2 | SIM-002 | Mode hợp lệ (5 modes) |
| 3 | SIM-003 | Capability có agent |
| 4 | SIM-004 | Context đủ required |
| 5 | SIM-005 | Artifact version không conflict |
| 6 | SIM-006 | Dependency chain đủ |
| 7 | SIM-007 | Risk + Confidence hợp lệ |

## 2. Context validation

Ví dụ Builder cần `Plan` nhưng Plan missing → SIM-004 fail → simulation fail.

## 3. Artifact validation

Ví dụ Review dùng `Plan v1` nhưng Builder sinh `Plan v2` → SIM-005 version conflict → cảnh báo/fail.

## 4. Capability validation

Workflow yêu cầu `implementation.code` nhưng không có agent hỗ trợ → SIM-003 fail.

## 5. Exit

- `simulation-validator.ps1` — gate Phase 7 (structure + schema).
- Simulation runtime validator — per-run checks SIM-001..007.

## 6. Tương tác

- `dependency-checker.md` — SIM-006.
- `risk-engine.md` — SIM-007.
- `simulation-validator.ps1` — static gate.