---
name: spec-011-x020-dashboard
description: SPEC-011 X020 - Doctor Dashboard. 6 panels tu S011 metrics.
agent: general
---

# X020 - Doctor Dashboard

> **SPEC-011**: Doctor - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Lam sao quan sat Doctor tren mot man hinh?**

## XDA001 - Philosophy

- Dashboard doc TU metrics/events S011 - khong tao nguon moi.
- Mo panel mo ta mot khia canh suc khoe.
- Khong co dashboard -> khong debug duoc (P005).

## XDA002 - Panels (6)

| Panel | Mo ta | Nguon du lieu |
|-------|-------|---------------|
| XPAN-001 | Health Trend | X011 metrics |
| XPAN-002 | Findings by Domain | X011 metrics |
| XPAN-003 | Failures | X015 metrics |
| XPAN-004 | Repair Status | X011 metrics |
| XPAN-005 | Coverage | X011 metrics |
| XPAN-006 | Compliance Score | X016 report |

## XDA003 - Config

Refresh 60s, theme S011, filters (scan_id, domain, severity, time_range), export JSON.

## XDA004 - Events

DOCTOR_DASHBOARD_OPENED / FILTERED / EXPORTED (S011).

## XDA005 - Tiep nhan

- Neu metric thieu -> loi X011, khong che dashboard.
- Neu score thap -> dan X019 Doctor.

## Tham chieu

- X011 Observability - SPEC-011
- X016 Compliance - SPEC-011
- X019 Doctor - SPEC-011
- SPEC-001 Runtime Kernel
