---
name: workflow-runtime-configuration
description: configuration — Phase 1.18: tất cả cấu hình runtime tập trung, không hard-code. Tích hợp Feature Flags.
agent: general
---

# configuration.md — Runtime Configuration

> Tất cả cấu hình tập trung. **Không hard-code.**

## 1. Config block

```yaml
runtime:
  max_retry: 3
  timeout: 300
  parallel: false
  rollback: true
  auto_save: true
  validation: strict
```

| Key | Default | Mô tả |
|-----|---------|-------|
| max_retry | 3 | retry tối đa (khi phase không khai báo) |
| timeout | 300 | timeout phase (giây) |
| parallel | false | song song (Phase 1 luôn false) |
| rollback | true | bật rollback |
| auto_save | true | tự lưu persistence |
| validation | strict | strict/lenient (CONTRACTS.md) |

## 2. Nguồn cấu hình

```text
runtime.yaml (default)
  ← workflow-specific override (per workflow)
  ← CLI/env override
```

Override theo thứ tự: default → workflow → env.

## 3. Không hard-code

- Không số ma thuật trong runtime.md/executor.
- Mọi ngưỡng (retry/timeout/validation) đọc từ config.

## 4. Config → Service Locator

- Config quyết định implementation nào được bind (DI): `logger: file`, `persistence: json`.
- Service Locator đọc config tại boot.

## 5. Feature Flags

- `features.*` tách riêng trong `feature-flags.md` để bật/tắt module.

## 6. Tương tác

- `feature-flags.md` (features block)
- `dependency-injection.md` (config → bind)
- `runtime.md` (đọc config)