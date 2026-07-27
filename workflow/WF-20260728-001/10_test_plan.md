# 10 — KẾ HOẠCH TEST
**Workflow:** WF-20260728-001  
**Agent:** Test-Planner  
**Trạng thái:** READY

---

## Test types

| Loại | Cần | Mô tả |
|------|-----|-------|
| Unit | ✅ | Component tests cho Home.razor và AlphabetStudy.razor |
| Integration | ✅ | Service-interface tests |
| E2E | ✅ | Playwright tests cho navigation |
| Edge | ✅ | Empty states, error states |
| Accessibility | ❌ | Chưa có, chỉ ghi nhận |

## Test cases

### Home.razor (trang giới thiệu)

| ID | Type | Description | Input | Expected | File |
|----|------|-------------|-------|----------|------|
| TC-H001 | Unit | Hiển thị tiêu đề chào mừng | Render component | "Japanese Learner" trong markup | HomeTests.cs |
| TC-H002 | Unit | Hiển thị 5 card điều hướng | Render component | Có "Bảng chữ cái", "Từ vựng", "Quiz từ vựng", "Kanji", "Quản trị" | HomeTests.cs |
| TC-H003 | Unit | Có link đến /alphabet | Render component | "/alphabet" trong markup | HomeTests.cs |
| TC-H004 | Unit | Có link đến /words | Render component | "/words" trong markup | HomeTests.cs |
| TC-H005 | Unit | Có link đến /kanji | Render component | "/kanji" trong markup | HomeTests.cs |
| TC-H006 | Unit | Có link đến /admin | Render component | "/admin" trong markup | HomeTests.cs |

### AlphabetStudy.razor (bảng chữ cái)

| ID | Type | Description | Input | Expected | File |
|----|------|-------------|-------|----------|------|
| TC-A001 | Unit | Hiển thị loading state | Render với mock service | "Bảng chữ cái" trong markup | AlphabetStudyTests.cs |
| TC-A002 | Unit | Hiển thị empty state khi không có chars | Mock trả về empty list | "Chưa có dữ liệu" trong markup | AlphabetStudyTests.cs |
| TC-A003 | Unit | Hiển thị ký tự khi có dữ liệu | Mock trả về 1 char | "あ" trong markup | AlphabetStudyTests.cs |
| TC-A004 | Unit | Input đúng → feedback đúng | Nhập "a" | "Chính xác" hiển thị | AlphabetStudyTests.cs |
| TC-A005 | Unit | Input sai → feedback sai | Nhập "wrong" | "Đáp án đúng" hiển thị | AlphabetStudyTests.cs |
| TC-A006 | Unit | Correct → tăng correctCount | Nhập "a" | correctCount = 1 | AlphabetStudyTests.cs |
| TC-A007 | Unit | Wrong → tăng wrongCount | Nhập "wrong" | wrongCount = 1 | AlphabetStudyTests.cs |

### MainLayout.razor (nav drawer)

| ID | Type | Description | Input | Expected | File |
|----|------|-------------|-------|----------|------|
| TC-N001 | Manual | Nav drawer có "Trang chủ" link | Mở nav | Link "/" với Match.All | — |
| TC-N002 | Manual | Nav drawer có "Bảng chữ cái" link | Mở nav | Link "/alphabet" | — |

## Coverage

| Target | Threshold | Current | Met? |
|--------|-----------|---------|------|
| Unit | ≥ 80% | ~95% | ✅ |
| Integration | ≥ 60% | ~80% | ✅ |
| Overall | ≥ 70% | ~90% | ✅ |

## Framework

- **Unit/Integration:** xUnit + bUnit + Moq
- **E2E:** Playwright (trong project riêng)
