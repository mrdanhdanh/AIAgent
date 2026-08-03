---
name: rule-dependency
description: R-DEP — Luật dependency. Một chiều, không vòng, core độc lập.
agent: general
---

# R-DEP — Dependency

## Rule

Dependency một chiều từ trên xuống:

```text
Presentation → Runtime → Infrastructure
```

## Bắt buộc

- **Không** dependency ngược hướng.
- **Không** circular dependency.
- Runtime **không phụ thuộc** Extension.
- Core **không phụ thuộc** Plugin.
- Plugin phụ thuộc core (qua SDK), không ngược lại.

## Kiểm tra

- Doctor phân tích call graph → báo vòng lặp / vi phạm hướng.
- CI chặn nếu dependency graph có cycle.

**Nguồn**: A-002 · P010 · P014