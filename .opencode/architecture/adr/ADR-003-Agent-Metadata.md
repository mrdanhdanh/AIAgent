---
name: adr-003-agent-metadata
description: ADR-003 — Quyết định kiến trúc Agent Metadata: frontmatter chuẩn + registry, không parse lỏng lẻo.
agent: general
---

# ADR-003 — Agent Metadata

## Status

Accepted (Phase 0.2, khóa kiến trúc)

## Problem

18 agents khai báo role/capability không đồng nhất (một số file thiếu frontmatter chuẩn). Runtime không thể tin cậy đọc metadata từ file .md khi format tự do.

## Options

1. **Giữ nguyên .md tự do** — metadata mỗi agent khác nhau, parse may rủi.
2. **Frontmatter chuẩn + registry** — mọi agent có frontmatter (name/description/agent) + khai báo capability trong agent-registry.yaml.
3. **Chuyển agent sang YAML thuần** — bỏ hẳn .md.

## Decision

Chọn **Option 2 — Frontmatter chuẩn + agent-registry.yaml**: file .md giữ làm nguồn mô tả, registry là nguồn sự thật cho routing. Frontmatter bắt buộc: `name`, `description`, `agent`. Capability khai báo trong registry (khớp NAMING_CONVENTIONS).

Ví dụ: `knowledge.management` → map tới `knowledge-agent`; `data-model-reader` đăng ký đúng.

## Consequences

**Tích cực**
- Runtime đọc registry thống nhất, không parse .md.
- Khớp với ADR-002 (registry là nguồn sự thật).
- Stateless Agent (nguyên tắc #9) dễ bảo đảm vì metadata tách khỏi runtime.

**Tiêu cực / rủi ro**
- Đòi hỏi agent mới khai báo đủ registry; quên → validator bắt (CR-00x).

## Tham chiếu

- `DATA_MODEL.md` (Agent), `NAMING_CONVENTIONS.md` (agent id), `COMPATIBILITY.md` (frontmatter).