---
name: spec-000-ai-native
description: SPEC-000 Part VI — AI-Native Principles, Human vs AI Responsibilities, Architecture Decision Hierarchy.
agent: general
---

# Part VI — AI-Native

## Chương 21 — AI-Native Principles

AIOS được sinh ra để AI vận hành. Đây là nguyên tắc riêng:

```text
Machine Readable     — output dạng schema/json
LLM Friendly         — prompt deterministic, context rõ
Deterministic Prompt — cùng input → cùng output
Structured Output    — không prose tự do, theo contract
Schema First         — mọi dữ liệu có schema
```

| Nguyên tắc | Ý nghĩa |
|-----------|---------|
| Machine Readable | mọi metadata/config/output là dữ liệu có schema |
| LLM Friendly | context package rõ ràng, prompt có cấu trúc |
| Deterministic | input giống nhau → output giống nhau |
| Structured Output | agent trả theo output contract |
| Schema First | schema là nguồn, code sinh từ schema |

## Chương 22 — Human vs AI Responsibilities

Phân định rõ quyền hạn — tránh AI vượt quyền.

```text
AI
  Generate
  Review
  Validate
  Suggest

Human
  Approve
  Merge
  Release
  Policy
```

| Việc | AI | Human |
|------|:--:|:-----:|
| Generate code/plan | ✅ | — |
| Review + validate | ✅ | — |
| Suggest cải tiến | ✅ | — |
| Approve proposal | ❌ | ✅ |
| Merge/release | ❌ | ✅ |
| Đặt policy | ❌ | ✅ |

- AI không tự apply proposal lớn — cần approval (P-010, P-015).
- Autonomous mode (L3) chỉ khi policy cho phép, luôn audit.

## Chương 23 — Architecture Decision Hierarchy

Thứ tự ưu tiên khi có xung đột:

```text
Core Principles (SPEC-000)
      ↓
ADR
      ↓
SPEC
      ↓
Contracts
      ↓
Implementation
      ↓
Configuration
```

Luật:

- Nếu **Implementation** khác **SPEC** → Implementation sai.
- Nếu **SPEC** khác **Core Principles** → SPEC sai.
- Nếu **Contract** khác **SPEC** → Contract sai.
- Mọi thay đổi đi từ trên xuống; không sửa ngầm tầng dưới.