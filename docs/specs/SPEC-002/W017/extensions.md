---
name: spec-002-w017-extensions
description: >
  SPEC-002 W017 — Workflow Extensions. Trả lời: Workflow Engine mở rộng như
  thế nào? Extension mở rộng qua Contract (W007) và đăng ký trong Registry
  (S014) — không sửa core. Mirror S017 (SPEC-001).
agent: general
---

# W017 — Workflow Extensions

> **SPEC-002**: Workflow Engine · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Workflow Engine mở rộng như thế nào?**

## WXE001 — Extension Philosophy

- Extension mở rộng Workflow Engine qua Contract (W007).
- Extension không sửa Workflow Engine core.
- Mọi Extension đăng ký trong Registry (S014).
- Extension chỉ truy cập qua Capability + Contract.

## WXE002 — Extension Principles

- **Contract First** (W007) · **Registry First** (S014) · **Isolated** (S012 POL-ISOL-001) · **Least Privilege** (S012 POL-SEC-001) · **Versioned** (SemVer) · **Verifiable** (W016).

## WXE003 — Extension Categories

- **Step Extension** — loại step mới.
- **Gate Extension** — loại gate mới.
- **Condition Extension** — đánh giá điều kiện branch mới.
- **Formatter Extension** — định dạng output mới.
- **Binding Extension** (W012) — loại binding mới.

## WXE004 — Canonical Extension Model

```yaml
extension:
  fields: [id, name, version, category, status, owner, capabilities, contracts, dependencies, metadata]
```

`contracts` bắt buộc trỏ đến Contract tồn tại (W007).

## WXE005 — Extension Lifecycle

```text
Draft → Published → Installed → Active → Disabled → Retired
```

Chỉ Published mới Install; chỉ Installed mới Activate.

## WXE006 — Extension Installation

```text
Register (S014) → Validate (Contract W007 + Compatibility W013) → Install → Activate
```

Contract không hợp lệ → Install thất bại; Dependency chưa resolve → Install thất bại (S014).

## WXE007 — Extension Activation

Chỉ Activate khi:

- Contract hợp lệ (W007).
- Compatibility pass (W013).
- Governance allow (W013).
- Isolation đảm bảo (S012 POL-ISOL-001).

## WXE008 — Extension Capabilities

- Khai báo capabilities → đăng ký trong Registry (S014).
- Capability chỉ expose qua Contract (W007).
- Resolution qua Registry (W014).

## WXE009 — Extension Contracts

- Extension implement Contract (W007).
- Contract xác định giới hạn giao tiếp — không có cách nào khác.

## WXE010 — Extension Isolation

- Context isolated (S010 EF008).
- Resource bounded (W015 quota).
- Không truy cập Agent Internal State (S011 OB003A).
- Không truy cập Extension khác (gọi qua Contract).
- Vi phạm → WORKFLOW_EXTENSION_FAILED + Disabled.

## WXE011 — Extension Security

- Permission qua POL-SEC-001 (S012).
- Deny mặc định (W013).

## WXE012 — Extension Resources

- Extension owner resource (W015).
- Quota riêng cho mỗi Extension.
- Resource leak → Disabled + Invalid Audit (W013).

## WXE013 — Extension Compatibility

- Contract (W013) · Capability (W013) · Workflow (W013) · Registry compatibility check (W014).

## WXE014 — Extension Events

- WORKFLOW_EXTENSION_REGISTERED · INSTALLED · ACTIVATED · DISABLED · FAILED · UNINSTALLED.

> W017 định nghĩa 6 event types WORKFLOW_EXTENSION_* — S011 cung cấp event model (fields, correlation_id).

## WXE015 — Extension Metrics

- active_extensions · installed_extensions · failed_extensions · extension_calls · extension_errors · avg_extension_latency.

## WXE016 — Machine-readable

```text
workflow-extensions.yaml
workflow-extension-model.yaml
workflow-extension-categories.yaml
workflow-extension-lifecycle.yaml
workflow-extension-installation.yaml
workflow-extension-isolation.yaml
workflow-extension-events.yaml
workflow-extension-metrics.yaml
workflow-extension-validation.yaml
workflow-extensions.schema.json
```

## WXE017 — Success Criteria

- Extension không sửa Workflow Engine core.
- Mọi Extension đăng ký trong Registry (S014).
- Mọi Extension implement ít nhất một Contract (W007).
- Extension không truy cập Agent Internal State.
- Extension hoạt động trong isolation (S012 POL-ISOL-001).
- Extension có quota riêng (W015).
- Doctor xác minh từ machine-readable.

## Tham chiếu

- W007: `../W007/contracts.md`
- W013: `../W013/governance.md`
- W014: `../W014/registry.md`
- W015: `../W015/resources.md`
- W016: `../W016/compliance.md`
- S017: `../../SPEC-001/S017/plugins.md` (mẫu)
- Constitution: `docs/specs/SPEC-000/`
