---
name: artifact-diff
description: Artifact Diff — so sánh nội dung giữa các version; Context Engine gửi diff thay vì full.
agent: general
---

# Artifact Diff

## 1. Mục đích

Context Engine chỉ gửi **diff** giữa hai version artifact (v1→v2), không gửi lại toàn bộ nội dung.

## 2. Khi nào dùng

- Artifact đã được giao ở lần trước → iteration sau gửi diff.
- Cache hit → so sánh checksum → nếu khác → compute line-level diff.

## 3. Format

```text
+ dòng thêm
- dòng xóa
  dòng giữ nguyên (không gửi)
```

## 4. Cơ chế

- Cần giữ content cũ trong artifact cache (checksum làm key).
- So sánh: content mới vs content cũ → diff.
- Package diff kèm `diff_from: v1, diff_to: v2`.

## 5. Lợi ích

- Plan từ 900 token xuống diffuse ~50 token (tiết kiệm 850).
- Tổng cộng giúp Context Engine đạt mục tiêu 40-70% token.

## 6. Tương tác

- `versioning.md` — produce versions.
- `context/cache/diff.md` — Context Diff module dùng artifact diff.
- `cache.md` — giữ content cũ.