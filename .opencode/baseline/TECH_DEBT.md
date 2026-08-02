---
name: techdebt
description: TECH_DEBT — nợ kỹ thuật của Agent Framework v3, phân theo severity.
agent: general
---

# TECH_DEBT.md — Agent Framework v3

> Nợ kỹ thuật cần giải quyết trong roadmap v4. Mỗi mục ánh xạ gợi ý Phase.

| # | Debt | Severity | Impact | Giải quyết ở Phase |
|---|------|----------|--------|--------------------|
| 1 | Workflow hardcode (phase mapping dính agent theo tên) | High | Khó scale, khó đổi agent | Phase 1 (Workflow Runtime) + Phase 3 (Agent Definition) |
| 2 | Agent Metadata thiếu (agent.md chỉ prompt, chưa agent.yaml với contract/token/lifecycle) | High | Agent không mô tả được lifecycle/priority | Phase 3 |
| 3 | Không mô tả cấu trúc workflow linh hoạt, phase thiếu sequencing chuẩn | High | Workflow dễ phá vỡ khi thêm Phase | Phase 1 |
| 4 | No Capability-based routing (engine không biết capability) | Medium | Đã có registry nhưng chưa dùng để routing | Phase 2 |
| 5 | Context build thủ công trong agent, trùng lặp | Medium | Token wasteful, thiếu consistency | Phase 4 |
| 6 | Artifact chỉ là file thường, thiếu checksum/version/object/dependency | Medium | Khó track dependency artifact | Phase 5 |
| 7 | No Event System — không event-driven | Medium | Khó phản ứng khi phase xong | Phase 6 |
| 8 | No Simulation — /team-simulate chưa tồn tại | Medium | Khó thử workflow trước khi apply | Phase 7 |
| 9 | Doctor chỉ schema-level, thiếu behavior/coverage/perf | Low | Hạn chế diagnosic chiều sâu | Phase 8 |
| 10 | Knowledge thiếu confidence/references graph | Low | Cần update index | Phase 9 |
| 11 | Evolution chỉ suggestion, thiếu migration/version/release | Medium | Khó evolve có control | Phase 10 |
| 12 | No Extension System (plugin agent/skill/command/workflow) | Medium | Khó mở rộng ngoài | Phase 11 |
| 13 | No Observability Dashboard | Low | Khó monitor token/perf | Phase 12 |

## Ưu tiên settle (Adopt)

- HIGH, HIGH-2, HIGH-3 — bắt buộc trước Phase 3+
- Trong baseline, mục #1/#2/#3 là điểm yếu lớn nhất khiến Migration Plan phải cẩn thận.