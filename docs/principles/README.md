---
name: aios-principles
description: >
  AIOS Constitution Principles (D003 + D003.5) — 20 nguyên tắc gần như bất biến.
  Mỗi principle một file (Policy Engine). Registry: INDEX.yaml + registry/categories/
  dependencies/enforcement.yaml. Đây là tài liệu quan trọng nhất của AIOS.
agent: general
---

# AIOS Constitution Principles

> **D003 + D003.5** — Manifest trả lời AIOS là gì. Glossary trả lời khái niệm là gì.
> Constitution Principles trả lời **AIOS phải hoạt động theo quy luật nào**.
> Đây là những luật **gần như bất biến** — Core Principles có thể đổi, Constitution Principles thì không.
> Principles giờ là **Policy Engine** (nguồn dữ liệu điều khiển), không chỉ tài liệu.

## Vị trí trong hệ thống

```text
SPEC-000
    ↓
Constitution Principles
    ↓
SPEC-001 Runtime
    ↓
SPEC-002 Workflow
    ↓
...
```

## Index (20 Principles)

| ID | File | Category | Statement |
|----|------|----------|-----------|
| P001 | `P001-runtime-first.md` | Core | Runtime là trung tâm; mọi hoạt động qua Runtime điều phối |
| P002 | `P002-contract-first.md` | Architecture | Không module nào giao tiếp trực tiếp; qua Contract |
| P003 | `P003-metadata-first.md` | Data | Mọi thực thể có metadata |
| P004 | `P004-everything-is-versioned.md` | Data | Không object nào không version |
| P005 | `P005-event-driven.md` | Execution | Không notify trực tiếp; mọi state change phát Event |
| P006 | `P006-stateless-agent.md` | Execution | Agent KHÔNG giữ state |
| P007 | `P007-capability-driven.md` | Execution | Runtime chỉ biết Capability, không biết Agent |
| P008 | `P008-single-responsibility.md` | Architecture | Một Agent chỉ làm một việc |
| P009 | `P009-single-source-of-truth.md` | Data | Mỗi dữ liệu một nguồn duy nhất |
| P010 | `P010-immutable-artifact.md` | Data | Artifact sinh ra không sửa; sửa = version mới |
| P011 | `P011-explicit-dependency.md` | Architecture | Không dependency ẩn |
| P012 | `P012-plugin-first.md` | Platform | Core không sửa; mở rộng qua Plugin |
| P013 | `P013-simulation-before-execution.md` | Evolution | Workflow mới qua Simulation trước Execute |
| P014 | `P014-observability-first.md` | Platform | Mọi hoạt động sinh Event/Metrics/Logs/Artifacts |
| P015 | `P015-fail-safe.md` | Security | Lỗi → Rollback → Artifact → Audit |
| P016 | `P016-human-approval.md` | Governance | AI không Merge/Release/Delete nếu chưa qua Policy |
| P017 | `P017-ai-native.md` | Evolution | Mọi thứ Machine Readable + Human Readable |
| P018 | `P018-evolvable.md` | Evolution | Mọi module hỗ trợ Migration/Compatibility/Versioning |
| P019 | `P019-open-extension-closed-core.md` | Architecture | Core bất biến; mở rộng bằng Plugin/SDK/Capability/Metadata |
| P020 | `P020-constitution-first.md` | Governance | Constitution > ADR > SPEC > Contract > Implementation > Config |

## Policy Engine (D003.5)

Principles không còn là tài liệu — là **nguồn dữ liệu điều khiển**:

| File | Vai trò |
|------|---------|
| `INDEX.yaml` | Registry-like: mỗi P gồm file/category/priority/owner/version/status/requires/enforced_by/verification |
| `registry.yaml` | Metadata tổng hợp toàn bộ principle |
| `categories.yaml` | Mapping category → principle |
| `dependencies.yaml` | requires / conflicts / strengthens |
| `enforcement.yaml` | Doctor/Runtime/Validator enforce principle nào |

## Template (Executable)

Mỗi principle có YAML frontmatter executable:

```yaml
id: P001
name: Runtime First
status: Stable
version: 1.0.0
category: Core
priority: Critical
normative: MUST
owner: Runtime Team
requires_adr: true
rationale_type: Architecture
affects: [Runtime, Workflow, Agent, Registry]
verification:
  doctor: [runtime-direct-call, agent-chain]
  runtime: [orchestration-check]
  tests: [runtime-first-tests]
violation:
  level: Critical
  action: [stop_execution, doctor_error]
formal_rule: caller != Agent && callee == Runtime
decision:
  mandatory: true
  runtime: true
  doctor: true
  dashboard: false
requires: [P002, P005, P007]
conflicts: []
strengthens: [P005]
```

## Categories (8)

- **Core**: P001
- **Execution**: P005, P006, P007
- **Architecture**: P002, P008, P011, P019
- **Platform**: P012, P014
- **Data**: P003, P004, P009, P010
- **Security**: P015
- **Governance**: P016, P020
- **Evolution**: P013, P017, P018

## Tham chiếu

- Manifest liệt kê P001–P020: `docs/manifest/AIOS_MANIFEST.yaml`
- Glossary: `docs/glossary/`
- Chi tiết quan hệ: `dependencies.yaml`
- Chi tiết enforcement: `enforcement.yaml`
