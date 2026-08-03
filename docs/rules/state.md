---
name: rule-state
description: R-STATE — Luật state. State thuộc Runtime, agent stateless.
agent: general
---

# R-STATE — State

## Rule

State **thuộc Runtime**, không thuộc Agent (P001, P005).

## Bắt buộc

- Agent **stateless** — không lưu state nội bộ giữa các lần gọi.
- Mọi state change **phải** phát Event (P004).
- State versioned + traceable (replay được).
- Không duplicate state — single source of truth (P012).
- State transition qua state machine (SPEC-012).

## Phân biệt

| Thuật ngữ | Nghĩa |
|-----------|-------|
| State | trạng thái runtime, thuộc Runtime |
| Status | mức trưởng thành khai báo (metadata) |

## Kiểm tra

- Doctor kiểm tra agent giữ state nội bộ → cảnh báo.
- Event log phải đủ để tái dựng state.

**Nguồn**: P001 · P004 · P005 · P012 · A-006