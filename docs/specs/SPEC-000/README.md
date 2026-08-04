---
name: spec-000-constitution
description: >
  SPEC-000 — Hiến pháp AIOS. SPEC được ASSEMBLE (không viết mới) từ D001-D005:
  Manifest, Glossary, Principles, Rules, Governance. Mọi SPEC-001..020 phải
  tham chiếu Constitution, không định nghĩa lại.
agent: general
---

# SPEC-000 — AIOS Constitution

> **Trạng thái**: Draft · **Version**: 1.0.0 · **Mô hình**: Assemble (không viết mới)

## SPEC-000 là gì?

SPEC-000 là **Hiến pháp** của AIOS — bộ luật tối cao mà mọi SPEC/ADR/RFC/Code phải tuân theo. Nó **không tạo kiến trúc mới**, chỉ **assemble** toàn bộ D001–D005 thành một bộ luật thống nhất.

```text
                SPEC-000 Constitution
                       │
      ┌────────────────┼────────────────┐
      │                │                │
   Manifest        Glossary       Principles
      │                │                │
      └────────────┬───┴────────────────┘
                   │
            Architecture Rules
                   │
             Governance Framework
```

## Bao gồm gì?

| Phần | File | Nguồn |
|------|------|-------|
| 01 Manifest | `01-manifest.md` | `docs/manifest/` |
| 02 Glossary | `02-glossary.md` | `docs/glossary/` |
| 03 Principles | `03-principles.md` | `docs/principles/` |
| 04 Rules | `04-rules.md` | `docs/rules/` |
| 05 Governance | `05-governance.md` | `docs/governance/` |

## Không bao gồm gì?

- Không bao gồm **implementation** — không code, không chi tiết SPEC-001..020.
- Không **định nghĩa lại** thuật ngữ/rule/policy — chỉ tham chiếu.
- Không bao gồm **SPEC triển khai** (Runtime, Workflow, ...) — đó là SPEC-001+.

## Các SPEC khác phải sử dụng thế nào?

- Mọi SPEC-001..020 **tham chiếu** Constitution, không định nghĩa lại khái niệm/rule.
- Mọi SPEC khai báo `implements` component (VD: `implements: Runtime`).
- Doctor dùng `compliance-matrix.yaml` để biết component còn thiếu gì.
- Breaking change → ADR + RFC (SPEC.yaml `breaking_change_requires`).

## Decision Hierarchy

```text
Constitution (SPEC-000) > ADR > SPEC-001..020 > Contract > Implementation > Configuration
```

- **Constitution** là tầng tối cao.
- **ADR** ghi quyết định kiến trúc dựa trên Constitution — cao hơn SPEC.
- **SPEC-001..020** tham chiếu Constitution + ADR, không định nghĩa lại.
- Nếu code trái SPEC → Code sai. Nếu SPEC trái ADR/Constitution → SPEC sai.

## Machine-readable

| File | Vai trò |
|------|---------|
| `SPEC.yaml` | Metadata (id/includes/authoritative/references) |
| `INDEX.yaml` | Registry: documents/principles/rules/policies/glossary_terms |
| `cross-reference.yaml` | P### → rules/policies/terms |
| `dependency-map.yaml` | Manifest→Glossary→Principles→Rules→Governance |
| `compliance-matrix.yaml` | Component → principles/rules/policies |
| `constitution.schema.json` | Validate SPEC.yaml |

## Definition of Done

- [ ] D001–D005 đều ở trạng thái Stable.
- [ ] Không còn tham chiếu vòng (circular references).
- [ ] Mọi Principle được ≥1 Rule và ≥1 Policy thực thi.
- [ ] Mọi thuật ngữ Glossary dùng nhất quán.
- [ ] Cross-reference, dependency-map, compliance-matrix sinh thành công.
- [ ] Doctor validate toàn bộ Constitution không lỗi.

## Tham chiếu

- Metadata: `SPEC.yaml`
- Registry: `INDEX.yaml`
- Toàn bộ SPEC: `docs/specs/README.md`
