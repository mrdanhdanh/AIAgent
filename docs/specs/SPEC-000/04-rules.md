---
name: spec-000-04-rules
description: >
  SPEC-000 Part 04 — Architecture Rules. Assemble từ docs/rules/.
agent: general
---

# 04 — Architecture Rules

> Phần này **tham chiếu**, không định nghĩa lại. Nguồn sự thật: `docs/rules/`.

## Nội dung

| Điều | Nguồn |
|------|-------|
| 15 rules (RULE-001..015) | `docs/rules/RULE-###-*.md` |
| Architecture Registry | `docs/rules/architecture-registry.yaml` |
| INDEX (15 rules + dependencies) | `docs/rules/INDEX.yaml` |
| Schema | `docs/rules/rules.schema.json` |

## 15 Rules

| ID | Name | Category |
|----|------|----------|
| RULE-001 | Layering | Architecture |
| RULE-002 | Dependency | Architecture |
| RULE-003 | Communication | Architecture |
| RULE-004 | Execution | Execution |
| RULE-005 | State | State |
| RULE-006 | Data Flow | Data |
| RULE-007 | Event | Event |
| RULE-008 | Security | Security |
| RULE-009 | Versioning | Data |
| RULE-010 | Extension | Architecture |
| RULE-011 | Resource Ownership | Data |
| RULE-012 | Failure Isolation | Reliability |
| RULE-013 | Deterministic Execution | Reliability |
| RULE-014 | Observability Contract | Observability |
| RULE-015 | Backward Compatibility | Compatibility |

## Layering

```text
Presentation → Command → Workflow → Runtime → Capability → Registry → Agent → Skill → Infrastructure
```

Chỉ gọi xuống. Không gọi ngược. Không vượt tầng. Không circular.

## Ràng buộc

- Mỗi rule là **Policy** (policy_type mandatory + enforcement).
- allowed/forbidden dependencies trong architecture-registry.yaml — Doctor kiểm tra.
- Mọi rule tham chiếu ≥1 principle.

## Tham chiếu

- `docs/rules/README.md`
- `docs/rules/architecture-registry.yaml`
- `docs/rules/INDEX.yaml`
