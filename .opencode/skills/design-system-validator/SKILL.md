---
name: design-system-validator
description: Kiểm tra source code tuân thủ Design System FluentUI — Primary/Secondary/Danger Button, Text Size, Border Radius, Elevation, Shadow, spacing tokens. Sử dụng câu lệnh /test-ui --validate.
schema_version: "1.0"
---

# Design System Validator — Kiểm Tra Tuân Thủ Design System

Skill kiểm tra xem component/source code có đúng design system không. Khác ui-review (đánh giá tổng thể), skill này kiểm tra **chính xác từng token**.

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [CÁC HẠNG MỤC KIỂM TRA](#các-hạng-mục-kiểm-tra)
- [PHÂN LOẠI LỖI](#phân-loại-lỗi)
- [QUY TRÌNH](#quy-trình)
- [ĐỊNH DẠNG ĐẦU RA](#định-dạng-đầu-ra)

---

## TỔNG QUAN

Design System Validator đảm bảo UI nhất quán theo **FluentUI 4.14.3** design tokens. Kiểm tra tĩnh source code — phát hiện giá trị hardcode không thuộc design system.

### Command

| Command | Mô tả |
|---------|-------|
| `/test-ui --validate` | Chạy design system validation |

### Kiến thức liên quan

- **Design tokens (nguồn chuẩn): `.opencode/knowledge/ui/design-system-tokens.md`**
- FluentUI: `.opencode/knowledge/ui/fluentui-components.md`
- UI review: `.opencode/skills/ui-review/SKILL.md`
- Source tokens thật: `JapaneseLearner/wwwroot/css/theme.css`

> ⚠️ Project **override radius** (6/10/16/24px) và shadow (`--shadow-*`) — validate theo `design-system-tokens.md`, không theo FluentUI default 4px.

---

## CÁC HẠNG MỤC KIỂM TRA

### 1. Primary / Secondary / Danger Button
| Loại | FluentUI | Kiểm tra |
|------|----------|----------|
| Primary | `Appearance.Accent` | Không dùng class custom thay thế |
| Secondary | `Appearance.Neutral` | Nền trắng + border |
| Danger | `Appearance.Accent` + màu đỏ override | Dùng đúng token |

```csharp
// ĐÚNG
<FluentButton Appearance="Appearance.Accent">Lưu</FluentButton>
// SAI — dùng class custom giả accent
<button class="my-primary-btn">Lưu</button>
```

### 2. Text Size
| Token | Giá trị | Dùng cho |
|-------|---------|----------|
| `--font-size-sm` | 12px | caption |
| `--font-size-base` | 14px | body |
| `--font-size-plus` | 16px | emphasis |
| `--font-size-l` | 18px | sub-title |
| `--font-size-xl` | 20px | title |
| `--font-size-xxl` | 24px+ | heading |

**Lỗi:** `font-size: 13px`, `font-size: 17px` — không có token tương ứng.

### 3. Border Radius
Project **override** FluentUI default — dùng `--radius-*` tokens:
| Token | Giá trị | Dùng cho |
|-------|---------|----------|
| `--radius-sm` | 6px | chips, badges |
| `--radius-md` | 10px | buttons, inputs, cards nhỏ |
| `--radius-lg` | 16px | cards, panels |
| `--radius-xl` | 24px | hero, large containers |

**Lỗi:** radius không thuộc {6, 10, 16, 24} (vd 4px, 5px, 8px, 12px).

### 4. Elevation / Shadow
Project dùng `--shadow-*` tokens (thay cho elevation):
| Token | Dùng cho |
|-------|----------|
| `--shadow-sm` | subtle card |
| `--shadow-md` | card elevated |
| `--shadow-lg` | dialog/menu |

**Lỗi:** `box-shadow: 0 2px 8px rgba(...)` hardcode.

### 5. Shadow
- Card/dialog dùng `var(--shadow-*)`, không dùng shadow ngẫu nhiên
- KHÔNG dùng `filter: drop-shadow` tràn lan

### 6. Spacing
| Token | Giá trị |
|-------|---------|
| `--spacing-xs` | 4px |
| `--spacing-s` | 8px |
| `--spacing-m` | 12px |
| `--spacing-l` | 16px |
| `--spacing-xl` | 24px |
| `--spacing-xxl` | 32px |
| `--spacing-xxxl` | 40px |

**Lỗi:** margin/padding/gap không thuộc {4, 8, 12, 16, 24, 32, 40}.

---

## PHÂN LOẠI LỖI

| Mức | Ý nghĩa | Ví dụ |
|-----|---------|-------|
| `ERROR` | Vi phạm design system rõ ràng | radius 5px thay vì 4px |
| `WARNING` | Lệch nhẹ, không block | gap 7px thay vì 8px |
| `INFO` | Ghi nhận, không cần sửa | dùng token nhưng context khác |

---

## QUY TRÌNH

1. **Đọc** — tất cả `.razor` + CSS files
2. **Trích xuất** — mọi giá trị: px, em, rem, color, shadow, font-size
3. **So khớp** — từng giá trị với design tokens
4. **Phân loại** — ERROR/WARNING/INFO theo bảng
5. **Xuất** — danh sách vi phạm + file + line + đề xuất

**Tự động hóa:** dùng regex quét:
```
font-size:\s*(\d+)px        → check token {12,14,16,18,20,24}
border-radius:\s*(\d+)px    → check {6,10,16,24} (project --radius-*)
box-shadow:\s*[^;]+         → check var(--shadow-*)
margin/padding/gap:\s*\d+px → check spacing scale {4,8,12,16,24,32,40}
```

---

## ĐỊNH DẠNG ĐẦU RA

```yaml
status: "PASS | CHANGES_NEEDED"
summary: "Tóm tắt số vi phạm design system"
design_system: "FluentUI 4.14.3"
violations:
  - severity: "ERROR"
    file: "WordQuiz.razor"
    line: 87
    category: "border-radius"
    value: "5px"
    expected: "10px (--radius-md) hoặc 6px (--radius-sm)"
    suggestion: "Thay 5px bằng var(--radius-md)"
  - severity: "WARNING"
    file: "Home.razor"
    line: 15
    category: "spacing"
    value: "7px"
    expected: "8px (--spacing-s)"
    suggestion: "Dùng var(--spacing-s)"
stats:
  errors: 2
  warnings: 3
  info: 1
score:
  compliance: 92
issues: []
next_action: "Sửa ERROR trước khi visual regression"
```
