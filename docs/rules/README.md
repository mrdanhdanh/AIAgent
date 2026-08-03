---
name: aios-rules
description: >
  AIOS Architecture Rules — luật kiến trúc bắt buộc (layering, dependency,
  communication, versioning, state, security). Kế thừa từ Architecture
  Principles (A-001..A-006). Đây là LUẬT, không phải khuyến nghị.
agent: general
---

# AIOS Architecture Rules

> Sprint 0.0 / Milestone 0. Luật kiến trúc bắt buộc.
> Khác với Principles (định hướng) — Rules là **bắt buộc**, có thể kiểm tra.
> Mọi SPEC-001..020 và code phải tuân thủ.

## Danh sách Rules

| Rule | File | Luật (tóm tắt) |
|------|------|-----------------|
| R-LAYER | `layering.md` | 5 tầng: Presentation → Extensions → Intelligence → Runtime → Infrastructure. Phụ thuộc một chiều từ trên xuống. |
| R-DEP | `dependency.md` | Không circular dependency. Runtime không phụ thuộc Extension. Core không phụ thuộc Plugin. |
| R-COMM | `communication.md` | Mọi giao tiếp qua Contract (P002) + Runtime (P001). Không gọi trực tiếp. |
| R-VER | `versioning.md` | Mọi entity versioned (P009). Không ghi đè. Backward compatible (P015). |
| R-STATE | `state.md` | State thuộc Runtime (P001, P005). Agent stateless. Mọi state change phát Event (P004). |
| R-SEC | `security.md` | Least privilege (P014). Kiểm tra quyền trước khi thực thi. |

## Nguồn

- `docs/principles/architecture-principles.md` (A-001..A-006)
- `docs/principles/principles.md` (P001–P015)

## Quy tắc

- Mọi rule bắt buộc — vi phạm là lỗi kiến trúc (Doctor phát hiện).
- Muốn đổi rule → RFC → ADR → hợp nhất vào rule.
