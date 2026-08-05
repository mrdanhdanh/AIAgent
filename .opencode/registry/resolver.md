---
name: capability-resolver
description: Resolver — chuyển intent/request của user thành capability id.
agent: general
---

# Capability Resolver

## 1. Mục đích

Resolver dịch yêu cầu người dùng (ngôn ngữ tự nhiên) thành các capability. System trả lời:
"việc cần làm là gì?" — trước khi hỏi "ai làm?".

## 2. Procedure

1. Nhận request raw (từ `/team`, `/test-*`, `/knowledge-*`, hoặc input trực tiếp).
2. Trích intent cốt lõi (verb + object). Ví dụ: "tạo UI" → verb=create, object=ui.
3. Map intent → capability dựa trên bảng mẫu dưới đây.
4. Nếu request chạm nhiều capability → trả danh sách, mức priority theo mức quan trọng.
5. Nếu không khớp → fallback `orchestration.fallback`.

## 3. Intent → Capability map (ví dụ)

| User request | Intent | Capability |
|--------------|--------|------------|
| "Tạo UI" | create ui | ui.design |
| "Review code" | review code | review.code |
| "Fix bug" | fix | implementation.fix |
| "Tạo unit test" | create test | testing.unit |
| "Phân tích yêu cầu" | analyze req | analysis.requirement |
| "Truy nguyên lỗi" | root-cause | analysis.root-cause |
| "Push lên git" | deploy | deployment.git |
| "Dọn workspace" | cleanup | workspace.cleanup |
| "Thiết kế giao diện" | design ui | ui.design |
| "Xem ai xài symbol X" | where | knowledge.retrieve |
| "Đánh giá security" | security | review.security |

## 4. Steering từ Workflow Engine

Resolver là gợi ý static: không có ML. Kết quả được scoring ở matcher/scorer.
Engine v4 KHÔNG bắt buộc gọi resolver trong sprint này (non-invasive) — resolver là tài liệu
+ logic tham chiếu cho /team-capabilities và Sprint 3.