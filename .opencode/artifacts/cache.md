---
name: artifact-cache
description: Artifact Cache — cache content theo checksum; reuse khi Context Engine request.
agent: general
---

# Artifact Cache

## 1. Mục đích

Builder vừa đọc PLAN-001 → Tester cũng cần → cache tránh đọc lại.

## 2. Cơ chế

- Cache: map `checksum → content`.
- Khi resolver request artifact → kiểm tra cache trước.
- Hit → trả ngay. Miss → `repository.Read()`.

## 3. Invalidation

- Artifact version mới → checksum khác → cache miss → load mới.
- Soft expiry: clear sau workflow kết thúc (session cache).
- Hard expiry: clear sau N giờ (global cache).

## 4. Cache layers

| Layer | Scope | TTL |
|-------|-------|-----|
| Memory | per-session | workflow end |
| Index | per-session | workflow end |
| File System | permanent | — |

## 5. Metrics

- Hit rate target > 80%.
- Cache size (mem).