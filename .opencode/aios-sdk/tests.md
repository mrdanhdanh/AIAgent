---
name: sdk-tests
description: SDK Tests — component API, permission, version, error contract.
agent: general
---

# SDK Tests

## 1. Test cases

| # | Scenario | Expected |
|---|----------|----------|
| 1 | Component API | mỗi SDK trả đúng DTO |
| 2 | Permission denied | SDK-ERR-401 |
| 3 | Version incompatible | SDK-ERR-403 |
| 4 | NotFound | SDK-ERR-404 |
| 5 | Control with key | operator+ pass |
| 6 | Audit log | mọi call log |
| 7 | Backward compat | old consumer chạy trên new SDK |
| 8 | Error contract | lỗi chuẩn hóa |

## 2. Cách chạy

- Unit test từng SDK con với mock Core.
- Integration test SDK → Core.
- `sdk-validator.ps1` — gate Phase 13 (structure).

## 3. Target

- Mọi SDK component có test.
- Permission + version gate coverage.