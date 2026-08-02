---
name: spec-000-constitution
description: >
  SPEC-000 — Hiến pháp AIOS (Enterprise Constitution). Tài liệu quan trọng nhất.
  Không sinh code trực tiếp. Mọi SPEC/ADR/RFC/Code phải tham chiếu và không mâu thuẫn.
  Ở mức Enterprise: 7 Part, 30 chương, Appendix A-H.
agent: general
---

# SPEC-000 — AIOS Constitution

> **Trạng thái**: Ratified · **Version**: 1.0.0 · **Mức**: Enterprise · **Quy mô**: 150–250 trang

## Preamble

AIOS là một nền tảng điều hành cho AI Agent.

**Agent không phải là trung tâm. Runtime mới là trung tâm.**
Mọi Agent đều chỉ là thành phần chạy trên Runtime.

SPEC-000 là **Hiến pháp (Constitution)** của AIOS. Nó **không phải là "Core Principles"** — nó là nền tảng hiến pháp mà mọi tài liệu khác phải tuân theo.

## Vai trò của Hiến pháp

| Vai trò | Trong AIOS |
|---------|-----------|
| Hiến pháp | **SPEC-000** (tài liệu này) |
| Luật chuyên ngành | SPEC-001 → SPEC-020 |
| Biên bản (vì sao ban hành) | ADR |
| Đề xuất sửa luật | RFC |
| Cơ quan thực thi | Code |
| Kiểm tra tuân thủ | Doctor |

## Quy tắc ràng buộc

- **SPEC-001 đến SPEC-020 không được mâu thuẫn với SPEC-000.**
- **ADR phải giải thích quyết định dựa trên nguyên tắc SPEC-000.**
- **RFC phải chỉ rõ điều khoản SPEC-000 bị ảnh hưởng.**
- **Doctor có thể kiểm tra SPEC/implementation có vi phạm hiến pháp hay không.**

## Cấu trúc

| Part | Chủ đề | Chương | File |
|------|--------|:------:|------|
| I | Foundation | 1–5 | `foundation.md` |
| II | Constitutional Principles | P001–P015 | `principles.md` |
| III | Architecture | 6–11 | `architecture.md` |
| IV | Governance | 12–16 | `governance.md` |
| V | Lifecycle | 17–20 | `lifecycle.md` |
| VI | Quality | 21–24 | `quality.md` |
| VII | AI Native | 25–30 | `ai-native.md` |
| Appendix | A–H | — | `glossary.md`, `appendices/` |

Xem `SUMMARY.md` cho mục lục đầy đủ.

## Definition of Done

SPEC-000 chưa hoàn thành nếu thiếu:

- [ ] Mọi nguyên tắc P001–P015 định nghĩa rõ, không mâu thuẫn.
- [ ] Mọi SPEC-001..020 tham chiếu SPEC-000 không cần diễn giải lại.
- [ ] ADR tham chiếu các quyết định kiến trúc quan trọng.
- [ ] Glossary thống nhất thuật ngữ.
- [ ] Decision Hierarchy rõ ràng.
- [ ] Không chứa chi tiết implementation.
- [ ] Doctor có thể validate tuân thủ hiến pháp.