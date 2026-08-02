---
name: sdk-doctor
description: Doctor SDK — run scan, get health, reports.
agent: general
---

# Doctor SDK

## 1. Vai trò

Giao diện Doctor v2 (Diagnostics).

## 2. API

| Method | Mô tả |
|--------|-------|
| `Doctor.Scan(mode)` | chạy diagnostics |
| `Doctor.GetHealth()` | health scores |
| `Doctor.GetTechnicalDebt()` | nợ kỹ thuật |
| `Doctor.GetReadiness()` | production/plugin/evolution ready |
| `Doctor.GetReport(id)` | report chi tiết |
| `Doctor.GetRules()` | doctor rules |

## 3. DTO

```yaml
HealthScores: { overall, architecture, runtime, context, ... }
```

## 4. Permission

- Scan/GetHealth/GetReport: `doctor.read`.
- Scan deep: `runtime.read`.

## 5. Tương tác

- `doctor/` (Phase 8).
- Dashboard Doctor Center dùng doctor-sdk.