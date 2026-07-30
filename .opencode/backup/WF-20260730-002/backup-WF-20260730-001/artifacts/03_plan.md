# Alphabet Quiz - Execution Plan

## Steps

### Step 1: Create AlphabetQuiz.razor
- **Action:** CREATE
- **File:** `JapaneseLearner/Pages/AlphabetQuiz.razor`
- **Chunk:** 2 (logic) + 3 (UI) — combined into single file
- **Risk Level:** LOW
- **Logic:**
  - `@page "/alphabet/quiz"`
  - Inject `ICharService` + `NavigationManager`
  - `OnInitializedAsync` → `LoadCharsAsync()` → `PickRandomChar()`
  - `GenerateOptions(JapaneseChar correct)`:
    - Mode Kana→Romaji: pool = distinct Romaji khác đáp án → chọn 3 distractors
    - Mode Romaji→Kana: pool = distinct Character khác đáp án → chọn 3 distractors
    - Fill còn thiếu với "???"
    - Return 4 options shuffled
  - `PickRandomChar()` → random từ availableChars, reset selectedOption/isCorrect
  - `SelectAnswer(AnswerOption opt)` → set feedback, update score, delay 3s, auto-next
  - `SwitchMode(bool toKanaToRomaji)` → toggle mode, reset
  - Filter row với `FluentSelect<string>`: All / Hiragana / Katakana
- **Expected Result:** Page renders with chars from service, 2 modes work, score tracking works
- **Validation:** `dotnet build JapaneseLearner\JapaneseLearner.csproj` không lỗi

### Step 2: Add navigation link
- **Action:** MODIFY
- **File:** `JapaneseLearner/Layout/MainLayout.razor`
- **Requires Backup:** true
- **Chunk:** 1 (config)
- **Risk Level:** LOW
- **Logic:** Thêm `<FluentNavLink Href="alphabet/quiz" ...>` sau link "Bảng chữ cái" (dòng 52)
- **Expected Result:** Nav menu hiển thị link "Alphabet Quiz"
- **Validation:** `dotnet build` không lỗi

### Step 3: Create AlphabetQuizTests.cs
- **Action:** CREATE
- **File:** `JapaneseLearner.Tests/AlphabetQuizTests.cs`
- **Chunk:** 4 (test)
- **Risk Level:** LOW
- **Logic:**
  - Test render shows title
  - Test render shows mode toggle (Kana→Romaji, Romaji→Kana)
  - Test default mode is Kana→Romaji
  - Test displays char when data exists
  - Test shows 4 options
  - Test options include correct answer
  - Test all options have distinct values
  - Test select correct answer increments correctCount
  - Test select wrong answer increments wrongCount
  - Test correct answer shows feedback
  - Test wrong answer shows correct answer
  - Test after answer, options are disabled
  - Test empty state when no chars
  - Test stats initially zero
  - Test switch mode resets and shows correct display
  - Test filter by type (Hiragana/Katakana)
- **Expected Result:** All tests pass
- **Validation:** `dotnet test JapaneseLearner.Tests\JapaneseLearner.Tests.csproj` — tất cả pass

## Rollback Strategy
- **Enabled:** true
- **Trigger Conditions:** Build fail CRITICAL, Test fail (same_error >= 2)
- **Restore Order:** Restore MainLayout.razor từ backup → xóa AlphabetQuiz.razor → xóa AlphabetQuizTests.cs
- **Requires User Confirmation:** true

## Validate
- **Per-step:** Mỗi step chạy `dotnet build` kiểm tra compile
- **Final:** `dotnet build` + `dotnet test` thành công
