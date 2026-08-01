---
name: flaky-test-detector
description: Phân tích test flaky — retry, timeout, animation, network, wait, race condition. Đưa ra nguyên nhân gốc và cách khắc phục. Sử dụng trong /doctor-test, /test-audit.
schema_version: "1.0"
---

# Flaky Test Detector — Phát Hiện Test Chập Chờn

Skill phân tích nguyên nhân test chạy lúc pass lúc fail (flaky) và đề xuất cách khắc phục.

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [DẤU HIỆU FLAKY](#dấu-hiệu-flaky)
- [6 NGUYÊN NHÂN CHÍNH](#6-nguyên-nhân-chính)
- [CÁCH PHÁT HIỆN](#cách-phát-hiện)
- [ĐỊNH DẠNG ĐẦU RA](#định-dạng-đầu-ra)

---

## TỔNG QUAN

Test flaky là test chạy không ổn định — pass lần này, fail lần khác mà không đổi code. Đây là rủi ro lớn vì làm mất niềm tin vào bộ test. Skill này phân tích và đưa ra nguyên nhân + fix.

### Command liên quan

| Command | Vai trò |
|---------|---------|
| `/doctor-test` | Phát hiện flaky trong health check |
| `/test-audit` | Tính flaky rate + cải thiện |

---

## DẤU HIỆU FLAKY

- Test pass khi chạy riêng, fail khi chạy chung (parallel)
- Test pass khi chạy lại (retry) → `retry: 2` trong config
- Fail theo thời gian: 3h sáng hay fail, giờ hành chính pass
- Fail theo máy: máy A pass, máy B fail
- Fail có timeout ngẫu nhiên

---

## 6 NGUYÊN NHÂN CHÍNH

### 1. Retry che giấu
```yaml
# Có retry → dấu hiệu test có thể flaky
retries: 3
```
**Fix:** thay vì retry, tìm nguyên nhân gốc (wait thiếu, selector mơ hồ).

### 2. Timeout quá ngắn
```csharp
await _page.Locator(".result").WaitForAsync(TimeSpan.FromMilliseconds(500));
```
**Fix:** dùng auto-wait `Expect(...).ToBeVisibleAsync()` mặc định (5s), không set cứng.

### 3. Animation
Test click khi element còn đang animate → click vào chỗ cũ, element đã di chuyển.
```csharp
await _page.WaitForFunctionAsync("document.animations.length === 0");
```
**Fix:** chờ animation xong hoặc disable animation trong test (`reducedMotion`).

### 4. Network
- API response chậm bất thường → timeout
- CDN font load chậm → screenshot khác
- Mock API không stable

**Fix:** dùng `page.route` mock deterministic, set `expect` timeout hợp lý, dùng `page.waitForResponse` thay vì sleep.

### 5. Wait cứng (hardcode wait)
```csharp
await Task.Delay(2000);  // SAI — chạy chậm máy thì fail
```
**Fix:** thay bằng conditional wait: chờ element/state cụ thể.

### 6. Race condition
- Test A và B cùng đổi localStorage/dữ liệu chung
- Parallel test đụng nhau trên shared state
- `DisableParallelization` không set cho E2E collection

**Fix:** cô lập state mỗi test, dùng unique data per test, set `[Collection("E2E")]` + `DisableParallelization = true`.

---

## CÁCH PHÁT HIỆN

1. **Chạy lại** — test fail → chạy lại lần 2, 3. Fail lần đầu pass lần sau = flaky
2. **Chạy parallel** — chạy cả suite vs riêng lẻ, so sánh
3. **Phân tích log** — timeout pattern, wait trùng, retry count
4. **Quét code** — tìm `Task.Delay`, `WaitForTimeout`, timeout cứng, retry cao
5. **Track history** — test fail nhiều lần nhưng khác error = flaky

---

## ĐỊNH DẠNG ĐẦU RA

```yaml
status: "READY"
summary: "Phát hiện 3 test flaky, 2 nguyên nhân chính"
flaky_tests:
  - id: "TC-007"
    file: "WordStudyTests.cs"
    symptom: "fail lần 1, pass retry"
    root_cause:
      category: "network"
      description: "API fetch words chậm > 2s lúc CI load"
      fix: "Dùng waitForResponse thay vì WaitForTimeout(2000)"
    severity: "MAJOR"
  - id: "TC-011"
    file: "HomePageTests.cs"
    symptom: "fail khi chạy chung suite"
    root_cause:
      category: "race_condition"
      description: "Shared localStorage giữa các test"
      fix: "Reset localStorage trong fixture setup"
    severity: "CRITICAL"
stats:
  flaky_rate: 3.2%
  total_tests: 62
  flaky_tests: 2
issues: []
next_action: "Fix flaky trước khi /approve-test"
```
