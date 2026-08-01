---
name: accessibility
description: Kiểm tra accessibility — ARIA, Tab Order, Screen Reader, Keyboard, Color Contrast, Alt, Label, Focus Ring. Sinh báo cáo WCAG AA/AAA. Sử dụng câu lệnh /test-accessibility.
schema_version: "1.0"
---

# Accessibility — Kiểm Tra Khả Năng Tiếp Cận

Skill kiểm tra khả năng sử dụng của app với người khuyết tật, theo chuẩn WCAG.

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [8 HẠNG MỤC KIỂM TRA](#8-hạng-mục-kiểm-tra)
- [CÔNG CỤ](#công-cụ)
- [BÁO CÁO WCAG](#báo-cáo-wcag)
- [QUY TRÌNH](#quy-trình)
- [ĐỊNH DẠNG ĐẦU RA](#định-dạng-đầu-ra)

---

## TỔNG QUAN

Accessibility đảm bảo mọi người dùng được, kể cả người dùng screen reader, keyboard-only, hoặc suy giảm thị lực. FluentUI hỗ trợ a11y sẵn, nhưng component dùng sai vẫn gây lỗi.

### Command

| Command | Mô tả |
|---------|-------|
| `/test-accessibility` | Chạy axe → report → fix suggestion |

### Kiến thức liên quan

- FluentUI: `.opencode/knowledge/ui/fluentui-components.md`
- Tri-state rendering: `.opencode/knowledge/ui/tri-state-rendering.md`

---

## 8 HẠNG MỤC KIỂM TRA

### 1. ARIA
- `aria-label` trên icon button (không có text)
- `aria-describedby` trên input có helper text
- `role` đúng: dialog, alert, tab, etc.
- KHÔNG dùng `aria-hidden="true"` trên element focusable

```csharp
// ĐÚNG
<FluentIconButton Icon="@Icons.Regular.Delete" AriaLabel="Xóa" />
// SAI — icon button không có tên
<FluentIconButton Icon="@Icons.Regular.Delete" />
```

### 2. Tab Order
- Tab theo thứ tự trực quan (trái→phải, trên→xuống)
- Không có `tabindex` lẻ (1, 2, 3...)
- Dialog/overlay giữ focus bên trong (focus trap)

### 3. Screen Reader
- Mọi thông tin quan trọng đều có text thay thế
- KHÔNG dùng màu làm nguồn thông tin duy nhất
- Live region cho notification: `aria-live="polite"`

### 4. Keyboard
- Mọi hành động chuột đều có thể thao tác bằng bàn phím
- `Enter`/`Space` kích hoạt button
- Escape đóng dialog/menu
- KHÔNG có keyboard trap

### 5. Color Contrast (WCAG)
| Level | Tỉ lệ |
|-------|-------|
| WCAG AA text thường | ≥ 4.5:1 |
| WCAG AA text lớn (≥24px) | ≥ 3:1 |
| WCAG AAA | ≥ 7:1 |

### 6. Alt Text
- `<img>` luôn có `alt`
- Icon decor không cần alt → `alt=""` + `aria-hidden`
- Icon chức năng cần alt mô tả hành động

### 7. Label
- Mọi input có label liên kết: `for`/`id` hoặc `aria-label`
- Placeholder KHÔNG thay thế label
- Error message liên kết với input (`aria-describedby`)

```csharp
// ĐÚNG
<FluentTextField Label="Tên" Id="name" />
// SAI — chỉ có placeholder, không có label
<input type="text" placeholder="Tên" />
```

### 8. Focus Ring
- Mọi element focusable có focus indicator rõ ràng
- KHÔNG xóa `outline` khi focus mà không thay thế
- Focus ring tương phản với background

---

## CÔNG CỤ

### Axe (Playwright)
```csharp
var results = await new AxeBuilder(_page).AnalyzeAsync();
foreach (var violation in results.Violations)
{
    Console.WriteLine($"[{violation.Impact}] {violation.Id}: {violation.Help}");
}
```

### Alternative
- `@axe-core/playwright` cho Node
- Lighthouse CI
- WAVE (browser extension) cho manual check

---

## BÁO CÁO WCAG

### WCAG AA (bắt buộc)
Danh sách violation + hạng mục không đạt:
- 1.4.3 Contrast (Minimum)
- 2.1.1 Keyboard
- 2.4.7 Focus Visible
- 3.3.1 Error Identification

### WCAG AAA (nâng cao)
- 1.4.6 Contrast (Enhanced) — 7:1
- 2.4.9 Link Purpose
- 3.1.3 Unusual Words

---

## QUY TRÌNH

1. **Quét tự động** — axe trên mọi route chính (`/`, `/alphabet`, `/words`, `/kanji`, `/grammar`, `/admin`)
2. **Phân loại** — critical/serious/moderate/minor
3. **Manual check** — tab order, keyboard, screen reader (không tự động được)
4. **Sinh báo cáo** — WCAG AA/AAA status cho từng hạng mục
5. **Đề xuất fix** — kèm file + line

---

## ĐỊNH DẠNG ĐẦU RA

```yaml
status: "PASS | CHANGES_NEEDED"
summary: "Tóm tắt số a11y issues"
routes_checked:
  - "/"
  - "/alphabet"
  - "/words"
violations:
  - severity: "CRITICAL"
    wcag: "1.4.3"
    impact: "serious"
    description: "Color contrast 3.2:1 trên button accent"
    file: "Home.razor"
    suggestion: "Đổi màu text hoặc background để đạt 4.5:1"
  - severity: "MAJOR"
    wcag: "2.4.7"
    impact: "moderate"
    description: "Focus ring bị xóa trên FluentButton"
    file: "Global.css"
    suggestion: "Thêm :focus-visible style"
wcag_status:
  aa: "FAIL"
  aaa: "NOT_TESTED"
manual_checks:
  - "tab_order"
  - "keyboard"
  - "screen_reader"
issues: []
next_action: "Fix CRITICAL/MAJOR trước khi approve"
```
