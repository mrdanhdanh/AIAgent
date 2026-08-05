---
name: context-compress
description: dedup+compress — gộp nội dung trùng và nén context để nằm trong budget.
agent: general
---

# Context Compression

Gồm 2 module: **Deduplicate** + **Compress** (bước 5-6 pipeline).

## 1. Deduplicate

- Nếu 2 nguồn cùng nội dung ("Use Blazor") → giữ 1 (ưu tiên project).
- Bằng checksum content-hash.
- Đặc biệt nguồn project + knowledge trùng.

## 2. Compress

| chế độ | cách | áp dụng |
|--------|------|---------|
| select | chọn top-score trong budget | knowledge/memory list |
| summary | tóm tất các item dài | lessons, history |
| structure | giữ khung, bỏ detail | large artifacts |

## 3. Ví dụ

- 50 lessons → summary 5 (không phải 50).
- Memory 300 records → summary 1 dòng.

## 4. Policy theo score

| score | default | action |
|-------|---------|--------|
| required | — | không nén |
| >=80 | giữ nguyên |
| 50-79 | nén/select |
| <50 | loại |

## 5. An toàn

- Không nén `required`, không nén `task.goal`.
- Sau compress phải validate lại (đủ required).
- Compress có thể gọi LLM tóm tắc (optional, tốn token) hoặc dùng các metrics rule (rẻ).

## 6. Metrics

- compression_ratio = original/result
- save_token = original_size - result_size per iteration.

## 7. Tương tác

- `intelligence/` cung cấp score.
- `validator/` đảm bảo không vi phạm required.
- Schedule sau rank, trước package.