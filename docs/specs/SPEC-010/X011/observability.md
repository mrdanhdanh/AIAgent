---
name: spec-010-x011-observability
description: SPEC-010 X011 - Plugin Observability. Events, metrics, audit, traces (S011).
agent: general
---

# X011 - Plugin Observability

> **SPEC-010**: Plugin Framework - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Trang thai Plugin quan sat duoc nhu the nao?**

## XO001 - Philosophy

- Plugin la observable (RULE-014).
- Moi thay doi Plugin phai phat Event (S011).
- Khong the debug Plugin Framework ma khong co event/trace.
- Observability la bat buoc (P005, XNF-004).

## XO002 - Principles

- **Event-first** - moi stage/transition co event.
- **Immutable events** - chi append (P005).
- **Correlated** - correlation_id xuyen suot.
- **Metrics co label** - phan tich duoc.
- **Audit day du** - ai lam gi, khi nao (XFR-016).

## XO003 - Events (12)

| Event | Y nghia |
|-------|---------|
| PLUGIN_INSTALLED | Plugin install |
| PLUGIN_VALIDATING | Dang validate |
| PLUGIN_SANDBOXED | Sandbox thiet lap |
| PLUGIN_ENABLED | Enable xong |
| PLUGIN_EXPORTED | Export xong |
| PLUGIN_DISABLED | Disable |
| PLUGIN_UNINSTALLED | Uninstall |
| PLUGIN_REJECTED | Tu choi |
| PLUGIN_PERMISSION_BLOCKED | Vuot permission bi chan |
| PLUGIN_CORE_MODIFY_BLOCKED | Sua Core bi chan |
| PLUGIN_SANDBOX_VIOLATION | Vi pham sandbox |
| PLUGIN_RESTORED | Phuc hoi |

Event immutable, append-only, co correlation_id (S011).

## XO004 - Metrics (9)

plugin_installed_total, plugin_enabled_total, plugin_disabled_total,
plugin_uninstalled_total, plugin_rejected_total, plugin_exported_total,
plugin_enable_latency_seconds, plugin_install_latency_seconds, plugin_sandbox_violations_total.

Labels: plugin_id, state, execution_id, provider_id.

## XO005 - Traces (7 spans)

plugin.install / validate / sandbox / enable / export / disable / uninstall.
Span attrs: plugin_id, execution_id, version, provider_id.

## XO006 - Audit

who / what / when / where / why - append-only (S011).
XFR-016 bat buoc ghi audit moi thay doi Plugin.

## XO007 - Correlation

correlation_id (Plugin) + trace_id (Runtime) + execution_id (Execution)
-> lien ket moi observability voi Execution.

## XO008 - Dashboard

Plugin Activity, Lifecycle, Failures, Export Status, Sandbox Status.
Tool: X020 Plugin Dashboard.

## XO009 - Health Checks (5)

install_ok, sandbox_ok (khong vi pham), enable_ok,
event_ok (day du), policy_ok (S012).
Score tinh trong X019 Doctor.

## Tham chieu

- S011 Observability - SPEC-001
- S014 Plugin Registry - SPEC-001
- X019 Doctor - SPEC-010
