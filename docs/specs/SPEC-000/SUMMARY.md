---
name: spec-000-summary
description: SUMMARY — mục lục toàn bộ SPEC-000 Constitution (7 Part, 30 chương, Appendix A-H).
agent: general
---

# SPEC-000 — AIOS Constitution · SUMMARY

> **Trạng thái**: Ratified · **Version**: 1.0.0 · **Phạm vi**: 150–250 trang (Enterprise)

## Part I — Foundation

| Chương | Tiêu đề |
|:------:|---------|
| 1 | Vision |
| 2 | Scope |
| 3 | Goals |
| 4 | Non Goals |
| 5 | Terminology |

## Part II — Constitutional Principles

| Nguyên tắc | Tiêu đề |
|:----------:|---------|
| P001 | Runtime First |
| P002 | Contract First |
| P003 | Metadata First |
| P004 | Everything is Versioned |
| P005 | Everything Emits Events |
| P006 | Everything is Discoverable |
| P007 | Everything is Observable |
| P008 | Capability Driven |
| P009 | Stateless Agents |
| P010 | Plugin First |
| P011 | Simulation Before Execution |
| P012 | Single Source of Truth |
| P013 | Immutable Artifacts |
| P014 | Least Privilege |
| P015 | Backward Compatibility |

## Part III — Architecture

| Chương | Tiêu đề |
|:------:|---------|
| 6 | Architecture Layers |
| 7 | Object Model |
| 8 | Dependency Rules |
| 9 | Communication Model |
| 10 | Execution Model |
| 11 | Data Model |

## Part IV — Governance

| Chương | Tiêu đề |
|:------:|---------|
| 12 | Versioning |
| 13 | Compatibility |
| 14 | Naming |
| 15 | Documentation |
| 16 | Decision Hierarchy |

## Part V — Lifecycle

| Chương | Tiêu đề |
|:------:|---------|
| 17 | Entity Lifecycle |
| 18 | Workflow Lifecycle |
| 19 | Plugin Lifecycle |
| 20 | Artifact Lifecycle |

## Part VI — Quality

| Chương | Tiêu đề |
|:------:|---------|
| 21 | Quality Attributes |
| 22 | Architecture Constraints |
| 23 | Error Philosophy |
| 24 | Security Principles |

## Part VII — AI Native

| Chương | Tiêu đề |
|:------:|---------|
| 25 | Machine Readable |
| 26 | Human Readable |
| 27 | Executable Specification |
| 28 | AI Responsibilities |
| 29 | Evolution Principles |
| 30 | Future Compatibility |

## Appendix

| Mục | Tiêu đề | File |
|:----:|---------|------|
| A | Glossary | `glossary.md` |
| B | Object Catalog | `appendices/object-catalog.md` |
| C | Metadata Catalog | `appendices/metadata-catalog.md` |
| D | State Catalog | `appendices/state-catalog.md` |
| E | Error Catalog | `appendices/error-catalog.md` |
| F | Event Catalog | `appendices/event-catalog.md` |
| G | Capability Catalog | `appendices/capability-catalog.md` |
| H | References | `appendices/references.md` |

## Cấu trúc thư mục

```text
SPEC-000-constitution/
├── README.md
├── SUMMARY.md
├── glossary.md
├── foundation.md      (Part I, Ch 1-5)
├── principles.md      (Part II, P001-P015)
├── architecture.md    (Part III, Ch 6-11)
├── governance.md      (Part IV, Ch 12-16)
├── lifecycle.md       (Part V, Ch 17-20)
├── quality.md         (Part VI, Ch 21-24)
├── ai-native.md       (Part VII, Ch 25-30)
├── changelog.md
├── appendices/
│   ├── object-catalog.md
│   ├── metadata-catalog.md
│   ├── state-catalog.md
│   ├── error-catalog.md
│   ├── event-catalog.md
│   ├── capability-catalog.md
│   └── references.md
└── diagrams/