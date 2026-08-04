---
name: spec-000-03-principles
description: >
  SPEC-000 Part 03 — Constitution Principles. Assemble từ docs/principles/.
agent: general
---

# 03 — Constitution Principles

> Phần này **tham chiếu**, không định nghĩa lại. Nguồn sự thật: `docs/principles/`.

## Nội dung

| Điều | Nguồn |
|------|-------|
| 20 principles (P001-P020) | `docs/principles/P###-*.md` |
| INDEX (Registry-like) | `docs/principles/INDEX.yaml` |
| Registry | `docs/principles/registry.yaml` |
| Categories (8) | `docs/principles/categories.yaml` |
| Dependencies (requires/conflicts/strengthens) | `docs/principles/dependencies.yaml` |
| Enforcement (doctor/runtime/validator) | `docs/principles/enforcement.yaml` |

## 20 Principles

| ID | Name | Category |
|----|------|----------|
| P001 | Runtime First | Core |
| P002 | Contract First | Architecture |
| P003 | Metadata First | Data |
| P004 | Everything is Versioned | Data |
| P005 | Event Driven | Execution |
| P006 | Stateless Agent | Execution |
| P007 | Capability Driven | Execution |
| P008 | Single Responsibility | Architecture |
| P009 | Single Source of Truth | Data |
| P010 | Immutable Artifact | Data |
| P011 | Explicit Dependency | Architecture |
| P012 | Plugin First | Platform |
| P013 | Simulation Before Execution | Evolution |
| P014 | Observability First | Platform |
| P015 | Fail Safe | Security |
| P016 | Human Approval | Governance |
| P017 | AI Native | Evolution |
| P018 | Evolvable | Evolution |
| P019 | Open Extension, Closed Core | Architecture |
| P020 | Constitution First | Governance |

## Ràng buộc

- Constitution Principles **gần như bất biến** — đổi qua RFC + ADR (P020).
- Mỗi principle có formal_rule + verification (Doctor dùng luôn).
- Mỗi principle được thực thi bởi ≥1 Rule và ≥1 Policy (xem compliance-matrix.yaml).

## Tham chiếu

- `docs/principles/README.md`
- `docs/principles/INDEX.yaml`
- `docs/principles/enforcement.yaml`
