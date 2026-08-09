---
name: spec-004-a017-extensions
description: >
  SPEC-004 A017 — Agent Extensions. Trả lời: Agent System mở rộng như thế nào?
  Extension mở rộng qua Contract (A007) và đăng ký trong Registry (S014) —
  không sửa core. Mirror C017 (SPEC-003).
agent: general
---

# A017 — Agent Extensions

> **SPEC-004**: Agent System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Agent System mở rộng như thế nào?**

## AXE001 — Extension Philosophy

- Extension mở rộng Agent System qua Contract (A007).
- Extension không sửa Agent System core.
- Mọi Extension đăng ký trong Registry (S014).
- Extension chỉ truy cập qua Capability + Contract.

## AXE002 — Extension Principles

- **Contract First** (A007) · **Registry First** (S014) · **Isolated** (S012 POL-ISOL-001) · **Least Privilege** (S012 POL-SEC-001) · **Versioned** (SemVer) · **Verifiable** (A016).

## AXE003 — Extension Categories

- **Agent Type Extension** — loại agent mới.
- **Binding Extension** (A012) — loại binding mới.
- **Mapping Extension** (SPEC-003) — chiến lược mapping capability mới.
- **Orchestration Extension** — chiến lược điều phối mới.
- **Compatibility Extension** — quy tắc compatibility mới.

## AXE004 — Canonical Extension Model

```yaml
extension:
  fields: [id, name, version, category, status, owner, capabilities, contracts, dependencies, metadata]
```

`contracts` bắt buộc trỏ đến Contract tồn tại (A007).

## AXE005 — Extension Lifecycle

```text
Draft → Published → Installed → Active → Disabled → Retired
```

Chỉ Published mới Install; chỉ Installed mới Activate.

## AXE006 — Extension Installation

```text
Register (S014) → Validate (Contract A007 + Compatibility A013) → Install → Activate
```

Contract không hợp lệ → Install thất bại; Dependency chưa resolve → Install thất bại (S014).

## AXE007 — Extension Activation

Chỉ Activate khi:

- Contract hợp lệ (A007).
- Compatibility pass (A013).
- Governance allow (A013).
- Isolation đảm bảo (S012 POL-ISOL-001).

## AXE008 — Extension Capabilities

- Khai báo capabilities → đăng ký trong Registry (S014).
- Capability chỉ expose qua Contract (A007).
- Resolution qua Registry (A014).

## AXE009 — Extension Contracts

- Extension implement Contract (A007).
- Contract xác định giới hạn giao tiếp — không có cách nào khác.

## AXE010 — Extension Isolation

- Context isolated (S010 EF008).
- Resource bounded (A015 quota).
- Không truy cập Agent Internal State (S011 OB003A).
- Không truy cập Extension khác (gọi qua Contract).
- Vi phạm → AGENT_EXTENSION_FAILED + Disabled.

## AXE011 — Extension Security

- Permission qua POL-SEC-001 (S012).
- Deny mặc định (A013).

## AXE012 — Extension Resources

- Extension owner resource (A015).
- Quota riêng cho mỗi Extension.
- Resource leak → Disabled + Invalid Audit (A013).

## AXE013 — Extension Compatibility

- Contract (A013) · Capability (A013) · **Agent (A013)** · Registry compatibility check (A014).

## AXE014 — Extension Events

- AGENT_EXTENSION_REGISTERED · INSTALLED · ACTIVATED · DISABLED · FAILED · UNINSTALLED.

> S011 reuse trực tiếp.

## AXE015 — Extension Metrics

- active_extensions · installed_extensions · failed_extensions · extension_calls · extension_errors · avg_extension_latency.

## AXE016 — Machine-readable

```text
agent-extensions.yaml
agent-extension-model.yaml
agent-extension-categories.yaml
agent-extension-lifecycle.yaml
agent-extension-installation.yaml
agent-extension-isolation.yaml
agent-extension-events.yaml
agent-extension-metrics.yaml
agent-extension-validation.yaml
agent-extensions.schema.json
```

## AXE017 — Success Criteria

- Extension không sửa Agent System core.
- Mọi Extension đăng ký trong Registry (S014).
- Mọi Extension implement ít nhất một Contract (A007).
- Extension không truy cập Agent Internal State.
- Extension hoạt động trong isolation (S012 POL-ISOL-001).
- Extension có quota riêng (A015).
- Doctor xác minh từ machine-readable.

## Tham chiếu

- A007: `../A007/contracts.md`
- A013: `../A013/governance.md`
- A014: `../A014/registry.md`
- A015: `../A015/resources.md`
- A016: `../A016/compliance.md`
- C017: `../../SPEC-003/C017/extensions.md` (mẫu)
- Constitution: `docs/specs/SPEC-000/`