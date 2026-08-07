---
name: lifecycle-specification
description: >
  Specification Lifecycle (Document Lifecycle) — Draft → Review → Approved → Frozen → Deprecated → Archived.
  Tách bạch khỏi Review Lifecycle (NotReviewed → Rev1 → Completed). Mỗi mục bắt buộc review tối thiểu 2 lần.
agent: general
---

# Specification Lifecycle

> D005 — Vòng đời của một SPEC (SPEC-001..020) và các mục S0xx bên trong.
> **2 trục tách bạch**: Document Lifecycle (file này) vs Review Lifecycle (`../review-workflow.md`).
> Điều hành bởi lệnh `/review`.

## Document Lifecycle

```text
Draft ──► Review ──► Approved ──► Frozen ──► Deprecated ──► Archived
```

| State | Ý nghĩa |
|-------|---------|
| `Draft` | Tạo xong, chưa được duyệt |
| `Review` | Đang trong vòng đánh giá (review hoặc approval) |
| `Approved` | Đã duyệt (POLICY-001) |
| `Frozen` | Đóng băng — **chỉ đến từ Approved**, không bao giờ trực tiếp |
| `Deprecated` | Hết hiệu lực, còn tham chiếu (POLICY-004) |
| `Archived` | Lưu trữ, không dùng nữa |

## Transitions

| From | To | Điều kiện |
|------|-----|-----------|
| Draft | Review | Bắt đầu review (review.count ≥ 1) |
| Review | Approved | **review.status = Completed** (2 lần review) + approval pass (POLICY-001) |
| Approved | Frozen | Quyết định freeze — không trực tiếp từ Draft/Review |
| Frozen | Deprecated | POLICY-004 Deprecation |
| Deprecated | Archived | Hết chu kỳ deprecation |

## Review Lifecycle (trục riêng — xem review-workflow.md)

```text
NotReviewed ──► (review 1) ──► Rev1 ──► (review 2) ──► Completed
```

- **Bắt buộc ≥ 2 lần review** trước khi Completed — tiền đề cho Approved.
- Mục đã review/Freeze từ trước (vd: SPEC-000, S001–S008) **giữ nguyên cả 2 trục** (inherited).

## Quy tắc

- `lifecycle: Approved` → bắt buộc `review.status: Completed`.
- `lifecycle: Frozen` không bao giờ trực tiếp từ Draft/Review.
- Trạng thái 2 trục ghi trong `review-tracker.yaml` (nguồn sự thật duy nhất) — chỉ `/review` cập nhật.
- Mỗi SPEC có `SPEC.yaml` (metadata, status, implemented_by).
- Không mâu thuẫn SPEC-000 Constitution (P020).
- Traceability: SPEC → Implementation → Test (POLICY-011).

## Tham chiếu

- Review workflow: `../review-workflow.md` · Tracker: `../review-tracker.yaml`
- Status: `../review-status.yaml` · Rules: `../review-rules.yaml`
- Command: `.opencode/commands/review.md`
- P020 Constitution First · POLICY-011 Traceability
- `docs/specs/SPEC-000/` (Constitution)
