---
name: spec-000-building-blocks
description: >
  SPEC-000 Consolidation (Sprint 4) — ghép building blocks thành Constitution.
  Glossary → Manifest → Principles → Architecture → Governance → SPEC-000.
  Mỗi building block là nguồn chính; Constitution là tổng hợp.
agent: general
---

# SPEC-000 — Consolidation (từ building blocks)

> Sprint 4. SPEC-000 được xây **từ dưới lên**. Mỗi phần của Constitution
> tham chiếu building block tương ứng — không diễn giải lại.

## Pipeline building blocks

```text
Glossary
    ↓
Manifest
    ↓
Core Principles
    ↓
Architecture Principles
    ↓
Governance
    ↓
SPEC-000 Constitution  ← Sprint 4
    ↓
Architecture Freeze v1.0
```

## Mapping building blocks → Constitution

| Building block | Vị trí | Vào Constitution |
|----------------|--------|------------------|
| Glossary | `docs/glossary/` | Chương 5, Appendix A |
| Manifest | `docs/manifest/AIOS_MANIFEST.yaml` | Preamble |
| Core Principles | `docs/principles/principles.md` | Part II (P001–P015) |
| Architecture | `docs/principles/architecture-principles.md` | Part III (Ch 6–11) |
| Governance | `docs/principles/governance.md` | Part IV (Ch 12–16) |
| Rules | `docs/rules/` | R-LAYER..R-SEC |
| Lifecycle | `docs/specs/SPEC-000/lifecycle.md` | Part V (Ch 17–20) |
| Quality | `docs/specs/SPEC-000/quality.md` | Part VI (Ch 21–24) |
| AI Native | `docs/specs/SPEC-000/ai-native.md` | Part VII (Ch 25–30) |

## Quy tắc Consolidation

- **Building block là nguồn chính** — sửa glossary/principles → cập nhật Constitution.
- Constitution **không mâu thuẫn** building block.
- Nếu xung đột → building block (tầng thấp) thắng, theo Decision Hierarchy.
- Mọi SPEC-001..020 tham chiếu building block hoặc Constitution.

## Freeze v1.0

- Sau consolidation → **Architecture Freeze v1.0** (xem `AIOS_V5_FREEZE.md`).
- Không thêm principle mới trừ khi RFC được duyệt.
- Core chỉ đổi khi kiến trúc lớn (ADR).

## Definition of Done (Consolidation)

- [ ] Glossary đầy đủ (mọi thuật ngữ một nghĩa).
- [ ] Manifest ratified.
- [ ] 15 core principles, không mâu thuẫn.
- [ ] Architecture + Governance nhất quán.
- [ ] Constitution ghép từ building block.
- [ ] Freeze v1.0.
- [ ] Validators PASS.