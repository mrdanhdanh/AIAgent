---
name: gov-release
description: Quy trình Release — phát hành phiên bản theo SemVer.
agent: general
---

# Release

## Mục đích

Phát hành phiên bản AIOS một cách nhất quán, kiểm chứng, và rollback được.

## Quy trình

```text
Freeze branch
  ↓
Build + Test (unit + E2E)
  ↓
Validator gates (35 scripts PASS)
  ↓
Changelog
  ↓
Tag version (vX.Y.Z)
  ↓
Release notes
```

## Quy tắc

- SemVer (MAJOR.MINOR.PATCH) — tương ứng mức breaking (G-001).
- Không release khi validator FAIL.
- Mỗi release phải có changelog ghi rõ thay đổi SPEC/rule.
- Breaking change bắt buộc qua RFC + ADR trước khi release.
- Release cũ được rollback nếu critical defect.

## Version tương ứng

| Release | Điều kiện |
|---------|-----------|
| MAJOR | breaking change (SPEC thay đổi giao diện) |
| MINOR | thêm tính năng backward compatible |
| PATCH | sửa lỗi, không đổi giao diện |
