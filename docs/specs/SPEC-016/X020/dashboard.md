---
name: spec-016-x020-dashboard
description: SPEC-016 X020 - CLI Dashboard. 6 panels tu S011 metrics.
agent: general
---

# X020 - CLI Dashboard

> **SPEC-016**: CLI - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Lam sao quan sat CLI tren mot man hinh?**

## XDA001 - Philosophy

- Dashboard doc TU metrics/events S011 - khong tao nguon moi.
- Mo panel mo ta mot khia canh CLI.
- Khong co dashboard -> khong debug duoc (P005).

## XDA002 - Panels (6)

| Panel | Mo ta | Nguon du lieu |
|-------|-------|---------------|
| XPAN-001 | CLI Activity | X011 metrics |
| XPAN-002 | CLI Lifecycle | X009 states |
| XPAN-003 | CLI Failures | X015 metrics |
| XPAN-004 | Binding Status | X011 metrics |
| XPAN-005 | Auth Status | X011 metrics |
| XPAN-006 | Compliance Score | X016 report |

## XDA003 - Config

Refresh 30s, theme S011, filters (client_id, state, version, time_range), export JSON.

## XDA004 - Events

CLI_OPENED / FILTERED / EXPORTED (S011).

## XDA005 - Tiep nhan

- Neu metric thieu -> loi X011, khong che dashboard.
- Neu score thap -> dan X019 Doctor.

## Tham chieu

- X011 Observability - SPEC-016
- X016 Compliance - SPEC-016
- X019 Doctor - SPEC-016
- SPEC-001 Runtime Kernel
