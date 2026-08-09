---
name: spec-006-x020-dashboard
description: SPEC-006 X020 - Context Dashboard. 6 panels tu S011 metrics.
agent: general
---

# X020 - Context Dashboard

> **SPEC-006**: Context Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Lam sao quan sat Context Engine tren mot man hinh?**

## XDA001 - Philosophy

- Dashboard doc TU metrics/events S011 - khong tao nguon moi.
- Mo panel mo ta mot khia canh Context.
- Khong co dashboard -> khong debug duoc (P005).

## XDA002 - Panels (6)

| Panel | Mo ta | Nguon du lieu |
|-------|-------|---------------|
| XPAN-001 | Context Activity | X011 metrics |
| XPAN-002 | Context Lifecycle | X009 states |
| XPAN-003 | Context Failures | X015 metrics |
| XPAN-004 | Grant Status | X011 metrics |
| XPAN-005 | Resource Usage | X015 metrics |
| XPAN-006 | Compliance Score | X016 report |

## XDA003 - Config

Refresh 30s, theme S011, filters (execution_id, state, agent_id, time_range), export JSON.

## XDA004 - Events

CONTEXT_DASHBOARD_OPENED / FILTERED / EXPORTED (S011).

## XDA005 - Tiep nhan

- Neu metric thieu -> loi X011, khong che dashboard.
- Neu score thap -> dan X019 Doctor.

## Tham chieu
`n- SPEC-001 Runtime Kernel

- X011 Observability - SPEC-006
- X016 Compliance - SPEC-006
- X019 Doctor - SPEC-006
