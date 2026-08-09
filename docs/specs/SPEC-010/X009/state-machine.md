---
name: spec-010-x009-state-machine
description: SPEC-010 X009 - Plugin State Machine. 6 states, 6 transitions, 3 guards.
agent: general
---

# X009 - Plugin State Machine

> **SPEC-010**: Plugin Framework - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Plugin chuyen trang thai nhu the nao?**

## XS001 - Philosophy

- Plugin luon co dung mot State.
- State chi thay doi qua Transition (S009).
- Moi Transition sinh Event (S011).
- **Plugin chay dung State Machine cua Runtime (S009) - khong dinh nghia lai.**

## XS002 - Principles

- State la nguon su that cua Plugin.
- State doc lap implementation.
- Transition quyet dinh Lifecycle (TERM-015).
- Guard chan transition khong hop le.

## XS003 - Structure (2 tang)

1. **Definition State Machine** (XST-001..006, XTR-001..006).
2. **Run State Machine** - tham chieu S009 (Runtime).

## XS004 - Definition States (6)

| State | Category | Type | Terminal |
|-------|----------|------|----------|
| XST-001 Installed | Initial | Initial | - |
| XST-002 Validating | Preparation | Internal | - |
| XST-003 Enabled | Active | Active | - |
| XST-004 Disabled | Active | Active | - |
| XST-005 Uninstalled | Terminal | Terminal | yes |
| XST-006 Rejected | Terminal | Terminal | yes |

`initial_state: XST-001` - `terminal_states: [XST-005, XST-006]`

## XS005 - Definition Transitions (6)

| From -> To | Event | Guard |
|-----------|-------|-------|
| XST-001 -> XST-002 | PLUGIN_VALIDATING | Manifest hop le |
| XST-002 -> XST-003 | PLUGIN_ENABLED | Validate pass + permission OK |
| XST-002 -> XST-006 | PLUGIN_REJECTED | Validate fail |
| XST-003 -> XST-004 | PLUGIN_DISABLED | Can tat |
| XST-004 -> XST-003 | PLUGIN_ENABLED | Enable lai |
| XST-004 -> XST-005 | PLUGIN_UNINSTALLED | Het dung |

## XS006 - Transition Matrix

```text
XST-001 -> XST-002
XST-002 -> XST-003 | XST-006
XST-003 -> XST-004
XST-004 -> XST-003 | XST-005
XST-005 -> (terminal)
XST-006 -> (terminal)
```

## XS007 - Guards (3)

1. XTR-002: Validate pass + permission hop le.
2. XTR-004: Khong co execution dang chay.
3. XTR-006: Da disable (P011).

Guard fail -> BLOCK + PLUGIN_GUARD + Event (S011).

## XS008 - Events (6)

- Moi transition sinh dung mot event PLUGIN_*.
- Event immutable, append-only (P005).
- Event co correlation_id (S011).

## XS009 - Registered Machines

- XSTM-001 Plugin Lifecycle (6 states, 6 transitions).

## XS010 - Validation

- initial_state ton tai, moi state reachable.
- Terminal chi co inbound.
- Validate bang Doctor (X019) + Plugin Test.

## XS011 - Metrics

- plugin_states_total, plugin_transitions_total.
- plugin_rejected_total, plugin_uninstalled_total.

## Tham chieu

- S009 State Machine - SPEC-001
- S014 Plugin Registry - SPEC-001
- TERM-015 Plugin
