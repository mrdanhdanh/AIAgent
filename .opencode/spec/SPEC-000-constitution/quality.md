---
name: spec-000-quality
description: SPEC-000 Part VI — Quality: Quality Attributes, Architecture Constraints, Error Philosophy, Security.
agent: general
---

# Part VI — Quality

## Chương 21 — Quality Attributes

Framework luôn tối ưu cho:

| Attribute | Mô tả |
|-----------|-------|
| Reliability | không crash core, recovery tự động |
| Scalability | stateless → scale ngang |
| Performance | cache, budget, lazy load |
| Maintainability | metadata-driven, spec-first |
| Extensibility | plugin-first |
| Security | least privilege, sandbox |
| Testability | deterministic, replayable |
| Determinism | cùng input → cùng output |

## Chương 22 — Architecture Constraints

Luật bắt buộc:

- **Không circular dependency.**
- **Không shared mutable state.**
- **Không bypass Runtime.**
- **Không bypass Registry.**
- **Không bypass Event Bus.**
- Không sửa metadata lúc runtime.
- Không truy cập artifact trực tiếp (qua Artifact Store).

Vi phạm = vi phạm hiến pháp.

## Chương 23 — Error Philosophy

Lỗi xử lý theo triết lý:

```text
Retry · Recover · Fail Fast · Rollback · Audit
```

| Loại lỗi | Hành vi |
|----------|---------|
| Recoverable | tiếp tục sau khắc phục |
| Retryable | retry có backoff |
| Fatal | fail fast + rollback |
| Ignored | log + continue |

- Mọi lỗi có mã + context (P012 từ bản cũ, nay chuẩn hóa).
- Fatal → transaction rollback + audit.
- Không nuốt lỗi.

## Chương 24 — Security Principles

```text
Least Privilege
Sandbox
Signed Plugins
Approval Gate
Audit Trail
```

| Nguyên tắc | Mô tả |
|-----------|-------|
| Least Privilege | quyền tối thiểu |
| Sandbox | cô lập plugin/agent |
| Signed Plugins | plugin phải ký |
| Approval Gate | hành động nguy hiểm cần duyệt |
| Audit Trail | mọi hành động log |