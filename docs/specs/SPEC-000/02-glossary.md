---
name: spec-000-02-glossary
description: >
  SPEC-000 Part 02 — Glossary (Domain Model). Assemble từ docs/glossary/.
agent: general
---

# 02 — Glossary (Domain Model)

> Phần này **tham chiếu**, không định nghĩa lại. Nguồn sự thật: `docs/glossary/`.

## Nội dung

| Điều | Nguồn |
|------|-------|
| 16 thuật ngữ (TERM-001..016) | `docs/glossary/terms/` |
| Taxonomy (7 category) | `docs/glossary/taxonomy.yaml` |
| Relationships + cardinality + ownership | `docs/glossary/relationships.yaml` |
| Catalog | `docs/glossary/CATALOG.md` |
| Rules sử dụng | `docs/glossary/RULES.md` |

## 16 Thuật ngữ

| ID | Term | Category |
|----|------|----------|
| TERM-001 | Runtime | Core |
| TERM-002 | Workflow | Execution |
| TERM-003 | Phase | Execution |
| TERM-004 | Task | Execution |
| TERM-005 | Agent | Execution |
| TERM-006 | Capability | Execution |
| TERM-007 | Command | EntryPoint |
| TERM-008 | Artifact | Data |
| TERM-009 | Context | Data |
| TERM-010 | Memory | Data |
| TERM-011 | Knowledge | Knowledge |
| TERM-012 | Event | Platform |
| TERM-013 | Registry | Platform |
| TERM-014 | Contract | Platform |
| TERM-015 | Plugin | Extension |
| TERM-016 | Skill | Knowledge |

## Ràng buộc

- Mỗi thuật ngữ một nghĩa duy nhất.
- Mọi SPEC/ADR/RFC phải tham chiếu Glossary, không tự định nghĩa lại.
- Muốn đổi định nghĩa → ADR + RFC (RULES.md Rule 4).

## Tham chiếu

- `docs/glossary/CATALOG.md`
- `docs/glossary/taxonomy.yaml`
- `docs/glossary/relationships.yaml`
- `docs/glossary/RULES.md`
