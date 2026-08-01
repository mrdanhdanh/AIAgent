---
name: screenshot-analyzer
description: Đọc và phân tích screenshot — layout, alignment, color, missing icon, wrong font, blur, cropped, wrong spacing. Hỗ trợ Vision Model. Sử dụng câu lệnh /test-visual --analyze.
schema_version: "1.0"
---

# Screenshot Analyzer — Phân Tích Ảnh Chụp Màn Hình

Skill đọc file screenshot và phân tích trực quan để phát hiện vấn đề UI.

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [8 HẠNG MỤC PHÂN TÍCH](#8-hạng-mục-phân-tích)
- [QUY TRÌNH](#quy-trình)
- [VISION MODEL](#vision-model)
- [ĐỊNH DẠNG ĐẦU RA](#định-dạng-đầu-ra)

---

## TỔNG QUAN

Screenshot Analyzer xử lý ảnh chụp màn hình (từ visual regression, manual, hoặc screenshot test) và đưa ra đánh giá chi tiết về chất lượng UI. Dùng kết hợp với visual-regression để phân loại diff.

### Command

| Command | Mô tả |
|---------|-------|
| `/test-visual --analyze <screenshot.png>` | Phân tích 1 hoặc nhiều screenshot |

---

## 8 HẠNG MỤC PHÂN TÍCH

### 1. Layout
- Có cân đối không? Header/body/footer rõ ràng?
- Grid/flex có đúng cấu trúc không?
- Element có bị chồng/tràn không?

### 2. Alignment
- Text, icon, input thẳng hàng không?
- Cạnh trái/phải của các block có khớp không?
- Vertical/horizontal center đúng không?

### 3. Color
- Màu có đúng palette FluentUI không?
- Có màu lạc quẻ, tương phản kém không?
- Dark/light mode render đúng không?

### 4. Missing Icon
- Icon có bị vỡ (broken image) không?
- Icon placeholder có hiện không?
- Icon có đúng vị trí không?

### 5. Wrong Font
- Font render có đúng không (khác font fallback)?
- Font size có đúng token không?
- Text có bị cắt/xén không?

### 6. Blur
- Ảnh/icon có bị mờ không?
- Text có blur không (scale sai)?
- Screenshot có bị motion blur (chụp khi đang animation) không?

### 7. Cropped
- Content có bị cắt mất không?
- Text có bị clip giữa chừng không?
- Card cuối có bị cắt ở mép không?

### 8. Wrong Spacing
- Gap giữa các element có lệch token không?
- Padding có đối xứng không?
- White space có bị phá vỡ không?

---

## QUY TRÌNH

1. **Nhận screenshot** — 1 file hoặc thư mục `screenshots/`
2. **Đọc ảnh** — dùng tool read ảnh (hoặc Vision Model nếu có)
3. **Phân tích** — lần lượt 8 hạng mục
4. **Đối chiếu design system** — FluentUI tokens
5. **Đề xuất** — fix cụ thể kèm severity
6. **Xuất report** — từng ảnh + findings

---

## VISION MODEL

Khi có Vision Model (multimodal LLM):
- Đọc ảnh trực tiếp, nhận diện vấn đề tinh vi hơn
- So sánh 2 ảnh (baseline vs actual) bằng mắt
- Mô tả chính xác vị trí lỗi

Khi không có Vision Model:
- Phân tích tĩnh metadata (kích thước ảnh, so sánh histogram)
- Kết hợp với pixel diff output từ visual-regression
- Ghi rõ "cần xác nhận bằng mắt"

---

## ĐỊNH DẠNG ĐẦU RA

```yaml
status: "READY"
summary: "Phân tích 3 screenshots, phát hiện 2 issues"
screenshots_analyzed:
  - file: "home-desktop-light.png"
    viewport: "1366x768"
    findings:
      - category: "alignment"
        severity: "MAJOR"
        description: "Button 'Lưu' không thẳng hàng với input bên trên (lệch 4px)"
        suggestion: "Dùng cùng flex container, align-items: center"
      - category: "color"
        severity: "WARNING"
        description: "Màu text phụ tương phản thấp (3.8:1)"
        suggestion: "Dùng --color-foreground-subtle đúng token"
  - file: "home-mobile-dark.png"
    viewport: "375x667"
    findings:
      - category: "cropped"
        severity: "CRITICAL"
        description: "Card cuối bị cắt ở mép dưới màn hình"
        suggestion: "Thêm padding-bottom vào container scroll"
issues: []
next_action: "Fix CRITICAL/MAJOR hoặc chuyển sang approve gate"
```
