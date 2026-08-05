---
name: context-provider-knowledge
description: Knowledge Provider — khung Knowledge Context (patterns, best practices, lessons).
agent: general
---

# Knowledge Provider

## 1. Vai trò

Cung cấp best practices, patterns, lessons từ Knowledge Base.

## 2. Nguồn

- `.opencode/knowledge/` (lessons, patterns)
- `.opencode/knowledge-index/` (index lookup)
- Repository patterns.

## 3. Interface

- `discover(keyword)`: truy vấn index → candidate.
- `resolve()`: nội dung bài/lesson.
- `size()`: token.
- `validate()`: metadata hợp lệ.

## 4. Quá trình

Phải dùng **index** (Knowledge Index) thay vì scan toàn bộ — Context Index chuẩn bị cho Knowledge Graph.

## 5. Compress

Knowledge là **medium score (70)** → có thể nén/tóm tắc khi budget hẹp. Xem `compression/`.

## 6. Ranking

- Chỉ giữ các knowledge liên quan task (query-based), không trộn chung tất cả.
- Token budget hẹp → knowledge bị giảm trước memory.

## 7. Tương tác

- Profile: `optional: [knowledge]`.
- Phase 5 Artifact Store cho artifacts; knowledge giữ qua Provider này.