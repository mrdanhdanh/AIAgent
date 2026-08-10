---
name: spec-005-r017-extensions
description: SPEC-005 R017 — Registry Extensions.
agent: general
---

# R017 — Registry Extensions

> **SPEC-005**: Registry · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Registry mở rộng như thế nào?**

## RXE001 — Extension Philosophy

- Extension mở rộng Registry qua Contract (R007).
- Extension không sửa Registry core.
- Mọi Extension đăng ký trong Registry (S014).

## RXE002 — Extension Principles

- Contract First (R007) · Registry First (S014) · Isolated (POL-ISOL-001) · Least Privilege (POL-SEC-001) · Versioned · Verifiable (R016).

## RXE003 — Extension Categories

- Entry Type · Binding (R012) · Resolution · Query · Compatibility Extension.

## RXE004 — Canonical Extension Model

```yaml
extension:
  fields: [id, name, version, category, status, owner, capabilities, contracts, dependencies, metadata]
```

## RXE005 — Extension Lifecycle

```text
Draft → Published → Installed → Active → Disabled → Retired
```

## RXE006 — Extension Installation

```text
Register (S014) → Validate (R007 + R013) → Install → Activate
```

## RXE007 — Extension Activation

- Contract hợp lệ (R007) · Compatibility pass (R013) · Governance allow (R013) · Isolation đảm bảo (POL-ISOL-001).

## RXE008 — Extension Capabilities

- Khai báo capabilities → Registry (S014); expose qua Contract (R007).

## RXE009 — Extension Contracts

- Extension implement Contract (R007).

## RXE010 — Extension Isolation

- Context isolated (EF008) · Resource bounded (R015) · Không truy cập Agent Internal State (OB003A) · Không truy cập Extension khác (qua Contract).

## RXE011 — Extension Security

- Permission qua POL-SEC-001 (S012). · Deny mặc định (R013).

## RXE012 — Extension Resources

- Extension owner resource (R015) · Quota riêng.

## RXE013 — Extension Compatibility

- Contract · Capability · Agent (R013) · Registry compatibility check (R014).

## RXE014 — Extension Events

- REGISTRY_EXTENSION_REGISTERED · INSTALLED · ACTIVATED · DISABLED · FAILED · UNINSTALLED.

## RXE015 — Extension Metrics

- active_extensions · installed_extensions · failed_extensions · extension_calls · extension_errors · avg_extension_latency.

## RXE016 — Machine-readable

```text
registry-extensions.yaml
registry-extension-model.yaml
registry-extension-categories.yaml
registry-extension-lifecycle.yaml
registry-extension-installation.yaml
registry-extension-isolation.yaml
registry-extension-events.yaml
registry-extension-metrics.yaml
registry-extension-validation.yaml
registry-extensions.schema.json
```

## RXE017 — Success Criteria

- Extension không sửa Registry core. · Đăng ký S014. · Implement Contract (R007). · Isolation. · Quota riêng (R015).

## Tham chiếu

- R007: `../R007/contracts.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
