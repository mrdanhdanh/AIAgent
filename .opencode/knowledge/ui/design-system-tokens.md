---
category: ui
last_updated: 2026-08-01
---

# Design System Tokens — FluentUI 4.14.3 + Project Overrides

Nguồn chuẩn duy nhất (single source of truth) cho các skill QA: `ui-review`, `design-system-validator`, `visual-regression`.
Mọi giá trị px/color/shadow trong source phải được so với bảng này — không so với chuẩn FluentUI "mặc định" nếu project đã override.

> ⚠️ **Lưu ý quan trọng:** Project **không dùng FluentUI default radius (4px)**. `JapaneseLearner/wwwroot/css/theme.css` override radius và shadow. Khi validate, **ưu tiên project tokens** — chỉ flag vi phạm khi giá trị không khớp project tokens.

---

## 1. FluentUI Standard Tokens (mặc định của component)

| Token | Giá trị | Dùng cho |
|-------|---------|----------|
| `--spacing-xs` | 4px | icon gap |
| `--spacing-s` | 8px | inline gap |
| `--spacing-m` | 12px | button padding |
| `--spacing-l` | 16px | card padding |
| `--spacing-xl` | 24px | section gap |
| `--spacing-xxl` | 32px | large section |
| `--spacing-xxxl` | 40px | page hero |
| `--font-size-sm` | 12px | caption |
| `--font-size-base` | 14px | body |
| `--font-size-plus` | 16px | emphasis |
| `--font-size-l` | 18px | sub-title |
| `--font-size-xl` | 20px | title |
| `--font-size-xxl` | 24px+ | heading |
| `--border-radius-medium` | 4px | FluentUI default radius |
| `--elevation-shadow-card-rest` | — | card resting |
| `--elevation-shadow-card-hover` | — | card hover |
| `--elevation-shadow-tooltip` | — | tooltip |
| `--elevation-shadow-flyout` | — | menu/dialog |

---

## 2. Project Overrides — `JapaneseLearner/wwwroot/css/theme.css`

### Radius (khác FluentUI default!)

| Token | Giá trị | Ghi chú |
|-------|---------|---------|
| `--radius-sm` | 6px | small elements (chips, badges) |
| `--radius-md` | 10px | buttons, inputs, cards nhỏ |
| `--radius-lg` | 16px | cards, panels |
| `--radius-xl` | 24px | hero, large containers |

**Quy tắc validate:** radius chỉ hợp lệ ∈ {6, 10, 16, 24}px (project tokens). Giá trị 4px/5px/8px/12px → WARNING (không thuộc scale project).

### Shadow (tinted, thay thế elevation)

| Token | Giá trị | Dùng cho |
|-------|---------|----------|
| `--shadow-sm` | `0 1px 2px rgba(43,33,31,.04), 0 2px 8px rgba(43,33,31,.05)` | subtle card |
| `--shadow-md` | `0 4px 14px rgba(43,33,31,.06), 0 10px 30px rgba(43,33,31,.07)` | card elevated |
| `--shadow-lg` | `0 8px 24px rgba(43,33,31,.1), 0 18px 48px rgba(43,33,31,.1)` | dialog/menu |

**Quy tắc validate:** shadow phải dùng `var(--shadow-*)`. Hardcode `box-shadow` ngẫu nhiên → ERROR.

### Spacing

Project không override spacing — dùng FluentUI scale {4, 8, 12, 16, 24, 32, 40}px.
**Lỗi:** margin/padding/gap không thuộc scale trên (vd 5px, 7px, 10px, 14px).

### Typography

- Font stack: `'Noto Sans JP', 'Outfit', 'Roboto', sans-serif` (body), `'Outfit', ...` (display)
- Font-size dùng FluentUI `--font-size-*` scale. **Lỗi:** 13px, 15px, 17px không có token.

### Color — Brand (light theme)

| Token | Giá trị |
|-------|---------|
| `--accent-color` | `#c5413b` |
| `--accent-hover` | `#a93732` |
| `--secondary-color` | `#3f6b85` |
| `--success-color` | `#2f7d5f` |
| `--danger-color` | `#c5413b` |
| `--text-primary` | `#2b211f` |
| `--text-secondary` | `#6f645f` |
| `--bg-page` | `#f7f5f1` |
| `--bg-card` | `#ffffff` |

### Color — Dark theme (`[data-theme="dark"]`)

| Token | Giá trị |
|-------|---------|
| `--accent-color` | `#e56a55` |
| `--accent-hover` | `#f07a66` |
| `--secondary-color` | `#7fa8bf` |
| `--success-color` | `#5fae8f` |
| `--danger-color` | `#e56a55` |
| `--text-primary` | `#ece7e1` |
| `--text-secondary` | `#a89f98` |
| `--bg-page` | `#141210` |
| `--bg-card` | `#1f1c1a` |

**Quy tắc:** semantic color phải dùng token (accent/secondary/success/danger/text-*), không hardcode hex lẻ. Accent chỉ đổi tại 2 nơi (light/dark) — không rải hex trực tiếp trong `.razor`.

---

## 3. Thang Validate Nhanh

```
font-size:\s*(\d+)px        → phải ∈ {12,14,16,18,20,24}
border-radius:\s*(\d+)px    → phải ∈ {6,10,16,24} (project)
margin|padding|gap:\s*\d+px → phải ∈ {4,8,12,16,24,32,40}
box-shadow:\s*[^;]+         → phải dùng var(--shadow-*)
color: #[0-9a-fA-F]{6}      → phải khớp project token (light/dark)
```

---

## 4. File Liên Quan

- Components: `.opencode/knowledge/ui/fluentui-components.md`
- Theme/dark mode: `.opencode/knowledge/ui/dark-mode-theming.md`
- FluentDesignTheme (accent): `.opencode/knowledge/framework/fluentu/design-tokens.md`
- Source tokens thật: `JapaneseLearner/wwwroot/css/theme.css`
