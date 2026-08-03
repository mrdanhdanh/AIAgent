---
name: aios-governance
description: >
  AIOS Governance — quy trình quản trị dự án (ADR, RFC, Release, Naming,
  Review, Approval). Luật chơi để AIOS vNext vận hành như dự án mã nguồn mở.
agent: general
---

# AIOS Governance

> Sprint 0.0 / Milestone 0. Quy trình quản trị để mọi thay đổi
> đều có thể **review, approve, và thực thi**.

## Các quy trình

| Quy trình | File | Mô tả |
|-----------|------|-------|
| ADR | `adr.md` | Ghi lại quyết định kiến trúc + lý do |
| RFC | `rfc.md` | Đề xuất thay đổi trước khi ban hành |
| Release | `release.md` | Quy trình phát hành phiên bản |
| Naming | `naming.md` | Quy ước đặt tên (entity, spec, artifact) |
| Review | `review.md` | Cổng đánh giá trước khi hợp nhất |
| Approval | `approval.md` | Chuỗi phê duyệt theo mức độ rủi ro |

## Dòng thay đổi chuẩn

```text
RFC (đề xuất)
  ↓
Review (đánh giá)
  ↓
Approve (phê duyệt)
  ↓
Implement (thực thi)
  ↓
Release (phát hành)
```

## Nguyên tắc

- Mọi thay đổi đáng kể đều bắt đầu bằng RFC.
- Mọi quyết định đáng nhớ đều ghi ADR.
- Không được merge nếu chưa qua Review.
- Mức Approve tăng theo rủi ro (nội bộ → core → breaking).

## Tham chiếu

- Governance Principles: `docs/principles/governance.md` (G-001..G-007)
- ADR thực tế: `docs/adr/`
- RFC thực tế: `docs/rfc/`
