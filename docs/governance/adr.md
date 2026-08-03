---
name: gov-adr
description: G-006 — Quy trình ADR. Ghi lại quyết định kiến trúc + lý do.
agent: general
---

# ADR — Architecture Decision Record

## Mục đích

Ghi lại quyết định kiến trúc quan trọng và lý do, để sau này hiểu **tại sao** chọn A không chọn B.

## Khi nào viết ADR

- Quyết định ảnh hưởng nhiều module.
- Thay đổi core/kiến trúc.
- Chọn tech stack / library.
- Đổi rule trong `docs/rules/`.

## Template

```markdown
---
id: ADR-001
title: <quyết định>
status: Accepted | Proposed | Deprecated | Superseded
date: YYYY-MM-DD
supersedes: []
related_rfc: []
principles: [P001, ...]
---

# ADR-001 — <title>

## Context
Vấn đề là gì?

## Decision
Chọn gì? Dựa trên principle nào?

## Consequences
Được gì, mất gì?

## Alternatives
Cân nhắc gì khác, vì sao bỏ?
```

## Vị trí

- ADR thực tế: `docs/adr/ADR-001.md`, `ADR-002.md`, ...

## Quy tắc

- ADR bất biến sau Accepted — sửa thì ADR mới.
- Bắt buộc trích dẫn principle/rules liên quan (SPEC-000).
