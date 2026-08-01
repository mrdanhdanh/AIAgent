---
name: playwright-e2e
description: Sinh test E2E Playwright hoàn chỉnh — Playwright Test, Page Object, Test Fixture, Mock API, Login Helper. Input: Screen/API/Requirement. Output: tests/, page-object/, fixtures/. Sử dụng câu lệnh /test-e2e.
schema_version: "1.0"
---

# Playwright E2E — Sinh Test E2E Playwright

Skill chuyên sinh bộ test E2E Playwright cho Blazor WebAssembly (JapaneseLearner) hoặc bất kỳ web app nào.

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [QUY TRÌNH SINH TEST](#quy-trình-sinh-test)
- [CẤU TRÚC OUTPUT](#cấu-trúc-output)
- [PLAYWRIGHT TEST](#playwright-test)
- [PAGE OBJECT](#page-object)
- [TEST FIXTURE](#test-fixture)
- [MOCK API](#mock-api)
- [LOGIN HELPER](#login-helper)
- [QUY TẮC BẮT BUỘC](#quy-tắc-bắt-buộc)
- [ĐỊNH DẠNG ĐẦU RA](#định-dạng-đầu-ra)

---

## TỔNG QUAN

Skill này sinh bộ test E2E dựa trên:
- **Screen** — màn hình cần test (route, component)
- **API** — endpoints liên quan
- **Requirement** — yêu cầu nghiệp vụ

### Command

| Command | Mô tả |
|---------|-------|
| `/test-e2e` | Chạy pipeline: requirement → Playwright → Fixture → Run → Report |

### Kiến thức liên quan

- `.opencode/knowledge/testing/playwright-e2e.md` — convention dự án
- `JapaneseLearner.E2ETests/` — vị trí test hiện tại
- Port **5173** hardcode trong `AppFixture.cs` — không đổi nếu không sửa cả 2 nơi

---

## QUY TRÌNH SINH TEST

### Bước 1: Phân tích Requirement
Từ yêu cầu, xác định:
- Màn hình/route liên quan
- Actions người dùng (click, type, navigate)
- Expected behavior (nội dung hiển thị, navigation, validation)

### Bước 2: Xác định Page Object
Mỗi màn hình 1 Page Object class. Đặt tại `page-object/<Name>Page.cs`.

### Bước 3: Sinh Test
Mỗi requirement ≥ 1 test method. Test theo pattern: **Arrange → Act → Assert**.

### Bước 4: Xác định Fixture
Nếu test cần dữ liệu → tạo fixture riêng hoặc dùng `AppFixture` chung.

---

## CẤU TRÚC OUTPUT

```
tests/
  <Feature>Tests.cs          # Test classes
page-object/
  <Feature>Page.cs           # Page Object
fixtures/
  <Feature>Fixture.cs        # Test fixtures
  Mock<IApi>.cs              # Mock API (nếu cần)
helpers/
  LoginHelper.cs             # Login helper
```

---

## PLAYWRIGHT TEST

Sinh test class kế thừa xUnit + Playwright pattern:

```csharp
[Collection("E2E")]
public class HomePageTests
{
    private readonly IPage _page;

    public HomePageTests(AppFixture fixture)
    {
        _page = fixture.Page;
    }

    [Fact]
    public async Task HomePage_Loads_Successfully()
    {
        await _page.GotoAsync("/");
        await Expect(_page.Locator("h1")).ToBeVisibleAsync();
    }
}
```

**Quy tắc test method:**
- Tên: `{Screen}_{Action}_{Expected}`
- Luôn có assertion (không test "chạy không lỗi")
- Dùng `Expect` (auto-wait) thay vì `WaitForTimeout`

---

## PAGE OBJECT

Sinh Page Object encapsulate selector + actions:

```csharp
public class AlphabetPage
{
    private readonly IPage _page;
    private readonly string _baseUrl;

    public AlphabetPage(IPage page, string baseUrl)
    {
        _page = page;
        _baseUrl = baseUrl;
    }

    private ILocator Title => _page.Locator("h1");
    private ILocator NextButton => _page.GetByRole(AriaRole.Button, new() { Name = "Tiếp" });

    public async Task GotoAsync() => await _page.GotoAsync($"{_baseUrl}/alphabet");

    public async Task<string> GetTitleAsync() => await Title.InnerTextAsync();

    public async Task ClickNextAsync() => await NextButton.ClickAsync();
}
```

**Quy tắc Page Object:**
- Selector ưu tiên: `data-testid` > `getByRole` > `getByLabel` > CSS class
- KHÔNG dùng selector dễ vỡ: auto-generated id, index không ổn định
- KHÔNG hardcode URL — dùng `_baseUrl` từ fixture

---

## TEST FIXTURE

Sinh fixture hoặc tham chiếu `AppFixture` chung:

```csharp
public class AppFixture
{
    public IPage Page { get; }
    public string BaseUrl { get; } = "http://localhost:5173";
}
```

**Quy tắc:**
- E2E dùng `[Collection("E2E")]` + `DisableParallelization = true` (1 dev server / run)
- KHÔNG khởi động nhiều dev server trong cùng collection

---

## MOCK API

Khi cần cô lập frontend khỏi backend:

```csharp
await _page.RouteAsync("**/api/words", route =>
{
    var json = /* dữ liệu fake */;
    route.FulfillAsync(new() { ContentType = "application/json", Body = json });
});
```

**Quy tắc:**
- Chỉ mock khi API không ổn định hoặc chưa có
- Mock data sinh từ skill `test-data-generator`
- Luôn ghi rõ API được mock trong test comment

---

## LOGIN HELPER

```csharp
public static class LoginHelper
{
    public static async Task LoginAsync(IPage page, string baseUrl)
    {
        await page.GotoAsync($"{baseUrl}/login");
        await page.GetByLabel("Email").FillAsync("test@example.com");
        await page.GetByLabel("Mật khẩu").FillAsync("Test@123");
        await page.GetByRole(AriaRole.Button, new() { Name = "Đăng nhập" }).ClickAsync();
        await page.WaitForURLAsync("**/");
    }
}
```

**Quy tắc:**
- KHÔNG dùng credential thật — dùng test account / mock
- Cô lập login vào 1 helper để tái sử dụng

---

## QUY TẮC BẮT BUỘC

1. **Port**: dùng 5173 (khớp `AppFixture.cs`) — không đổi tùy tiện
2. **Selector**: ưu tiên `data-testid` / role / label
3. **Không hardcode wait** — dùng auto-wait của Playwright (`Expect`, `WaitForURL`)
4. **Không đụng production** — kiểm tra URL luôn là localhost
5. **Test độc lập** — mỗi test tự chuẩn bị dữ liệu, tự cleanup
6. **Chạy unit test trước E2E** — E2E chậm, phụ thuộc máy

---

## ĐỊNH DẠNG ĐẦU RA

```yaml
status: "READY | FAIL"
summary: "Tóm tắt số test sinh được"
tests_created:
  - file: "tests/HomePageTests.cs"
    test_methods: 3
page_objects_created:
  - "page-object/HomePage.cs"
fixtures_created: []
mock_apis: []
issues:
  - severity: "WARNING"
    description: "PlaywrightFixture.cs:24 browser path hardcoded"
    suggestion: "Cấu hình browser path theo máy"
next_action: "Chạy dotnet test E2E"
```
