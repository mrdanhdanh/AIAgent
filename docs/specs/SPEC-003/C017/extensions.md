---
name: spec-003-c017-extensions
description: >
  SPEC-003 C017 — Capability Extensions. Trả lời: Capability System mở rộng
  như thế nào? Extension mở rộng qua Contract (C007) và đăng ký trong
  Registry (S014) — không sửa core. Mirror W017 (SPEC-002).
agent: general
---

# C017 — Capability Extensions

> **SPEC-003**: Capability System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Capability System mở rộng như thế nào?**

## CXE001 — Extension Philosophy

- Extension mở rộng Capability System qua Contract (C007).
- Extension không sửa Capability System core.
- Mọi Extension đăng ký trong Registry (S014).
- Extension chỉ truy cập qua Capability + Contract.

## CXE002 — Extension Principles

- **Contract First** (C007) · **Registry First** (S014) · **Isolated** (S012 POL-ISOL-001) · **Least Privilege** (S012 POL-SEC-001) · **Versioned** (SemVer) · **Verifiable** (C016).

## CXE003 — Extension Categories

- **Capability Type Extension** — loại capability mới.
- **Binding Extension** (C012) — loại binding mới.
- **Mapping Extension** — chiến lược mapping Agent/Plugin mới.
- **Resolver Extension** — logic resolution bổ sung.
- **Compatibility Extension** — quy tắc compatibility mới.

## CXE004 — Canonical Extension Model

```yaml
extension:
  fields: [id, name, version, category, status, owner, capabilities, contracts, dependencies, metadata]
```

`contracts` bắt buộc trỏ đến Contract tồn tại (C007).

## CXE005 — Extension Lifecycle

```text
Draft → Published → Installed → Active → Disabled → Retired
```

Chỉ Published mới Install; chỉ Installed mới Activate.

## CXE006 — Extension Installation

```text
Register (S014) → Validate (Contract C007 + Compatibility C013) → Install → Activate
```

Contract không hợp lệ → Install thất bại; Dependency chưa resolve → Install thất bại (S014).

## CXE007 — Extension Activation

Chỉ Activate khi:

- Contract hợp lệ (C007).
- Compatibility pass (C013).
- Governance allow (C013).
- Isolation đảm bảo (S012 POL-ISOL-001).

## CXE008 — Extension Capabilities

- Khai báo capabilities → đăng ký trong Registry (S014).
- Capability chỉ expose qua Contract (C007).
- Resolution qua Registry (C014).

## CXE009 — Extension Contracts

- Extension implement Contract (C007).
- Contract xác định giới hạn giao tiếp — không có cách nào khác.

## CXE010 — Extension Isolation

- Context isolated (S010 EF008).
- Resource bounded (C015 quota).
- Không truy cập Agent Internal State (S011 OB003A).
- Không truy cập Extension khác (gọi qua Contract).
- Vi phạm → CAPABILITY_EXTENSION_FAILED + Disabled.

## CXE011 — Extension Security

- Permission qua POL-SEC-001 (S012).
- Deny mặc định (C013).

## CXE012 — Extension Resources

- Extension owner resource (C015).
- Quota riêng cho mỗi Extension.
- Resource leak → Disabled + Invalid Audit (C013).

## CXE013 — Extension Compatibility

- Contract (C013) · Capability (C013) · **Agent (C013)** · Registry compatibility check (C014).

## CXE014 — Extension Events

- CAPABILITY_EXTENSION_REGISTERED · INSTALLED · ACTIVATED · DISABLED · FAILED · UNINSTALLED.

> C017 định nghĩa 6 event types — S011 cung cấp event model (fields, correlation_id).

## CXE015 — Extension Metrics

- active_extensions · installed_extensions · failed_extensions · extension_calls · extension_errors · avg_extension_latency.

## CXE016 — Machine-readable

```text
capability-extensions.yaml
capability-extension-model.yaml
capability-extension-categories.yaml
capability-extension-lifecycle.yaml
capability-extension-installation.yaml
capability-extension-isolation.yaml
capability-extension-events.yaml
capability-extension-metrics.yaml
capability-extension-validation.yaml
capability-extensions.schema.json
```

## CXE017 — Success Criteria

- Extension không sửa Capability System core.
- Mọi Extension đăng ký trong Registry (S014).
- Mọi Extension implement ít nhất một Contract (C007).
- Extension không truy cập Agent Internal State.
- Extension hoạt động trong isolation (S012 POL-ISOL-001).
- Extension có quota riêng (C015).
- Doctor xác minh từ machine-readable.

## Tham chiếu

- C007: `../C007/contracts.md`
- C013: `../C013/governance.md`
- C014: `../C014/registry.md`
- C015: `../C015/resources.md`
- C016: `../C016/compliance.md`
- W017: `../../SPEC-002/W017/extensions.md` (mẫu)
- Constitution: `docs/specs/SPEC-000/`
