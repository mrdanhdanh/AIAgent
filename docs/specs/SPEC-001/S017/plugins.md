---
name: spec-001-s017-plugins
description: >
  SPEC-001 S017 — Runtime Plugins. Trả lời: Runtime mở rộng bằng cách nào?
  Plugin mở rộng Runtime qua Contract (S007) và đăng ký trong Registry
  (S014). 17 sections PL001-PL017.
agent: general
---

# S017 — Runtime Plugins

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: Draft
> **Vai trò**: Định nghĩa Plugin — cơ chế mở rộng Runtime duy nhất, không sửa Runtime core.

## Mục tiêu

> **Runtime mở rộng bằng cách nào?**

Không mô tả:

- implementation
- package
- code
- entry point

Chỉ mô tả **Plugin Model**.

Vị trí trong chuỗi:

```text
Plugin (S017)
    ↓
Registry (S014)
    ↓
Capability Resolution
    ↓
Execution (S010)
```

## PL001 — Plugin Philosophy

- Plugin mở rộng Runtime qua Contract (S007).
- Plugin không sửa Runtime core.
- Mọi Plugin đăng ký trong Registry (S014).
- Plugin chỉ truy cập qua Capability + Contract.

## PL002 — Plugin Principles

- **Contract First** — implement contracts (S007).
- **Registry First** — đăng ký (S014).
- **Isolated** — S012 POL-ISOL-001.
- **Least Privilege** — S012 POL-SEC-001.
- **Versioned** — SemVer.
- **Verifiable** — S016.

## PL003 — Plugin Categories

- Capability Plugin
- Workflow Plugin
- Tool Plugin
- Model Plugin
- Integration Plugin
- Provider Plugin

## PL004 — Canonical Plugin Model

```yaml
plugin:
  id:
  name:
  version:
  category:
  status:
  owner:
  capabilities:
  contracts:
  dependencies:
  metadata:
```

**Rules:** Thiếu bất kỳ field nào → Invalid Plugin; `contracts` bắt buộc trỏ đến Contract tồn tại (S007).

## PL005 — Plugin Lifecycle

```text
Draft
    ↓
Published
    ↓
Installed
    ↓
Active
    ↓
Disabled
    ↓
Retired
```

**Rules:** Chỉ Published mới Install; chỉ Installed mới Activate; Disabled không nhận cuộc gọi mới; Retired giữ traceability.

## PL006 — Plugin Installation

```text
Register (S014 plugin-registry)
    ↓
Validate (Contract S007 + Compatibility S013)
    ↓
Install
    ↓
Activate
```

**Rules:** Contract không hợp lệ → Install thất bại; Dependency chưa resolve → Install thất bại (S014); mỗi bước sinh Event + Audit (S011).

## PL007 — Plugin Activation

Chỉ Activate khi:

- Contract hợp lệ (S007).
- Compatibility pass (S013 GV010).
- Governance allow (S013).
- Isolation đảm bảo (S012 POL-ISOL-001).

## PL008 — Plugin Capabilities

- Plugin khai báo capabilities → đăng ký trong Registry (S014 capability-registry).
- Capability chỉ expose qua Contract (S007).
- Resolution qua Registry (S014 RG005) trước khi sử dụng.

## PL009 — Plugin Contracts

- Plugin implement Contract (S007).
- Contract xác định giới hạn giao tiếp — không có cách nào khác.
- Plugin không được implement Contract chưa published.

## PL010 — Plugin Isolation

- Context isolated (S010 EF008).
- Resource bounded (S015 quota).
- Không truy cập Agent Internal State (S011 OB003A).
- Không truy cập Plugin khác (gọi qua Contract).
- Vi phạm → PLUGIN_FAILED + Disabled.

## PL011 — Plugin Security

- Permission qua POL-SEC-001 (S012).
- Resource Access qua POL-RESACC-001 (S012).
- Deny mặc định (S013).

## PL012 — Plugin Resources

- Plugin owner resource (S015).
- Quota riêng cho mỗi Plugin.
- Resource leak → Plugin bị Disabled + Invalid Audit (S013).

## PL013 — Plugin Compatibility

- Contract (S013 GV010)
- Capability (S013 GV010)
- Plugin (S013 GV010)
- Workflow (S013 GV010)
- Registry compatibility check (S014 RG005)

## PL014 — Plugin Events

- PLUGIN_REGISTERED
- PLUGIN_INSTALLED
- PLUGIN_ACTIVATED
- PLUGIN_DISABLED
- PLUGIN_FAILED
- PLUGIN_UNINSTALLED

> S011 reuse trực tiếp.

## PL015 — Plugin Metrics

- active_plugins
- installed_plugins
- failed_plugins
- plugin_calls
- plugin_errors
- avg_plugin_latency

## PL016 — Machine-readable

```text
plugins.yaml
plugin-model.yaml
plugin-categories.yaml
plugin-lifecycle.yaml
plugin-installation.yaml
plugin-isolation.yaml
plugin-events.yaml
plugin-metrics.yaml
plugin-validation.yaml
plugins.schema.json
```

## PL017 — Success Criteria

- Plugin không sửa Runtime core.
- Mọi Plugin đăng ký trong Registry (S014).
- Mọi Plugin implement ít nhất một Contract (S007).
- Plugin không truy cập Agent Internal State.
- Plugin hoạt động trong isolation (S012 POL-ISOL-001).
- Plugin có quota riêng (S015).
- Doctor xác minh toàn bộ Plugin từ machine-readable.

## Tham chiếu

- `plugins.yaml` — nguồn dữ liệu chuẩn
- `plugin-model.yaml` · `plugin-categories.yaml` · `plugin-lifecycle.yaml`
- `plugin-installation.yaml` · `plugin-isolation.yaml`
- `plugin-events.yaml` · `plugin-metrics.yaml` · `plugin-validation.yaml`
- `plugins.schema.json`
- S007: `../S007/contracts.md`
- S010 EF008: `../S010/execution-flow.md`
- S011: `../S011/observability.md`
- S012: `../S012/policies.md`
- S013: `../S013/governance.md`
- S014: `../S014/registry.md`
- S015: `../S015/resources.md`
- Constitution: `docs/specs/SPEC-000/`
