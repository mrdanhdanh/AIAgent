---
name: plugin-installer
description: Plugin Installer — cài, cập nhật, gỡ plugin; verify package trước khi cài.
agent: general
---

# Plugin Installer

## 1. Vai trò

Cài/update/gỡ plugin package vào framework.

## 2. Install flow

```text
Package (zip/dir)
  → Verify (checksum, schema)
  → Copy vào plugins/installed/
  → Validate + certify
  → Register exports
  → Enable
```

## 3. Update flow

```text
Update(id, version)
  → Tải package mới
  → Migration (v1 → v2)
  → Re-validate
  → Re-certify
  → Swap (không crash Core)
```

## 4. Uninstall

```text
Uninstall(id)
  → Disable trước
  → Gỡ exports khỏi Registry
  → Xóa package (backup trước)
  → Remove từ plugins/
```

## 5. Verification

- Checksum package hợp lệ (SHA256).
- plugin.yaml đúng schema.
- Dependency đủ.
- Compat framework.

## 6. Tương tác

- `manager.md` — orchestrate.
- `validator.md` — checks.
- `marketplace.md` — nguồn package.