# 01 — PHÂN TÍCH YÊU CẦU (Analysis)
**Workflow:** WF-20260728-001  
**Agent:** Analyst  
**Trạng thái:** READY

---

## Tổng quan

Yêu cầu: Tách trang học bảng chữ cái (Hiragana/Katakana) ra khỏi Home page (`/`), tạo Home page mới là trang giới thiệu và điều hướng đến các trang con khác.

## Phân tích hiện trạng

### Cấu trúc hiện tại

| Route | Component | Nội dung |
|-------|-----------|----------|
| `/` | `Home.razor` | Hiragana/Katakana flashcard quiz (luyện gõ Romaji) |
| `/words` | `WordStudy.razor` | Vocabulary flashcard quiz |
| `/words/quiz` | `WordQuiz.razor` | Multiple-choice word quiz |
| `/kanji` | `KanjiStudy.razor` | Kanji study list |
| `/kanji/{Id:int}` | `KanjiDetail.razor` | Single kanji detail |
| `/admin` | `Admin.razor` | CRUD admin |

### Nav drawer (MainLayout.razor)
Hiện tại nav drawer có link:
- `Hiragana / Katakana` → `/`
- `Word Study` → `/words`
- `Word Quiz` → `/words/quiz`
- `Kanji Study` → `/kanji`
- `Admin` → `/admin`

### File bị ảnh hưởng

| File | Hành động | Lý do |
|------|-----------|-------|
| `Pages/Home.razor` | MODIFY | Biến thành trang giới thiệu/điều hướng |
| `Pages/Home.razor` | CREATE → `Pages/AlphabetStudy.razor` | Tách flashcard quiz sang trang mới |
| `Pages/Home.razor` | MODIFY | Xóa code flashcard, thêm nội dung mới |
| `Layout/MainLayout.razor` | MODIFY | Sửa link "Hiragana/Katakana" → `/alphabet` + thêm link Home |
| `Program.cs` | MODIFY | Có thể cần thêm route nếu dùng tập trung (kiểm tra) |

### Test files bị ảnh hưởng

| File | Hành động | Lý do |
|------|-----------|-------|
| `Tests/HomeTests.cs` | MODIFY | Sửa test cho Home page mới (hoặc tạo AlphabetStudyTests.cs) |
| `E2ETests/HomePageTests.cs` | MODIFY | Sửa E2E test cho Home page mới |
| `Tests/*.cs` | CREATE | Có thể tạo AlphabetStudyTests.cs |

## Yêu cầu con

1. **Tạo trang AlphabetStudy.razor** — copy toàn bộ code flashcard từ Home.razor sang, route `/alphabet`
2. **Sửa Home.razor** — trở thành trang giới thiệu với các card điều hướng đến các trang khác
3. **Cập nhật MainLayout.razor** — sửa nav link Home và thêm Alphabet
4. **Cập nhật unit tests** — HomeTests.cs sửa cho Home mới, tạo AlphabetStudyTests.cs cho trang mới
5. **Cập nhật E2E tests** — HomePageTests.cs sửa cho Home mới

## Rủi ro

| Severity | Mô tả | Biện pháp |
|----------|-------|-----------|
| MEDIUM | Test cũ cho Home page sẽ fail vì nội dung thay đổi | Sửa test đồng bộ với code |
| LOW | Link nav cũ trỏ đến `/` sẽ không còn là flashcard nữa | Cập nhật nav drawer |
| LOW | E2E test dùng selector `.japanese-char` sẽ không tìm thấy trên Home mới | Sửa selector cho phù hợp |

## Effort
**Medium** — 5 files cần sửa, 2 file cần tạo mới, test cần cập nhật.

## Tasks

| Task | File | Effort |
|------|------|--------|
| Tạo AlphabetStudy.razor | Pages/AlphabetStudy.razor | Small |
| Sửa Home.razor | Pages/Home.razor | Medium |
| Sửa MainLayout.razor | Layout/MainLayout.razor | Small |
| Sửa HomeTests.cs + tạo AlphabetStudyTests.cs | Tests/ | Medium |
| Sửa E2E HomePageTests.cs | E2ETests/HomePageTests.cs | Small |
