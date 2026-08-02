---
name: spec-000-engineering
description: SPEC-000 Part IV — Engineering Principles: Versioning, Compatibility, Error Handling, Security.
agent: general
---

# Part IV — Engineering Principles

## Chương 12 — Versioning

Quy định chung:

- **Semantic Version**: MAJOR.MINOR.PATCH.
- MAJOR = breaking, MINOR = tính năng, PATCH = fix.
- Mọi thực thể (P-003): agent, artifact, prompt, capability, workflow đều version.
- Không overwrite — tạo version mới.
- **Deprecation**: đánh dấu deprecated, giữ window, rồi mới gỡ.

## Chương 13 — Compatibility

Luật rõ ràng:

```text
Runtime v4
  ↓
Agent v3
  ↓
Compatible
```

| Trường hợp | Kết quả |
|-----------|---------|
| version ≥ requirement | ✅ compatible |
| MAJOR bump (breaking) | ⚠️ cần migration |
| version < requirement | ❌ reject |

- Backward compatible by default (P-015).
- Breaking → deprecation window + migration guide.

## Chương 14 — Error Handling

Không nói Exception. Chỉ quy định 4 loại lỗi:

| Loại | Mô tả | Xử lý |
|------|-------|-------|
| Recoverable | có thể tiếp tục | retry/failover |
| Retryable | transient, retry có thể thành công | retry có backoff |
| Fatal | không thể tiếp tục | abort + rollback |
| Ignored | không ảnh hưởng kết quả | log + continue |

- Mọi lỗi có **mã** + context (P-012).
- Lỗi không nuốt — phát event, audit.
- Fatal → transaction rollback (P-010).

## Chương 15 — Security

```text
Least Privilege
Sandbox
Signed Plugin
Audit Trail
```

| Nguyên tắc | Mô tả |
|-----------|-------|
| Least Privilege | chỉ cấp quyền tối thiểu |
| Sandbox | plugin/agent chạy cô lập |
| Signed Plugin | plugin phải được ký |
| Audit Trail | mọi hành động log |

- Permission qua Policy Engine, không hard-code.
- Hành động nguy hiểm → approval (Trust & Safety).