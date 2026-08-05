---
name: adr-004-context-engine
description: ADR-004 — Quyết định kiến trúc Context Engine: scope isolation + token compression.
agent: general
---

# ADR-004 — Context Engine

## Status

Accepted (Phase 0.2, khóa kiến trúc). Implementation ở Phase 4.

## Problem

Mỗi phase/agent cần dữ liệu riêng (requirement, kết quả phase trước, knowledge). Nếu dùng chung một context duy nhất → nhiễu token, vượt giới hạn model (PERFORMANCE: < 8000 token), khó mô phỏng song song.

## Options

1. **Một context global** — mọi thứ chung một chỗ.
2. **Context theo scope (Project/Workflow/Task/Artifact/Knowledge/Memory/Runtime)** — tách biệt, child kế thừa parent, có token count + compression.
3. **Không context, đọc file trực tiếp** — mỗi phase tự đọc.

## Decision

Chọn **Option 2 — Context isolation theo scope**: 7 scope, mỗi scope có `data` + `token_count` + `version`. Context Engine (Phase 4) đảm nhiệm: tạo/lưu/đọc, tính token, compress khi vượt ngưỡng, released khi xong.

Context Isolation là nguyên tắc #6; SEQUENCE.md mô tả cây context.

## Consequences

**Tích cực**
- Đúng ngưỡng PERFORMANCE (< 8000 token, CTX-002 khi vượt).
- Simulation/parallel dễ vì context tách biệt.
- An toàn: tránh nhiễu requirement này sang requirement khác.

**Tiêu cực / rủi ro**
- Quản lý vòng đời context phức tạp hơn (released phải gọn).
- Truy vấn cross-scope phải có cơ chế cho phép rõ (CTX-003).

## Tham chiếu

- `COMPONENTS.md` (Context Engine), `DATA_MODEL.md` (Context), `PERFORMANCE.md`, `ERROR_HANDLING.md` (CTX-002/CTX-003).