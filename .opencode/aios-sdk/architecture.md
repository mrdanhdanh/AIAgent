---
name: aios-sdk-architecture
description: Kiến trúc AIOS SDK — layers, components, stability, versioning, security.
agent: general
---

# AIOS SDK — Architecture

## 1. Layers

```text
┌────────────────────────────────────┐
│  Consumers                         │
│  Plugin · CLI · Dashboard · IDE ·   │
│  Third-party apps                  │
├────────────────────────────────────┤
│           AIOS SDK                 │
│  Agent · Plugin · Workflow ·        │
│  Context · Artifact · Event ·       │
│  Registry · Doctor · Simulation ·   │
│  Evolution · Dashboard              │
├────────────────────────────────────┤
│          SDK Core                   │
│  permission check · audit ·         │
│  version gate · error contract      │
├────────────────────────────────────┤
│          Framework Core             │
└────────────────────────────────────┘
```

## 2. SDK Core responsibilities

| Concern | Mô tả |
|---------|-------|
| Permission | kiểm tra trước mỗi call |
| Audit | log SDK access |
| Version gate | SDK vs framework tương thích |
| Error contract | lỗi chuẩn hóa (SDK-ERR-xxx) |
| Stability | experimental/stable/frozen |

## 3. Component SDK design

Mỗi SDK con:
- Wrap Core module qua facade.
- Không expose internal state.
- Trả DTO (Data Transfer Object), không trả internal object.

## 4. Stability lifecycle

```text
experimental (warning)
  → stable (default, breaking cần deprecation)
  → frozen (không đổi nữa)
```

## 5. Versioning

- SDK version = framework version (13.0.0).
- MAJOR bump → breaking (với deprecation window).
- Plugin manifest khai `sdk: ">=13.0"`.

## 6. Tương tác

- Plugin (Phase 11) — dùng plugin-sdk.
- Dashboard (Phase 12) — dùng dashboard-sdk.
- Mọi module AIOS — expose qua SDK.