---
name: test-report
description: Sinh báo cáo kiểm thử — HTML, Markdown, JSON, JUnit, Allure. Gồm coverage, failed, passed, skipped, screenshot, video, trace. Sử dụng trong /test-e2e, /doctor-test, /approve-test.
schema_version: "1.0"
---

# Test Report — Sinh Báo Cáo Kiểm Thử

Skill sinh báo cáo kiểm thử ở nhiều định dạng, phục vụ cả người và máy.

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [ĐỊNH DẠNG BÁO CÁO](#định-dạng-báo-cáo)
- [NỘI DUNG BÁO CÁO](#nội-dung-báo-cáo)
- [DỮ LIỆU ĐÍNH KÈM](#dữ-liệu-đính-kèm)
- [QUY TRÌNH](#quy-trình)
- [ĐỊNH DẠNG ĐẦU RA](#định-dạng-đầu-ra)

---

## TỔNG QUAN

Test Report tổng hợp kết quả test thành tài liệu dễ đọc, dễ tích hợp CI/CD. Dùng cuối mỗi pipeline test.

### Command liên quan

| Command | Vai trò |
|---------|---------|
| `/test-e2e` | Tự sinh report sau khi run |
| `/doctor-test` | Báo cáo health |
| `/approve-test` | Dùng report để quyết định |

---

## ĐỊNH DẠNG BÁO CÁO

### HTML
- Report trực quan cho team/PM
- Kèm screenshot thumbnails
- Filter theo status, module, severity

### Markdown
- Đính kèm PR/issue
- Bảng tổng hợp nhanh

### JSON
- Máy đọc, tích hợp CI
- Feed vào `/approve-test` gate

### JUnit XML
- Tiêu chuẩn CI (GitHub Actions, Jenkins)
- `dotnet test --logger "junit"` hoặc Playwright report

### Allure
- Advanced report với history, trends
- Tích hợp screenshot/video/trace

---

## NỘI DUNG BÁO CÁO

| Mục | Mô tả |
|-----|-------|
| Coverage | unit/integration/e2e/overall % |
| Passed | số test PASS |
| Failed | số test FAIL + error message |
| Skipped | số test SKIP + lý do |
| Duration | tổng thời gian, test chậm nhất |
| Flaky | test retry thành công (báo riêng) |
| Environments | browser, viewport, OS, date |

---

## DỮ LIỆU ĐÍNH KÈM

- **Screenshot** — màn hình lúc test chạy (kèm từng step)
- **Video** — ghi lại toàn bộ session (Playwright: `video: 'on'`)
- **Trace** — Playwright trace zip (network, console, DOM snapshot)

```csharp
// Bật video + trace trong PlaywrightFixture
new BrowserNewContextOptions
{
    RecordVideoDir = "videos/",
    Trace = "on"
};
```

---

## QUY TRÌNH

1. **Thu thập kết quả** — từ `dotnet test`, Playwright, axe, visual diff
2. **Tổng hợp** — nhóm theo module, status, severity
3. **Chọn định dạng** — theo yêu cầu (mặc định: Markdown + JSON)
4. **Sinh report** — file + nội dung chuẩn
5. **Xuất** — lưu vào `test-results/` + in summary ra console

---

## ĐỊNH DẠNG ĐẦU RA

```yaml
status: "READY"
summary: "Sinh report test tại test-results/report.md + report.json"
formats_generated:
  - "markdown"
  - "json"
artifacts:
  - file: "test-results/report.md"
    size: "12KB"
  - file: "test-results/report.json"
    size: "8KB"
content:
  total: 25
  passed: 22
  failed: 2
  skipped: 1
  coverage: { unit: 85, integration: 70, e2e: 55, overall: 78 }
  duration: "3m 25s"
  flaky: ["TC-007", "TC-011"]
issues: []
next_action: "Chuyển report cho /approve-test gate"
```
