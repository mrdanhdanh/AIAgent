---
name: architecture-compatibility
description: COMPATIBILITY — backward compatibility và migration path v3 → v4 cho Agent Framework.
agent: general
---

# COMPATIBILITY.md — Backward Compatibility

> Quy định v3 → v4 migration an toàn. Nguyên tắc #8 (Backward Compatible).

## 1. Nguyên tắc

- v3 vẫn chạy được trong khi v4 xây dựng.
- Không xóa file v3 trong quá trình migration.
- Baseline `.opencode/baseline/` là điểm rollback.
- File v4 nằm thư mục mới, không đè file v3 cùng tên (trừ khi có ADR).

## 2. Migration path

```
v3
 │
 ├─ registry mới (.opencode/registry/)     → v4 dùng
 ├─ workflow definitions mới               → v4 dùng
 ├─ skill/command/agent metadata           → thêm frontmatter chuẩn
 └─ baseline snapshot                      → rollback reference
 │
 ▼
v4
```

## 3. Ma trận tương thích

| Hạng mục | v3 | v4 | Compatible |
|----------|----|----|------------|
| agent .md | có frontmatter cũ | thêm description/agent fields | ✅ |
| command .md | có frontmatter | giữ nguyên format | ✅ |
| skill SKILL.md | có frontmatter | giữ nguyên | ✅ |
| workflow engine | 13 bước cứng | engine v4 + definitions | ✅ (song song) |
| registry | không có | có (CR validated) | ✅ (thêm mới) |
| knowledge | .opencode/knowledge | index | ✅ |

## 4. Quy tắc breaking change

- Breaking change → bắt buộc:
  1. Tạo ADR mới.
  2. Ghi COMPATIBILITY matrix.
  3. Migration script hoặc hướng dẫn.
  4. Tăng MAJOR version tương ứng.

## 5. Rollback

- Dùng `.opencode/backup/<WF-ID>/` và baseline.
- Rollback theo MIGRATION_GUIDE.md (workflow engine).
- Doctor kiểm tra baseline trước/sau thay đổi.