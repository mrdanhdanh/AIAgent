---
name: SPEC-010-x020-dashboard
description: SPEC-010 X020 - Plugin Dashboard. 6 panels tu S011 metrics.
agent: general
---

# X020 - Plugin Dashboard

> **SPEC-010**: Plugin Framework - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Lam sao quan sat Plugin Framework tren mot man hinh?**

## XDA001 - Philosophy

- Dashboard doc TU metrics/events S011 - khong tao nguon moi.
- Mo panel mo ta mot khia canh Plugin.
- Khong co dashboard -> khong debug duoc (P005).

## XDA002 - Panels (6)

| Panel | Mo ta | Nguon du lieu |
|-------|-------|---------------|
| XPAN-001 | Plugin Activity | X011 metrics |
| XPAN-002 | Plugin Lifecycle | X009 states |
| XPAN-003 | Plugin Failures | X015 metrics |
| XPAN-004 | Version Status | X011 metrics |
| XPAN-005 | Binding Status | X011 metrics |
| XPAN-006 | Compliance Score | X016 report |

## XDA003 - Config

Refresh 30s, theme S011, filters (PLUGIN_id, state, provider_id, time_range), export JSON.

## XDA004 - Events

PLUGIN_DASHBOARD_OPENED / FILTERED / EXPORTED (S011).

## XDA005 - Tiep nhan

- Neu metric thieu -> loi X011, khong che dashboard.
- Neu score thap -> dan X019 Doctor.

## Tham chieu

- X011 Observability - SPEC-010
- X016 Compliance - SPEC-010
- X019 Doctor - SPEC-010
- SPEC-001 Runtime Kernel
