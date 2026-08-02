---
name: artifact-metrics
description: Artifact Metrics — count, size, version, dependency depth, reuse rate.
agent: general
---

# Artifact Metrics

## 1. Chỉ số

| Metric | Mô tả |
|--------|-------|
| artifact.count | tổng artifact active |
| artifact.by_type | count per type |
| avg.size | kích thước trung bình (byte) |
| version.avg | số version trung bình mỗi artifact |
| dependency.depth.max | độ sâu tối đa DAG |
| dependency.depth.avg | độ sâu trung bình |
| orphan.count | artifact không consumed_by |
| cache.hit_rate | tỷ lệ cache hit |
| checksum.mismatch | số lần checksum fail |
| reuse.rate | artifact được nhiều agent dùng |

## 2. Lưu trữ

- `artifacts/metrics.json` — dump định kỳ.
- Doctor đọc tổng hợp.

## 3. Tương tác

- `manager.md` cập nhật counter.
- `cache.md` cập nhật hit_rate.
- Phase 8 (Doctor) đọc metrics.