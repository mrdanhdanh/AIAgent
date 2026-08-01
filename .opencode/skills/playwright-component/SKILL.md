---
name: playwright-component
description: Sinh test component-level cho FluentUI — button, textbox, dropdown, dialog, grid, form. Kiểm tra validation, keyboard, focus, tab order, shortcut. Dùng bUnit cho Blazor component. Sử dụng câu lệnh /test-e2e kèm --component.
schema_version: "1.0"
---

# Playwright Component — Sinh Test Component

Skill sinh test cho UI component (FluentUI/Blazor) ở mức component, không cần full page.

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [KHI NÀO DÙNG](#khi-nào-dùng)
- [COMPONENT SUPPORT](#component-support)
- [KIỂM TRA VALIDATION](#kiểm-tra-validation)
- [KIỂM TRA KEYBOARD](#kiểm-tra-keyboard)
- [KIỂM TRA FOCUS & TAB ORDER](#kiểm-tra-focus--tab-order)
- [SHORTCUT](#shortcut)
- [ĐỊNH DẠNG ĐẦU RA](#định-dạng-đầu-ra)

---

## TỔNG QUAN

Test component dùng **bUnit** (JapaneseLearner.Tests) cho Blazor WASM, hoặc Playwright cho web component thuần. Bộ test component nhanh hơn E2E nhiều lần, chạy không cần server.

### Agent & Kiến thức

- Bộ test hiện tại: `JapaneseLearner.Tests/` — xUnit + bUnit + Moq
- `BunitTestBase` mock 9 FluentUI JSInterop modules — dùng làm base class
- `MockStorageService` cho service test không cần browser storage

---

## KHI NÀO DÙNG

| Trường hợp | Dùng |
|-----------|------|
| Test 1 component đơn lẻ | ✅ Component test |
| Test interaction giữa nhiều component | ✅ Component test |
| Test full route + navigation | ❌ Dùng playwright-e2e |
| Test visual regression | ❌ Dùng visual-regression |

---

## COMPONENT SUPPORT

### Button
```csharp
var cut = RenderComponent<FluentButton>(p => p
    .Add(x => x.Appearance, Appearance.Accent)
    .AddChildContent("Lưu"));

cut.Find("button").Click();
```

Kiểm tra:
- Click handler được gọi
- Disabled state (không click được)
- Appearance đúng (`.Accent`/`.Neutral`/`.Lightweight`)

### Textbox
```csharp
var cut = RenderComponent<FluentTextField>(p => p
    .Add(x => x.Value, "")
    .Add(x => x.ValueChanged, EventCallback.Factory.Create<string>(this, v => value = v)));
```

Kiểm tra: gõ input, `ValueChanged` fire, validation message.

### Dropdown (FluentSelect)
```csharp
var cut = RenderComponent<FluentSelect<string>>(p => p
    .Add(x => x.Items, new[] { "A", "B", "C" })
    .Add(x => x.Value, "A"));
```

Kiểm tra: chọn item, value cập nhật, empty state.

### Dialog (FluentDialog)
```csharp
var cut = RenderComponent<FluentDialog>(p => p
    .Add(x => x.Visible, true)
    .AddChildContent("Nội dung"));
```

Kiểm tra: hiển thị/ẩn, close button, backdrop.

### Grid (FluentDataGrid)
```csharp
var cut = RenderComponent<FluentDataGrid<Item>>(p => p
    .Add(x => x.Items, items)
    .Add(x => x.GenerateHeader, GenerateHeaderOption.Sticky));
```

Kiểm tra: render đủ rows, empty state, sorting.

### Form
Kiểm tra validation tổng hợp: submit, error messages, disable submit khi invalid.

---

## KIỂM TRA VALIDATION

Mỗi input cần test đủ:
- ✅ **Positive** — giá trị hợp lệ
- ✅ **Negative** — giá trị không hợp lệ → error message
- ✅ **Boundary** — min/max value
- ✅ **Empty** — rỗng → required error
- ✅ **Null** — null input

```csharp
[Fact]
public void TextField_Empty_ShowsRequiredError()
{
    var cut = RenderComponent<FluentTextField>(p => p.Add(x => x.Required, true));
    Assert.Contains("required", cut.Markup, StringComparison.OrdinalIgnoreCase);
}
```

---

## KIỂM TRA KEYBOARD

- `Tab` di chuyển focus đúng thứ tự
- `Enter` submit form / kích hoạt button
- `Escape` đóng dialog
- `Arrow` điều hướng dropdown
- Space toggle checkbox

```csharp
cut.Find("input").KeyDown(Key.Enter);
```

---

## KIỂM TRA FOCUS & TAB ORDER

1. Render component
2. Focus phần tử đầu tiên
3. Tab qua từng phần tử → ghi lại document.activeElement
4. So sánh với tab order kỳ vọng

```csharp
cut.Find("input").Focus();
Assert.Equal("input", cut.Instance.FocusedElement?.TagName);
```

**Lưu ý:** FluentUI dùng shadow DOM — cần `.Instance` hoặc JSInterop mock để kiểm tra focus chính xác.

---

## SHORTCUT

- Alt+key mở menu
- Ctrl+S save
- F1 help

Test: `cut.Find("...").KeyDown(Key.S, modifiers: Alt)` hoặc mô phỏng qua JSInterop.

---

## ĐỊNH DẠNG ĐẦU RA

```yaml
status: "READY | FAIL"
summary: "Tóm tắt số component test sinh"
components_covered:
  - name: "FluentButton"
    tests: 4
validation_checks:
  - "positive"
  - "negative"
  - "boundary"
  - "empty"
keyboard_checks: ["tab", "enter", "escape"]
issues: []
next_action: "Chạy dotnet test JapaneseLearner.Tests"
```
