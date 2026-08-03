---
id: P019
name: Open Extension, Closed Core
status: Draft
category: Architecture
severity: critical
breaking_change: true
enforced_by:
  - doctor
implemented_in:
  - SPEC-018
  - SPEC-019
related:
  - P003
  - P012
statement: >
  Core gần như bất biến. Mở rộng bằng Plugin, SDK, Capability, Metadata.
rationale: >
  Core bất biến → ổn định. Mọi mở rộng qua các điểm mở rộng đã định nghĩa.
rules:
  - Không sửa core để mở rộng.
  - Mở rộng qua Plugin, SDK, Capability, Metadata.
  - Core bất biến trừ khi ADR cấp cao.
implications:
  - Open for extension, closed for modification.
  - Plugin/SDK là điểm mở rộng chính.
anti_patterns:
  - Mở core để thêm tính năng.
  - Hard-code extension vào core.
exceptions:
  - Thay đổi core chỉ qua ADR + P020 hierarchy.
examples:
  - SDK expose API ổn định; plugin mở rộng capability.
references:
  - P003 Metadata First
  - P012 Plugin First
---

# P019 — Open Extension, Closed Core

## Statement

> Core gần như bất biến. Mở rộng bằng Plugin, SDK, Capability, Metadata.

## Rules

- Plugin.
- SDK.
- Capability.
- Metadata.

## Implications

- Open for extension, closed for modification.
- Không sửa core để mở rộng.

## Anti Pattern

❌ Mở core để thêm tính năng.
