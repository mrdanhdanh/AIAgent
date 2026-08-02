---
name: context-pipeline
description: pipeline — trình tự 9 bước Context Engine, mỗi bước là một module độc lập.
agent: general
---

# Context Pipeline

```text
Discover → Filter → Resolve → Rank → Deduplicate → Compress → Validate → Package → Deliver
```

## 1. Discover

> Không load. Chỉ tìm.

Quét nguồn khả dụng: Project, Knowledge, Workflow, Memory, Artifacts. Trả **danh sách nguồn** (candidate) kèm metadata (type, path, size).

Module: `providers/`.

## 2. Filter

> Loại ngay thứ không cần.

Dựa vào `forbidden_context` trong profile/metadata. Ví dụ Builder → không cần Review/Testing/Failure History.

Module: `resolver/filter.md`.

## 3. Resolve

> Ghép theo metadata.

Đọc `required_context`/`requires` của agent → khớp với provider trả về. Engine **tự tìm**, không hard-code.

Module: `resolver/resolve.md`.

## 4. Rank

> Không phải context nào cũng quan trọng.

Chấm điểm 0..100 theo Context Intelligence Layer. Token hết → loại context điểm thấp.

Module: `intelligence/ranking.md`.

| Loại | Score mặc định |
|------|---------------:|
| task | 100 |
| artifact.plan | 95 |
| project.rules | 88 |
| knowledge | 65 |
| memory | 30 |

## 5. Deduplicate

Gộp nội dung trùng (project "Use Blazor" == knowledge "Use Blazor") → giữ một.

Module: `compression/deduplicate.md`.

## 6. Compress

- Tóm tóm 50 lessons → 5 lessons.
- Chỉ khi cần (vượt budget).
- Không làm mất field bắt buộc.

Module: `compression/compress.md`.

## 7. Validate

- Đảm bảo đủ `required` context.
- Thiếu → Error (KHÔNG chạy agent).

Module: `validator/`.

## 8. Package

Sinh Context Package object theo `schemas/context.schema.yaml`.

Module: `builder/`.

## 9. Deliver

Trao package cho agent + ghi metrics (token, time, cache).

Module: `metrics/` + `cache/`.

## Ghi chú

- Bước 4-6 có thể skip nếu context nhỏ (không cần nén).
- Bước 7 bắt buộc; fail thì dừng pipeline (an toàn).
- Mỗi bước test riêng trong `tests/`.