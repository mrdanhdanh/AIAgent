---
name: spec-008-x020-dashboard
description: SPEC-008 X020 - Event Dashboard. 6 panels tu S011 metrics.
agent: general
---

# X020 - Event Dashboard

> **SPEC-008**: Event Bus - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Lam sao quan sat Event Bus tren mot man hinh?**

## XDA001 - Philosophy

- Dashboard doc TU metrics/events S011 - khong tao nguon moi.
- Mo panel mo ta mot khia canh Event.
- Khong co dashboard -> khong debug duoc (P005).

## XDA002 - Panels (6)

| Panel | Mo ta | Nguon du lieu |
|-------|-------|---------------|
| XPAN-001 | Event Activity | X011 metrics |
| XPAN-002 | Event Lifecycle | X009 states |
| XPAN-003 | Event Failures | X015 metrics |
| XPAN-004 | Subscription Status | X011 metrics |
| XPAN-005 | Replay Status | X011 metrics |
| XPAN-006 | Compliance Score | X016 report |

## XDA003 - Config

Refresh 30s, theme S011, filters (event_id, state, producer_id, time_range), export JSON.

## XDA004 - Events

EVENT_DASHBOARD_OPENED / FILTERED / EXPORTED (S011).

## XDA005 - Tiep nhan

- Neu metric thieu -> loi X011, khong che dashboard.
- Neu score thap -> dan X019 Doctor.

## Tham chieu

- X011 Observability - SPEC-008
- X016 Compliance - SPEC-008
- X019 Doctor - SPEC-008
- SPEC-001 Runtime Kernel
