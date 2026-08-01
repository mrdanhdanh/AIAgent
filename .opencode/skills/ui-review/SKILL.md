---
name: ui-review
description: Đánh giá UI tĩnh (không chạy code) — đọc HTML, Razor, CSS, Tailwind, FluentUI. Kiểm tra spacing, padding, margin, alignment, font, icon, white space, consistency. Sử dụng câu lệnh /test-ui.
schema_version: "1.0"
---

# UI Review — Đánh Giá Giao Diện Tĩnh

Skill đánh giá chất lượng UI bằng cách **đọc source code** (Razor/CSS/FluentUI), không cần chạy app.

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [KHI NÀO DÙNG](#khi-nào-dùng)
- [8 TIÊU CHÍ ĐÁNH GIÁ](#8-tiêu-chí-đánh-giá)
- [THANG ĐO DESIGN SYSTEM](#thang-đo-design-system)
- [VÍ DỤ PHÁT HIỆN](#ví-dụ-phát-hiện)
- [QUY TRÌNH](#quy-trình)
- [ĐỊNH DẠNG ĐẦU RA](#định-dạng-đầu-ra)

---

## TỔNG QUAN

UI Review là kênh kiểm tra **tĩnh** — đọc markup và CSS để phát hiện vi phạm design system, không cần browser. Nhanh, rẻ, chạy được ngay trong CI. Khác với visual-regression (chạy browser), ui-review đọc source.

### Command

| Command | Mô tả |
|---------|-------|
| `/test-ui` | Review UI/UX/consistency/responsive/accessibility tổng hợp |

### Kiến thức liên quan

- **Design tokens (nguồn chuẩn): `.opencode/knowledge/ui/design-system-tokens.md`**
- FluentUI components: `.opencode/knowledge/ui/fluentui-components.md`
- Tri-state rendering: `.opencode/knowledge/ui/tri-state-rendering.md`

---

## KHI NÀO DÙNG

- **Trước khi build** — audit code mới viết
- **Review PR** — kiểm tra consistency giữa các trang
- **Kiểm tra nhanh** — không muốn chạy browser

---

## 8 TIÊU CHÍ ĐÁNH GIÁ

### 1. Spacing
- Khoảng cách giữa các element có thuộc grid system (8px/4px base) không?
- Gap giữa button-input, section-section có nhất quán không?

### 2. Padding
- Padding trong cùng card/button có đồng nhất không?
- FluentUI chuẩn: button padding ~ `var(--spacing-m)` (12px)

### 3. Margin
- Margin giữa section có đủ breathing room không?
- Tránh margin âm, margin dương ngẫu nhiên

### 4. Alignment
- Text, icon, input có thẳng hàng không?
- Flex/grid container có align đúng không?

### 5. Font
- Dùng đúng font stack? Font size nhất quán? (`--font-size-*` tokens)
- KHÔNG hardcode font-size lẻ (13px, 15px)

### 6. Icon
- Icon có kích thước nhất quán? Có đúng icon set?
- Icon + label alignment đúng?

### 7. White Space
- Có đủ khoảng trắng giữa các khối không?
- Không quá dày đặc, không quá thưa

### 8. Consistency
- Cùng loại component dùng cùng style ở mọi trang?
- Button primary/secondary/danger nhất quán?

---

## THANG ĐO DESIGN SYSTEM

Dự án dùng **FluentUI 4.14.3** — design tokens:

| Token | Giá trị | Ghi chú |
|-------|---------|---------|
| `--spacing-xs` | 4px | icon gap |
| `--spacing-s` | 8px | inline gap |
| `--spacing-m` | 12px | button padding |
| `--spacing-l` | 16px | card padding |
| `--spacing-xl` | 24px | section gap |
| `--font-size-base` | 14px | body |
| `--font-size-plus` | 16px | emphasis |
| `--radius-sm` | 6px | project radius (chips) |
| `--radius-md` | 10px | project radius (buttons/cards) |
| `--shadow-sm` | — | project shadow (card) |

**KHÔNG dùng hardcode** px khi có token tương ứng.

> ⚠️ Project override: radius thực dùng `--radius-*` (6/10/16/24px), shadow dùng `--shadow-*`.
> Chi tiết đầy đủ: `.opencode/knowledge/ui/design-system-tokens.md`

---

## VÍ DỤ PHÁT HIỆN

```
❌ Button cách input 7px
   Chuẩn design system là 8px (--spacing-s)
   => WARNING: dùng gap: 8px thay vì 7px

❌ Button border-radius: 5px
   Project dùng --radius-sm (6px) hoặc --radius-md (10px)
   => ERROR: design system violation

❌ font-size: 13px trên card title
   Dùng --font-size-plus (16px) hoặc --font-size-l (18px)
   => WARNING

❌ Padding card: 10px 8px 10px 12px (không đối xứng)
   => WARNING: nên dùng token đối xứng
```

---

## QUY TRÌNH

1. **Thu thập** — đọc các `.razor` file + `<style>` blocks + `.razor.css`
2. **Map** — từng element → design token tương ứng
3. **Phát hiện** — hardcode, lệch token, không nhất quán
4. **Phân loại** — ERROR (vi phạm design system) / WARNING (lệch nhẹ) / INFO
5. **Đề xuất** — cách sửa cụ thể (thay hardcode bằng token)

---

## ĐỊNH DẠNG ĐẦU RA

```yaml
status: "PASS | CHANGES_NEEDED"
summary: "Tóm tắt số issue phát hiện"
screens_reviewed:
  - "Home.razor"
  - "AlphabetStudy.razor"
findings:
  - severity: "ERROR"
    file: "WordStudy.razor"
    line: 42
    description: "border-radius: 5px — không thuộc project tokens"
    suggestion: "Dùng var(--radius-md) (10px)"
    design_token: "--radius-md"
  - severity: "WARNING"
    file: "Home.razor"
    line: 15
    description: "Button cách input 7px"
    suggestion: "Dùng gap: 8px"
    design_token: "--spacing-s"
score:
  consistency: 85
  spacing: 90
  typography: 80
  overall: 85
issues: []
next_action: "Sửa các ERROR trước khi visual test"
```
