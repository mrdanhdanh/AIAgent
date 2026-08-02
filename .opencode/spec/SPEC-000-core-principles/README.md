---
name: spec-000-constitution
description: >
  SPEC-000 — Hiến pháp (Constitution) của AIOS. Không chứa implementation.
  Định nghĩa nguyên tắc bất biến mọi module phải tuân theo. 6 Part, 23 chương.
  SPEC-001..020 = luật chuyên ngành. ADR = biên bản. RFC = đề xuất. Code = cơ quan thực thi.
agent: general
---

# SPEC-000 — Hiến pháp AIOS

> **Trạng thái**: Ratified · **Version**: 1.0.0 · **Sprint**: A · **Schema**: spec-v1
>
> SPEC-000 **không phải là một document**. Nó là **Hiến pháp (Constitution)** của AIOS.
> Nó tồn tại 5–10 năm. Nó **không được chứa implementation**.
> Chỉ chứa những nguyên tắc mà mọi module phải tuân theo.

## Preamble

AIOS là một nền tảng điều hành cho AI Agent.

**Agent không phải là trung tâm. Runtime mới là trung tâm.**
Mọi Agent đều chỉ là thành phần chạy trên Runtime.

Hiến pháp này đặt ra các nguyên tắc bất biến mà mọi SPEC, ADR, Contract, Implementation và Configuration phải tuân theo. Không một tầng nào được phép mâu thuẫn với Hiến pháp.

## Mối quan hệ (phép ẩn dụ quốc gia)

| Vai trò | Trong AIOS |
|---------|-----------|
| Hiến pháp | **SPEC-000** (tài liệu này) |
| Luật chuyên ngành | SPEC-001 → SPEC-020 |
| Biên bản | ADR (kiến trúc, vì sao ban hành) |
| Đề xuất sửa luật | RFC |
| Cơ quan thực thi | Code |

## Cấu trúc

```text
Part I.   Foundation        — 1 Vision · 2 Goals · 3 Non Goals · 4 Design Philosophy
Part II.  Architecture      — 5 Core Principles · 6 Constraints · 7 Quality Attributes
Part III. System Model      — 8 Object · 9 Execution · 10 Communication · 11 Data
Part IV.  Engineering       — 12 Versioning · 13 Compatibility · 14 Error · 15 Security
Part V.   Governance        — 16 Terminology · 17 Naming · 18 Documentation · 19 Decision · 20 Evolution
Part VI.  AI-Native         — 21 AI-Native Principles · 22 Human vs AI · 23 Decision Hierarchy
```

| File | Part |
|------|------|
| `README.md` | Preamble + Part I (1–4) + DoD |
| `principles.md` | Part II (5–7) |
| `system-model.md` | Part III (8–11) |
| `engineering.md` | Part IV (12–15) |
| `governance.md` | Part V (16–20) |
| `ai-native.md` | Part VI (21–23) |

---

# Part I — Foundation

## Chương 1 — Vision

> AIOS là một nền tảng điều hành cho AI Agent.
>
> Agent không phải là trung tâm.
>
> Runtime mới là trung tâm.
>
> Mọi Agent đều chỉ là thành phần chạy trên Runtime.

Triết lý:
- Tách **AI logic** khỏi **hạ tầng**.
- Agent = một loại ứng dụng chạy trên AIOS, không phải trung tâm kiến trúc.
- Mở rộng qua extension, không sửa lõi.

## Chương 2 — Goals

```
✓ Stateless            — agent không giữ state
✓ Event Driven         — state change đều phát event
✓ Contract First       — giao tiếp qua contract
✓ Plugin First         — mở rộng qua plugin
✓ Observable           — mọi thứ đo được
✓ Evolvable            — tự đề xuất cải tiến
✓ AI Friendly          — máy đọc được, LLM thân thiện
✓ Machine Readable     — metadata/schema/json, không prose
```

## Chương 3 — Non Goals

AIOS **không phải**:

- IDE
- Chatbot
- LLM
- Workflow Designer
- Source Control
- CI/CD

Non Goals giúp tránh framework phình to (over-engineering).

## Chương 4 — Design Philosophy

```text
Simple Core
Rich Extensions
Configuration over Coding
Metadata over Logic
Composition over Inheritance
Convention over Configuration
Everything Declarative
```

---

# Definition of Done

SPEC-000 **chưa hoàn thành** nếu thiếu bất kỳ tiêu chí nào:

- [ ] Mọi nguyên tắc cốt lõi được định nghĩa rõ, không mâu thuẫn.
- [ ] Mọi SPEC-001 đến SPEC-020 đều tham chiếu SPEC-000 không cần diễn giải lại.
- [ ] Có ADR tham chiếu các quyết định kiến trúc quan trọng.
- [ ] Có Glossary thống nhất thuật ngữ.
- [ ] Có Architecture Decision Hierarchy.
- [ ] Không chứa bất kỳ chi tiết implementation nào.