---
name: plugin-security
description: Plugin Security — khai báo quyền, audit, chống malicious plugin, supply chain.
agent: general
---

# Plugin Security

## 1. Vai trò

Đảm bảo plugin không gây hại framework — quyền minh bạch, audit, isolation.

## 2. Security layers

| Layer | Biện pháp |
|-------|-----------|
| Install | checksum verify, publisher verify |
| Sandbox | permission enforcement |
| Audit | access log, violation detection |
| Certification | security scan trước enable |
| Update | re-verify + re-certify |

## 3. Malicious prevention

- Plugin không được phép `runtime.modify` trừ core.
- Script chạy restricted policy.
- Không truy cập credential/secret (quyền không có).
- Knowledge write giới hạn namespace plugin.

## 4. Supply chain

- Marketplace: plugin verified (author + checksum).
- Version pin: chỉ install version đã kiểm tra.
- Dependency chéo → kiểm tra plugin dependency cũng certified.

## 5. Security events

- `SECURITY_PLUGIN_PERMISSION_DENIED`
- `SECURITY_PLUGIN_VIOLATION`
- `SECURITY_PLUGIN_INSTALL_FAILED`

Gửi Event Bus → Doctor + Dashboard.

## 6. Tương tác

- `sandbox.md` — isolation.
- `permissions.md` — model.
- `certification.md` — security scan gate.