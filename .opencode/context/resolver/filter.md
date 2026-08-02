---
name: context-filter
description: filter — loại nguồn không cần (forbidden_context, irrelevant) ngay trước Resolve.
agent: general
---

# Context Filter

## 1. Vai trò

Bước **Filter** trong pipeline: loại thứ không cần trước Resolve để giảm tải.

## 2. Cơ chế

- Đọc `forbidden_context` từ profile → loại khối context tương ứng.
- Loại provider market không liên quan `require`.
- Loại artifact null/không có.

## 3. Ví dụ

| Agent | Forbidden | Loại bỏ |
|-------|-----------|---------|
| builder | review | context cho review (không gửi review-detail, only review.code)? |
| builder | failure_history | memory ➜ chỉ gửi summary |
| planner | build_log | không include build log |

## 4. Thứ tự

Filter chạy TRƯỚC Resolve (giảm số provider phải gọi), trước Rank.

## 5. Rule

- `required` không bao giờ bị filter.
- Filter chỉ tác động context: không protocol, contract.
- Nếu tất cả bị filter → vẫn giữ task (luôn có).

## 6. Tương tác

- `profiles/*.yaml` cấu hình forbidden.
- Q updated trong analytics (metrics số context bị loại).