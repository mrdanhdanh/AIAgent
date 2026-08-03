---
name: gov-naming
description: G-002 — Quy ước đặt tên entity, spec, artifact.
agent: general
---

# Naming

## Mục đích

Mọi thứ có tên **nhất quán**, máy đọc được (P003, A-005).

## Quy ước

| Loại | Quy ước | Ví dụ |
|------|---------|-------|
| SPEC | `SPEC-###-kebab-case` | `SPEC-001-runtime` |
| ADR | `ADR-###` | `ADR-001` |
| RFC | `RFC-###` | `RFC-001` |
| Artifact | `<TYPE>-<id>-v<version>` | `PLAN-001-v3` |
| Entity id | kebab-case, duy nhất | `word-service` |
| File glossary | kebab-case | `runtime.md` |
| Branch | `feature/`, `fix/`, `release/` | `feature/runtime-spec` |

## Quy tắc

- Kebab-case (chữ thường + gạch nối) cho id/file.
- Không dùng khoảng trắng, ký tự đặc biệt, ký tự Unicode trong id.
- Tên phải mô tả đúng chức năng — một cái tên một nghĩa.
- Không đổi tên sau khi publish (đổi = ADR + rename + compat).
