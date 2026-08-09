---
name: spec-009-x020-dashboard
description: SPEC-009 X020 - Contract Dashboard. 6 panels tu S011 metrics.
agent: general
---

# X020 - Contract Dashboard

> **SPEC-009**: Contract System - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Lam sao quan sat Contract System tren mot man hinh?**

## XDA001 - Philosophy

- Dashboard doc TU metrics/events S011 - khong tao nguon moi.
- Mo panel mo ta mot khia canh Contract.
- Khong co dashboard -> khong debug duoc (P005).

## XDA002 - Panels (6)

| Panel | Mo ta | Nguon du lieu |
|-------|-------|---------------|
| XPAN-001 | Contract Activity | X011 metrics |
| XPAN-002 | Contract Lifecycle | X009 states |
| XPAN-003 | Contract Failures | X015 metrics |
| XPAN-004 | Version Status | X011 metrics |
| XPAN-005 | Binding Status | X011 metrics |
| XPAN-006 | Compliance Score | X016 report |

## XDA003 - Config

Refresh 30s, theme S011, filters (contract_id, state, provider_id, time_range), export JSON.

## XDA004 - Events

CONTRACT_DASHBOARD_OPENED / FILTERED / EXPORTED (X020 dinh nghia event types — S011 cung cap event model: fields, correlation_id).

## XDA005 - Tiep nhan

- Neu metric thieu -> loi X011, khong che dashboard.
- Neu score thap -> dan X019 Doctor.

## Tham chieu

- X011 Observability - SPEC-009
- X016 Compliance - SPEC-009
- X019 Doctor - SPEC-009
- SPEC-001 Runtime Kernel
