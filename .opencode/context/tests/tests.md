---
name: context-tests
description: tests — test scenarios cho Context Engine: missing, duplicate, compression, cache, resolver, validation, package.
agent: general
---

# Context Tests

## 1. Test cases

| # | Scenario | Kỳ vọng |
|---|----------|---------|
| 1 | Missing required context | validator báo CXT-002, không chạy agent |
| 2 | Duplicate context | deduplicate giữ 1 |
| 3 | Budget exceed | Intelligence loại context thấp; used<=limit |
| 4 | Cache hit | project không đọc lại sau lần đầu |
| 5 | Resolver match | builder resolve artifact.plan đúng |
| 6 | Validation invalid | package không đúng schema |
| 7 | Package structure | đúng context.schema.yaml |
| 8 | Diff iteration | iteration2 chỉ gửi diff artifact |
| 9 | Forbidden filter | builder không nhận review context |
| 10 | Empty task | goal rỗng → CXT-001 |

## 2. Cách chạy

- Unit test gọi engine + profile mẫu (`profiles/test.yaml`).
- Không cần server/LLM (pure logic + mock provider).
- Không dùng token thật.

## 3. Coverage targets

- Resolver nhánh required/optional/forbidden.
- Validator CXT-001..005.
- Compress policy các score band.
- Cache hit/miss + diff.

## 4. Integration

- Với `context-validator.ps1` (gate: validate registry/profiles hợp lệ).
- Doctor gọi test context như health check.

## 5. Files

- `tests/` chứa kịch bản + fixtures:
  - `missing.yaml`, `duplicate.yaml`, `budget-over.yaml`, `profile-builder.yaml`.

## 6. Lưu ý

- Tests phải deterministic, không phụ thuộc network.