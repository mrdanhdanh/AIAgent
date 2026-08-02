---
name: context-validator
description: validator — kiểm tra context package đủ required trước khi giao agent. Thiếu required → không chạy agent.
agent: general
---

# Context Validator

## 1. Vai trò

Bước **Validate** — đảm bảo agent có đủ context needed. Nếu thiếu required → **Error**, không chạy.

## 2. Checks

| # | Mã | Kiểm tra |
|---|-----|----------|
| 1 | CXT-001 | `task.goal` present |
| 2 | CXT-002 | đủ `required` trong profile |
| 3 | CXT-003 | bot.used <= bot.limit |
| 4 | CXT-004 | forbidden context không lọt vào package |
| 5 | CXT-005 | output đúng schema (context.schema.yaml) |

## 3. Error behavior

- Lỗi CXT-002/004 → blocker: Engine không gọi agent, trả error lên workflow.
- Lỗi CXT-003 → giảm context (Intelligence tự loại) rồi retry validate.
- CXT-005 → format lại package.

## 4. Stateless

Validator pure, không đọc project → dễ test.

## 5. Ví dụ builder thiếu

profile builder `required: [artifact.plan]` nhưng artifact.plan null → CXT-002 → gọi `artifact.resolve()` lần nữa; vẫn null → error, không xây code.

## 6. Tương tác

- Engine gọi compare sau build, trước deliver.
- `tests/` cover missing/duplicate/invalid.
- Exit code: 0 = OK, 1 = invalid (unit test).