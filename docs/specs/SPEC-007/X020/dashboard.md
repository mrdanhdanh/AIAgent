---
name: spec-007-x020-dashboard
description: SPEC-007 X020 - Artifact Dashboard. 6 panels tu S011 metrics.
agent: general
---

# X020 - Artifact Dashboard

> **SPEC-007**: Artifact Manager - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Lam sao quan sat Artifact Manager tren mot man hinh?**

## XDA001 - Philosophy

- Dashboard doc TU metrics/events S011 - khong tao nguon moi.
- Mo panel mo ta mot khia canh Artifact.
- Khong co dashboard -> khong debug duoc (P005).

## XDA002 - Panels (6)

| Panel | Mo ta | Nguon du lieu |
|-------|-------|---------------|
| XPAN-001 | Artifact Activity | X011 metrics |
| XPAN-002 | Artifact Lifecycle | X009 states |
| XPAN-003 | Artifact Failures | X015 metrics |
| XPAN-004 | Storage Usage | X015 metrics |
| XPAN-005 | Retention Status | X015 metrics |
| XPAN-006 | Compliance Score | X016 report |

## XDA003 - Config

Refresh 30s, theme S011, filters (artifact_id, state, producer_id, time_range), export JSON.

## XDA004 - Events

ARTIFACT_DASHBOARD_OPENED / FILTERED / EXPORTED (S011).

## XDA005 - Tiep nhan

- Neu metric thieu -> loi X011, khong che dashboard.
- Neu score thap -> dan X019 Doctor.

## Tham chieu

- X011 Observability - SPEC-007
- X016 Compliance - SPEC-007
- X019 Doctor - SPEC-007
- SPEC-001 Runtime Kernel
