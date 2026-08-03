---
name: spec-000-constitution
description: >
  SPEC-000 — Hiến pháp AIOS. Đây là SPEC ĐƯỢC ASSEMBLE, không phải viết mới.
  README này chỉ tham chiếu các thành phần (Manifest, Glossary, Principles,
  Rules, Governance). Mọi SPEC/ADR/RFC/Code phải tuân theo các thành phần này.
agent: general
---

# SPEC-000 — AIOS Constitution

> **Trạng thái**: Draft · **Version**: 1.0.0 · **Mô hình**: Assemble (không viết mới)

## Preamble

AIOS là nền tảng điều hành cho AI Agent. **Runtime là trung tâm; Agent chỉ là thành phần chạy trên Runtime.**

SPEC-000 là **Hiến pháp** — được **assembled** từ các building blocks sau, không phải tài liệu viết mới:

```text
SPEC-000
  ↓
Assemble (tham chiếu)
  ↓
Manifest + Glossary + Principles + Rules + Governance
```

## Thành phần (building blocks)

| Thành phần | Vị trí | Vai trò |
|------------|--------|---------|
| Manifest | `docs/manifest/AIOS_MANIFEST.yaml` | AIOS là gì, tồn tại để làm gì |
| Glossary | `docs/glossary/` | Thuật ngữ — mỗi từ một nghĩa |
| Principles | `docs/principles/` | P001–P015 + A-001..006 + G-001..007 |
| Rules | `docs/rules/` | Luật kiến trúc bắt buộc (R-LAYER, R-DEP, ...) |
| Governance | `docs/governance/` | ADR, RFC, Release, Naming, Review, Approval |

> **Quy tắc**: Mỗi thành phần là nguồn chính. Sửa thành phần → SPEC-000 thay đổi theo. SPEC-000 không có nội dung riêng tách biệt.

## Metadata

Xem `spec.yaml` — `references: [MANIFEST, GLOSSARY, PRINCIPLES, RULES, GOVERNANCE]`.

## Điều khoản tham chiếu

- **SPEC-001..020 không được mâu thuẫn** với các thành phần trên.
- **ADR** phải trích dẫn principle/rule liên quan.
- **RFC** phải chỉ rõ điều khoản nào bị ảnh hưởng.
- **Doctor** kiểm tra SPEC/implementation có vi phạm không.

## Decision Hierarchy

```text
Constitution (SPEC-000) > SPEC-001..020 > ADR > RFC > Code
```

## Definition of Done

SPEC-000 hoàn thành khi:

- [ ] Manifest ratified.
- [ ] Glossary đầy đủ, mỗi thuật ngữ một nghĩa.
- [ ] 15–20 Core Principles list được review + freeze.
- [ ] Architecture Rules list được review + freeze.
- [ ] Governance process được review + freeze.
- [ ] Validators PASS.

## Xem thêm

- `SUMMARY.md` — mục lục chi tiết (bản Assemble).
- `building-blocks.md` — mapping building blocks.
- `docs/specs/README.md` — index toàn bộ SPEC.
