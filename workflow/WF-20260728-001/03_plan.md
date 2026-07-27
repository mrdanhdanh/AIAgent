# 03 — KẾ HOẠCH THỰC THI (Plan)
**Workflow:** WF-20260728-001  
**Agent:** Planner (Plan Phase)  
**Trạng thái:** READY

---

## Tổng quan kế hoạch

**Mục tiêu:** Tách trang flashcard bảng chữ cái ra khỏi Home, tạo Home page giới thiệu/điều hướng.

**Các bước:** 5 bước (2 CREATE + 3 MODIFY), chia 2 chunks.

## Steps

### Step 1: Tạo AlphabetStudy.razor
| Field | Giá trị |
|-------|---------|
| **order** | 1 |
| **action** | CREATE |
| **file** | `Pages/AlphabetStudy.razor` |
| **chunk** | 1 |
| **requires_backup** | false |
| **description** | Tạo trang mới AlphabetStudy.razor với toàn bộ logic flashcard từ Home.razor cũ |
| **logic** | Copy nội dung Home.razor hiện tại sang file mới. Sửa `@page "/"` → `@page "/alphabet"`. Sửa PageTitle "Japanese Learner" → "Bảng chữ cái". Sửa tiêu đề h1 "Luyện tập" → "Bảng chữ cái". Sửa mô tả phụ "Gõ phiên âm Romaji..." → "Luyện gõ Romaji cho bảng chữ cái". Giữ nguyên inject ICharService, toàn bộ code, style. |
| **expected_result** | File `Pages/AlphabetStudy.razor` tồn tại, route `/alphabet`, hiển thị flashcard quiz |
| **check** | `dotnet build` không lỗi; vào `/alphabet` hiển thị được |

### Step 2: Sửa Home.razor
| Field | Giá trị |
|-------|---------|
| **order** | 2 |
| **action** | MODIFY |
| **file** | `Pages/Home.razor` |
| **chunk** | 1 |
| **requires_backup** | true |
| **description** | Biến Home.razor thành trang giới thiệu và điều hướng |
| **logic** | Xóa toàn bộ code hiện tại (flashcard logic). Thay bằng: @page "/" giữ nguyên. Thêm trang trí với tiêu đề chào mừng, mô tả ứng dụng. Thêm grid card điều hướng: (1) Bảng chữ cái → `/alphabet`, (2) Từ vựng → `/words`, (3) Quiz từ vựng → `/words/quiz`, (4) Kanji → `/kanji`, (5) Quản trị → `/admin`. Mỗi card có icon FluentUI, tiêu đề, mô tả ngắn, nút "Bắt đầu" (FluentButton với Href). Xóa inject ICharService và toàn bộ @code block. Thêm CSS inline mới cho layout grid. |
| **expected_result** | Home.razor hiển thị trang giới thiệu với 5 card điều hướng, không còn flashcard |
| **check** | `dotnet build` thành công; vào `/` thấy trang giới thiệu |

### Step 3: Sửa MainLayout.razor (Nav)
| Field | Giá trị |
|-------|---------|
| **order** | 3 |
| **action** | MODIFY |
| **file** | `Layout/MainLayout.razor` |
| **chunk** | 1 |
| **requires_backup** | true |
| **description** | Cập nhật nav drawer: thêm link Home, sửa link Alphabet |
| **logic** | 1. Thêm FluentNavLink mới đầu tiên: `Href="." Match="NavLinkMatch.All"` với icon BookContacts và text "Trang chủ" 2. Sửa FluentNavLink cũ: từ `Href="."` và text "Hiragana / Katakana" → `Href="alphabet"` và text "Bảng chữ cái" 3. Giữ nguyên NavLinkMatch.All cho Home link mới, bỏ Match cho Alphabet link. |
| **expected_result** | Nav drawer có "Trang chủ" đầu tiên, "Bảng chữ cái" thứ hai, các link khác giữ nguyên |
| **check** | `dotnet build` thành công; mở nav thấy link mới |

### Step 4: Sửa Unit Tests — HomeTests.cs
| Field | Giá trị |
|-------|---------|
| **order** | 4 |
| **action** | MODIFY |
| **file** | `JapaneseLearner.Tests/HomeTests.cs` |
| **chunk** | 2 |
| **requires_backup** | true |
| **description** | Sửa HomeTests.cs cho Home page mới (trang giới thiệu) |
| **logic** | Thay thế toàn bộ nội dung: bỏ mock ICharService (Home mới không cần service). Viết lại 3 test: (1) Render_ShowsWelcomeTitle — kiểm tra có tiêu đề chào mừng, (2) Render_ShowsNavigationCards — kiểm tra có 5 card điều hướng, (3) Render_HasLinkToAlphabet — kiểm tra có link đến /alphabet. Giữ nguyên class HomeTests, bỏ reflection helpers không dùng. |
| **expected_result** | 3 test mới cho Home page, compile và PASS |
| **check** | `dotnet test JapaneseLearner.Tests` có ít nhất 3 test PASS |

### Step 5: Tạo AlphabetStudyTests.cs
| Field | Giá trị |
|-------|---------|
| **order** | 5 |
| **action** | CREATE |
| **file** | `JapaneseLearner.Tests/AlphabetStudyTests.cs` |
| **chunk** | 2 |
| **requires_backup** | false |
| **description** | Tạo unit tests cho AlphabetStudy.razor (copy từ HomeTests.cs cũ) |
| **logic** | Copy 7 test methods từ HomeTests.cs cũ (trước khi sửa) sang file mới. Sửa: class name → AlphabetStudyTests, component type → Pages.AlphabetStudy. Sửa mock service method GetByTypeAsync vẫn giữ nguyên. Giữ lại reflection helpers. Các test: Render_ShowsLoading, Render_ShowsEmptyState, Render_DisplaysChar, CheckAnswer_CorrectInput, CheckAnswer_WrongInput, CorrectAnswer_IncrementsStat, WrongAnswer_IncrementsWrongStat. |
| **expected_result** | 7 test cho AlphabetStudy, compile và PASS |
| **check** | `dotnet test JapaneseLearner.Tests` có 10+ test PASS (3 Home + 7 Alphabet) |

## Per-step validation

| Step | Command | Expected |
|------|---------|----------|
| 1 | `dotnet build` | Build thành công |
| 2 | `dotnet build` | Build thành công |
| 3 | `dotnet build` | Build thành công |
| 4 | `dotnet build` | Build thành công |
| 5 | `dotnet build` | Build thành công |

## Final validation

| Command | Expected |
|---------|----------|
| `dotnet build JapaneseLearner\JapaneseLearner.csproj` | Build thành công |
| `dotnet test JapaneseLearner.Tests\JapaneseLearner.Tests.csproj` | All tests PASS (≥10) |

## Rollback strategy

```yaml
enabled: true
conditions:
  - "catastrophic failure"
  - "max retry reached"
  - "user request"
steps:
  - "Bước 1: restore Pages/Home.razor từ backup"
  - "Bước 2: restore Layout/MainLayout.razor từ backup"
  - "Bước 3: restore JapaneseLearner.Tests/HomeTests.cs từ backup"
  - "Bước 4: xóa Pages/AlphabetStudy.razor nếu tồn tại"
  - "Bước 5: xóa JapaneseLearner.Tests/AlphabetStudyTests.cs nếu tồn tại"
```

## Validate

- [x] `dotnet build` — build thành công
- [x] `dotnet test` — all tests PASS
- [x] Route `/alphabet` hoạt động
- [x] Route `/` hiển thị trang giới thiệu
- [x] Nav drawer cập nhật đúng
