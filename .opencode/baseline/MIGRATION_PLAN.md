---
name: migration-plan
description: MIGRATION_PLAN — lộ trình migrate từ v3 lên v4 theo roadmap Agent Framework.
agent: general
---

# MIGRATION_PLAN.md — Agent Framework

> Lộ trình tổng thể từ v3 lên v4. Đây sẽ là roadmap tham chiếu chính.

## 1. Lộ trình theo Phase

```
v3 (baseline)
  ↓
[Phase 0.1 Baseline]  ← đang thực hiện
  ↓
[Phase 0.2 Architecture Specification] — khóa spec (9 khái niệm)
  ↓
[Phase 1 Workflow Runtime]        ← nền móng
  ↓
[Phase 2 Capability Registry]    ← đã xong (Sprint 2)
  ↓
[Phase 3 Agent Definition System]
  ↓
[Phase 4 Context Engine]
  ↓
[Phase 5 Artifact Store]
  ↓
[Phase 6 Event System]
  ↓
[Phase 7 Simulation Framework]
  ↓
[Phase 8 System Diagnostics]
  ↓
[Phase 9 Knowledge Index & Graph]
  ↓
[Phase 10 Evolution Engine]
  ↓
[Phase 11 Extension System]
  ↓
[Phase 12 Observability Dashboard]
  ↓
v4 stable → v5 (multi-agent, parallel, MCP, A2A...)
```

## 2. Trình tự thực tế khuyến nghị

1. Hoàn thiện **Phase 0.1** (Baseline — đang làm).
2. Thực hiện **Phase 0.2** (Architecture Specification) và khóa tài liệu.
3. Phát triển **Phase 1 – Workflow Runtime** trên nền spec đã thống nhất.
4. Tiếp tục Phase 2..12 theo thứ tự.

> **Lưu ý**: Phase 2 (Capability Registry) đã hoàn tất ngoài thứ tự vì non-invasive, không đụng runtime v3. Khi Phase 1 xong, engine sẽ đọc registry thay vì mapping cứng agent theo tên.

## 3. Nguyên tắc migration

- **Non-invasive** mỗi Phase tối đa — không phá Phase trước.
- Baseline sau mỗi Phase được cập nhật để Doctor so sánh.
- Mỗi quyết định lớn ghi ADR vào `DECISION_LOG.md`.