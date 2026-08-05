---
name: risk-assessment
description: RISK_ASSESSMENT — đánh giá rủi ro cac thành phần/Phase kế của Agent Framework v3.
agent: general
---

# RISK_ASSESSMENT.md — Agent Framework v3

> Đánh giá rủi ro theo thành phần và theo Phase trong roadmap v4.

## 1. Theo Component

| Component | Risk | Level | Mitigation |
|-----------|------|-------|------------|
| Workflow (hardcode) | Workflow phá | High | Phase 1 Runtime, không refactor trước khi có Runtime |
| Workflow v4 (nửa mới) | Đang ổn | Low | Giữ nguyên runtime, thin |
| Capability Registry | mapping thủ công lệch | Medium | capability-validator CR-002, PASS giữ |
| Knowledge | stale index | Low | Chạy /knowledge-index --update |
| Memory | ghi tay lệch | Low | Learning Pipeline approval gate |
| Doctor | chỉ schema-level | Low | Phase 8 |
| Build & Test (.NET project) | ổn đực | Low | dotnet build + test trước push (GitGuard) |

## 2. Theo Phase roadmap

| Phase | Risk | Level | Lưu ý |
|-------|------|-------|-------|
| Phase 0.1 Baseline | thấp, chỉ document | Low | Khóa trạng thái, không đụng runtime |
| Phase 0.2 Architecture | thấp nhưng cần khóa spec | Medium | Nếu trì hoãn → Phase 1-2 phải refactor |
| Phase 1 Workflow Runtime | trung bình, thay engine | High | Đây là nền móng, cần spec stable trước |
| Phase 2 Capability Registry | đã hoàn tất (Sprint 2) | Low | Tiếp tục dùng được |
| Phase 3 Agent Definition | trung bình | Medium | Đổi agent.md → agent.yaml cần test lại |
| Phase 4 Context Engine | trung bình | Medium | Cache/compression phức tạp |
| Phase 6 Event | trung bình | Medium | Event bus thay đổi flow điều phối |
| Phase 7 Simulation | thấp (không sửa source) | Low | Answer bước an toàn |

## 3. Risk tổng

- **Rủi ro lớn nhất**: làm Phase 1 trước khi có ARCHITECTURE set (0.2) — sẽ refactor nhiều.
- **Giảm thiểu**: hoàn thiện 0.1 + 0.2 trước Phase 1. (Chính là khuyến nghị của kế hoạch.)