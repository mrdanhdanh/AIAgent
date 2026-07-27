# 02 — THIẾT KẾ GIẢI PHÁP (Design)
**Workflow:** WF-20260728-001  
**Agent:** Planner (Design Phase)  
**Trạng thái:** READY

---

## 1. Architecture tổng thể

```
[App.razor] → Router
                ├── /        → Home.razor (MỚI: trang giới thiệu)
                ├── /alphabet → AlphabetStudy.razor (MỚI: flashcard cũ)
                ├── /words   → WordStudy.razor
                ├── /words/quiz → WordQuiz.razor
                ├── /kanji   → KanjiStudy.razor
                ├── /kanji/{id} → KanjiDetail.razor
                └── /admin   → Admin.razor
```

- **Không cần thêm service mới** — AlphabetStudy tái sử dụng `ICharService` hiện có
- **Không cần thêm DI** — Program.cs giữ nguyên
- **CSS** — AlphabetStudy dùng lại style từ Home.razor cũ + thêm style riêng nếu cần

## 2. Components

| Component | Đường dẫn | Action | Mô tả |
|-----------|-----------|--------|-------|
| AlphabetStudy | `Pages/AlphabetStudy.razor` | CREATE | Copy code flashcard từ Home.razor cũ, route `/alphabet` |
| Home | `Pages/Home.razor` | MODIFY | Trang giới thiệu: tiêu đề, mô tả, card nav đến các trang |
| MainLayout | `Layout/MainLayout.razor` | MODIFY | Sửa nav link Home + Alphabet |

### Chi tiết AlphabetStudy.razor (CREATE)
- Route: `@page "/alphabet"`
- Inject: `ICharService`
- Nội dung: Copy toàn bộ từ Home.razor cũ (flashcard quiz với Hiragana/Katakana)
- Thay đổi: Đổi PageTitle thành "Bảng chữ cái", sửa heading thành "Bảng chữ cái"
- CSS: Giữ nguyên từ Home.razor cũ, thêm style tùy chỉnh nếu cần

### Chi tiết Home.razor (MODIFY)
- Route: `@page "/"` (giữ nguyên)
- Inject: Không cần service (chỉ là trang giới thiệu)
- Nội dung:
  - Tiêu đề chào mừng
  - Mô tả ngắn về ứng dụng
  - Card grid: 4-5 card dẫn đến Alphabet, Word Study, Word Quiz, Kanji, Admin
  - Mỗi card có icon, tiêu đề, mô tả ngắn, nút "Bắt đầu"
- CSS: Style mới cho trang giới thiệu

### Chi tiết MainLayout.razor (MODIFY)
- Sửa nav link "Hiragana / Katakana" từ `/` → `/alphabet`
- Thêm nav link "Trang chủ" trỏ đến `/`
- Cập nhật label phù hợp

## 3. Data flow

```
Home.razor (trang giới thiệu)
  → User click card → navigate đến route tương ứng
  → Không gọi service, không có state

AlphabetStudy.razor (flashcard)
  → OnInitializedAsync → CharService.GetByTypeAsync(type)
  → User nhập Romaji → CheckAnswer() → so sánh với currentChar.Romaji
  → Đúng/Sai → cập nhật stats → PickRandomChar()
```

## 4. Security concerns

| Vấn đề | Mức | Biện pháp |
|--------|-----|-----------|
| Không có input từ user trên Home | LOW | Chỉ link điều hướng, không rủi ro |
| AlphabetStudy giống logic cũ | LOW | Đã kiểm thử từ trước |

## 5. Edge cases

| Tình huống | Xử lý |
|------------|-------|
| Home không có dữ liệu để hiển thị | Static page, luôn hiển thị được |
| AlphabetStudy không có chars | Empty state (giữ nguyên từ code cũ) |
| User bookmarked `/` | Vẫn hoạt động, chỉ khác nội dung |
| Nav link cũ trỏ đến `/` (Hiragana/Katakana) | Cập nhật để trỏ đến `/alphabet` |

## Effort: Medium
