---
name: aios-principles
description: >
  AIOS Core Principles (D003) — 20 nguyên tắc bất biến. Mỗi principle một file.
  INDEX.yaml cho Doctor/Dashboard/Evolution. Đây là tài liệu quan trọng nhất của AIOS.
agent: general
---

# AIOS Core Principles

> **D003** — Manifest trả lời AIOS là gì. Glossary trả lời khái niệm là gì.
> Core Principles trả lời **AIOS phải hoạt động theo quy luật nào**.
> Đây là những luật **không được vi phạm**.

## Index (20 Principles)

| ID | File | Statement |
|----|------|-----------|
| P001 | `P001-runtime-first.md` | Runtime là trung tâm; mọi hoạt động qua Runtime điều phối |
| P002 | `P002-contract-first.md` | Không module nào giao tiếp trực tiếp; qua Contract |
| P003 | `P003-metadata-first.md` | Mọi thực thể có metadata |
| P004 | `P004-everything-is-versioned.md` | Không object nào không version |
| P005 | `P005-event-driven.md` | Không notify trực tiếp; mọi state change phát Event |
| P006 | `P006-stateless-agent.md` | Agent KHÔNG giữ state |
| P007 | `P007-capability-driven.md` | Runtime chỉ biết Capability, không biết Agent |
| P008 | `P008-single-responsibility.md` | Một Agent chỉ làm một việc |
| P009 | `P009-single-source-of-truth.md` | Mỗi dữ liệu một nguồn duy nhất |
| P010 | `P010-immutable-artifact.md` | Artifact sinh ra không sửa; sửa = version mới |
| P011 | `P011-explicit-dependency.md` | Không dependency ẩn |
| P012 | `P012-plugin-first.md` | Core không sửa; mở rộng qua Plugin |
| P013 | `P013-simulation-before-execution.md` | Workflow mới qua Simulation trước Execute |
| P014 | `P014-observability-first.md` | Mọi hoạt động sinh Event/Metrics/Logs/Artifacts |
| P015 | `P015-fail-safe.md` | Lỗi → Rollback → Artifact → Audit |
| P016 | `P016-human-approval.md` | AI không Merge/Release/Delete nếu chưa qua Policy |
| P017 | `P017-ai-native.md` | Mọi thứ Machine Readable + Human Readable |
| P018 | `P018-evolvable.md` | Mọi module hỗ trợ Migration/Compatibility/Versioning |
| P019 | `P019-open-extension-closed-core.md` | Core bất biến; mở rộng bằng Plugin/SDK/Capability/Metadata |
| P020 | `P020-constitution-first.md` | Constitution > ADR > SPEC > Contract > Implementation > Config |

## Template

Mọi principle dùng chung template (YAML frontmatter + body markdown):

```yaml
id:
name:
status:
category:
statement:
rationale:
rules:
implications:
anti_patterns:
exceptions:
related:
examples:
```

Metadata bổ sung (Doctor/Dashboard/Evolution đọc):

```yaml
severity: critical | high
enforced_by: [doctor, runtime, validator, ...]
implemented_in: [SPEC-001, ...]
related: [P002, ...]
breaking_change: true|false
```

## Categories

- **Runtime**: P001, P005, P006, P007
- **Architecture**: P002, P008, P011, P012, P019
- **Data**: P003, P004, P009, P010
- **Governance**: P016, P020
- **AI**: P013, P017
- **Quality**: P014, P015, P018

## Dependencies

Xem `INDEX.yaml` — `dependencies` map P→deps, `categories` map nhóm→P.

## Tham chiếu

- Manifest liệt kê P001–P020: `docs/manifest/AIOS_MANIFEST.yaml`
- Glossary: `docs/glossary/`
- INDEX cho Doctor: `INDEX.yaml`
