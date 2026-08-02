---
name: dashboard-security
description: Dashboard Security — roles Viewer/Operator/Administrator; permission gating cho read + control.
agent: general
---

# Dashboard Security

## 1. Roles

| Role | Quyền |
|------|-------|
| viewer | đọc snapshot, search, simulate (read-only) |
| operator | + control: retry, pause, resume, stop, replay |
| administrator | + plugin install, config, evolution apply |

## 2. Permission matrix

| Action | viewer | operator | admin |
|--------|:------:|:--------:|:-----:|
| GetHealth | ✅ | ✅ | ✅ |
| Search | ✅ | ✅ | ✅ |
| Simulate | ✅ | ✅ | ✅ |
| RetryWorkflow | ❌ | ✅ | ✅ |
| StopWorkflow | ❌ | ✅ | ✅ |
| InstallPlugin | ❌ | ❌ | ✅ |
| ApplyEvolution | ❌ | ❌ | ✅ |

## 3. Enforcement

- API kiểm tra role mỗi request.
- Control actions log audit (ai làm gì khi nào).

## 4. Audit log

```text
{ time, user, action, target, role, result }
```

Gửi Event Bus `SECURITY_DASHBOARD_ACTION`.

## 5. Tương tác

- `api/` — enforce.
- `control/` — permission gate.
- `plugins/security.md` — consistent model.